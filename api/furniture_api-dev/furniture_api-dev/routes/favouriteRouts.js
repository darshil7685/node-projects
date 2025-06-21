const express = require("express");
const router = express.Router();


const { favouriteadd,getfavourite,deletefavourite } = require("../controller/favouriteControllers");
const { isCostomer } = require("../middleware/jwtMiddleware");



router.post( "/favourit-add",isCostomer,favouriteadd);
router.get( "/favourit-get",isCostomer,getfavourite);
router.delete( "/favourit-delete/:_id",isCostomer,deletefavourite);


module.exports = router
