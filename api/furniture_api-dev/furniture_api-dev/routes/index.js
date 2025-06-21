const express = require("express");
const router = express.Router();
const userRouts = require("./userRouts");
const categoryRouts = require("./categoryRouts");
const productRouts = require("./productRouts");
const favouriteRouts = require("./favouriteRouts");


router.use('/user',userRouts)
router.use('/category',categoryRouts)
router.use('/product',productRouts)
router.use('/favourite',favouriteRouts)


module.exports = router; 
