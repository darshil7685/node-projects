module.exports={
    a:a
}


function a(req,res){
    console.log("req",req.body);
    res.send(req.body)
}