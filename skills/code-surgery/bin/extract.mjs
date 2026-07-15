#!/usr/bin/env node
/**
 * extract — 从源文件提取代码块到目标文件，并自动加 import。
 *
 * 用法：
 *   node bin/extract.mjs --from source.vue --target target.js --lines 100:150 --export-as myConst
 *   node bin/extract.mjs --from source.vue --target target.js --lines 100:150 --export-as myConst --dry-run
 *
 * 流程：
 * 1. 从源文件读取指定行范围
 * 2. 写入目标文件（export const myConst = ...）
 * 3. 替换源文件指定行为 import { myConst } from './relative/path'
 *
 * --export-as 不指定时，只提取原始内容到目标文件，不替换源文件。
 */

import fs from 'node:fs';
import path from 'node:path';
import { Command } from 'commander';

/**
 * 解析行范围参数 "start:end"。
 * @param {string} range
 * @returns {{ start: number, end: number }}
 */
function parseLineRange(range) {
  const parts = range.split(':');
  if (parts.length !== 2) {
    throw new Error(
      `Invalid line range: ${range}. Expected format: start:end`
    );
  }
  const start = parseInt(parts[0], 10);
  const end = parseInt(parts[1], 10);
  if (isNaN(start) || isNaN(end) || start < 1 || end < start) {
    throw new Error(
      `Invalid line range: ${range}. Must be start:end with start >= 1 and end >= start`
    );
  }
  return { start, end };
}

/**
 * 计算源文件到目标文件的相对路径（用于 import 语句）。
 * @param {string} fromFile
 * @param {string} toFile
 * @returns {string}
 */
function computeRelativePath(fromFile, toFile) {
  const fromDir = path.dirname(fromFile);
  const rel = path.relative(fromDir, toFile);
  if (!rel.startsWith('.') && !rel.startsWith('/')) {
    return './' + rel;
  }
  return rel;
}

/**
 * 提取指定行范围的内容。
 * @param {string} text
 * @param {number} start - 1-based
 * @param {number} end - 1-based, inclusive
 * @returns {string}
 */
function extractLines(text, start, end) {
  const lines = text.split('\n');
  return lines.slice(start - 1, end).join('\n');
}

/**
 * 替换指定行范围为新内容。
 * @param {string} text
 * @param {number} start - 1-based
 * @param {number} end - 1-based, inclusive
 * @param {string} replacement
 * @returns {string}
 */
function replaceLines(text, start, end, replacement) {
  const lines = text.split('\n');
  const before = lines.slice(0, start - 1);
  const after = lines.slice(end);
  return [...before, replacement, ...after].join('\n');
}

const program = new Command();
program
  .name('extract.mjs')
  .description(
    '从源文件提取代码块到目标文件，并自动加 import。'
  )
  .requiredOption('--from <path>', '源文件路径')
  .requiredOption('--target <path>', '目标文件路径')
  .requiredOption('--lines <range>', '源文件中的行范围，如 100:150')
  .option(
    '--export-as <name>',
    '导出名，生成 export const <name> = ... 并替换源文件为 import'
  )
  .option('--dry-run', '仅预览，不写入文件')
  .action((options) => {
    let start, end;
    try {
      ({ start, end } = parseLineRange(options.lines));
    } catch (e) {
      console.error(`❌ ${e.message}`);
      process.exit(1);
    }

    if (!fs.existsSync(options.from)) {
      console.error(`❌ 源文件不存在: ${options.from}`);
      process.exit(1);
    }

    const sourceText = fs.readFileSync(options.from, 'utf-8');
    const sourceLines = sourceText.split('\n');

    if (end > sourceLines.length) {
      console.error(
        `❌ 行范围超出文件长度: ${end} > ${sourceLines.length}`
      );
      process.exit(1);
    }

    const extracted = extractLines(sourceText, start, end);

    // 计算 import 路径
    const importPath = computeRelativePath(options.from, options.target);

    // 构建目标文件内容
    let targetContent;
    let importStatement;

    if (options.exportAs) {
      targetContent = `export const ${options.exportAs} = ${extracted};\n`;
      importStatement = `import { ${options.exportAs} } from '${importPath}';`;
    } else {
      targetContent = extracted + '\n';
      importStatement = null;
    }

    if (options.dryRun) {
      console.log('=== 提取的内容（将写入目标文件）===');
      console.log(targetContent);

      if (importStatement) {
        console.log('=== import 语句（将替换源文件行范围）===');
        console.log(importStatement);
        console.log('');

        // 显示替换位置的上下文
        const previewStart = Math.max(0, start - 3);
        const previewEnd = Math.min(sourceLines.length, start + 2);
        console.log('=== 替换位置上下文 ===');
        for (let i = previewStart; i < previewEnd; i++) {
          const prefix = i === start - 1 ? '>' : ' ';
          const lineNum = String(i + 1).padStart(4, ' ');
          console.log(`${prefix} ${lineNum}: ${sourceLines[i]}`);
        }
      } else {
        console.log('（未指定 --export-as，不替换源文件）');
      }
      return;
    }

    // 写入目标文件
    const targetDir = path.dirname(options.target);
    if (!fs.existsSync(targetDir)) {
      fs.mkdirSync(targetDir, { recursive: true });
    }
    fs.appendFileSync(options.target, targetContent, 'utf-8');
    const lineCount = extracted.split('\n').length;
    console.log(`✅ 写入 ${lineCount} 行 → ${options.target}`);

    // 替换源文件
    if (importStatement) {
      const newSourceText = replaceLines(
        sourceText,
        start,
        end,
        importStatement
      );
      fs.writeFileSync(options.from, newSourceText, 'utf-8');
      console.log(
        `✅ 替换 ${options.from} 的第 ${start}-${end} 行为 import`
      );
      console.log(`   → ${importStatement}`);
    } else {
      console.log('ℹ️  未指定 --export-as，跳过源文件替换');
    }
  });

program.parse();