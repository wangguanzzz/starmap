
const redis = require('redis');
const request = require('request-promise-lite');

const URL = 'http://hq.sinajs.cn/list=';
let FUTURES_MAP= { CU0: '铜连续',AL0:'铝连续',ZN0:'锌连续',PB0:'铅连续',FU0 : '燃料油连续',HC0:'热卷连续',NI0:'镍连续',RB0:'螺纹钢连续', 
  I0:'铁矿石连续',J0:'焦炭连续', JD0 :'鸡蛋连',RI0 :'玻璃连续',RM0:'菜粕连续',TA0:'PTA连续',AP0:'苹果连续', 
  SN0:'锡连续',A0:'豆1连续',B0:'豆2连续',SR0:'白糖连续', M0 : '豆粕连续',C0:'玉米连续',Y0:'豆油连续', 
  P0 : '棕榈连续',RU0 : '橡胶连续',FG0 : '玻璃连续',CF0 : '棉花连续', WS0 : '强麦连续',AO0 : '菜籽油连续',BU0: '沥青连续' }


let keys = Object.keys(FUTURES_MAP);

keys.forEach((key)=> {
  request.get(URL+key,{ json: false })
  .then((response) => {
    console.log(response.toString());
  });
});
/*

FUTURES_MAP.each((k,v) => {
  console.log(v)
})
request.get(URL,{ json: false })
  .then((response) => {
    console.log(response.toString());
  });
*/