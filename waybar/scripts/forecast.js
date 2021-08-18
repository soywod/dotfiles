#!/usr/bin/env node

const http = require("http");

const QUOTE_REGEXP = new RegExp('"', "g");

async function requestForecast(format, postData) {
  return new Promise(function (resolve, reject) {
    const req = http.request(`http://wttr.in?format="${format}"`, (res) => {
      if (res.statusCode < 200 || res.statusCode >= 300) {
        return reject(new Error(res.statusCode));
      }

      const buffer = [];
      res.on("data", (chunk) => buffer.push(chunk));
      res.on("end", () => {
        const data = Buffer.concat(buffer).toString().replace(QUOTE_REGEXP, "");
        resolve(data);
      });
    });

    req.on("error", reject);

    if (postData) {
      req.write(postData);
    }

    req.end();
  });
}

Promise.all([
  requestForecast("%c%t"),
  requestForecast("%c%C\\n︁ %t (%f)\\n︁ %w\\n%m %M\\n🌅︁ %S\\n🌇︁ %s"),
]).then(([text, tooltip]) => {
  console.log(JSON.stringify({ text, tooltip }));
});
