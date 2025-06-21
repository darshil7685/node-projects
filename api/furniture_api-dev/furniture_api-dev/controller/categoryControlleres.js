
const jwt = require("jsonwebtoken");
const Category = require("../models/Category");
const { throwError } = require("../middleware/throwErrors");
const slugify = require('slugify')

exports.categoryAdd = async (req, res, next) => {
    try {
      const { category_name,status,slug } = req.body;
      const category = new Category();
      category.category_name = category_name;
      category.status = status;
      category.slug = slugify(category_name,{strict: true} )+Math.floor(1000000+Math.random()*99999)
      await category.save();
  
      res.status(200).json({
        message: "Category added successfully.",
        data: category,
      });
    } catch (err) {
      console.log(err);
      return next(throwError(422, "Something went wrong"));
    }
  };

  exports.categoryGet = async (req, res,next) => {
      try {
    const category = await Category.findOne({ _id: req.params._id });
    if (!category) {
      return next(throwError(404, "category not found."));
    }
    res.json({
      message: "Your category get successfully",
      data: category,
    });
} catch (err) {
    console.log(err);
    return next(throwError(422, "Something went wrong"));
}
};

  exports.categoryUpdate = async (req, res, next) => {
    const category = await Category.findOne({ _id: req.params._id });
    if (!category) {
      return next(throwError(404, "category not found."));
    }
  
    const { category_name, status } = req.body;
    category.category_name = category_name;
    category.status = status;
    category.slug = slugify(category_name,{strict: true} )+Math.floor(1000000+Math.random()*99999)
    await category.save();
  
    res.status(200).json({
      date: category,
      message: "Your Profile Is Update Successfuly",
    });
  };
  



  exports.categoryAllGet = async (req, res,next) => {
    try {
  const category = await Category.find({ });
  if (!category) {
    return next(throwError(404, "category not found."));
  }
  res.json({
    message: "Your category get successfully",
    data: category,
  });
} catch (err) {
  console.log(err);
  return next(throwError(422, "Something went wrong"));
}
};


exports.categoryDelete = async (req, res,next) => {
  try {
const category = await Category.findOneAndDelete({ _id: req.params._id });
if (!category) {
  return next(throwError(404, "category not found."));
}
res.json({
  message: "Your category delete successfully",
});
} catch (err) {
console.log(err);
return next(throwError(422, "Something went wrong"));
}
};

