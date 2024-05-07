import {fromES, toES} from "./es"

// template
const template = await fromES.get("/_template")

Object.keys(template.data).forEach(t => {
  console.log('/_template/' + t)
  console.log(template.data[t])

  toES.put('/_template/' + t, template.data[t]).catch(err => {
    console.log(err)
  })
})

const toPolicy = await toES.get("/_template")
console.log(Object.keys(toPolicy.data))

