#!/usr/bin/env node

import log4js from "log4js";
import {apis} from "./apis.js";

//log4js.configure({
//appenders: {
//app: { type: "file", filename: "application.log" },
//},
//categories: {
//default: { appenders: ["app"], level: "debug" },
//},
//});

const logger = log4js.getLogger("api checker");
logger.level = "info";

class Result {
  end = null
  host = ""
  remoteAddress = ""
  status = 0

  constructor(url){
    this.start = new Date();
    this.url = url
  }

  record(response){
    this.end = new Date()
    this.status = response.status
    this.remoteAddress = response.request.socket.remoteAddress
  }

  get time() {
    return this.end - this.start
  }

  toString(){
    return `${this.url}, ${this.remoteAddress}, ${this.time}ms, status: ${this.status}`
  }
}

export const httpclient = axios.create();

httpclient.interceptors.request.use(
  function (config) {
    config.result = new Result(config.url)
    return config
  }
)

httpclient.interceptors.response.use(
  function (response) {
    const r = response.config.result.record(response)
    return response
  },
  function (err) {
    console.log(err);
  }
)

/**
 * @param {*} api
 * @returns {Promise<Result>}
 */
async function check_api(api) {
  let {method, url, data} = api
  if (data && typeof data == "object") {
    data = data
  }
  if (data && typeof data == "function") {
    data = data()
  }
  return httpclient({
    method: method,
    url: url,
    data: data
  }).then((resp) => {
      return resp.config.result
    }).catch((err) => {
      if (err.response) {
        return err.response.request.result
      } else {
        logger.error(err);
      }
    });
}

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

async function main() {
  for (let i = 1; i > 0; i--) {
    apis.map(async (api) => {
      const result = await check_api(api);
      logger.info(result.toString())
    });
    await sleep(5000);
  }
}

await main();

/**
 * 结果统计
 * awk '/INFO.*ww/{print $9}' application.log  | sort | uniq -c
  * awk '/INFO.*sms/{print $10}' application.log  | sort | uniq -c
awk '/INFO.*cgi-bin/{print $10}' application.log  | sort | uniq -c
awk '/INFO.*mattress/{print $10}' application.log  | sort | uniq -c
awk '/INFO.*auth/{print $10}' application.log  | sort | uniq -c

 **/
