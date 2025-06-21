const express = require('express');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const bodyParser = require('body-parser');
const decodeJWT = require("jwt-decode")

const ACCESS_TOKEN_EXPIRY='15m'
const privateKey='abcdefgh'
function genrateToken(){
    const token = jwt.sign({ user:"ABC" }, privateKey, {
        expiresIn: ACCESS_TOKEN_EXPIRY,
        issuer:(["Android","ABC2"]).join('-')
    });
    return token 
}

function decodeToken(token){
    jwt.verify(token, privateKey, {  
        expiresIn: ACCESS_TOKEN_EXPIRY,
        issuer:(["Android","ABC2"]).join('-')
     }, (err, user) => {
        if (err) {
            console.log("err========= ",err)
        }else{
            console.log("useruseruseruseruseruseruseruser=======",user);
            
        }
      });
}
const token = genrateToken()
console.log("token",token);

const tt='eyJhbGciOiJIUzI1NiIsInRXVCJ9.eyJ1c2VyIjoiQUiwiaWF0IjoxNzM4MjQ2NjM4LCJleHAiOjE3MzgyNDc1MzgsImlzcyI6IkFvaWQtQUJDMiJ9.HmmyB_8nkNP0IxfDkVIW4HWb1wENgIJihZYWtN9p'

console.log("decoded",decodeJWT.jwtDecode(tt));

decodeToken(token)




