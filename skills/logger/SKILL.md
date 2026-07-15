---
name: logger
description: "Logger 日志服务。统一日志记录，替代散落的 console.log/error/warn。Invoke when adding logging to controller, service, or view code."
---

# Logger 日志服务

> 当前问题：项目中大量使用 `console.log('🚀 ~ xxx')`，格式五花八门，无法统一控制日志级别，也无法一键关闭。

## 设计思路

日志服务封装在 `infra/services/` 中，提供分级日志。这样 controller 和 service 不直接依赖 `console`，「统一控制日志开关」成为可能。

## API

```javascript
logger.info('消息')
logger.warn('警告')
logger.error('错误')
logger.debug('调试')
```

### 可选：日志级别控制

```javascript
// 开发环境：输出全部
logger.setLevel('debug')

// 生产环境：只输出 warn/error
logger.setLevel('warn')

// 关闭日志
logger.setLevel('none')
```

## 建议的实现

`src/infra/services/logger.js`：

```javascript
const LEVELS = { none: -1, error: 0, warn: 1, info: 2, debug: 3 };

class Logger {
  constructor() {
    this._level = process.env.NODE_ENV === 'production' ? 'warn' : 'debug';
  }

  setLevel(level) {
    this._level = level;
  }

  error(...args) { this._log('error', console.error, args); }
  warn(...args)  { this._log('warn', console.warn, args); }
  info(...args)  { this._log('info', console.info, args); }
  debug(...args) { this._log('debug', console.debug, args); }

  _log(level, fn, args) {
    if (LEVELS[level] > LEVELS[this._level]) return;
    // 可以在这里加时间戳、模块名等
    fn(`[${level.toUpperCase()}]`, ...args);
  }
}

export const logger = new Logger();
```

## 使用规范

```javascript
import { logger } from '@/infra/services/logger';

// controller/service 中用 logger 代替 console
logger.info('开始导出', { count: 100 });
logger.warn('数据不完整', missingFields);
logger.error('请求失败', err);
```

## 禁止

- ❌ 在 controller/service 中直接使用 `console.log` / `console.error` / `console.warn`
- ✅ 视图层（.vue 文件）中可以保留 `console.log` 用于模板调试，但业务逻辑中的日志归 logger

---

*相关代码*
- 待创建：`src/infra/services/logger.js`
