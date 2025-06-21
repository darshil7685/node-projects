let inp = {
    "input": [
      {
        "Green": [
          {
            "Vegetables": "Broccoli"
          },
          {
            "Vegetables": "Brussel,sprouts"
            
          },
          {
            "Fruit": "Green Apple"
          }
        ],
        "Red": [
          {
            "Fruit": "Apple"
          },
          {
            "Vegetables": "carrat"
          }
        ],
        "Yellow": [
          {
            "Fruit": "Apple"
          }
        ]
      }
    ]
  };

var subkey = [];

inp_sub = inp.input;
  for (var i in inp_sub) {
    temp = inp_sub[i];
   // mainkey.push(Object.keys(temp));
    for (var j in temp) {
        for (var k in temp[j]) {
            for (let [key, name] of Object.entries(temp[j][k])) {
                subkey.push(key); // extracting subkey
                //console.log(subkey);
            }
        }
    }
    var uniquecate = [...new Set(subkey)];
    //console.log(uniquecate);
  }


  var mainkey = Object.keys(temp);
 // mainkey.push(Object.keys(temp));
  console.log(mainkey);
  var childkey = uniquecate;
  console.log(childkey);

let arr = [];
const array_null=[];

for(var m=0; m<childkey.length; m++){

  var op = [];
    arr.push({"name": childkey[m],
    "children": op});
   
  // console.log(mainkey.length)
     for(var n=0; n<mainkey.length;n++)
     {
      // console.log(mainkey[n])
      op.push({"name":mainkey[n],
      "children":[]});
    }
  }

  // console.log(JSON.stringify(arr,null,4));


  arr.forEach(key1 => {
    var k1 = Object.values(key1.name).join('');
   // console.log("k1:",k1)
            for (let c2 = 0; c2 < key1.children.length; c2++) {
                    let o_color = key1.children[c2].name;
                 //  console.log("o_color:",o_color);
                   for (const key2 in inp.input[0][o_color]) {
                        main_c = Object.keys(inp.input[0][o_color][key2])[0];
                        //console.log("main_c:",main_c);
                        main_cat = Object.values (inp.input[0][o_color][key2])[0];
                        if(k1 == main_c){
                            key1.children[c2].children.push({
                                name:main_cat
                            })
                          }
                   }
            }
});


   for(let i=0;i<arr.length;i++)
   {
       Object.keys(arr[i].children).forEach(key3 =>{
            if(arr[i].children[key3].children.length == 0)
                 array_null.push(key3)
                //  console.log(arr[i].children[key3].children);
        });
        //console.log(Object.keys(arr[i].children));
    
        while(array_null.length){    
          let y=array_null.pop();
            arr[i].children.splice(y,1)

        }
     
   }

   

   console.log(JSON.stringify(arr,null,4));

 
  
    

  
  
  
