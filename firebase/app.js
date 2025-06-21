import express from "express"
import bodyParser from 'body-parser'
import args from 'minimist'
import dotenv from 'dotenv'
import path, { resolve } from 'path'

dotenv.config({path:`.env.${process.env.NODE_ENV}`})
// console.log(`.env.${process.env.NODE_ENV}`);
// console.log("process.env",process.env.NODE_ENV);
// dotenv.config({path:`.env.dev`})

console.log("dotenv",dotenv,JSON.stringify(dotenv),`.env.${process.env.NODE_ENV}`);
let app=express()

function o(){
    return new Promise((resolve,reject)=>{
        setTimeout(()=>{
            if(1==2){
                resolve("success")
            }else{
                reject("fail")
            }
        },2000)
    })
}
async function a(){
    try{
        const x=await o()
        console.log("xxxx",x);
        
    }catch(aErr){
        console.log("aErraErraErr",aErr);
        
    }
}
a()



// var args=require('minimist')
const arg=args(process.argv)
console.log("arg",arg.v,arg._);
console.log("app",process.argv.slice(2));
// app.use(bodyParser.json())
// app.use(bodyParser.urlencoded({ extended: true }));
var options = {
    inflate: true,
    // limit: '100kb',
    type: 'text/html'
  }; 
  
app.use(bodyParser.raw(options));
app.get('/payload',(req,res)=>{
    console.log(req.body.toString())
    console.log(req.params)
    console.log(req.headers);
    res.send(req.body.toString())
})
// import redis from 'redis'
// const client = redis.createClient({});
// client.on('connect', function() {
//     console.log('Connected!');
//   });
// let cli=await client.connect();
// cli.set('framework', 'ReactJS', function(err, reply) {
// console.log('1',reply); // OK
// });
// let ab=await cli.get('frameWork')
// console.log(ab)

console.log("process.env.port",process.env.port);
app.listen(process.env.port,()=>{
    console.log("Server Started on ",process.env.port)
})

