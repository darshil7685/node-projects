const express = require("express");
const app = express();
const multer = require("multer");
const sharp = require("sharp")

const upload = multer({
    dest: 'images',
    limits: {
        fileSize: 1000000
    },
    fileFilter(req, file, cb) {
        if (!file.originalname.match(/\.(jpg|jpeg|png)$/)) {
            return cb(new Error("Please upload an image"))
        }
        cb(undefined, true)
    }
})

app.post('/upload', upload.single('upload'), (req, res) => {
    //const buffer = sharp(req.file.buffer).resize({width:250,height:250}).png().toBuffer() 
    res.send("file uploaded successfully")
}, (error, req, res, next) => {
    res.status(400).send({ error: error.message })
})

app.listen(3000, () => {
    console.log("server running at 3000");
})