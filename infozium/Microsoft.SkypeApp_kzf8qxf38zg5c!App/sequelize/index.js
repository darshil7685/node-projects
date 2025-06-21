const express = require('express');
const app = express();
const port = 3000;
const router = require('./services');
const {logger} =require("./logger")

const db = require('./db/db.js')

db.sequelize.sync();

app.use(router);
app.all('*',(req,res,next)=>{
    logger.info('Path not Found')
    console.error("Path not found")
    res.json("Path not Found")
})

app.use((err,req,res,next)=>{
    console.error(err);
    res.json("Error occured  "+err)
})
app.listen(port, () => console.log('Server listening on port ' + port));