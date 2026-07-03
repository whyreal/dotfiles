#!/usr/bin/env node
/**
 * 行号定位工具 — 基于锚点字符串或括号计数法定位行号。
 *
 * 用法：
 *   node find_line.mjs <文件路径> <锚点>           # 返回锚点所在行
 *   node find_line.mjs <文件路径> <锚点> --end     # 括号计数，返回结构结束行
 *
 * 示例：
 *   node find_line.mjs ConditionTree.vue "  created() {"
 *   → 423
 *
 *   node find_line.mjs SankeyJumpController.js "class SankeyJumpController {" --end
 *   → 495
 */

import fs from "node:fs";
import { Command } from "commander";
import { skipString, findMatchingBrace } from "./code_utils.mjs";

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

const program = new Command();
program
  .name("find_line.mjs")
  .description("行号定位工具 — 基于锚点字符串或括号计数法定位行号。")
  .argument("<filepath>", "目标文件路径")
  .argument("<anchor>", "定位锚点字符串")
  .option("--end", "括号计数模式，返回结构结束行号")
  .action((filepath, anchor, options) => {
    if (!fs.existsSync(filepath)) {
      console.error(`❌ 文件不存在: ${filepath}`);
      process.exit(1);
    }
    const text = fs.readFileSync(filepath, "utf-8");
    try {
      const line = options.end ? findStructureEnd(text, anchor) : findAnchorLine(text, anchor);
      console.log(line);
    } catch (e) {
      console.error(`❌ ${e.message}`);
      process.exit(1);
    }
  });
program.parse();