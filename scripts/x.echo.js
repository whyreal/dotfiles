class A {
  a = 1
  b = 2
  constructor(){

  }
  echo(){
    console.log(this.a);
    console.log(this.b);
  }
}

class B extends A{
  constructor(){
    super()
    this.a = 100
  }
}

const b = new B()
b.echo()
