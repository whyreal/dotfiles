# ai-bin 工具集

本目录有一套 Node.js 代码处理工具，位于 `bin/`，用于批量替换 / 定位行号 / 插入行 / 替换方法体。

## 快速参考

| 工具 | 用途 | 示例 |
|---|---|---|
| `batch_replace` | 按 `_replace_pairs.json` 批量替换文本 | `node bin/batch_replace.mjs "*.vue"` |
| `find_line` | 锚点定位行号 / `--end` 括号闭环 | `node bin/find_line.mjs file.vue "created()"` |
| `insert_line` | 在行前/后插入 `_insert_content.txt` | `node bin/insert_line.mjs file.vue 423 --before` |
| `replace_method` | 用 `_new_body.txt` 替换方法体 | `node bin/replace_method.mjs file.vue "foo()"` |

## 工作流

```bash
LN=$(node bin/find_line.mjs file.vue "  created() {")
node bin/insert_line.mjs file.vue $LN --after
```

## 公共库

- `lib/code_utils.mjs` — `skipString()` / `findMatchingBrace()`，被 `find_line` 和 `replace_method` 引用。