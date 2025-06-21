const express = require("express");
const router = express.Router();

const { addProduct,getProduct,updateProduct,deleteProduct,getAllProduct,listing } = require("../controller/productControlleres");
const { productImage } = require("../middleware/imageUpload");
const { isAdmin } = require("../middleware/jwtMiddleware");
const { productValidator } = require("../validatore/productValidators");



router.post( "/product-add", productImage.array("images"),isAdmin,productValidator,addProduct);
router.get( "/product-get/:_id",isAdmin,getProduct);
router.put( "/product-update/:_id", productImage.array("images"),isAdmin,productValidator,updateProduct);
router.delete( "/product-delete/:_id",isAdmin,deleteProduct);
router.get( "/product-all-get/:_id",isAdmin,getAllProduct);
router.get( "/product-listing",listing);


module.exports = router
