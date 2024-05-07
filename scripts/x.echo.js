#!/usr/bin/env node

const x = {
  a: 1,
  b: 1,
  c: 1,
  d: 1
}

const y = {...x, a:2}
console.log(x);
console.log(y);

class A {
  a = 1
  constructor(){
  }
  echo() {
    console.log(this.a);
  }
}
const a = new A()

console.log(Object.getPrototypeOf(a));
console.log(A.prototype.constructor === A);
console.log(JSON.stringify(A.prototype));


