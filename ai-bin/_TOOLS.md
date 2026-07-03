# ai-bin — 跨项目代码辅助工具集

本目录 (`~/code/whyreal/dotfiles/ai-bin`) 有一套 Node.js 代码处理工具。
在任何项目中使用，路径为 `~/code/whyreal/dotfiles/ai-bin/bin/<工具名>`。

## 工具

| 工具 | 用途 | 用法 |
|---|---|---|
| `batch_replace` | 按 `_replace_pairs.json` 批量替换文本 | `node ~/.../bin/batch_replace.mjs "*.vue"` |
| `find_line` | 锚点定位行号 / `--end` 括号闭环 | `node ~/.../bin/find_line.mjs file.vue "created()"` |
| `insert_line` | 在行前/后插入 `_insert_content.txt` | `node ~/.../bin/insert_line.mjs file.vue 423 --before` |
| `replace_method` | 用 `_new_body.txt` 替换方法体 | `node ~/.../bin/replace_method.mjs file.vue "foo()"` |

## 工作流

```bash
# 批量改名 → 在 created 中插入调用
node ~/code/whyreal/dotfiles/ai-bin/bin/batch_replace.mjs "src/**/*.vue"
LN=$(node ~/code/whyreal/dotfiles/ai-bin/bin/find_line.mjs file.vue "  created() {")
node ~/code/whyreal/dotfiles/ai-bin/bin/insert_line.mjs file.vue $LN --after
```

## 公共库

- `lib/code_utils.mjs` — `skipString()` / `findMatchingBrace()`