#!/usr/bin/env node

import fs from 'fs';
import {project_root} from './const.js';
import {connect} from 'tls';

class Domain {
  cert = {}
  remoteAddress = ""

  /**
   * Creates an instance of Domain.
   * @param {string} url
   * @memberof Domain
   */
  constructor(url) {
    if (!url.startsWith("https://")) {
      url = `https://${url}`
    }
    this.url = new URL(url)
  }

  toString() {
    return `${this.url} | ${this.remoteAddress} | ${this.cert.ca} | ${this.cert.time}`
  }
  /**
   * @param {Domain} d
   * @returns 
   * @memberof Domain
   */
  cert_newer_then(d) {
    if (this.cert.time > d.cert.time) {
      return -1
    }
    return 1
  }
}

class DomainRepo {
  getdomains() {
    let domains = []
    if (process.argv.length > 2) {
      domains = process.argv.slice(2)
    } else {
      domains = fs.readFileSync(project_root + "/check_https_cert_dn.txt")
        .toString()
        .split(/\r?\n/)
        .filter(l => {
          return l.trim().length > 0 && !l.startsWith("#")
        })
    }

    return domains.map(d => new Domain(d))
  }
  /**
   * @param {Domain} domain
   * @memberof DomainRepo
   */
  async loadCert(domain) {
    let conn = connect({
      host: domain.url.host,
      servername: domain.url.host,
      port: Number(domain.url.port) || 443,
    })
    await new Promise((resolve, _) => {
      conn.on("secureConnect", () => {
        const cert = conn.getPeerCertificate()
        domain.remoteAddress = conn.remoteAddress || ""
        domain.cert.ca = cert.issuer.O
        domain.cert.time = Math.floor((new Date(cert.valid_to).getTime() - Date.now()) / 24 / 3600 / 1000)
        conn.destroy()
        resolve()
      })
      conn.on('error', () => {
        domain.cert = {
          time: 0,
          ca: 'error'
        }
        resolve()
      })
    })
  }
}

class AppService {
  async run() {
    const domainRepo = new DomainRepo();

    const domains = domainRepo.getdomains()
    await Promise.all(domains.map(async d => {
      await domainRepo.loadCert(d)
    }))

    domains
      .sort((d1, d2) => d1.cert_newer_then(d2))
      .map(d => console.log(d.toString()))
  }
}

await (new AppService()).run()
