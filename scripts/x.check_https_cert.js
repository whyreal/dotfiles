#!/usr/bin/env node

import https from 'https';
import fs from 'fs';
import {project_root} from './const.js';

import './types.js'

/**
  * @param {string} dn domain name
  * @returns {Promise<CheckResult>}
  */
function check_cert(dn) {
  var result = [dn]
  return new Promise((resolve, reject) => {
    var options = {
      host: dn,
      port: 443,
      method: 'GET',
      checkServerIdentity: function (_, cert) {
        const ca = cert.issuer.O
        const valid_to = new Date(cert.valid_to)
        result.push(
          `${ca}`,
          Math.floor((valid_to.getTime() - Date.now()) / 24 / 3600 / 1000)
        )
      }
    };

    var req = https.request(options, function (res) {
      res.on('data', (_) => {});
      result.push(res.socket.remoteAddress)
      resolve(result)
    });
    req.on("error", (_) => {
      reject(`${dn}`)
    })

    req.end()
  })
}

//----------- main -------------

const domains = process.argv.length > 2
  ? process.argv.slice(2)
  : fs
  .readFileSync(project_root + "/check_https_cert_dn.txt")
  .toString()
  .split(/\r?\n/)
  .filter(l => {
    return l.trim().length > 0 && !l.startsWith("#")
  })

const print = msg => console.log(msg)
const printErr = e => console.log(e, ">>>> Error")
const compareTlsDays = (r1, r2) => r1[2] > r2[2] ? -1 : 1 
const sortPrint = res => res
  .sort(compareTlsDays)
  .map(JSON.stringify)
  .map(print)

Promise.all(domains.map(check_cert))
  .then(sortPrint)
  .catch(printErr)
