const jwt = require("jsonwebtoken");
const { throwError } = require("../middleware/throwErrors");
const mongoose = require("mongoose");
const Product = require("../models/Product");
const Favourite = require("../models/Favourite");

exports.favouriteadd = async (req, res, next) => {
  const { productId } = req.body;
  const product = await Product.findOne({
    _id: mongoose.Types.ObjectId(productId),
  });
  if (!product) {
    return next(throwError(404, "Product not found."));
  }
  const favourite = new Favourite();
  favourite.productId = productId;
  favourite.userId = req.user._id;

  await favourite.save();

  res.status(200).json({
    data: favourite,
  });
};

exports.getfavourite = async (req, res, next) => {
  const favourite = await Favourite.find({
    userId: mongoose.Types.ObjectId(req.user._id),
  }).populate("productId");
  if (!favourite) {
    return next(throwError(404, "favourite not found."));
  }
  res.status(200).json({
    data: favourite,
  });
};

exports.deletefavourite = async (req, res) => {
  const favourite = await Favourite.findOneAndDelete({ _id: req.params._id });
  if (!favourite) return next(throwError(404, "Favourite not found."));

  res.status(200).json({
    message: "Your Favourite has been deleted",
  });
};
