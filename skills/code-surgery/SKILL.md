---
name: code-surgery
description: "代码操作工具集：批量替换、行定位、插入、方法替换。当用户需要精确的代码编辑操作时调用。"
---

# code-surgery — 代码操作工具集

所有工具位于 `bin/`，共享库在 `lib/`。括号计数处理嵌套结构，跳过字符串/注释。

## 工具

### batch_replace — 批量文本替换

根据 `_replace_pairs.json` 替换文本。

```bash
node bin/batch_replace.mjs <glob>
node bin/batch_replace.mjs <glob> --flex        # 弹性缩进（忽略前导空格）
node bin/batch_replace.mjs <glob> --dry-run     # 预览
```

`_replace_pairs.json` 格式：`[["旧文本", "新文本"], ...]`

### find_line — 查找行号

```bash
node bin/find_line.mjs <file> <anchor>          # 找锚点行号
node bin/find_line.mjs <file> <anchor> --end    # 括号计数找结束行
```

### insert_line — 插入行

内容来自 `_insert_content.txt`。

```bash
node bin/insert_line.mjs <file> <lineNum> --before
node bin/insert_line.mjs <file> <lineNum> --after
```

### replace_method — 替换方法体 / 区域

新内容来自 `_new_body.txt`。

```bash
node bin/replace_method.mjs <file> <methodSignature>       # 锚点模式
node bin/replace_method.mjs <file> --region 100:150        # 区域模式
node bin/replace_method.mjs <file> <sig> --dry-run         # 预览
```

### read_lines — 按范围读取行

```bash
node bin/read_lines.mjs <file> <start> <end>
node bin/read_lines.mjs <file> <start> <end> --highlight <pattern>   # 高亮匹配行
node bin/read_lines.mjs <file> <start> <end> --grep <pattern>         # 只显示匹配行
```

### script_runner — 执行临时脚本并自动清理

将脚本写入 OS 临时目录执行，退出自动删除。

```bash
node bin/script_runner.mjs --script 'echo "hello"'          # 直接传内容
node bin/script_runner.mjs --file _temp.sh                  # 从文件读
node bin/script_runner.mjs --script '...' --cwd src/        # 指定工作目录
node bin/script_runner.mjs --script '...' --keep            # 保留临时文件
```

### refactor_catch — 批量替换 try/catch 空忽略 → logger.warn

```bash
node bin/refactor_catch.mjs <glob>
node bin/refactor_catch.mjs <glob> --dry-run
node bin/refactor_catch.mjs <glob> --logger-path '@/infra/services/logger'
```

匹配规则：完全空 catch、仅注释 catch → 替换；已有 logger.warn 或有实际代码 → 跳过。
自动保留缩进 + 添加 import。

### extract — 提取代码块到新文件

```bash
node bin/extract.mjs --from <src> --target <dst> --lines <start:end> --export-as <name>
node bin/extract.mjs --from <src> --target <dst> --lines <start:end> --export-as <name> --dry-run
```

自动生成 `export const <name> = ...` 并替换源文件为 import。

## 原则

### 1. 编辑前先格式化

```bash
npx prettier --write <file>
```

一开始就 format，只做一次。消除缩进差异，锚点匹配可靠，Edit 工具不会因空白失败。

### 2. 从后往前改，防止行号漂移

连续修改大文件时，先改末尾，再改前面。手动执行多个 `Edit` 调用时同样遵循。

### 3. 复杂命令写临时文件执行

用 `Write` 工具写 `_temp.sh`，用 `RunCommand` 执行 `bash _temp.sh`。不要内联。

```markdown
Write: /path/to/project/_temp.sh  → 脚本内容（带 #!/usr/bin/env bash）
RunCommand: bash _temp.sh
```