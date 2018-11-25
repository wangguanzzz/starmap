const requestPromise = require("request-promise");
const URL = "http://hq.sinajs.cn/list=";
const futureList = ["A0", "B0", "M0", "CU0", "RB0"];

function convertFutureInfo(body) {
  let arr = body.split(",");
  const indexOfSymbol = body.indexOf("=");
  let name = body.slice(11, indexOfSymbol);
  return {
    name: name,
    price: arr[8],
    volumn: arr[14],
    raw: body
  };
}

function getLatestData(symbol) {
  return requestPromise(URL + symbol);
}

module.exports.getFutureData = getLatestData;
module.exports.convertFutureInfo = convertFutureInfo;
module.exports.futureList = futureList;
