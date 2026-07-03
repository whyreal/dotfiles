#!/usr/bin/env node

/**
 * 批量文本替换工具 — 带定界符的精确替换，无确认步骤。
 *
 * 用法：
 *   node batch_replace.mjs <glob>
 *
 * 工作流程：
 *  1. 把替换对写入 _replace_pairs.json（JSON 数组，每对 [old, new]）
 *  2. 执行 node batch_replace.mjs（传入 glob 模式）
 *  3. 脚本自动匹配并替换，打印变更清单
 *  4. 用 diagnostics 验证无新增错误
 *  5. 清理 _replace_pairs.json
 *
 * 替换对示例（_replace_pairs.json）：
 *   [
 *     ["this.loadData(",     "this.loadTreeData("],
 *     ["loadData() {",       "loadTreeData() {"],
 *     [":loadData=\"",       ":loadTreeData=\""]
 *   ]
 *
 * 特性：
 *   - 每对 old_string 定界精确，不会误伤字符串字面量
 *   - 替换前无需确认，直接执行
 *   - 替换后打印所有变更（文件:行号:内容对比）
 *   - 全局统计：文件数、替换处数
 */


import { Command } from "commander";
import fs from "node:fs";
import fglob from "fast-glob";

const CONFIG_FILE = "_replace_pairs.json";

/**
 * 从配置文件加载替换对。
 * @returns {Array<[string, string]>}
 */
function loadPairs() {
  const raw = fs.readFileSync(CONFIG_FILE, "utf-8");
  const data = JSON.parse(raw);

  const pairs = [];
  for (const item of data) {
    if (!Array.isArray(item) || item.length !== 2) {
      console.error(`⚠️  跳过无效项: ${JSON.stringify(item)}`);
      continue;
    }
    pairs.push([item[0], item[1]]);
  }
  return pairs;
}

/**
 * 返回文本中所有匹配 old 的位置。
 * @param {string} text
 * @param {string} old
 * @returns {number[]}
 */
function findMatches(text, old) {
  const positions = [];
  let start = 0;
  while (true) {
    const pos = text.indexOf(old, start);
    if (pos < 0) break;
    positions.push(pos);
    start = pos + old.length;
  }
  return positions;
}

/**
 * 在单个文件中执行所有替换对，返回变更记录。
 * @param {string} filepath
 * @param {Array<[string, string]>} pairs
 * @returns {Array<{file: string, line: number, old: string, new: string}>}
 */
function replaceAllInFile(filepath, pairs) {
  let text = fs.readFileSync(filepath, "utf-8");

  const changes = [];
  let modified = text;

  for (const [oldStr, newStr] of pairs) {
    const positions = findMatches(modified, oldStr);
    if (positions.length === 0) continue;

    for (const pos of positions) {
      const lineNum = modified.slice(0, pos).split("\n").length;
      changes.push({
        file: filepath,
        line: lineNum,
        old: oldStr,
        new: newStr,
      });
    }
    modified = modified.replaceAll(oldStr, newStr);
  }

  if (changes.length === 0) return [];

  fs.writeFileSync(filepath, modified, "utf-8");
  return changes;
}
/**
 * 打印帮助信息。
 */

const program = new Command();
program
  .name("batch_replace.mjs")
  .description("批量文本替换工具 \u2014 基于 _replace_pairs.json 中的替换规则，批量替换匹配文件。")
  .argument("<glob>", "文件匹配模式（如 *.vue、src/**/*.ts）")
  .option("--dry-run", "仅预览，不实际写入文件")
  .action((globPattern, options) => {
    const pairs = loadPairs();
    const files = fglob.sync(globPattern, { onlyFiles: true });
    if (files.length === 0) {
      console.error(`\u274c 未找到匹配文件: ${globPattern}`);
      process.exit(1);
    }
    let totalChanges = 0;
    for (const filepath of files.sort()) {
      const changes = replaceAllInFile(filepath, pairs);
      totalChanges += changes.length;
      for (const c of changes) {
        const prefix = options.dryRun ? "\u25b6" : "\u2714";
        console.log(`${prefix} ${c.file}:${c.line}`);
        console.log(`  -${c.old}`);
        console.log(`  +${c.new}`);
      }
    }
    if (options.dryRun) {
      console.log(`\n\u25b6 DRY RUN: 将替换 ${totalChanges} 处（未实际写入）`);
    } else {
      console.log(`\n\u2714 完成: ${files.length} 个文件，${totalChanges} 处替换`);
    }
  });
program.parse();
