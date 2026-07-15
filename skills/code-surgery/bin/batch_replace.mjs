#!/usr/bin/env node

/**
 * 批量文本替换工具 — 支持精确匹配和弹性缩进模式。
 *
 * 用法：
 *   # 精确匹配（默认）
 *   node batch_replace.mjs <glob>
 *
 *   # 弹性缩进模式：忽略前导空格差异
 *   node batch_replace.mjs <glob> --flex
 *
 *   # 预览模式
 *   node batch_replace.mjs <glob> --dry-run
 *   node batch_replace.mjs <glob> --flex --dry-run
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
 * 弹性缩进模式（--flex）：
 *   当同一段代码在不同缩进层级出现时（如不同深度嵌套的 catch），
 *   无需为每种缩进写单独的替换对。old 中忽略前导空格。
 *
 *   示例：匹配任意缩进的 "catch {"
 *   [["catch {", "catch (e) { }"]]
 *
 * 特性：
 *   - 精确模式：每对 old_string 定界精确，不会误伤字符串字面量
 *   - 弹性模式：忽略前导空格差异，自动保留原缩进
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
 * 返回文本中所有匹配 old 的位置（精确模式）。
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
 * 构建弹性缩进正则：忽略前导空格，保留原缩进替换。
 * @param {string} old
 * @returns {RegExp}
 */
function buildFlexRegex(old) {
  // 去掉前导空格
  const stripped = old.replace(/^[ \t]+/, "");
  // 转义正则特殊字符
  const escaped = stripped.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  // 捕获前导空格，替换时保留原缩进
  return new RegExp(`([ \\t]*)${escaped}`, "g");
}

/**
 * 在单个文件中执行所有替换对（精确模式），返回变更记录。
 * @param {string} filepath
 * @param {Array<[string, string]>} pairs
 * @param {boolean} dryRun
 * @returns {Array<{file: string, line: number, old: string, new: string}>}
 */
function replaceAllInFile(filepath, pairs, dryRun) {
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
  if (!dryRun) {
    fs.writeFileSync(filepath, modified, "utf-8");
  }
  return changes;
}

/**
 * 在单个文件中执行所有替换对（弹性缩进模式），返回变更记录。
 * @param {string} filepath
 * @param {Array<[string, string]>} pairs
 * @param {boolean} dryRun
 * @returns {Array<{file: string, line: number, old: string, new: string}>}
 */
function replaceAllInFileFlex(filepath, pairs, dryRun) {
  let text = fs.readFileSync(filepath, "utf-8");

  const changes = [];
  let modified = text;

  for (const [oldStr, newStr] of pairs) {
    const regex = buildFlexRegex(oldStr);
    const matches = [...modified.matchAll(regex)];
    if (matches.length === 0) continue;

    for (const m of matches) {
      const lineNum = modified.slice(0, m.index).split("\n").length;
      changes.push({
        file: filepath,
        line: lineNum,
        old: oldStr,
        new: newStr,
      });
    }
    // 替换时保留原缩进
    modified = modified.replace(regex, (match, indent) => indent + newStr);
  }

  if (changes.length === 0) return [];
  if (!dryRun) {
    fs.writeFileSync(filepath, modified, "utf-8");
  }
  return changes;
}

const program = new Command();
program
  .name("batch_replace.mjs")
  .description(
    "批量文本替换工具 — 基于 _replace_pairs.json 中的替换规则，批量替换匹配文件。"
  )
  .argument("<glob>", "文件匹配模式（如 *.vue、src/**/*.ts）")
  .option("--flex", "弹性缩进模式：忽略前导空格差异，自动保留原缩进")
  .option("--dry-run", "仅预览，不实际写入文件")
  .action((globPattern, options) => {
    const pairs = loadPairs();
    const files = fglob.sync(globPattern, { onlyFiles: true });
    if (files.length === 0) {
      console.error(`❌ 未找到匹配文件: ${globPattern}`);
      process.exit(1);
    }

    const replaceFn = options.flex
      ? replaceAllInFileFlex
      : replaceAllInFile;

    let totalChanges = 0;
    for (const filepath of files.sort()) {
      const changes = replaceFn(filepath, pairs, options.dryRun);
      totalChanges += changes.length;
      for (const c of changes) {
        const prefix = options.dryRun ? "▶" : "✔";
        console.log(`${prefix} ${c.file}:${c.line}`);
        console.log(`  -${c.old}`);
        console.log(`  +${c.new}`);
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