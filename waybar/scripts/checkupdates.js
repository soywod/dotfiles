#!/usr/bin/env node

const { execSync } = require("child_process");

const packagesCount = execSync("checkupdates | wc -l");
const packagesName = execSync("checkupdates");

console.log(
  JSON.stringify({
    text: packagesCount,
    tooltip: packagesName,
  })
);
