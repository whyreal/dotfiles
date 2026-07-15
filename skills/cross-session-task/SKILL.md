---
name: cross-session-task
description: "Manages large-scale tasks (refactoring/migration/new features) across multiple chat sessions with a checklist. Invoke when starting or continuing a multi-session task."
---

# 跨会话任务管理

大规模任务（重构/迁移/新功能）可能跨多次会话时，按以下流程管理进度：

## 流程

1. **创建清单** — 项目根目录下创建 `TASK_CHECKLIST.md`，包含目标、完成标准、已处理/待处理
2. **每步更新** — 每完成一项立即更新清单状态
3. **会话恢复** — 新会话先读取清单了解进度，再继续工作
4. **完成后** — 删除清单文件

## 清单模板

```markdown
# 任务：xxx
## 目标
## 完成标准
## 已处理
## 待处理
## 风险/注意事项
```

## 使用示例

- **开始任务**："我要开始重构 XX 模块，需要跨多个会话完成" → 创建清单，启动任务
- **恢复任务**："继续上次的重构任务" → 读取清单，了解当前进度
- **完成任务**：所有项目完成后 → 删除清单文件
