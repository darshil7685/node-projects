const input = require("./Input.json");

let output = { output: [] };

let colors = [];
let veg = [];

for (let i in input["input"]) {
  for (let [key, values] of Object.entries(input["input"][i])) {
    colors.push(key);
  }
  // for(var j in input["input"][i]["Green"]){
  //     console.log(input["input"][i]["Green"][j])
  // }
}

for (let i in input["input"]) {
  for (let [key, values] of Object.entries(input["input"][i])) {
    for (let j in input["input"][i][key]) {
      for (let [key1, values] of Object.entries(input["input"][i][key][j])) {
        veg.push(key1);
      }
    }
  }
}

let a = veg.filter((element, index) => veg.indexOf(element) === index);

console.log(a);
console.log(colors);

for (let k in a) {
  for (let i in input["input"]) {
    for (let [key, values] of Object.entries(input["input"][i])) {
      for (let j in input["input"][i][key]) {
        for (let [key1, values1] of Object.entries(input["input"][i][key][j])) {
          if (a[k] == key1) {
            for (let x in output["output"]) {
              //for (let [key3, values3] of Object.entries(output["output"][x])) {
                console.log(`output["output"][x]["name"]==1==`,output["output"][x]["name"])
                if(output["output"][x]["name"] === key1){
                  
                  console.log(`output["output"][x]["name"]=2===`,output["output"][x]["name"])
                  
                  for(let y in output["output"][x]["children"]){
                    //console.log(key)
                    console.log(`output["output"][x]["children"][y]["name"]====`,output["output"][x]["children"][y]["name"])
                      if(output["output"][x]["children"][y]["name"] == key){
                        //console.log(values1)  
                        output["output"][x]["children"][y]["children"].push({"name":values1})
                        console.log(`output["output"][x]["children"][y]["children"]["name"] === in childkey children added`,output["output"][x]["children"][y]["children"])
                      }else{   
                        output["output"][x]["children"].push({"name":key,"children":[{"name":values1}]})
                        console.log(`output["output"][x] == child keyadded`,output["output"][x]["children"])
                      }                                
                  }    
                }                      
               // else{
                  //output["output"].push({
                  //   "name": key1,
                  //   "children": [{ "name": key, "children": [{ "name": values1 }] }],
                  // });
                // }
                // console.log(key3,values3);
              //}   
            }             
            output["output"].push({
              "name": key1,
              "children": [{ "name": key, "children": [{ "name": values1 }] }],
            });  
            console.log(key1+" Main key added")          
          }
        }
      }
    }
  }
}

console.log(JSON.stringify(output));
// for (let x in output["output"]) {
  
//     for(let y in output["output"][x]["children"]){      
//         if(output["output"][x]["children"][y]){
//           console.log(output["output"][x]["children"][y]["name"])
//         }
      
//   //console.log(values3)
//   }
//   //console.log(output["output"][x]["name"])
// }
//console.log(output["output"][0]["children"][0]["name"])


