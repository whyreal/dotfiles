#!/usr/bin/env node

if (process.argv.length < 3) {
    console.error("give me a markdown file!!!")
  process.exit(1)
}

const inputFile = process.argv[2]
const {Pandoc} = require("../lib/index.js")
new Pandoc(inputFile, "md", "docx").convert()
