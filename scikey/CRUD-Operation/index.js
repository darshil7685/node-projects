const express=require("express")
const app =express();
const bodyParser=require("body-parser")
const userRoutes=require("./routes/user_routes")
const PORT=process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(express.json());

app.use('/employee',userRoutes)

app.use((err,req,res,next)=>{
    res.status(400).json({status:false,errors:err})
})
app.listen(PORT,(err)=>{
    if(err){
        console.log(`Error on starting server`);
    }else{
    console.log(`App listening on ${PORT}`);
    }
})
