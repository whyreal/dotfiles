#!/usr/bin/env node

import axios from 'axios';
import fs from 'fs';
import { project_root } from './const.js';

class Result {

  constructor(url, response){
    this.url = url
    this.remoteAddress = response.request.socket.remoteAddress
    const cert = response.request.socket.getPeerCertificate()
    this.ca = cert.issuer.O
    this.time = Math.floor((new Date(cert.valid_to).getTime() - Date.now()) / 24 / 3600 / 1000)
  }

  toString(){
    return `${this.url}, ${this.remoteAddress}, ${this.ca}, ${this.time}`
  }
}

/**
 * @param {*} url
 * @returns {Promise<Result>}
 */
async function check_url(url) {
  return axios.get(url, {
    maxRedirects: 0
  }).then(response => {
    return response
  }).catch(err => {
    if (err.response) {
      return err.response
    }
  }).then(response => {
    return new Result(url, response)
  })
}

const printResult = result => {
  console.log(result.toString());
}
const compareByValidToTime = (r1, r2) => r1.time > r2.time ? -1 : 1
const sortPrintByValidToTime = res => res
  .sort(compareByValidToTime)
  .map(printResult)
const printErr = e => console.log(e, ">>>> Error")

function main() {
  const domains = process.argv.length > 2
    ? process.argv.slice(2)
    : fs.readFileSync(project_root + "/check_https_cert_dn.txt")
      .toString()
      .split(/\r?\n/)
      .filter(l => {
        return l.trim().length > 0 && !l.startsWith("#")
      })
  Promise.all(domains.map(check_url))
    .then(sortPrintByValidToTime)
    .catch(printErr)
}

main()
