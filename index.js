const express = require("express");
const app = express();

const URL = "http://hq.sinajs.cn/list=";
const request = require("request");

function getfutures(arr) {
  return {
    price: arr[8],
    volumn: arr[14]
  };
}

function getFutureInfo(type) {
  request(URL + type, (error, response, body) => {
    if (!error && response.statusCode === 200) {
      data = body.split(",");
      return getfutures(data);
    }
  });
}

app.get("/", (req, res) => {
  res.send(getFutureInfo("CU0"));
});

app.listen(3000);
