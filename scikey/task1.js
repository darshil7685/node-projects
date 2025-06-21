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
  console.log(k, a[k]);
  for (let i in input["input"]) {
    for (let [key, values] of Object.entries(input["input"][i])) {
      for (let j in input["input"][i][key]) {
        for (let [key1, values] of Object.entries(input["input"][i][key][j])) {
          if (a[k] === key1) {
            console.log(key);
            console.log(key1);
            output["output"].push({"name":key1,"children":[{"name":key,"children":[]}]})
          }
        }
      }
    }
  }
}

console.log(JSON.stringify(output["output"]));
