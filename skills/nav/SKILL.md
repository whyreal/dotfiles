---
name: nav
description: "Nav 导航服务。封装路由跳转逻辑，替代散落的 this.$router.push/replace。Invoke when performing route navigation, redirect, or tab switching in controller or view."
---

# Nav 导航服务

> 当前问题：项目中大量使用 `this.$router.push()` / `this.$router.replace()`，分散在各视图层。controller 中没有 Vue 实例，只能通过参数传 router，不方便。

## 设计思路

Nav 服务封装路由跳转逻辑，提供命名式导航。controller 直接 import 使用，不依赖 Vue 实例。

## API

```javascript
nav.push({ name: 'route-name', params: { id: 1 } })
nav.replace({ name: 'route-name', params: { id: 1 } })
nav.go(-1)
nav.goBack()      // 别名
nav.open(url)     // window.open
```

## 建议的实现

`src/infra/services/nav.js`：

```javascript
class Nav {
  constructor() {
    this._router = null;
  }

  /** 由应用入口注入 router 实例 */
  setRouter(router) {
    this._router = router;
  }

  push(location) {
    this._router.push(location).catch(err => {
      if (err.name !== 'NavigationDuplicated') throw err;
    });
  }

  replace(location) {
    this._router.replace(location).catch(err => {
      if (err.name !== 'NavigationDuplicated') throw err;
    });
  }

  go(delta) {
    this._router.go(delta);
  }

  goBack() {
    this.go(-1);
  }

  open(url, target = '_blank') {
    window.open(url, target);
  }
}

export const nav = new Nav();
```

### 在 main.js 中注入

```javascript
import { nav } from '@/infra/services/nav';
import router from '@/router';

nav.setRouter(router);
```

## 使用规范

```javascript
import { nav } from '@/infra/services/nav';

// controller 中导航
nav.push({ name: 'userDetail', params: { id: userId } });

// 回到列表页
nav.replace({ name: 'userList' });

// 返回上一页
nav.goBack();
```

## 禁止

- ❌ 在 controller 中通过参数传 router 实例
- ✅ controller 直接 import nav 服务
- ✅ 视图层仍可使用 `this.$router`（与 nav 不冲突，逐步迁移）

---

*相关代码*
- 待创建：`src/infra/services/nav.js`
