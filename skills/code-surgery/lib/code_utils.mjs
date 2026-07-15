/**
 * 代码分析工具集 — 字符串跳过、括号匹配。
 */

/**
 * 跳过字符串字面量，返回字符串结束后的位置。
 * @param {string} text
 * @param {number} pos - 引号位置
 * @returns {number}
 */
export function skipString(text, pos) {
  const quote = text[pos];
  let i = pos + 1;
  while (i < text.length) {
    if (text[i] === "\\") {
      i += 2;
      continue;
    }
    if (text[i] === quote) {
      return i + 1;
    }
    i++;
  }
  return i;
}

/**
 * 通用括号匹配 — 从 startPos 开始找到第一个 `{`，跳过字符串/注释/模板 `${}`，
 * 返回匹配的 `}` 位置。
 * @param {string} text
 * @param {number} startPos - 搜索起始位置
 * @returns {number} 匹配的 `}` 的索引
 * @throws 未找到 `{` 或未闭合时抛出
 */
export function findMatchingBrace(text, startPos) {
  const bracePos = text.indexOf("{", startPos);
  if (bracePos < 0) {
    throw new Error(`未找到 {（从位置 ${startPos}）`);
  }

  let count = 0;
  let i = bracePos;

  while (i < text.length) {
    const ch = text[i];

    // 跳过模板字符串 ${}
    if (ch === "$" && i + 1 < text.length && text[i + 1] === "{") {
      let depth = 1;
      let j = i + 2;
      while (j < text.length && depth > 0) {
        if (text[j] === "{") {
          depth++;
        } else if (text[j] === "}") {
          depth--;
        } else if (text[j] === "'" || text[j] === '"' || text[j] === "\`") {
          j = skipString(text, j);
          continue;
        }
        j++;
      }
      i = j;
      continue;
    }

    // 跳过字符串字面量
    if (ch === "'" || ch === '"' || ch === "\`") {
      i = skipString(text, i);
      continue;
    }

    // 跳过单行注释 //
    if (ch === "/" && i + 1 < text.length && text[i + 1] === "/") {
      i = text.indexOf("\n", i);
      if (i < 0) break;
      i++;
      continue;
    }

    // 跳过块注释 /* */
    if (ch === "/" && i + 1 < text.length && text[i + 1] === "*") {
      i = text.indexOf("*/", i + 2);
      if (i < 0) break;
      i += 2;
      continue;
    }

    // 括号计数
    if (ch === "{") {
      count++;
    } else if (ch === "}") {
      count--;
      if (count === 0) {
        return i;
      }
    }

    i++;
  }

  throw new Error(`结构未闭合（从位置 ${startPos} 开始）`);
}
