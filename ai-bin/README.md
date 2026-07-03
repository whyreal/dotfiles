# ai-bin

Node.js 版代码辅助工具集。通过命令行快速定位、插入、替换代码。

## 安装

```bash
npm install
```

## 工具列表

### batch_replace — 批量文本替换

基于 `_replace_pairs.json` 中的替换规则，批量替换匹配文件。

```bash
node bin/batch_replace.mjs "src/**/*.vue"
node bin/batch_replace.mjs "*.ts" --dry-run    # 仅预览
```

**`_replace_pairs.json` 格式：**
```json
[
  ["this.loadData(", "this.loadTreeData("],
  [":loadData=", ":loadTreeData="]
]
```

---

### find_line — 行号定位

基于锚点字符串或括号计数法定位行号，用于给其它工具提供行号参数。

```bash
# 返回锚点所在行号
node bin/find_line.mjs ConditionTree.vue "  created() {"
# → 423

# 括号计数，返回结构结束行号
node bin/find_line.mjs SankeyJumpController.js "class SankeyJumpController {" --end
# → 495
```

---

### insert_line — 行插入

在指定行号前或后插入文本。

```bash
# 1. 准备插入内容
echo "  this.doSomething()" > _insert_content.txt

# 2. 执行插入
node bin/insert_line.mjs ConditionTree.vue 423 --before

# 3. 清理
rm _insert_content.txt

# 组合 find_line 使用
LN=$(node bin/find_line.mjs xxx.vue "  created() {")
node bin/insert_line.mjs xxx.vue $LN --after
```

---

### replace_method — 方法体替换

基于括号计数法精确定位方法边界并替换。

```bash
# 1. 准备新方法体
cat > _new_body.txt << 'EOF'
applySankeyPayload(payload) {
  this.loadTreeData(payload);
  this.updateView();
}
EOF

# 2. 执行替换
node bin/replace_method.mjs src/views/xxx.vue "applySankeyPayload(payload)"

# 3. 清理
rm _new_body.txt
```

## 工作流示例

组合使用完成一次典型的方法改名 + 插入调用：

```bash
# 1. 批量替换方法名
node bin/batch_replace.mjs "src/**/*.vue"

# 2. 在 created 中插入调用
LN=$(node bin/find_line.mjs ConditionTree.vue "  created() {")
node bin/insert_line.mjs ConditionTree.vue $LN --before
```

## 目录结构

```
ai-bin/
├── bin/                  # 可执行入口
│   ├── batch_replace.mjs
│   ├── find_line.mjs
│   ├── insert_line.mjs
│   └── replace_method.mjs
├── lib/                  # 公共组件
│   └── code_utils.mjs
├── package.json
└── README.md
```