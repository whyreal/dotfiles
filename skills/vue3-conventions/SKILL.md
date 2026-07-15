---
name: vue3-conventions
description: "Vue 3 项目通用规范（Composition API、组件设计、模板约定、性能优化）。Invoke when writing new components, reviewing Vue code, or refactoring."
---

# Vue 3 项目通用规范

## script setup 规范

- 一律使用 `<script setup>` 语法，禁止 Options API
- 组件名通过 `defineOptions({ name: 'XxxYyy' })` 声明
- props 和 emits 必须使用 `defineProps` / `defineEmits` 声明类型
- `defineProps` 优先用类型标注（纯类型参数），而非对象声明



## ref vs reactive

| 场景 | 选择 |
|------|------|
| 基础类型（string, number, boolean） | `ref` |
| 对象/数组，整体替换 | `ref` |
| 对象，深层嵌套，按属性修改 | `reactive` |
| 表单对象，多处字段绑定 | `reactive` |
| 需要 `watch` 或赋值给另一个 ref | `ref`（reactive 直接赋值会丢失响应） |

**禁止**：用 `ref` 包裹 `reactive`（`ref(reactive(obj))`）或反之。

## Props 设计

- **props 数量 ≤ 5 个**：超过考虑拆分组件或用配置对象
- **禁止从父组件传递函数作为 prop**：通过 `emit` 通信
- **布尔类型 prop 默认值必须为 `false`**，命名用 `is`/`has`/`should` 开头
- **类型必须明确**：禁止 `props: { data: null }` 或未标注类型
- **避免 prop 穿透**：`$attrs` 自动继承时，用 `inheritAttrs: false` 控制

## Emits 设计

- 使用 kebab-case 事件名（模板中）或 camelCase（代码中），保持一致
- 每个 emit 必须有类型声明
- 避免滥用 `emit('update:xxx')` 实现 v-model，仅对表单类组件使用

## 模板约定

- **v-for 必须用唯一 key**：优先用 `item.id`，禁止用 `index` 或 `index + title` 拼接
- **v-if 和 v-for 禁止同时出现在同一元素**：外层包一层 `<template>` 做判断
- **事件方法调用不加括号**：`@click="handleSubmit"` 而非 `@click="handleSubmit()"`
- **禁用模板插值中的方法调用**：`{{ formatTime(item.date) }}` → computed
- **复杂表达式提取到 script 中**：模板中只出现变量名和简单运算符（`?.`、`??`、三元）

## 组件设计

- **单个组件不超过 300 行**（template + script + style 合计）
- **components 仅含当前页面使用的子组件**：跨页面组件放 `src/components/`
- **Container/Presentational 分离**：数据获取和 UI 渲染解耦，至少让子组件可独立测试
- **禁用多根组件**（Fragment）：除非确实需要，否则包一层 `<div>`

## 生命周期

- **网络请求在 `onMounted` 中发起**，非 `setup` 顶层（SSR 兼容）
- **定时器/事件监听必须在 `onUnmounted` 清理**
- **watchEffect 优先于 watch**：除非需要监听特定字段或访问旧值
- **`immediate: true` 需加注释说明原因**

## 样式规范

- 所有 Vue 组件样式必须加 `scoped`
- 全局样式放 `src/style.scss`，使用 CSS 变量控制主题
- 避免深层选择器 `:deep()` 滥用：子组件应该通过 props 暴露样式接口
- CSS class 命名使用 kebab-case

## 性能

- **能 `computed` 就别用方法**：computed 有缓存机制
- **大列表用 `v-once` 或 `shallowRef`**：纯展示的不变列表用 `v-once`
- **`v-if` vs `v-show`**：频繁切换用 `v-show`，否则用 `v-if`
- **组件级别的按需加载**：路由组件用 `defineAsyncComponent`

## Composables

- **命名用 `useXxx` 驼峰格式**
- **每个 composable 只关注一个能力**：不要创建 "工具箱" 式 composable
- **返回值用对象**（方便解构），**不用数组**
- **禁止在 composable 内部修改传入的 ref 参数**：通过返回值传递变更
- **副作用在 composable 内部清理**（`onUnmounted`）