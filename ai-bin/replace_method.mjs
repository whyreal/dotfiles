#!/usr/bin/env node

/**
 * 方法体替换工具 — 基于括号计数法精确定位方法边界。
 *
 * 用法：
 *   node replace_method.mjs <文件路径> <方法签名>
 *
 * 工作流程：
 *  1. 把新方法体完整内容写入 _new_body.txt（用 Write 工具，无需关心转义）
 *  2. 执行 node replace_method.mjs <文件路径> <方法签名>
 *  3. 脚本从 _new_body.txt 读取新方法体，替换原方法
 *  4. 清理 _new_body.txt
 *
 * 示例：
 *   # 先准备 _new_body.txt（内容就是方法体，原样写入）
 *   # 然后执行：
 *   node replace_method.mjs src/views/xxx.vue "applySankeyPayload(payload)"
 *
 * 特性：
 *   - 括号计数法精确匹配方法结束边界，无视嵌套深度
 *   - 跳过字符串字面量、注释、模板字符串中的误匹配
 *   - 无行号漂移问题（每次重新扫描全文定位）
 *   - 替换前打印新旧方法体行数对比
 */


import { Command } from "commander";
import fs from "node:fs";
import { skipString, findMatchingBrace } from "./code_utils.mjs";

const NEW_BODY_FILE = "_new_body.txt";

/**
 * 转义正则特殊字符。
 * @param {string} str
 * @returns {string}
 */
function escapeRegex(str) {
  return str.replace(/[.+^${}()|[\]\\]/g, "\\$&");
}

/**
 * 在文本中定位方法定义的位置（行首缩进 + 签名）。
 *
 * 使用正则匹配：\n<缩进><签名>{，避免误匹配调用处（如 this.xxx()）。
 *
 * @param {string} text
 * @param {string} sig - 方法签名（如 "applySankeyPayload(payload)"）
 * @returns {number} 签名起始位置（指向缩进后的第一个字符）
 * @throws 未找到时抛出
 */
function findMethodDefinition(text, sig) {
  const escaped = escapeRegex(sig);
  // 匹配：新行开头 → 可选缩进空格 → 签名 → 可选空白 → {
  const pattern = new RegExp(`\\n( +)${escaped}\\s*\\{`);
  const m = pattern.exec(text);
  if (m) {
    // 返回签名实际起始位置（缩进之后）
    return m.index + m[1].length + 1; // +1 for \n
  }
  throw new Error(
    `方法定义 "${sig}" 未找到（确保签名不包含缩进，如 "isFromSankeyJump()"）`
  );
}

/**
 * 括号计数法定位方法体结束位置。
 * @param {string} text
 * @param {number} startPos - 方法签名起始位置
 * @returns {number} 方法体结束位置（含闭合 } 及可能的逗号）
 * @throws 未闭合时抛出
 */
function findMethodBody(text, startPos) {
  // 找到方法签名行的第一个 {
  const bracePos = text.indexOf("{", startPos);
  if (bracePos < 0) {
    throw new Error(`方法签名后未找到 {（位置 ${startPos}）`);
  }

  let count = 0;
  let i = bracePos;

  while (i < text.length) {
    const ch = text[i];

    // ── 跳过模板字符串 ${} ──
    if (ch === "$" && i + 1 < text.length && text[i + 1] === "{") {
      let depth = 1;
      let j = i + 2;
      while (j < text.length && depth > 0) {
        if (text[j] === "{") {
          depth++;
        } else if (text[j] === "}") {
          depth--;
        } else if (text[j] === "'" || text[j] === '"' || text[j] === "`") {
          j = skipString(text, j);
          continue;
        }
        j++;
      }
      i = j;
      continue;
    }

    // ── 跳过字符串字面量 ──
    if (ch === "'" || ch === '"' || ch === "`") {
      i = skipString(text, i);
      continue;
    }

    // ── 跳过单行注释 ──
    if (ch === "/" && i + 1 < text.length && text[i + 1] === "/") {
      i = text.indexOf("\n", i);
      if (i < 0) break;
      i++;
      continue;
    }

    // ── 跳过块注释 ──
    if (ch === "/" && i + 1 < text.length && text[i + 1] === "*") {
      i = text.indexOf("*/", i + 2);
      if (i < 0) break;
      i += 2;
      continue;
    }

    // ── 括号计数 ──
    if (ch === "{") {
      count++;
    } else if (ch === "}") {
      count--;
      if (count === 0) {
        if (i + 1 < text.length && text[i + 1] === ",") {
          return i + 2; // 包含逗号
        }
        return i + 1; // 只有 }
      }
    }

    i++;
  }

  throw new Error(`方法体未闭合（从位置 ${startPos} 开始）`);
}

/**
 * 替换方法体。
 * @param {string} text
 * @param {string} sig
 * @param {string} newBody
 * @returns {{ newText: string, oldBody: string }}
 */
function replaceMethod(text, sig, newBody) {
  const idxSig = findMethodDefinition(text, sig);
  const idxEnd = findMethodBody(text, idxSig);
  const oldBody = text.slice(idxSig, idxEnd);
  const newText = text.slice(0, idxSig) + newBody + text.slice(idxEnd);
  return { newText, oldBody };
}
/**
 * 打印帮助信息。
 */

const program = new Command();
program
  .name("replace_method.mjs")
  .description("方法体替换工具 \u2014 基于括号计数法精确定位方法边界并替换（新方法体来自 _new_body.txt）。")
  .argument("<filepath>", "目标文件路径")
  .argument("<sig>", "方法签名（如 applySankeyPayload(payload)）")
  .action((filepath, sig) => {
    if (!fs.existsSync(filepath)) {
      console.error(`\u274c 文件不存在: ${filepath}`);
      process.exit(1);
    }
    if (!fs.existsSync(NEW_BODY_FILE)) {
      console.error(`\u274c 新方法体文件不存在: ${NEW_BODY_FILE}`);
      console.error("   请先准备 _new_body.txt（用 Write 工具写入新方法体内容）");
      process.exit(1);
    }

    const newBody = fs.readFileSync(NEW_BODY_FILE, "utf-8");
    const text = fs.readFileSync(filepath, "utf-8");

    let newText, oldBody;
    try {
      ({ newText, oldBody } = replaceMethod(text, sig, newBody));
    } catch (e) {
      console.error(`\u274c ${e.message}`);
      process.exit(1);
    }

    const oldLines = oldBody.split("\n").length;
    const newLines = newBody.split("\n").length;
    const diff = newLines - oldLines;
    const sign = diff > 0 ? "+" : "";
    console.error(`\ud83d\udcc9 原方法: ${oldLines} 行`);
    console.error(`\ud83d\udcc8 新方法: ${newLines} 行`);
    console.error(`\ud83d\udcca 变化: ${sign}${diff} 行`);

    fs.writeFileSync(filepath, newText, "utf-8");
    console.error(`\u2705 替换完成: ${filepath}`);
  });
program.parse();
