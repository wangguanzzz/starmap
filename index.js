const express = require("express");
const app = express();
const futuresUtils = require("./futuresUtils");

app.get("/futures/:symbol", (req, res) => {
  //futuresUtils.futureList.includes()
  // let ping = futuresUtils.getFutureData(req.params.symbol);
  let ping = futuresUtils.getFutureData("CU0");
  ping.then(body => {
    res.send(body);
  });
  // res.send(req.params.symbol);
});

app.listen(3000);
