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
  var options = {
    host: dn,
    port: 443,
    method: 'GET'
  };

  return new Promise((resolve, reject) => {

    var req = https.request(options, function (res) {
      res.on('data', (_) => {});

      const cert = res.socket.getPeerCertificate();
      const ca = cert.issuer.O
      const valid_to = new Date(cert.valid_to)
      resolve([
        `${dn}`,
        `${ca}`,
        Math.floor((valid_to.getTime() - Date.now()) / 24 / 3600 / 1000),
        res.socket.remoteAddress])
    });
    req.on("error", (_) => {
      reject(`${dn}`)
    })

    req.end()
  })
}

//----------- main -------------

const argv = process.argv.slice(2)
var domains = []

if (argv.length > 0) {
  domains = argv
} else {
  domains = fs.readFileSync(project_root + "/check_https_cert_dn.txt").toString().split(/\r?\n/)
  domains = domains.filter(d => {
    return d.trim().length > 0 && !d.startsWith("#")
  })
}

Promise.all(domains.map(d => {
  return check_cert(d)
}))
.then(res => {
  res.sort((r1, r2) => {
    r1[3]
    return r1[2] > r2[2] ? -1 : 1;
  }).map(r => {console.log(JSON.stringify(r))})
})
.catch(e => {console.log(e, ">>>> Error")})
