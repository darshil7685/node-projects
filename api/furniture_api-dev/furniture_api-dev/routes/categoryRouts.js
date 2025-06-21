const express = require("express");
const router = express.Router();


const { categoryAdd,categoryGet,categoryUpdate,categoryAllGet,categoryDelete } = require("../controller/categoryControlleres");
const { isAdmin } = require("../middleware/jwtMiddleware");


router.post( "/category-add",isAdmin,categoryAdd);
router.get( "/category-get/:_id",categoryGet);
router.put( "/:_id",isAdmin,categoryUpdate);
router.get( "/category-all-get",isAdmin,categoryAllGet);
router.delete( "/category-delete/:_id",isAdmin,categoryDelete);



module.exports = router
