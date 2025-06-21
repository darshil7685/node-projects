const express = require("express");
const router = express.Router();
const { shop_userUpdate,shopUpdate,deleteShopUser,shopGetProfile,appointmentsShopget  } = require("../controller/shopController");
const { shop_user_updateValidator,shop_updateValidator } = require("../validators/shopValidators");
const { getAllShopTime } = require("../controller/shopTime");
const { isShop } = require("../middleware/jwtMiddleware");
const { shopgetAllServices,shopgetoneServices } = require("../controller/servicesController");
const { upload } = require("../middleware/logoUpload");




router.get( "/get-shop",shopGetProfile);
router.put("/shop-user-update",isShop,shop_user_updateValidator,shop_userUpdate);
router.put("/shop-update",upload.single("logo"),isShop,shop_updateValidator,shopUpdate);
router.delete("/delete-shop/:_id",deleteShopUser);
router.get( "/getall-shop-time",isShop, getAllShopTime);
router.get( "/appointments-shop-get",isShop,appointmentsShopget);
router.get( "/shop-get-all-services/:_id",isShop,shopgetAllServices);
router.get( "/shop-get-on-services/:_id",isShop,shopgetoneServices);





module.exports = router;
