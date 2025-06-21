 
const async=require("async")

async.waterfall([
    function(callback) {
      callback('err', 1, 2);
    },
    function(arg1, arg2, callback) {
       let arg3 = arg1 + arg2;
      callback(null, arg3);
    },
    function(arg1, callback) {
       arg1 += 5;
      callback(null, arg1);
    }
  ], function(err, result) {
      if(err) console.log(err)
     console.log(result);
  });

  async.parallel({
    task1:function(callback) {
        setTimeout(()=>{
            console.log(1)
          callback(null, 1);
        },4000)
     },
    task2:function(callback) {
        setTimeout(()=>{
            console.log(2)
          callback('err2', 2);
        },2000)}
    },
   function(err, results) {
       if(err) console.log(err)
       else console.log(results)
   });