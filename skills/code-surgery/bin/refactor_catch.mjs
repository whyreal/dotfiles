#!/usr/bin/env node

/**
 * 批量替换 try/catch ignore → logger.warn。
 *
 * 用法：
 *   # 替换单个文件
 *   node bin/refactor_catch.mjs <filepath>
 *
 *   # 预览模式
 *   node bin/refactor_catch.mjs <filepath> --dry-run
 *
 *   # 指定 logger 导入路径
 *   node bin/refactor_catch.mjs <filepath> --logger-path '@/infra/services/logger'
 *
 * 工作流程：
 *  1. 扫描文件，找到所有 body 为空或仅注释的 catch 块
 *  2. 根据上下文（函数名 + try 块内容）生成有意义的日志消息
 *  3. 替换为 logger.warn(message, e)
 *  4. 自动添加 import
 *
 * 匹配规则：
 *  - catch (e) {}                              → 完全空
 *  - catch (e) { /* comment * / }              → 仅注释 ← 留意转义
 *  - catch (e) { // comment\n}                 → 仅注释
 *  - catch (e) { logger.warn(...) }            → 已修复，跳过
 *  - catch (e) { doSomething() }               → 有实际代码，跳过
 */

import fs from "node:fs";
import fglob from "fast-glob";
import { Command } from "commander";
import { findMatchingBrace } from "../lib/code_utils.mjs";

const DEFAULT_LOGGER_PATH = "@/infra/services/logger";
const IMPORT_LINE = `import { logger } from '${DEFAULT_LOGGER_PATH}';`;

/**
 * 检查文本中从 bracePos 开始的花括号内是否仅有空白/注释。
 * @param {string} text
 * @param {number} bracePos - { 的位置
 * @returns {boolean}
 */
function isBodyEmptyOrComment(text, bracePos) {
  try {
    const endPos = findMatchingBrace(text, bracePos);
  } catch {
    return false;
  }
  const endPos = findMatchingBrace(text, bracePos);
  const body = text.slice(bracePos + 1, endPos).trim();

  if (body.length === 0) return true;

  // 去掉所有注释和空白后是否为空
  const stripped = body
    .replace(/\/\/.*$/gm, "") // 单行注释
    .replace(/\/\*[\s\S]*?\*\//g, "") // 块注释
    .trim();

  return stripped.length === 0;
}

/**
 * 查找文本中所有匹配的 catch 块位置。
 * @param {string} text
 * @returns {Array<{ start: number, end: number, bracePos: number, tryPos: number }>}
 */
function findAllCatchBlocks(text) {
  const results = [];
  const catchRe = /\bcatch\s*\(/g;
  let match;

  while ((match = catchRe.exec(text)) !== null) {
    const catchStart = match.index;

    // 找到 catch 后面的 {
    const bracePos = text.indexOf("{", match.index + match[0].length);
    if (bracePos < 0) continue;

    // 检查 body 是否为空或仅注释
    if (!isBodyEmptyOrComment(text, bracePos)) continue;

    // 找到 } 的位置
    try {
      const endPos = findMatchingBrace(text, bracePos) + 1; // 包含 }
      results.push({
        start: catchStart,
        end: endPos,
        bracePos,
        tryPos: findTryKeyword(text, catchStart),
      });
    } catch {
      continue;
    }
  }

  return results;
}

/**
 * 在 catch 位置之前查找 try 关键字。
 * @param {string} text
 * @param {number} catchPos
 * @returns {number}
 */
function findTryKeyword(text, catchPos) {
  // 从 catchPos 往前搜索，跳过空白，找到 try
  let i = catchPos - 1;
  while (i >= 0 && /\s/.test(text[i])) i--;
  // 此时 i 是 catch 前的空白之前，再往前应该能找到 try
  const before = text.slice(0, i + 1);
  const tryMatch = before.match(/\btry\s*$/);
  if (tryMatch) {
    return before.lastIndexOf("try", i);
  }
  return -1;
}

/**
 * 从 catch 位置往前查找最近的函数名。
 * @param {string} text
 * @param {number} catchPos
 * @returns {string|null}
 */
function findFunctionName(text, catchPos) {
  // 从 catchPos 往前找方法签名模式：methodName(args) {
  const before = text.slice(0, catchPos);
  // 匹配方法名，跳过 catch 所在的 try-catch 结构
  const lines = before.split("\n");

  // 从后往前行，找方法定义
  const methodRe = /^\s*(\w+)\s*\([^)]*\)\s*\{/;
  for (let i = lines.length - 1; i >= 0; i--) {
    const m = lines[i].match(methodRe);
    if (m) {
      return m[1];
    }
  }
  return null;
}

/**
 * 从 try 块内容中提取操作描述。
 * @param {string} text
 * @param {number} tryPos
 * @returns {string|null}
 */
function findOperationName(text, tryPos) {
  if (tryPos < 0) return null;
  const bracePos = text.indexOf("{", tryPos);
  if (bracePos < 0) return null;
  try {
    const endPos = findMatchingBrace(text, tryPos);
    const body = text.slice(bracePos + 1, endPos).trim();
    // 取第一行有意义的代码
    const firstLine = body.split("\n")[0].trim();
    // 提取方法调用名：Vue.ls.set(...) 或 this.xxx() 或 xxx()
    const callMatch = firstLine.match(/(?:this\.)?(\w+(?:\.\w+)*)\s*\(/);
    if (callMatch) {
      return callMatch[1];
    }
    // 提取赋值操作：this.xxx = ...
    const assignMatch = firstLine.match(/(?:this\.)?(\w+)\s*=/);
    if (assignMatch) {
      return assignMatch[1];
    }
    return null;
  } catch {
    return null;
  }
}

/**
 * 生成日志消息。
 * @param {string} text
 * @param {number} catchPos
 * @param {number} tryPos
 * @returns {string}
 */
function generateMessage(text, catchPos, tryPos) {
  const funcName = findFunctionName(text, catchPos);
  const opName = findOperationName(text, tryPos);

  let msg = "";
  if (funcName) {
    msg += `${funcName} failed`;
  }
  if (opName) {
    msg += msg ? `: ${opName}` : `${opName} failed`;
  }
  if (!msg) {
    msg = "Operation failed";
  }
  return msg;
}

/**
 * 检查文件是否已有 logger import。
 * @param {string} text
 * @returns {boolean}
 */
function hasLoggerImport(text) {
  // 匹配 import { logger } from '...' 的各种变体
  const re = /import\s*\{\s*logger\s*\}\s*from\s*['"]/;
  return re.test(text);
}

/**
 * 在文件中添加 logger import（在最后一个 import 之后）。
 * @param {string} text
 * @returns {string}
 */
function addLoggerImport(text) {
  // 找到最后一个 import 行
  const lines = text.split("\n");
  let lastImportIdx = -1;
  for (let i = 0; i < lines.length; i++) {
    if (/^\s*import\s/.test(lines[i])) {
      lastImportIdx = i;
    }
  }
  if (lastImportIdx >= 0) {
    lines.splice(lastImportIdx + 1, 0, IMPORT_LINE);
  } else {
    // 没有 import，在文件顶部添加
    lines.unshift(IMPORT_LINE, "");
  }
  return lines.join("\n");
}

/**
 * 在单个文件中执行替换。
 * @param {string} filepath
 * @param {boolean} dryRun
 * @returns {Array<{ line: number, message: string }>}
 */
function refactorFile(filepath, dryRun) {
  let text = fs.readFileSync(filepath, "utf-8");
  const blocks = findAllCatchBlocks(text);

  if (blocks.length === 0) return [];

  // 从后往前替换，避免位置偏移
  const changes = [];
  let modified = text;

  for (let i = blocks.length - 1; i >= 0; i--) {
    const block = blocks[i];
    const msg = generateMessage(
      modified,
      block.catchPos || block.start,
      block.tryPos
    );
    // 提取原 catch 行的缩进（只取空白部分）
    const lineStart = modified.lastIndexOf("\n", block.start) + 1;
    const lineBeforeCatch = modified.slice(lineStart, block.start);
    const catchIndent = lineBeforeCatch.match(/^\s*/)[0];
    const bodyIndent = catchIndent + "  ";
    const replacement = `catch (e) {\n${bodyIndent}logger.warn('${msg}', e);\n${catchIndent}}`;
    modified =
      modified.slice(0, block.start) + replacement + modified.slice(block.end);
    changes.push({
      line: modified.slice(0, block.start).split("\n").length,
      message: msg,
    });
  }

  // 添加 import
  if (!hasLoggerImport(modified)) {
    modified = addLoggerImport(modified);
  }

  if (!dryRun) {
    fs.writeFileSync(filepath, modified, "utf-8");
  }

  return changes;
}

const program = new Command();
program
  .name("refactor_catch.mjs")
  .description(
    "批量替换 try/catch ignore → logger.warn。自动添加 import，自动生成上下文消息。"
  )
  .argument("<glob>", "文件匹配模式（如 src/**/*.js）")
  .option("--dry-run", "预览模式，不写入文件")
  .option(
    "--logger-path <path>",
    "logger 导入路径",
    DEFAULT_LOGGER_PATH
  )
  .action((globPattern, options) => {
    const files = fglob.sync(globPattern, { onlyFiles: true });
    if (files.length === 0) {
      console.error(`❌ 未找到匹配文件: ${globPattern}`);
      process.exit(1);
    }

    let totalChanges = 0;
    for (const filepath of files.sort()) {
      const changes = refactorFile(filepath, options.dryRun);
      totalChanges += changes.length;
      for (const c of changes) {
        const prefix = options.dryRun ? "▶" : "✔";
        console.log(
          `${prefix} ${filepath}:${c.line} → logger.warn('${c.message}', e)`
        );
      }
    }

    if (options.dryRun) {
      console.log(
        `\n▶ DRY RUN: 将替换 ${totalChanges} 处（未实际写入）`
      );
    } else {
      console.log(
        `\n✔ 完成: ${files.length} 个文件，${totalChanges} 处替换`
      );
    }
  });
program.parse();