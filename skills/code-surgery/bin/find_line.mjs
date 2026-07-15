#!/usr/bin/env node
/**
 * 行号定位工具 — 基于锚点字符串或括号计数法定位行号。
 *
 * 用法：
 *   node find_line.mjs <文件路径> <锚点>                       # 返回锚点所在行
 *   node find_line.mjs <文件路径> <锚点> --end                 # 括号计数，返回结构结束行
 *   node find_line.mjs <文件路径> <锚点> --all                 # 列出所有匹配行（一行一个）
 *   node find_line.mjs <文件路径> <锚点> --context 3           # 显示匹配行前后 3 行上下文
 *   node find_line.mjs <文件路径> <锚点> --all --context 2     # 列出所有匹配行并显示上下文
 *
 * 示例：
 *   node find_line.mjs ConditionTree.vue "  created() {"
 *   → 423
 *
 *   node find_line.mjs SankeyJumpController.js "class SankeyJumpController {" --end
 *   → 495
 *
 *   node find_line.mjs recordSearch.vue "logger.warn" --all
 *   → 12
 *     34
 *     56
 *
 *   node find_line.mjs recordSearch.vue "catch" --context 1
 *   →  429:     } catch (e) {
 *     430:       logger.warn(...)
 */

import fs from "node:fs";
import { Command } from "commander";
import { skipString, findMatchingBrace } from "../lib/code_utils.mjs";

/**
 * 查找锚点所在行号（1-based）。
 * @param {string} text
 * @param {string} anchor
 * @returns {number}
 */
function findAnchorLine(text, anchor) {
  const pos = text.indexOf(anchor);
  if (pos < 0) {
    throw new Error(`锚点未找到: ${anchor}`);
  }
  return text.slice(0, pos).split("\n").length;
}

/**
 * 查找所有锚点所在行号（1-based）。
 * @param {string} text
 * @param {string} anchor
 * @returns {number[]}
 */
function findAllAnchorLines(text, anchor) {
  const lines = [];
  let index = 0;
  while (true) {
    const pos = text.indexOf(anchor, index);
    if (pos < 0) break;
    const lineNum = text.slice(0, pos).split("\n").length;
    lines.push(lineNum);
    index = pos + anchor.length;
  }
  if (lines.length === 0) {
    throw new Error(`锚点未找到: ${anchor}`);
  }
  return lines;
}

/**
 * 查找结构结束行号（括号计数法）。
 * @param {string} text
 * @param {string} anchor
 * @returns {number}
 */
function findStructureEnd(text, anchor) {
  const pos = text.indexOf(anchor);
  if (pos < 0) {
    throw new Error(`锚点未找到: ${anchor}`);
  }
  const bracePos = text.indexOf("{", pos);
  if (bracePos < 0) {
    throw new Error(`锚点后未找到 {: ${anchor}`);
  }
  const matchPos = findMatchingBrace(text, bracePos);
  return text.slice(0, matchPos).split("\n").length;
}

/**
 * 获取文本的某一行（1-based）。
 * @param {string} text
 * @param {number} lineNum
 * @returns {string}
 */
function getLine(text, lineNum) {
  const lines = text.split("\n");
  return lines[lineNum - 1] || "";
}

/**
 * 显示匹配行及其上下文。
 * @param {string} text
 * @param {number} lineNum - 匹配行号（1-based）
 * @param {number} context - 上下文行数
 * @param {boolean} isActive - 是否为当前匹配行
 */
function printContext(text, lineNum, context) {
  const lines = text.split("\n");
  const start = Math.max(0, lineNum - 1 - context);
  const end = Math.min(lines.length, lineNum + context);
  for (let i = start; i < end; i++) {
    const prefix = i === lineNum - 1 ? ">" : " ";
    console.log(`${prefix} ${String(i + 1).padStart(4, " ")}: ${lines[i]}`);
  }
}

const program = new Command();
program
  .name("find_line.mjs")
  .description("行号定位工具 — 基于锚点字符串或括号计数法定位行号。")
  .argument("<filepath>", "目标文件路径")
  .argument("<anchor>", "定位锚点字符串")
  .option("--end", "括号计数模式，返回结构结束行号")
  .option("--all", "列出所有匹配行（一行一个行号）")
  .option("--context <N>", "显示匹配行前后 N 行上下文", parseInt)
  .action((filepath, anchor, options) => {
    if (!fs.existsSync(filepath)) {
      console.error(`❌ 文件不存在: ${filepath}`);
      process.exit(1);
    }
    const text = fs.readFileSync(filepath, "utf-8");

    try {
      // --end 模式：返回结构结束行号
      if (options.end) {
        const line = findStructureEnd(text, anchor);
        console.log(line);
        return;
      }

      // --all 模式：列出所有匹配行
      if (options.all) {
        const lines = findAllAnchorLines(text, anchor);
        if (options.context != null) {
          // --all --context N：显示每个匹配的上下文块，用空行分隔
          for (let i = 0; i < lines.length; i++) {
            if (i > 0) console.log("---");
            printContext(text, lines[i], options.context);
          }
        } else {
          // --all 不加 context：只输出行号
          lines.forEach((l) => console.log(l));
        }
        return;
      }

      // 默认模式：返回第一个匹配行
      const line = findAnchorLine(text, anchor);
      if (options.context != null) {
        printContext(text, line, options.context);
      } else {
        console.log(line);
      }
    } catch (e) {
      console.error(`❌ ${e.message}`);
      process.exit(1);
    }
  });
program.parse();