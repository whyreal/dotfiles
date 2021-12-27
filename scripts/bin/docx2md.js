#!/usr/bin/env node

if (process.argv.length < 3) {
  console.error("give me a markfile file!!!")
  process.exit(1)
}

const inputFile = process.argv[2]
const {Pandoc} = require("../lib/pandoc")
new Pandoc(inputFile, "docx", "md").convert()
