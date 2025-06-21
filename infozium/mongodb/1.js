require("./db");
const { User, Blog, Comment } = require("./model");
const mongoose = require("mongoose");


const obj={
  "1":1,
  1:6,
  [1]:"ghnk"
}
console.log(obj[1],obj["1"]);


async function findUser(){
  const user=await User.findOne({name:'a1'}).select({email:1,name:1,_id:0})
  const checkemail = await user.matchemail('a@gmail.com')
  console.log("checkemail",checkemail);
  console.log("useruser",user);
}
findUser()
