---
name: "vue2-conventions"
description: "Vue 2 项目通用规范（Options API、组件设计、模板约定、Vuex 状态管理、性能优化）。Invoke when writing new components, reviewing Vue 2 code, or refactoring legacy Vue 2 projects."
---

# Vue 2 项目通用规范

## Options API 规范

- 一律使用 Options API（`export default { ... }`），禁止混用 Composition API（除非已安装 `@vue/composition-api` 插件）
- 组件选项顺序约定：`name` → `components` → `mixins` → `props` → `data` → `computed` → `watch` → `lifecycle hooks` → `methods`



## data

- `data` 中不要包含组件实例（`this`）或 DOM 元素引用

## Props 设计

- **props 必须声明类型**，禁止 `props: ['title']` 无类型标注
- 每个 prop 必须有清晰的类型定义，推荐使用对象语法
- **布尔类型 prop 默认值必须为 `false`**
- 命名用 camelCase（JS 中）和 kebab-case（模板中），框架自动转换
- **禁止从父组件传递函数作为 prop**：通过 `$emit` 通信



## Methods

- **方法名使用 camelCase**，动词开头（`fetchUser`、`handleSubmit`、`toggleVisible`）
- **事件处理方法统一 `handle` 前缀**：`handleClick`、`handleInputChange`
- **禁止在 `methods` 中使用箭头函数定义方法**（会导致 `this` 指向错误）
- 方法内部避免过长（超过 20 行考虑拆分为多个方法）
- 使用 `this.$emit` 触发父组件事件



## Computed

- **computed 必须无副作用**：禁止在 computed 中修改 data、调用异步操作、触发事件
- **能 computed 就别用 methods**：computed 有缓存机制，依赖不变时不重新计算
- 多个 computed 依赖同一数据时，考虑合并为一个
- computed 的 getter 应简洁，复杂逻辑提取为独立函数



## Watch

- **watch 优先用方法名或对象语法**，避免内联匿名函数过长
- **深度监听 `deep: true` 需加注释说明原因**，且注意性能开销
- **`immediate: true` 需加注释说明原因**
- 监听对象属性时用字符串形式：`'form.name'`（带引号）



## 模板约定

- **v-for 必须用唯一 key**：优先用 `item.id`，禁止用 `index` 或 `index + title` 拼接
- **v-if 和 v-for 禁止同时出现在同一元素**：Vue 2 中 v-for 优先级高于 v-if，外层包 `<template>` 做判断
- **事件方法调用不加括号**：`@click="handleSubmit"` 而非 `@click="handleSubmit()"`（除非需要传参）
- **禁用模板插值中的方法调用**：`{{ formatTime(item.date) }}` → computed
- **复杂表达式提取到 script 中**：模板中只出现变量名和简单运算符



## 事件与通信

- **父子通信用 `$emit` + `v-on`**，禁止直接修改 prop
- **`v-model` 默认绑定 `value` prop + `input` 事件**，可通过 `model` 选项自定义
- **跨级通信用 `$attrs` + `$listeners`**（Vue 2.4+），或 `provide / inject`
- **全局事件用 Event Bus**（`new Vue()`），但必须在 `beforeDestroy` 中 `$off` 清理，防止内存泄漏
- **禁止滥用 `$parent` / `$children` 访问组件实例**（耦合度高，难以维护）



## 生命周期 hook

| 用途 | hook |
|------|------|
| 初始化数据请求 | `created`（不涉及 DOM）或 `mounted`（需要 DOM） |
| DOM 操作 / 第三方库初始化 | `mounted` |
| props/data 变化响应 | `watch` 或 `updated` |
| 清理定时器 / 事件监听 | `beforeDestroy` |
| keep-alive 激活 | `activated` |
| keep-alive 停用 | `deactivated` |

- **网络请求优先在 `created` 中发起**（更早执行，不阻塞 DOM 渲染）
- **DOM 操作必须在 `mounted` 中**（`created` 阶段 DOM 不可用）
- **定时器 / 事件监听必须在 `beforeDestroy` 中清理**
- 避免在 `updated` 中修改数据（导致无限循环）



## 样式规范

- 所有 Vue 组件样式必须加 `scoped`
- 全局样式放单独文件（如 `src/styles/`），使用 CSS 变量或预处理变量控制主题
- **Vue 2 的 `scoped` 样式穿透用 `>>>` 或 `/deep/`**（取决于预处理器），推荐使用 `::v-deep`
- CSS class 命名使用 kebab-case



## 组件设计

- **单个组件不超过 500 行**（template + script + style 合计）
- **components 仅含当前页面使用的子组件**，跨页面组件放 `src/components/`
- **禁用多根组件**（Fragment）：Vue 2 不支持 Fragment，必须包一层 `<div>`
- 复杂表单组件考虑 `v-model` + `$emit('input')` 模式



## Mixins

- Mixin 命名用 `xxxMixin` 驼峰格式
- **每个 mixin 只关注一个能力**，不要创建"工具箱"式 mixin
- mixin 的 `data` 和组件 `data` 冲突时，组件优先级高；同名生命周期 hook 会合并执行
- **优先使用 `extends` 或组件组合替代 mixin**（mixin 的命名冲突和隐式依赖难以追踪）



## Vuex 状态管理

- **mutation 必须是同步函数**，异步逻辑放 `actions`
- mutation 命名用大写 + 下划线：`SET_USER`、`SET_LOADING`
- action 命名用 camelCase：`fetchUser`、`updateProfile`
- **禁止在组件中直接修改 Vuex state**（必须通过 mutation）
- 组件内 Vuex 映射用 `mapState`、`mapGetters`、`mapActions`、`mapMutations` 辅助函数



## 路由（Vue Router 2/3）

- **路由组件使用 `beforeRouteEnter` / `beforeRouteLeave`** 做导航守卫
- 路由参数变化通过 `$route` watch 或 `beforeRouteUpdate` 监听
- 命名路由使用 `name` 而非 `path` 跳转（解耦路径配置）



## 性能优化

- **`v-if` vs `v-show`**：频繁切换用 `v-show`，否则用 `v-if`
- **大列表用 `v-once` 或 `track-by`（`key`）**：纯展示的不变列表用 `v-once`
- **`Object.freeze()` 冻结纯展示数据**：`data` 中引用 `Object.freeze(list)` 可跳过 Vue 的响应式代理
- **函数式组件用 `functional: true`**：无状态、无实例的纯展示组件
- **`keep-alive` 缓存动态组件**：避免重复渲染
- **延迟加载（`v-if` + 异步）**：首屏不可见的内容用 `v-if` 控制渲染



## Vue 2 特有注意事项

- **`Vue.set()` / `Vue.delete()`**：Vue 2 无法检测数组索引赋值和对象属性新增/删除，必须使用 `Vue.set()` 或 `this.$set()`
- **`$forceUpdate()`**：极少使用，仅在确实无法触发响应式更新时作为最后手段
- **`v-html` 禁止用于用户输入内容**（XSS 风险），如有需要必须经过 `sanitize-html` 过滤
- **`$nextTick()`**：DOM 更新后执行回调，优先于 `setTimeout(fn, 0)`



## 与 Vue 3 的迁移兼容

- 当前项目使用 Vue 2 时，**避免使用 Vue 3 独有的 API**（如 `Teleport`、`Suspense`、`Composition API`）
- 如需渐进迁移，安装 `@vue/composition-api` 插件，且 **Composition API 和 Options API 不可混用在同一组件中**
- `filters` 在 Vue 3 中已移除，Vue 2 项目中可继续使用，但新代码建议用 computed 替代
- `$listeners` 在 Vue 3 中合并到 `$attrs`，Vue 2 项目中两者分开使用