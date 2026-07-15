#!/usr/bin/env node

/**
 * 临时脚本执行器 — 将脚本写入 OS 临时目录、执行、自动清理。
 *
 * 用法：
 *   # 直接传脚本内容（适合短脚本）
 *   node bin/script_runner.mjs --script 'echo "hello" && ls'
 *
 *   # 从已有文件读取（适合长脚本，自动清理临时副本）
 *   node bin/script_runner.mjs --file _temp_script.sh
 *
 *   # 指定工作目录
 *   node bin/script_runner.mjs --script 'npm test' --cwd src/
 *
 *   # 保留临时文件（调试用）
 *   node bin/script_runner.mjs --script '...' --keep
 *
 * 工作流程：
 *   1. 创建临时文件到 OS 临时目录
 *   2. 写入脚本内容或复制文件内容
 *   3. 自动 chmod +x
 *   4. 执行并透传 stdout/stderr/exit code
 *   5. 退出后自动删除临时文件（除非 --keep）
 */

import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { spawnSync } from "node:child_process";
import { Command } from "commander";

const program = new Command();
program
  .name("script_runner.mjs")
  .description("临时脚本执行器 — 写入 OS 临时目录、执行、自动清理。")
  .option("--script <content>", "脚本内容（直接传字符串）")
  .option("--file <path>", "脚本文件路径（从已有文件读取）")
  .option("--cwd <dir>", "工作目录，默认当前目录")
  .option("--keep", "保留临时文件（调试用）")
  .action((options) => {
    // ── 校验参数 ──
    if (!options.script && !options.file) {
      console.error("❌ 必须指定 --script 或 --file");
      process.exit(1);
    }
    if (options.script && options.file) {
      console.error("❌ --script 和 --file 不能同时使用");
      process.exit(1);
    }

    // ── 读取脚本内容 ──
    let content;
    let sourceLabel;
    if (options.script) {
      content = options.script;
      sourceLabel = "--script";
    } else {
      if (!fs.existsSync(options.file)) {
        console.error(`❌ 文件不存在: ${options.file}`);
        process.exit(1);
      }
      content = fs.readFileSync(options.file, "utf-8");
      sourceLabel = options.file;
    }

    // ── 写入临时文件 ──
    const timestamp = Date.now();
    const tmpDir = os.tmpdir();
    const tmpFile = path.join(tmpDir, `script_runner_${timestamp}.sh`);
    fs.writeFileSync(tmpFile, content, "utf-8");
    fs.chmodSync(tmpFile, 0o755);

    // ── 确定工作目录 ──
    const cwd = options.cwd
      ? path.resolve(options.cwd)
      : process.cwd();

    // ── 执行脚本（同步，用 bash 执行，无需 shebang） ──
    const result = spawnSync("bash", [tmpFile], {
      cwd,
      stdio: "inherit",
    });

    // ── 清理（除非 --keep） ──
    if (!options.keep) {
      try {
        fs.unlinkSync(tmpFile);
      } catch {
        // 忽略清理失败
      }
    }

    process.exit(result.status ?? 1);
  });

program.parse();