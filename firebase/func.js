'use strict'
// s()
{
    function s(){
        console.log("inside s");
    }
    s()
}
// s() 

let a = 0 || '' || 'dfd'
let b= 12 || 'b'
let c= 'sds' || 'dfdfdf'
let d= null || 'df'
let e='dfdf' || 15
// console.log(a,b,c,d,e)

let z={
    b:12
}
let y=Object.assign({},z)
y.a=15

// console.log(z,y)

let p=2
let q="34"

if(q instanceof String){
    console.log("p--q")
}
// console.log(q instanceof Array)


