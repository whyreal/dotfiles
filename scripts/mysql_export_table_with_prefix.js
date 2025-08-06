#!/usr/bin/env node

import log from "loglevel";
import {Command} from "commander";
import fs from 'node:fs';
import asString from "date-format";
import {execSync} from "child_process";
import {dirname} from "node:path";
import {fileURLToPath} from "node:url";
import {createConnection} from "mysql2/promise";

function getBinDir() {
  if (typeof require === "undefined") {
    return dirname(fileURLToPath(import.meta.url))
  }
  return __dirname
}

class Conf {

  tableFile = ""
  /** @type {string[]} */
  tablePrefix = []
  user = ""
  password = ""
  host = ""
  port = ""
  database = ""
  verbose = false
  dryRun = false

  load_table_prefix() {
    this.tablePrefix = fs.readFileSync(this.tableFile, 'utf-8')
      .split('\n')
      .filter(p => p.length > 0)
  }
}
class App {
  conf = new Conf();

  checkOptions() {
    const program = new Command();
    program
      .option("-h, --host <host>",            "host")
      .option("-t, --table-file <tableFile>", "table list file", `${getBinDir()}/tables`)
      .option("-u, --user <user>",            "user name")
      .option("-p, --password <password>",    "password")
      .option("-P, --port <port>",            "port",            "3306")
      .option("-B, --database <database>",               "database")
      .option("--dry-run",                    "just display commands, but not excute")
      .option("--verbose",                    "display commands")
      .option("--help",                       "display help")
      .showHelpAfterError("(add --help for additional information)");
    program.parse(process.argv);

    const options = program.opts();

    if (options.help) {
      program.help();
    }

    this.conf.tableFile = options.tableFile;
    this.conf.user = options.user;
    this.conf.port = options.port;
    this.conf.host = options.host;
    this.conf.password = options.password;
    this.conf.database = options.database;
    this.conf.load_table_prefix()

    this.conf.dryRun = options.dryRun;
    this.conf.verbose = options.verbose;

    if (this.conf.dryRun) {
      this.conf.verbose = true;
    }

    if (this.conf.verbose) {
      log.setLevel("DEBUG");
      log.debug(this.conf)
    } else {
      log.disableAll();
    }
  }

  async run() {
    this.checkOptions()

    const db = new Db(this)

    await db.fetchTables()
    db.dumpTables()
  }
}

class Db {
  /** @type {string[]} */
  tables = [];
  connection = null;
  constructor(app) {
    /** @type {Conf} */
    this.conf = app.conf
  }
  async connect() {
    this.connection = await createConnection({
      host: this.conf.host,
      port: this.conf.port,
      user: this.conf.user,
      password: this.conf.password,
      database: this.conf.database
    });
  }
  async disconnect() {
    await this.connection.end();
  }

  async fetchTables() {
    await this.connect()
    const [results, _ ] = await this.connection.query("show tables;");
    this.tables = results.map(r => r[`Tables_in_${this.conf.database}`]);
    await this.disconnect()
  }

  dumpTables() {
    const datetime = asString("yyyy-MM-dd-hh-mm", new Date());
    const dumpfile = `${datetime}-${this.conf.database}.sql`;
    const options = '--set-gtid-purged=OFF --column-statistics=0';
    const tables = this.tables.map(t => {
      return this.conf.tablePrefix.some(p => {
        return t.indexOf(p) > -1
      }) ? t : ""
    })
    .filter(t => t.length > 0)
    const cmd = `mysqldump ${options} -h ${this.conf.host} -P ${this.conf.port} -u${this.conf.user} -p'${this.conf.password}' ${this.conf.database} ${tables.join(" ")}> ${dumpfile}`;

    log.info(`start dumping ${this.conf.database}, command: ${cmd}`);

    if (this.conf.dryRun) { return; }
    try {
      execSync(cmd);
      log.info(`dump ${this.conf.database} success`);
    } catch (e) {
      log.error(e)
      log.info(`dump ${this.conf.database} faild`);
    }
  };
}

(new App()).run()
