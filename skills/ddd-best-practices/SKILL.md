---
name: "ddd-best-practices"
description: "通用 DDD 最佳实践（分层架构、战术模式、战略设计、边界决策）。Invoke when designing system architecture, reviewing layer boundaries, or deciding whether to introduce domain models."
---

# DDD 最佳实践

> 本规则是语言/框架无关的通用 DDD 实践指南。适用于任何后端、前端或全栈项目。
>
> 若项目使用 Vue，请同时参考 [vue-ddd](../vue-ddd/SKILL.md) 获取 Vue 特有的分层约定。

## 目录

- [核心概念](#核心概念)
- [四层架构](#四层架构)
- [依赖规则](#依赖规则)
- [战术模式](#战术模式)
- [战略设计](#战略设计)
- [各层职责边界](#各层职责边界)
- [引入 DDD 的决策树](#引入-ddd-的决策树)
- [常见反模式](#常见反模式)
- [命名规范](#命名规范)

---

## 核心概念

DDD（Domain-Driven Design，领域驱动设计）的核心思想：**软件复杂性应围绕业务领域来组织，而非技术框架**。

| 概念 | 说明 |
|------|------|
| **领域（Domain）** | 业务问题空间，即软件要解决的业务范围 |
| **子域（Subdomain）** | 领域的细分。分三类：核心子域（核心竞争力）、支撑子域（辅助）、通用子域（通用能力，如认证） |
| **限界上下文（Bounded Context）** | 领域模型的边界。每个上下文内部有统一的领域语言（Ubiquitous Language） |
| **领域语言（Ubiquitous Language）** | 团队（业务+技术）共享的业务术语，贯穿代码、文档、沟通 |

### 核心理念

```
业务专家 <--领域语言--> 开发团队
      ↓
   代码模型（准确反映业务概念）
```

---

## 四层架构

### 分层模型

```
┌─────────────────────────────────────────┐
│          接口层（Interface）              │
│  Controller / API Handler / View / CLI  │
│  职责：接收输入、返回响应、委托给应用层   │
├─────────────────────────────────────────┤
│          应用层（Application）            │
│    Application Service / DTO / 编排      │
│  职责：用例编排、事务管理、权限检查       │
├─────────────────────────────────────────┤
│          领域层（Domain）                │
│  Entity / Value Object / Aggregate /     │
│  Domain Service / Domain Event          │
│  职责：核心业务逻辑、业务规则             │
├─────────────────────────────────────────┤
│        基础设施层（Infrastructure）         │
│  Repository / Message Bus / Cache / DB  │
│  职责：技术实现、IO、与外部系统通信        │
└─────────────────────────────────────────┘
```

### 各层职责

#### 接口层
- 解析用户输入（HTTP 请求、CLI 参数、消息队列消息）
- 调用应用服务处理请求
- 将结果序列化为响应格式
- **不含业务逻辑**

#### 应用层
- **编排**：按用例流程协调多个领域对象和基础设施
- 事务边界管理
- 权限/安全校验
- 数据转换（DTO ↔ 领域模型）
- **不包含业务规则**（业务规则在领域层）

#### 领域层
- **核心**：所有业务逻辑、业务规则、业务不变量的所在地
- 定义 Entity、Value Object、Aggregate
- Domain Service（处理跨实体的业务逻辑）
- Domain Event（领域事件）
- **零依赖**：不依赖框架、数据库、外部服务

#### 基础设施层
- Repository 实现（数据持久化）
- 外部服务调用（HTTP 客户端、消息队列）
- 框架集成（ORM、序列化）
- 技术关注点的具体实现

---

## 依赖规则

### 核心原则：依赖倒置

```
接口层 → 应用层 → 领域层 ←—— 基础设施层
                      ↕
                依赖倒置（Dependency Inversion）
```

- **外层依赖内层**：接口层依赖应用层，应用层依赖领域层
- **内层不依赖外层**：领域层零外部依赖
- **基础设施层依赖领域层接口**：Repository 接口定义在领域层，实现在基础设施层

### 具体规则

| 层 | 可以依赖 | 禁止依赖 |
|----|---------|---------|
| **接口层** | 应用层、基础设施层（DI 配置） | 无（最外层） |
| **应用层** | 领域层、基础设施（接口） | **接口层** ❌ |
| **领域层** | 无（纯业务模型） | 接口层、应用层、基础设施层 ❌ |
| **基础设施层** | 领域层（实现接口）、外部库 | **领域层以上的层** ❌ |

### 依赖方向判定

```
A 依赖 B 是否合理？
├─ B 在内层（领域层），A 在外层 → ✅ 合理
├─ B 在外层，A 在内层 → ❌ 违反规则
├─ 同层之间 → 需谨慎（应用层互相依赖 → 考虑事件解耦）
└─ 接口层依赖基础设施层 → 仅限 DI 配置，不做业务调用
```

---

## 战术模式

### Entity（实体）

- 有唯一标识（ID），ID 相等即实体相等
- 可变（属性可变，但标识不变）
- 包含业务行为和业务规则

```typescript
// ✅ 好的实践
class Order {
    constructor(
        private readonly id: OrderId,
        private status: OrderStatus,
        private items: OrderItem[],
    ) {}

    addItem(item: OrderItem): void {
        if (this.status !== OrderStatus.Draft) {
            throw new Error('只能修改草稿订单');
        }
        this.items.push(item);
    }

    submit(): void {
        if (this.items.length === 0) {
            throw new Error('订单至少需要一个商品');
        }
        this.status = OrderStatus.Submitted;
    }
}
```

### Value Object（值对象）

- 无唯一标识，由属性值决定相等性
- **不可变**（immutable）：创建后不可修改
- 自包含验证逻辑
- 优先使用 Value Object 而非基本类型

```typescript
// ✅ 好的实践
class EmailAddress {
    constructor(private readonly value: string) {
        if (!this.isValid(value)) {
            throw new Error(`无效的邮箱地址: ${value}`);
        }
    }

    private isValid(value: string): boolean {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
    }

    equals(other: EmailAddress): boolean {
        return this.value === other.value;
    }

    toString(): string {
        return this.value;
    }
}
```

### Aggregate（聚合）

- 一组相关对象的集群，作为数据修改的**一致性边界**
- 一个 Aggregate Root（聚合根）作为外部访问的唯一入口
- 事务边界：一个事务只修改一个 Aggregate
- 通过 Aggregate Root 的 ID 引用其他 Aggregate

```typescript
// ✅ 好的实践
class Order {  // Aggregate Root
    private readonly items: OrderItem[] = [];

    get totalAmount(): Money {
        return this.items.reduce(
            (sum, item) => sum.add(item.subtotal),
            Money.zero()
        );
    }
}

// 外部通过 OrderId 引用，不直接持有 Order 引用
class OrderId {
    constructor(public readonly value: string) {}
}
```

### Domain Service（领域服务）

- 处理**跨实体**或**跨聚合**的业务逻辑
- 无状态
- 以动词命名（`TransferService`、`PricingService`）

```typescript
// ✅ 好的实践
class PricingService {
    calculateDiscount(order: Order, customer: Customer): Money {
        // 跨实体计算的业务逻辑
    }
}
```

### Domain Event（领域事件）

- 表示领域中有意义的事件（`OrderSubmitted`、`PaymentReceived`）
- 用于聚合间最终一致性通信
- 以过去时动词命名

```typescript
// ✅ 好的实践
class OrderSubmitted {
    constructor(
        public readonly orderId: string,
        public readonly submittedAt: Date,
    ) {}
}
```

### Repository（仓库）

- **接口定义在领域层**，实现在基础设施层
- 对上层暴露集合风格的接口（`save`、`findById`、`delete`）
- 按 Aggregate 组织，每个 Aggregate 一个 Repository

```typescript
// 领域层定义接口
interface OrderRepository {
    findById(id: OrderId): Promise<Order | null>;
    save(order: Order): Promise<void>;
    delete(id: OrderId): Promise<void>;
}

// 基础设施层实现
class PostgresOrderRepository implements OrderRepository {
    async findById(id: OrderId): Promise<Order | null> { /* ... */ }
    async save(order: Order): Promise<void> { /* ... */ }
    async delete(id: OrderId): Promise<void> { /* ... */ }
}
```

### Factory（工厂）

- 封装复杂对象的创建逻辑
- 可放在 Aggregate Root 上（静态工厂方法）或独立 Factory 类

```typescript
// ✅ 好的实践
class OrderFactory {
    static createDraft(customerId: CustomerId): Order {
        return new Order(
            new OrderId(uuid()),
            OrderStatus.Draft,
            customerId,
            [],
        );
    }
}
```

---

## 战略设计

### 限界上下文（Bounded Context）

限界上下文是 DDD 中**最重要的战略设计工具**。

- 每个上下文有独立的领域模型和领域语言
- 上下文之间通过**上下文映射**（Context Map）关联
- 不同上下文中相同的词可能有不同含义（如"订单"在电商上下文 vs 物流上下文）

```yaml
# 上下文映射示例
Bounded Contexts:
  - 电商上下文:
      - "订单" = 购物车生成的交易单
      - "客户" = 买家
  - 物流上下文:
      - "订单" = 配送单
      - "客户" = 收件人
```

### 上下文间关系

| 关系 | 说明 | 适用场景 |
|------|------|---------|
| **合作关系（Partnership）** | 两个团队协同演进 | 紧密耦合的需求 |
| **共享内核（Shared Kernel）** | 共享部分公共模型 | 需高度一致性的子集 |
| **客户-供应商（Customer-Supplier）** | 上游（供应商）影响下游（客户） | API 提供者与消费者 |
| **防腐层（Anti-Corruption Layer）** | 隔离外部模型的污染 | 集成遗留系统或第三方 |
| **开放主机服务（Open Host Service）** | 通过 API 对外暴露子系统 | 对外提供服务的模块 |
| **发布语言（Published Language）** | 标准数据格式交换 | 集成多个上下文 |
| **各行其道（Separate Ways）** | 完全独立，不集成 | 无集成需求的上下文 |

---

## 各层职责边界

### 视图/接口层该做什么

- 解析输入（HTTP 请求、WebSocket 消息、CLI 参数）
- 调用应用层服务
- 格式化并返回响应
- **不含业务逻辑、不含领域规则**

### 应用层该做什么 / 不该做什么

| 该做 | 不该做 |
|------|--------|
| 用例编排（调用 Repository 获取数据 → 调用领域对象执行操作 → 保存） | ❌ 包含业务规则判断 |
| 事务管理 | ❌ 直接操作 DB |
| 授权/身份校验 | ❌ 写 SQL 或数据查询 |
| DTO 转换 | ❌ 包含领域计算逻辑 |
| 事件发布 | ❌ 实现 Repository 接口 |

### 领域层该做什么 / 不该做什么

| 该做 | 不该做 |
|------|--------|
| 业务规则和业务不变量 | ❌ 依赖数据库/SDK/框架 |
| 实体状态转换 | ❌ 事务管理 |
| 值对象验证 | ❌ HTTP 请求 |
| 领域事件定义 | ❌ 持有 UI 引用 |
| Repository 接口定义 | ❌ 序列化/反序列化 |

### 基础设施层该做什么 / 不该做什么

| 该做 | 不该做 |
|------|--------|
| Repository 实现（操作 DB） | ❌ 包含业务判断逻辑 |
| 外部服务调用 | ❌ 直接返回 DTO 给上层 |
| 消息中间件集成 | ❌ 持有 UI 相关的状态 |
| 框架/ORM 集成 | ❌ 处理应用层编排 |

---

## 引入 DDD 的决策树

### 是否该用 DDD？

```
项目的核心复杂度在哪？
├─ 业务逻辑复杂（规则多、状态多、计算多）→ DDD 适合
├─ 技术复杂度高（高并发、大数据量）→ DDD 可能过重，考虑 CQRS/EDA
├─ CRUD 为主（增删改查，业务规则少）→ DDD 过度设计，贫血模型即可
└─ 两者兼具 → 核心子域用 DDD，通用子域用 CRUD
```

### 是否该引入领域实体？

```
数据是否需要业务行为（校验/计算/状态转换）？
├─ 否 → 使用纯数据对象（DTO / Response Model）即可
└─ 是 → 是否多个地方复用此模型？
        ├─ 否 → 单个用例内使用，局部使用即可
        └─ 是 → 引入领域实体/值对象
```

### 是否该引入 Aggregate？

```
是否存在事务一致性的边界？
├─ 修改 A 时必须确保 B 也满足约束
│   └─ 是 → Aggregate 边界 = {A, B}
├─ 存在并发修改冲突风险
│   └─ 是 → Aggregate 边界尽量小
└─ 以上都否 → 不需要 Aggregate，纯 Entity 即可
```

### 是否该引入 Domain Event？

```
操作 A 发生后，需要触发操作 B，且两者可最终一致？
├─ 是 → Domain Event
└─ 否 → 同步调用即可
```

---

## 常见反模式

### 1. 贫血模型（Anemic Domain Model）

```typescript
// ❌ 反模式：只有 getter/setter，无业务行为
class Order {
    id: string;
    status: string;
    items: OrderItem[];
    // 业务逻辑散落在 Service 层
}

// ✅ 正确：实体包含业务行为
class Order {
    private readonly id: string;
    private status: OrderStatus;
    private readonly items: OrderItem[];

    submit(): void { /* 业务规则内聚 */ }
    cancel(): void { /* 业务规则内聚 */ }
}
```

### 2. 基础设施渗透领域层

```typescript
// ❌ 反模式：领域层依赖 ORM
class Order {
    @Entity()
    @Column()
    status: string;
}

// ✅ 正确：领域层纯业务，ORM 在基础设施层
class Order {
    private status: OrderStatus;
}
```

### 3. 聚合过大（God Aggregate）

```typescript
// ❌ 反模式：一个 Aggregate 包含半个系统的表
class Customer {
    orders: Order[];
    payments: Payment[];
    addresses: Address[];
    preferences: Preferences[];
    // ...
}

// ✅ 正确：拆分为独立的小 Aggregate
// 通过 CustomerId 关联
```

### 4. 应用层变成"垃圾场"

```typescript
// ❌ 反模式：应用层包含业务规则
class OrderService {
    submit(orderId: string): void {
        const order = this.repo.findById(orderId);
        if (order.items.length === 0) throw Error(); // ← 这是业务规则，应在领域层
        order.submit();
        this.repo.save(order);
    }
}
```

### 5. 过度工程

```
小项目（< 5 个开发者，简单 CRUD）引入完整 DDD：
- Entity → Value Object → Aggregate → Domain Event → CQRS → Event Sourcing
- 不必要的复杂度，拖慢开发

✅ 正确做法：渐进式引入
CRUD 模型 → 出现业务规则 → 引入 Entity
            出现跨实体规则 → 引入 Domain Service
            出现一致性边界 → 引入 Aggregate
            出现异步需求 → 引入 Domain Event
```

---

## 命名规范

### 包/模块组织

```
com/company/{bounded-context}/
├── application/
│   ├── service/        # 应用服务
│   ├── dto/            # 数据传输对象
│   └── assembler/      # DTO ↔ 领域模型转换器
├── domain/
│   ├── model/          # Entity / Value Object / Aggregate
│   ├── service/        # 领域服务
│   ├── repository/     # Repository 接口
│   ├── event/          # 领域事件
│   └── specification/  # 规约模式（可选）
└── infrastructure/
    ├── persistence/    # Repository 实现（JPA/MyBatis/...）
    ├── messaging/      # 消息队列
    └── client/         # 外部服务客户端
```

### 类命名

| 模式 | 命名约定 | 示例 |
|------|---------|------|
| Entity | 名词，业务名 | `Order`、`Customer`、`Product` |
| Value Object | 名词，具体概念 | `Money`、`EmailAddress`、`OrderId` |
| Aggregate Root | 名词（核心实体） | `Order`、`Invoice` |
| Domain Service | 动词 + Service | `TransferService`、`PricingService` |
| Domain Event | 过去时动词 | `OrderSubmitted`、`PaymentReceived` |
| Repository（接口） | 实体名 + Repository | `OrderRepository` |
| Application Service | 名词 + Service | `OrderAppService`、`CheckoutService` |
| Factory | 实体名 + Factory | `OrderFactory` |

---

## 总结

```
DDD 的核心价值：
┌─────────────────────────────────────────┐
│ 代码即业务文档 → Ubiquitous Language     │
│ 业务复杂性有处安放 → 领域层              │
│ 系统边界清晰 → Bounded Context          │
│ 技术解耦 → DIP + Repository             │
└─────────────────────────────────────────┘

记住：DDD 是工具，不是目标。
引入 DDD 是为了降低业务复杂度，不是为了增加技术复杂度。
渐进式引入，按需使用。
```