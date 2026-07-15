---
name: "modal-service"
description: "ModalService 使用规则。添加新弹窗、注册、调用、组件约定的完整流程。Invoke when creating a new modal dialog, adding modal registration, or calling modalService in controller/view."
---

# ModalService 使用规则

项目弹窗采用**集中注册 + 常量传名 + 工厂分包**方案。

## 添加新弹窗

三步完成：

### 1. 写组件

弹窗组件放在 `views/` 下对应业务模块：

```vue
<!-- views/xxxModules/MyModal.vue -->
<template>
  <a-modal :visible="visible" title="我的弹窗" @ok="handleOk" @cancel="handleCancel">
    <div>{{ params.content }}</div>
  </a-modal>
</template>

<script>
export default {
  name: 'MyModal',
  props: {
    params: { type: Object, default: () => ({}) }
  },
  data() {
    return { visible: true };
  },
  methods: {
    handleOk() { this.$emit('confirm', { confirmed: true }); },
    handleCancel() { this.$emit('close', { confirmed: false }); }
  }
};
</script>
```

### 2. 加常量

在 `src/application/constants/modalNames.js` 中添加：

```javascript
export const MODAL = {
  CONFIRM: 'confirm',
  EXPORT_FILTER_CONFIRM: 'export-filter-confirm',
  MY_MODAL: 'my-modal',  // ← 新增
};
```

### 3. 注册

在 `src/main.js` 中添加注册（工厂函数实现分包）：

```javascript
modalService.register(MODAL.MY_MODAL, () => import('@/views/xxxModules/MyModal.vue').then(m => m.default));
```

## 调用方式

### 在 controller 中调用

```javascript
import { modalService } from '@/infra/services/modalService';
import { MODAL } from '@/application/constants/modalNames';

async handleSomething() {
  try {
    const result = await modalService.open(MODAL.MY_MODAL, { /* params */ });
    if (!result || !result.confirmed) return;
    // 处理结果...
  } catch (e) {
    console.error('弹窗异常', e);
  }
}
```

### 在视图层（.vue）中调用

```javascript
import { modalService } from '@/infra/services/modalService';
import { MODAL } from '@/application/constants/modalNames';

async handleClick() {
  const result = await modalService.open(MODAL.CONFIRM, { title: '提示', content: '确认？' });
  if (result.confirmed) { /* ... */ }
}
```

## 组件约定

- `props` 必须有一个 `params` 属性接收参数
- 确定按钮 `$emit('confirm', result)`
- 取消按钮 `$emit('close', result)`
- `name` 属性用于 Vue 开发者工具调试
- 组件文件放在 `views/` 下，不放在 `infra/`

## ModalService API

- `register(name, componentOrFactory)` — 注册弹窗，传组件对象或工厂函数
- `open(name, params)` — 打开弹窗，返回 Promise（resolve 值为 emit 传出的结果）
- `close(name, result)` — 关闭弹窗
- `closeAll()` — 关闭所有弹窗
- `has(name)` — 判断弹窗是否已注册

## 弹窗间不再需要模板嵌套

用 ModalService 之前，一个弹窗想开另一个弹窗，必须在模板里写死子组件、通过 ref 调用、再用 `$emit` 层层传递结果。弹窗之间是父子关系，耦合在模板上。

用 ModalService 之后，弹窗之间是平级的。任何一个弹窗（或 controller）都可以直接 `await modalService.open(NAME)` 开另一个弹窗，没有模板依赖、没有事件链。这种"打平"的方式让弹窗可以独立存在、自由组合。

```vue
<!-- 以前：模板里嵌子弹窗，ref + emit 传递 -->
<template>
  <a-modal>
    <child-modal ref="childRef" @result="handleResult" />
  </a-modal>
</template>

<!-- 用 ModalService：平级调用，直接 await -->
<script>
methods: {
  async handleNext() {
    const r = await modalService.open(MODAL.SOME_MODAL, params);
    // 直接拿结果
  }
}
</script>
```

工厂函数示例：

```javascript
// 工厂函数（动态 import）→ 独立 chunk，用到才下载
() => import('@/views/xxxModules/MyModal.vue').then(m => m.default)

// 直接传组件对象 → 打包进当前 chunk
import MyModal from '@/views/xxxModules/MyModal.vue';
modalService.register(MODAL.MY_MODAL, MyModal);
```

## Confirm 弹窗（全局确认框）

项目预置了一个通用确认弹窗 `GlobalConfirmModal`，用于"是否确认"类场景。

### 注册

已在 `main.js` 中注册好了：

```javascript
modalService.register(MODAL.CONFIRM, () => import('@/views/common/GlobalConfirmModal.vue').then(m => m.default));
```

### 调用

```javascript
import { modalService } from '@/infra/services/modalService';
import { MODAL } from '@/application/constants/modalNames';

const result = await modalService.open(MODAL.CONFIRM, {
  title: '确认删除',
  content: '删除后不可恢复，是否继续？',
  okText: '确定删除',
  okType: 'danger',
  async: true            // 需要异步 loading 时开启
});
if (!result.confirmed) return;
// 用户点了确定...
```

### 参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| title | string | '提示' | 弹窗标题 |
| content | string | - | 提示内容 |
| okText | string | '确定' | 确定按钮文字 |
| cancelText | string | '取消' | 取消按钮文字 |
| okType | string | 'primary' | 按钮类型（primary/danger/dashed） |
| width | number | 520 | 弹窗宽度 |
| async | boolean | false | 是否异步模式（确定后按钮显示 loading） |

### 返回结果

| 场景 | result 值 |
|------|-----------|
| 点确定 | `{ confirmed: true }` |
| 点取消/关 | `{ confirmed: false }` |

## 注意事项

- 调用 `modalService.open` 时用 try/catch 包裹（注册表中找不到弹窗会 throw）
- 返回值是 Promise，resolve 的值由弹窗 emit 的结果决定
- 不要在弹窗组件内写业务逻辑，弹窗只负责展示和收集用户操作
- controller 只 import 常量和 ModalService，不 import .vue 文件
