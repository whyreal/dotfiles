---
name: "vue-ddd"
description: "Vue + DDD 分层规范（目录结构、依赖规则、Vue 特有约定）。Invoke when creating a new Vue page, reviewing architecture compliance, 拆分，重构, 优化, 整改 Vue code."
---

# Vue DDD 分层架构规范

> 本规则与以下规则互补, 冲突的内容以本规则为准：
> - [ddd-best-practices](../ddd-best-practices/SKILL.md) 通用 DDD 理论（四层架构、战术模式、战略设计等）
> - [vue3-conventions](../vue3-conventions/SKILL.md) 
> - [vue2-conventions](../vue3-conventions/SKILL.md)

## 目录结构

理论模型：

```
src
├── interfaces/               # 视图层
│   ├── store/                # Pinia / VueX
│   ├── pages/页面名/
│   │   ├── components/  # 页面子组件
│   │   ├── service/  # 页面UI服务
│   │   └── 页面名.vue
│   ├── components/           # 跨页面通用组件
├── application/              # 应用层
│   ├── constants/            # 应用级配置常量
│   ├── service/              # 应用服务
├── domain/                   # 领域层
│   ├── aggregate/
│   ├── entity/
│   ├── vo/
│   ├── event/
│   └── service/
└── infra/                    # 基础设施
    ├── api/                  # HTTP（axios）
    ├── storage/                  
    ├── ui/                   # 第三方 UI / DOM 封装
    │   ├── modalService.js   # 管理应用中全部模态框，包括确认框
    │   ├── navService.js     # 页面导航
    │   ├── logger.js         # 日志
    │   ├── eventBus.js         # 导出一个bus 单例 和 一个 bus class
    │   └── notifyService.js  # 页面提示
    ├── converter/            # DTO 相关转换器
    ├── repository/           # 数据仓库（class 单例）
    └── mock/
```

- 目录按需创建，不需要提前占位。

实际项目调整：

```
- src/interfaces/components/  →  src/components/
- src/interfaces/pages/  →  src/views/
- src/interfaces/store/  →  src/store/
```

## 组件拆分指引

- style 超过 100行，拆分到独立文件。

- 数据源读写 -> src/infra/repository/
- DTO 转换 -> src/infra/converter/
- 浏览器存储读写能力封装（sessionstorag/localstorag/Vue.ls) -> src/infra/storage/

## 依赖规则

各层依赖方向严格单向，**禁止反向依赖**。

视图层 --> 应用层/领域层 --> 基础设施

应用层/领域层 可以跳过

## 视图层

视图层是人和 services 的交互媒介，其本身不具有业务功能。

理想情况下，组件 prop 应该只包含 service 实例。
  - 如果 prop 出现数据，分析这些数据是否应该放在某个service 里
  - 如果 prop 出现事件冒泡。
    事件处理函数，
      - 如果涉及业务，分析这些函数是否应该放在某个service 里
      - 如果涉及弹窗，应该使用 modalService 管理 modal，子组件自行弹窗

### 容器组件

- 初始化各种服务，通过prop或其他方式传递给子组件
- Vue3 引入方式：`const xxxCtrl = reactive(new xxxService())`
- Vue2 引入方式：在 `data()` 的 return 中 `new xxxService()`
- 编排子组件和各种服务

### 子组件

- 触发service 上的方法，派生service上的属性，监听Service上属性的变化

### Vue 视图层不该做什么

- ❌ **直接调用 数据源相关 API 或 DTO converter **
- 禁止使用 Mixin

### 存储路径

- 页面不包含子组件，直接保存在 src/views/, 否则放到 src/views/页面/

### 模板约定

- 模板中有大量重复片段时，用配置驱动 + `v-for` 方式精简
- 避免在模板中写复杂表达式，提取到 computed 或方法中
- ❌ **在模板插值 `{{ }}` 中直接调用方法**：派生数据用 computed 预计算

## 应用层

业务编排，禁止使用视图层 API

### Service 规范

- 作为整个应用的业务核心，持有业务状态，编排业务动作，实现业务功能。
- 应该按照业务领域进行拆分，和页面组件的划分无关。

- 基础设施，包括repo 直接在 Service内实例化，不需要外部注入。
- 可以使用 infra/ui/ 提供的通用UI能力

## 领域层

非必要，不使用

## 基础设施层

### 服务

- 使用 [modal-service](../modal-service/SKILL.md) 统一管理 modal
- 导航
- 消息通知
- 日志

### Repository 实现约定

- 职责：从数据源获取数据，使用 本层转换器将 DTO 转换为上层需要格式。包括：格式转换、字段/值兜底等
- 使用 **class 单例** 模式
- 命名：`XxxRepository`（如 `SearchRepository`）
- 导出：`export const xxxRepo = new XxxRepository()`

## 编排与实现

对象：vue 组件，函数，css class

上述对象单元，秉承单一职责原则，要么负责编排，要么负责某个功能实现，不可以兼顾。比如：

- 既调用接口，又对返回值进行处理
