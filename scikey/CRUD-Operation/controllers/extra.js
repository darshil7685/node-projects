let moment =require("moment");
const { DateTime } = require("mssql");
var time=moment().format('YYYY-MM-DD ')
console.log(new Date(moment().format("YYYY-MM-DD")));
console.log(time);
console.log(typeof time)

let async =require("async")

let a=[{a:1},{b:2},{c:3}]
let b=[]
async.each(a,(ele)=>{
     console.log(ele);
})
console.log(b);
