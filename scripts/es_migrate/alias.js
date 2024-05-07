import {fromES, toES} from "./es"

// alias
const resp = await fromES.get("/_aliases")

Object.keys(resp.data).forEach(i => {
  //console.log(i)
  const alias = Object.keys(resp.data[i].aliases)
  //console.log(alias)
  if (i.startsWith(".")) {
    return
  }
  if (i.startsWith("ilm")) {
    return
  }

  alias.forEach(a => {
    const params = {
      "actions": [
        {
          "add": {
            "index": i,
            "alias": a
          }
        }
      ]
    }
    console.log(i, a, JSON.stringify(params));
    toES.post('/_aliases/', params).catch(err => {
      console.log(err)
    })
  })
})

const toPolicy = await toES.get("/_template")
console.log(Object.keys(toPolicy.data))
