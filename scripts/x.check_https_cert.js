#!/usr/bin/env node

import axios from 'axios';
import fs from 'fs';
import {project_root} from './const.js';

class Domain {
  constructor(url) {
    this.url = url
    this.cert = {}
    this.remoteAddress = ""
  }

  toString() {
    return `${this.url} | ${this.remoteAddress} | ${this.cert.ca} | ${this.cert.time}`
  }
  async check_peer_cert() {
    return axios.get(this.url, {
      maxRedirects: 0
    }).then(response => {
      return response
    }).catch(err => {
      if (err.response) {
        return err.response
      }
    }).then(response => {
      const cert = response.request.socket.getPeerCertificate()
      this.remoteAddress = response.request.socket.remoteAddress
      this.cert.ca = cert.issuer.O
      this.cert.time = Math.floor((new Date(cert.valid_to).getTime() - Date.now()) / 24 / 3600 / 1000)
      return this
    })
  }
  newer_then(d) {
    if (this.cert.time > d.cert.time) {
      return -1
    }
    return 1
  }
}

class App {
  /** @type Domain[] */
  domains = []

  getdomains() {
    this.domains = process.argv.length > 2
      ? process.argv.slice(2)
      : fs.readFileSync(project_root + "/check_https_cert_dn.txt")
        .toString()
        .split(/\r?\n/)
        .filter(l => {
          return l.trim().length > 0 && !l.startsWith("#")
        })
        .map(d => new Domain(d))
  }

  async run() {
    this.getdomains()

    await Promise.all(this.domains.map(async d => {await d.check_peer_cert()}))
      .catch(e => console.log(e, ">>>> Error"))

    this.domains
      .sort((d1, d2) => d1.newer_then(d2))
      .map(d => console.log(d.toString()))
  }
}

(new App()).run()
