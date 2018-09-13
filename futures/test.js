
const redis = require('redis');
const request = require('request-promise-lite');

const URL = 'http://hq.sinajs.cn/list=CU0';
/*
request.get('https://httpbin.org/get', { json: true })
  .then((response) => {
    console.log(JSON.stringify(response));
  });
*/
request.get(URL,{ json: false })
  .then((response) => {
    console.log(response.toString());
  });