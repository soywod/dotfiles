#!/usr/bin/env node

const childProcess = require("child_process");

function execSync(cmd) {
  return childProcess.execSync(cmd).toString().replace(/\n*$/g, "");
}

console.log(
  JSON.stringify({
    text: execSync("checkupdates | wc -l"),
    tooltip: execSync("checkupdates"),
  })
);
