import {fromES, toES} from "./es"

// ilm
const policy = await fromES.get("/_ilm/policy")

Object.keys(policy.data).forEach(pn => {
  console.log('_ilm/policy/' + pn)
  delete policy.data[pn]["version"]
  delete policy.data[pn]["modified_date"]
  console.log(policy.data[pn])

  toES.put('/_ilm/policy/' + pn, policy.data[pn]).catch(err => {
    console.log(err)
  })
})

const toPolicy = await toES.get("/_ilm/policy")
console.log(Object.keys(toPolicy.data))

