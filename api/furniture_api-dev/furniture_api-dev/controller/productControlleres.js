const jwt = require("jsonwebtoken");
const Product = require("../models/Product");
const { throwError } = require("../middleware/throwErrors");
const mongoose = require("mongoose");
const Category = require("../models/Category");
const { deleteImage } = require("../middleware/imageDelete");

exports.addProduct = async (req, res, next) => {
  const images = req.files.map((file) => {
    return file.path.replace("public\\", "");
  });
  const { product_name, price, categoryId } = req.body;
  const category = await Category.findOne({
    _id: mongoose.Types.ObjectId(categoryId),
  });
  if (!category) {
    return next(throwError(404, "Category not found."));
  }
  const product = new Product();
  product.product_name = product_name;
  product.price = price;
  product.images = images;
  product.categoryId = categoryId;

  await product.save();

  res.status(200).json({
    data: product,
  });
};

exports.getProduct = async (req, res, next) => {
  const product = await Product.findOne({ _id: req.params._id });
  if (!product) {
    return next(throwError(404, "product not found."));
  }
  res.status(200).json({
    data: product,
  });
};

exports.updateProduct = async (req, res, next) => {
  try {
    const product = await Product.findOne({ _id: req.params._id });
    if (!product) {
      return next(throwError(404, "Product not found."));
    }
    let images = product.images;
    if (req.files.length > 0) {
      product.images.forEach((image) => {
        deleteImage(image);
      });
      images = req.files.map((file) => file.path.replace("public\\", ""));
    }

    const { product_name, price, categoryId } = req.body;
    const category = await Category.findOne({
      _id: mongoose.Types.ObjectId(categoryId),
    });
    if (!category) {
      return next(throwError(404, "Category not found."));
    }
    product.product_name = product_name;
    product.price = price;
    product.images = images;
    product.categoryId = categoryId;

    await product.save();

    res.status(200).json({
      message: "Your product Is Update Successfuly",
      data: product,
    });
  } catch (err) {
    return next(throwError(404, "Product not found", err));
  }
};

exports.deleteProduct = async (req, res) => {
  const product = await Product.findOneAndDelete({ _id: req.params._id });
  if (!product) return next(throwError(404, "Product not found."));

  (product.images || []).forEach((image) => {
    deleteImage(image);
  });

  res.status(200).json({
    message: "Your product has been deleted",
  });
};


exports.getAllProduct = async (req, res, next) => {
  const product = await Product.find({
    categoryId: mongoose.Types.ObjectId(req.params._id),
  });
  if (!product) {
    return next(throwError(404, "product not found."));
  }
  res.status(200).json({
    data: product,
  });
};

exports.listing = async (req, res, next) => {
  const product = await Product.find({  });
 
  res.status(200).json({
    data: product,
  });
};