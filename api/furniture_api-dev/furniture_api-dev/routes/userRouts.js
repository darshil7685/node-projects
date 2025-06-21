const express = require("express");
const router = express.Router();


const { adminRegister,userLogin,userGetProfile,userUpdate,customerRegister } = require("../controller/userControlleres");
const { authentication } = require("../middleware/jwtMiddleware");
const { userValidator,userLoginValidators,userUpdateValidator } = require("../validatore/userValidators");


router.post( "/admin-register", userValidator,adminRegister);
router.post( "/login",userLoginValidators,userLogin);
router.get( "/",authentication, userGetProfile);
router.put( "/",authentication,userUpdateValidator, userUpdate);
router.post( "/customer-register", userValidator,customerRegister);

module.exports = router;