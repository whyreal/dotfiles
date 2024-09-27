function immer(state, thunk) {
  let copies = new Map(); // Map 的 key 可以是一个对象，非常适合用来缓存被修改的对象

  const handler = {
    get(target, prop) { // 增加一个 get 的劫持，返回一个 Proxy
      return new Proxy(target[prop], handler);
    },
    set(target, prop, value) {
      const copy = {...target}; // 浅拷贝
      copy[prop] = value; // 给拷贝对象赋值
      copies.set(target, copy);
      console.log(target)
      console.log(copy)
      console.log(copy === target)
      console.log(copies)
      return true
    }
  };

  function finalize(state) { // 增加一个 finalize 函数
    const result = {...state};
    Object.keys(state).map(key => { // 以此遍历 state 的 key
      const copy = copies.get(state[key]);
      if(copy) { // 如果有 copy 表示被修改过
        result[key] = copy; // 就是用修改后的内容
      } else {
        result[key] = state[key]; // 否则还是保留原来的内容
      }
    });
    return result;
  }

  const proxy = new Proxy(state, handler);
  thunk(proxy);
  return finalize(state);
}

const state = {
  "phone": "1-770-736-8031 x56442",
  "website": {site: "hildegard.org"}, // 注意这里为了方便测试状态共享，将简单数据类型改成了对象
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
};

const copy = immer(state, draft => {
  draft.company.name = 'google';
});

console.log(copy.company.name); // 'google'
console.log(copy.website === state.website); // true
