#!/usr/bin/env node

import fs from 'fs';
import {project_root} from './const.js';
import {connect} from 'tls';

class Domain {
  constructor(url) {
    if (!url.startsWith("https://")) {
      url = `https://${url}`
    }
    this.url = new URL(url)
    this.cert = {}
    this.remoteAddress = ""
  }

  toString() {
    return `${this.url} | ${this.remoteAddress} | ${this.cert.ca} | ${this.cert.time}`
  }
  async check_peer_cert() {
    let conn = connect({
      host: this.url.host,
      servername: this.url.host,
      port: this.url.port || 443,
    })
    const cert = await new Promise((resolve, reject) => {
      conn.on("secureConnect", () => {
        resolve(conn.getPeerCertificate())
      })
    })
    this.remoteAddress = conn.remoteAddress
    conn.destroy()
    this.cert.ca = cert.issuer.O
    this.cert.time = Math.floor((new Date(cert.valid_to).getTime() - Date.now()) / 24 / 3600 / 1000)
  }
  cert_newer_then(d) {
    if (this.cert.time > d.cert.time) {
      return -1
    }
    return 1
  }
}

class DomainRepo {
  static getdomains() {
    return process.argv.length > 2
      ? process.argv.slice(2)
      : fs.readFileSync(project_root + "/check_https_cert_dn.txt")
        .toString()
        .split(/\r?\n/)
        .filter(l => {
          return l.trim().length > 0 && !l.startsWith("#")
        })
        .map(d => new Domain(d))
  }
}

class App {
  constructor() {
    /** @type Domain[] */
    this.domains = []
  }

  async run() {
    this.domains = DomainRepo.getdomains()

    await Promise.all(this.domains.map(async d => {
      await d.check_peer_cert()
    }))
      .catch(e => console.log(e, ">>>> Error"))

    this.domains
      .sort((d1, d2) => d1.cert_newer_then(d2))
      .map(d => console.log(d.toString()))
  }
}

await (new App()).run()

