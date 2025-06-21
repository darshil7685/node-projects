// var a=0;
// let b=0
// var z=123;
// const f=67
// function c(){
//     var a;
//      a=10;
//     console.log(a)
//     //  let b;
//     //  b=12;
//     console.log(b);
//     console.log(z);
//     console.log(f)

//     function d(){
//         console.log(a);
//         console.log(z);
//         console.log(f)
//     }
//     d()
// }
// c();
// console.log(a);
// console.log(b)

//loops
const arr = [3, 5, { a: 90 }, 7, 90];

// var date=new Date();
// for(var i=0;i<arr.length;i++){
//     console.log(arr[i])
// }
// console.log("time",new Date().getTime()-date.getTime())

// var date2=new Date();
// for(let i in arr){
//     console.log(arr[i])
// }
// console.log("time",new Date().getTime()-date2.getTime())

// for(let i of arr){
//         console.log(i)
//         if(i==5)
//         continue;
// }

// var date1=new Date();
//   arr.forEach((ele)=>{
//   console.log(ele)})
//   console.log("time",new Date().getTime()-date1.getTime())

// let i=0;
// while( i<arr.length){
//     console.log(arr[i])
// i++;
// }

// var j=0;
// do{
// console.log(arr[j]);
// j++;
// }while(j<arr.length)

// const arr1 = [4, 89,{a:"abc"} ,7];
// function w(){
//     for(let i=0;i<arr1.length;i++){
//         console.log(arr1[i])
//     }
//     function y(){
//         for(i=0;i<arr1.length;i++){
//             console.log(arr1[i])
//         }
//     }
//     y()
// }
// w()

const array = [3, 5, { a: 90 }, 7, 80, [1, 2]];
const array1 = ["a", "b"];

// console.log(array.at(2))
// console.log(array.concat(array1))
// console.log(array.copyWithin(0,2,9))  //(target,start,end)

// const iterator=array.entries();
// console.log(iterator.next().value);
// console.log(iterator.next().value);

// console.log(array.every((element)=>element>0));
// console.log(array.fill(0,2,4))   //fill 0 from 2 to 4
// console.log(array.fill(5,2))     //fill 5 from 2 to end
// console.log(array.filter((ele)=>ele.a == 90))
// console.log(array.filter(ele=>ele > 900))    //[]
// console.log(array.find(ele=>ele > 900))    //undefind
// console.log(array.findIndex(ele=>ele > 90))   //if not found return -1
// console.log(array.flat())
// console.log(array.flatMap(x=>[x,x*2]))
//  console.log(Array.from("foo")); //['f','o','o']
// console.log(Array.from([1,2,3],x=>x*x));

// console.log(array.includes(80))
//console.log(array.indexOf(7))
// console.log(Array.isArray(array))
// const iterator = array.keys();
// for(const key of iterator){
//     console.log(key)
// }

// console.log(array.lastIndexOf(5))
// console.log(array.map(x => x*2))
// console.log(Array.of(1,2,3,7))
// console.log([1,4,6,9].reduce((prev,curr)=>prev-curr))
// console.log([1,4,6,9].reduceRight((prev,curr)=>prev-curr))
//  console.log(array.slice(-3,-1))
//  console.log(array.splice(3));
//  console.log(array)
// console.log(array.some((ele)=>ele%3==0));
// console.log([9,4,3,5,1,0].sort((a,b)=>a-b));
// console.log(['a',2,3,'d'].toString())

let string = "Negative integers count back from the last string character.";
let string1 = "Hello world!";

// console.log(string.at(-8))
// console.log(string.charAt(02))
//console.log(string.bold())
// console.log(string.fontcolor('red'));
//console.log(string.charCodeAt(3));
//console.log(string.concat(' , ',string1));
// console.log(string.endsWith(" character."))
//console.log((string.startsWith("Neg")));

// console.log(string.includes("string char"));
// console.log(string.indexOf('la'));
// console.log(string.lastIndexOf("la"))

//console.log(string.localeCompare(string1))
//console.log(string.match(/[a-z]/i));
// console.log(string.padEnd(200,"."))
// console.log(string.padStart(200,"*"))
//console.log((string.repeat(3)));
// console.log(string.replaceAll("i","I"))
// console.log(string.replace("i","I"))
// console.log((string.search(/[a-z]/g)));
// console.log((string.slice(-4,-1)));
// console.log(string.split(" "));
// console.log((string.substr(2,10)));
// console.log((string.substring(0,3)));
// console.log("  abc ".trim())
// console.log((" abc  ".trimEnd()));
// console.log(("  xyz  ".trimStart()));
//console.log("abc".valueOf());

//console.log((Math.random()*10).toFixed())
//console.log(Math.ceil(2.2456))

//OOPs

// class index{
//     constructor(a,b){
//         this.a=a;
//         this.b=b;
//     }
//      getSum(){
//         return this.a + this.b;
//     }
// }

// class subIndex extends index{
//     constructor(a,b,c){
//         super(a,b)
//         this.c=c;
//         let z;
//     }
//     set Z(z){
//         this.z=z
//     }
//     get Z(){
//         return this.z
//     }
//     getData(){
//         return this.c
//     }
// }

// const obj = new subIndex(2,3,9)
// obj.Z=123;
// console.log(obj.Z)
// console.log(obj.getData())

// function PC(ram,rom){
//     this.ram=ram;
//     this.rom=rom;
// }
// PC.prototype.getData=function(){
//     return `Ram ${this.ram}, Rom ${this.rom}`;
// }

// const pcObj=new PC(8,500)
// console.log(pcObj.getData())



// let Obj = {
//   glossary: {
//     title: "example glossary",
//     GlossDiv: {
//       title: "S",
//       GlossList: {
//         GlossEntry: {
//           ID: "SGML",
//           SortAs: "SGML",
//           GlossTerm: "Standard Generalized Markup Language",
//           Acronym: "SGML",
//           Abbrev: "ISO 8879:1986",
//           GlossDef: {
//             para: "A meta-markup language, used to create markup languages such as DocBook.",
//             GlossSeeAlso: ["GML", "XML"],
//           },
//           GlossSee: "markup",
//         },
//       },
//     },
//   },
// };

// console.log(Object.entries(Obj));
// for (const item of Object.entries(Obj)) {
//   console.log(item);
// }
// for (const [key, value] of Object.entries(Obj)) {
//   console.log(key + " - " + value);
// }

