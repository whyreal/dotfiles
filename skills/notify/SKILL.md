---
name: notify
description: "Notify 消息通知服务。包装 Ant Design Vue 的 message 和 notification，替代散落的 this.$message.xxx。Invoke when showing toast messages, page notifications, or confirmation prompts in controller/view."
---

# Notify 消息通知服务

> 当前问题：项目通过 `Vue.prototype.$message = window.antd.message` 挂载 message API，各视图层直接 `this.$message.warning('xxx')`。controller 无法使用，且无法统一控制样式和拦截。

## 设计思路

Notify 服务将 Ant Design Vue 的 message（轻量提示）和 notification（桌面通知）统一封装在 `infra/services/` 中，controller 和视图层都通过 import 使用。

## API

### 轻量提示（Toast）

```javascript
notify.toast.success('操作成功')
notify.toast.error('操作失败')
notify.toast.warning('请注意')
notify.toast.info('提示信息')
```

### 桌面通知（Notification）

```javascript
notify.notify.success({ title: '成功', message: '导出完成' })
notify.notify.error({ title: '失败', message: '导出异常' })
notify.notify.warning({ title: '警告', message: '即将超时' })
notify.notify.info({ title: '提示', message: '任务已提交' })
```

## 建议的实现

`src/infra/services/notify.js`：

```javascript
const antd = window.antd;

function createToast() {
  const t = {};
  ['success', 'error', 'warning', 'info'].forEach(type => {
    t[type] = (content, duration) => antd.message[type](content, duration);
  });
  return t;
}

function createNotify() {
  const n = {};
  ['success', 'error', 'warning', 'info'].forEach(type => {
    n[type] = (config) => antd.notification[type]({
      placement: 'bottomRight',
      duration: 4.5,
      ...config,
    });
  });
  return n;
}

class Notify {
  constructor() {
    this.toast = createToast();
    this.notify = createNotify();
  }
}

export const notify = new Notify();
```

## 使用规范

```javascript
import { notify } from '@/infra/services/notify';

// controller 中使用
notify.toast.success('保存成功');
notify.toast.error('保存失败，请重试');

// 同时提示 + 关闭弹窗
modalService.close(name);
notify.toast.success('操作完成');
```

## 和 ModalService 的区别

| 特性 | ModalService | Notify |
|------|-------------|--------|
| 用户必须响应 | ✅（阻塞，等待用户操作） | ❌（自动消失） |
| 返回结果 | ✅（Promise 带结果） | ❌（无结果） |
| 堆叠 | 栈式管理（z-index） | 自动排列 |
| 适用场景 | 确认、编辑、详情 | 提示、反馈 |

## 禁止

- ❌ 在 controller 中直接使用 `this.$message`（controller 没有 Vue 实例）
- ❌ 在视图层用 `this.$message` 替代 `notify.toast`（渐进迁移，新代码用 notify）

---

*相关代码*
- 待创建：`src/infra/services/notify.js`
