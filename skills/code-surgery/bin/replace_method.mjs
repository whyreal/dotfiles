#!/usr/bin/env node

/**
 * 方法体替换工具 — 基于括号计数法或行范围定位并替换代码。
 *
 * 用法：
 *   # 替换方法体（锚点模式）
 *   node replace_method.mjs <文件路径> <方法签名>
 *
 *   # 替换行范围（区域模式）
 *   node replace_method.mjs <文件路径> --region 100:150
 *
 *   # 预览模式（不写入）
 *   node replace_method.mjs <文件路径> <方法签名> --dry-run
 *   node replace_method.mjs <文件路径> --region 100:150 --dry-run
 *
 * 工作流程：
 *  1. 把新代码写入 _new_body.txt（用 Write 工具，无需关心转义）
 *  2. 执行 replace_method.mjs
 *  3. 脚本从 _new_body.txt 读取新代码，替换原位置
 *  4. 清理 _new_body.txt
 *
 * 示例：
 *   # 准备 _new_body.txt，然后：
 *   node replace_method.mjs src/views/xxx.vue "applySankeyPayload(payload)"
 *   node replace_method.mjs src/views/xxx.vue --region 423:450
 *
 * 特性：
 *   - 锚点模式：括号计数法精确匹配方法结束边界，无视嵌套深度
 *   - 区域模式：按行号范围精确替换，适合生命周期、data 块等
 *   - 跳过字符串字面量、注释、模板字符串中的误匹配
 *   - 替换前打印新旧代码行数对比
 */

import { Command } from "commander";
import fs from "node:fs";
import { skipString } from "../lib/code_utils.mjs";

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
 * 替换方法体（锚点模式）。
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
 * 解析行范围字符串 "start:end"。
 * @param {string} range
 * @returns {{ start: number, end: number }}
 */
function parseLineRange(range) {
  const parts = range.split(":");
  if (parts.length !== 2) {
    throw new Error(
      `无效的行范围: ${range}，格式应为 start:end`
    );
  }
  const start = parseInt(parts[0], 10);
  const end = parseInt(parts[1], 10);
  if (isNaN(start) || isNaN(end) || start < 1 || end < start) {
    throw new Error(
      `无效的行范围: ${range}，必须满足 start >= 1 且 end >= start`
    );
  }
  return { start, end };
}

/**
 * 按行范围替换（区域模式）。
 * @param {string} text
 * @param {number} start - 1-based
 * @param {number} end - 1-based, inclusive
 * @param {string} newBody
 * @returns {{ newText: string, oldBody: string }}
 */
function replaceRegion(text, start, end, newBody) {
  const lines = text.split("\n");
  if (end > lines.length) {
    throw new Error(
      `行范围超出文件长度: ${end} > ${lines.length}`
    );
  }
  const oldBody = lines.slice(start - 1, end).join("\n");
  const before = lines.slice(0, start - 1);
  const after = lines.slice(end);
  const newText = [...before, newBody, ...after].join("\n");
  return { newText, oldBody };
}

const program = new Command();
program
  .name("replace_method.mjs")
  .description(
    "方法体替换工具 — 基于括号计数法或行范围定位并替换代码（新代码来自 _new_body.txt）。"
  )
  .argument("<filepath>", "目标文件路径")
  .argument("[sig]", "方法签名（如 applySankeyPayload(payload)）；锚点模式必填")
  .option("--region <range>", "区域模式，行范围如 100:150")
  .option("--dry-run", "预览模式，不写入文件")
  .action((filepath, sig, options) => {
    if (!fs.existsSync(filepath)) {
      console.error(`❌ 文件不存在: ${filepath}`);
      process.exit(1);
    }
    if (!fs.existsSync(NEW_BODY_FILE)) {
      console.error(`❌ 新代码文件不存在: ${NEW_BODY_FILE}`);
      console.error("   请先准备 _new_body.txt（用 Write 工具写入新代码内容）");
      process.exit(1);
    }

    const newBody = fs.readFileSync(NEW_BODY_FILE, "utf-8");
    const text = fs.readFileSync(filepath, "utf-8");

    let newText, oldBody;
    try {
      if (options.region) {
        // ── 区域模式 ──
        const { start, end } = parseLineRange(options.region);
        if (!sig) {
          // 区域模式：替换时用 newBody 替换整个行范围
          ({ newText, oldBody } = replaceRegion(text, start, end, newBody));
        } else {
          // 区域模式 + sig：在行范围内找到方法定义再替换
          // 先截取行范围，在子文本中定位方法
          const regionText = text.split("\n").slice(start - 1, end).join("\n");
          // 计算偏移量：regionText 中定位到的方法位置映射回原文本
          const idxSig = findMethodDefinition(regionText, sig);
          const idxEnd = findMethodBody(regionText, idxSig);
          oldBody = regionText.slice(idxSig, idxEnd);
          // 映射回原文本的偏移量
          const lineStartOffset = text.split("\n").slice(0, start - 1).join("\n").length + (start > 1 ? 1 : 0);
          const globalIdxSig = lineStartOffset + idxSig;
          const globalIdxEnd = lineStartOffset + idxEnd;
          newText = text.slice(0, globalIdxSig) + newBody + text.slice(globalIdxEnd);
        }
      } else {
        // ── 锚点模式 ──
        if (!sig) {
          console.error("❌ 锚点模式需要提供方法签名，或使用 --region 切换到区域模式");
          process.exit(1);
        }
        ({ newText, oldBody } = replaceMethod(text, sig, newBody));
      }
    } catch (e) {
      console.error(`❌ ${e.message}`);
      process.exit(1);
    }

    const oldLines = oldBody.split("\n").length;
    const newLines = newBody.split("\n").length;
    const diff = newLines - oldLines;
    const sign = diff > 0 ? "+" : "";
    console.log(`📉 原代码: ${oldLines} 行`);
    console.log(`📈 新代码: ${newLines} 行`);
    console.log(`📊 变化: ${sign}${diff} 行`);

    if (options.dryRun) {
      console.log("─── 旧代码 ───");
      console.log(oldBody);
      console.log("─── 新代码 ───");
      console.log(newBody);
      console.log("─── DRY RUN: 未写入文件 ───");
      return;
    }

    fs.writeFileSync(filepath, newText, "utf-8");
    console.log(`✅ 替换完成: ${filepath}`);
  });
program.parse();