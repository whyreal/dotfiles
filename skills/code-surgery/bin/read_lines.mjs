#!/usr/bin/env node
/**
 * 行读取工具 — 根据行号范围读取文件内容，支持高亮和搜索。
 *
 * 用法：
 *   node read_lines.mjs <文件路径> <起始行> <结束行>
 *   node read_lines.mjs <文件路径> <起始行> <结束行> --highlight searchTerm
 *   node read_lines.mjs <文件路径> <起始行> <结束行> --grep   searchTerm
 *
 * 示例：
 *   node read_lines.mjs file.vue 10 20
 *   → 输出第 10 到 20 行
 *
 *   node read_lines.mjs file.vue 10 20 --highlight catch
 *   → 输出第 10 到 20 行，匹配行前加 > 标记
 *
 *   node read_lines.mjs file.vue 10 20 --grep catch
 *   → 只输出第 10 到 20 行中匹配的行
 */

import fs from "node:fs";
import { Command } from "commander";

const program = new Command();
program
  .name("read_lines.mjs")
  .description("行读取工具 — 根据行号范围读取文件内容，支持高亮和搜索。")
  .argument("<filepath>", "目标文件路径")
  .argument("<start>", "起始行号（1-based）")
  .argument("<end>", "结束行号（1-based，包含）")
  .option("--highlight <pattern>", "高亮匹配行，行前加 > 标记")
  .option("--grep <pattern>", "只显示匹配的行（过滤器模式）")
  .action((filepath, start, end, options) => {
    if (!fs.existsSync(filepath)) {
      console.error(`❌ 文件不存在: ${filepath}`);
      process.exit(1);
    }
    const startLine = parseInt(start, 10);
    const endLine = parseInt(end, 10);
    if (isNaN(startLine) || isNaN(endLine)) {
      console.error("❌ 行号必须为数字");
      process.exit(1);
    }
    if (startLine < 1 || endLine < startLine) {
      console.error("❌ 无效的行号范围");
      process.exit(1);
    }

    const lines = fs.readFileSync(filepath, "utf-8").split("\n");
    if (endLine > lines.length) {
      console.error(`❌ 文件只有 ${lines.length} 行`);
      process.exit(1);
    }

    const slice = lines.slice(startLine - 1, endLine);
    const hasPattern = options.highlight || options.grep;
    const pattern = options.highlight || options.grep;
    const isGrepMode = !!options.grep;

    if (hasPattern) {
      const re = new RegExp(pattern, "i");
      slice.forEach((line, i) => {
        const lineNum = startLine + i;
        const matches = re.test(line);
        if (isGrepMode && !matches) return;
        const prefix = matches ? ">" : " ";
        const paddedNum = String(lineNum).padStart(4, " ");
        console.log(`${prefix} ${paddedNum}: ${line}`);
      });
    } else {
      console.log(slice.join("\n"));
    }
  });
program.parse();