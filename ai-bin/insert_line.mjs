#!/usr/bin/env node

/**
 * 行插入工具 — 在指定行号前或后插入文本。
 *
 * 用法：
 *   node insert_line.mjs <文件路径> <行号> --before   # 在行前插入
 *   node insert_line.mjs <文件路径> <行号> --after    # 在行后插入
 *
 * 工作流程：
 *  1. 把待插入内容写入 _insert_content.txt（用 Write 工具）
 *  2. 执行插入：node insert_line.mjs <文件路径> <行号> --before
 *  3. 验证结果
 *  4. 清理 _insert_content.txt
 *
 * 示例：
 *   # 在 created() 前插入一行
 *   # 先写 _insert_content.txt → "  this.sankeyJumpCtrl.consumePayloadIfAny()\n"
 *   node insert_line.mjs ConditionTree.vue 423 --before
 *
 * 组合 find_line 使用：
 *   LN=$(node find_line.mjs xxx.vue "  created() {")
 *   node insert_line.mjs xxx.vue $LN --before
 *
 * 注意事项：
 *   - 行号是 1-based
 *   - --before 在目标行之前插入，目标行下移
 *   - --after 在目标行之后插入，目标行不变
 *   - 插入后打印受影响的行范围
 */


import { Command } from "commander";
import fs from "node:fs";

const INSERT_FILE = "_insert_content.txt";

/**
 * 按行分割文本，保留每行末尾的换行符（类似 Python 的 splitlines(keepends=True)）。
 * @param {string} text
 * @returns {string[]}
 */
function splitLinesKeepEnds(text) {
  // 用正则在换行符后分割，保留 \n 在行内
  const parts = text.split(/(?<=\n)/);
  // 如果文本不以 \n 结尾，最后一项没有换行符，这是正常的
  return parts;
}
/**
 * 打印帮助信息。
 */

const program = new Command();
program
  .name("insert_line.mjs")
  .description("行插入工具 \u2014 在指定行号前或后插入文本（内容来自 _insert_content.txt）。")
  .argument("<filepath>", "目标文件路径")
  .argument("<lineNum>", "1-based 行号", (v) => parseInt(v, 10))
  .option("--before", "在目标行之前插入")
  .option("--after", "在目标行之后插入")
  .action((filepath, lineNum, options) => {
    if (!options.before && !options.after) {
      console.error("\u274c 必须指定 --before 或 --after");
      process.exit(1);
    }
    if (!fs.existsSync(filepath)) {
      console.error(`\u274c 文件不存在: ${filepath}`);
      process.exit(1);
    }
    if (!fs.existsSync(INSERT_FILE)) {
      console.error(`\u274c 插入内容文件不存在: ${INSERT_FILE}`);
      console.error("   请先准备 _insert_content.txt（用 Write 工具写入待插入内容）");
      process.exit(1);
    }
    if (isNaN(lineNum) || lineNum < 1) {
      console.error(`\u274c 行号必须是正整数: ${lineNum}`);
      process.exit(1);
    }

    const insertText = fs.readFileSync(INSERT_FILE, "utf-8");
    const text = fs.readFileSync(filepath, "utf-8");
    const lines = splitLinesKeepEnds(text);

    if (lineNum > lines.length) {
      console.error(`\u274c 行号越界: ${lineNum}（文件共 ${lines.length} 行）`);
      process.exit(1);
    }

    const insertLines = splitLinesKeepEnds(insertText);
    const idx = lineNum - 1;
    const originalCount = lines.length;

    if (options.before) {
      lines.splice(idx, 0, ...insertLines);
      console.log(`\u2728 已插入 ${insertLines.length} 行: L${lineNum} (前插)`);
    } else {
      lines.splice(idx + 1, 0, ...insertLines);
      console.log(`\u2728 已插入 ${insertLines.length} 行: L${lineNum} (后插)`);
    }

    fs.writeFileSync(filepath, lines.join(""), "utf-8");
    const added = lines.length - originalCount;
    console.log(`   文件: ${filepath}`);
  });
program.parse();
