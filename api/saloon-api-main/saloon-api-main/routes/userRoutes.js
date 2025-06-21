const express = require("express");
const router = express.Router();
const { userValidator,loginValidator } = require("../validators/userValidators");
const { adminRegister,userLogin,customerRegister,shopRegister } = require("../controller/userController");
const { shopValidator } = require("../validators/shopValidators");
const { customValidator,custom_updateValidator } = require("../validators/customerValidators");
const { upload } = require("../middleware/logoUpload");
const { isAdmin,isCustomer } = require("../middleware/jwtMiddleware");
const { customerUpdate } = require("../controller/customerController");
    
router.post( "/register",userValidator, adminRegister);
router.post( "/login", loginValidator,userLogin);
router.post( "/shop-register",upload.single("logo"),isAdmin,shopValidator,shopRegister);
router.post( "/customr-register", customValidator,customerRegister);
router.put("/customr-update",isCustomer,custom_updateValidator,customerUpdate);


module.exports = router;

