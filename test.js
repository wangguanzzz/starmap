const futureutils = require("./futuresUtils");

futureutils.futureList.forEach(ele => {
  let pingPromise = futureutils.getFutureData(ele);
  pingPromise.then(body => {
    console.log(futureutils.convertFutureInfo(body));
  });
});
