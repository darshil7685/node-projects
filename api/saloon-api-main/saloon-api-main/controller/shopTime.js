const ShopTime = require("../models/ShopTime");
const { throwError } = require("../middleware/throwErrors");
const mongoose = require("mongoose");

exports.getAllShopTime = async (req, res, next) => {
  try {
    const shopTime = await ShopTime.find({
      shop: mongoose.Types.ObjectId(req.user.shop_data._id),
    });
    if (!shopTime) return next(throwError(404, "ShopTime not found"));
    res.status(200).json({
      data: shopTime,
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "Somthing went wrong"));
  }
};
