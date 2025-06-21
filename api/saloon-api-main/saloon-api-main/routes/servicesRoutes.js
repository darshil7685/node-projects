const express = require("express");
const router = express.Router();

const { servicesAdd,getAllServices,Services_Update,ServiceDelete,shopgetAllServices,shopgetoneServices } = require("../controller/servicesController");
const { ServicesValidator,Services_updateValidator } = require("../validators/servicesValidators");
const { isShop } = require("../middleware/jwtMiddleware");

router.post( "/services-add",isShop,ServicesValidator,servicesAdd);
router.get( "/getall-services",isShop, getAllServices);
router.put("/services-update/:_id",isShop,Services_updateValidator,Services_Update);
router.delete("/service-delete/:_id",isShop,ServiceDelete);



module.exports = router;
