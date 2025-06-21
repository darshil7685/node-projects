

const jwt = require("jsonwebtoken")
const ACCESS_TOKEN_SECRET="abcd"

exports.verify = function(req, res, next){
    let accessToken = req.headers.token

    if (!accessToken){
        return res.status(403).send("accesstoken not in request")
    }

    let data
    try{
       
        data = jwt.verify(accessToken,ACCESS_TOKEN_SECRET)
        next()
    }
    catch(e){
        
        return res.status(401).send("error in accesstoken verify")
    }
}