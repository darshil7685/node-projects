const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const { throwError } = require("../middleware/throwErrors");
// const slugify = require('slugify')
// user.slug = slugify(name,{strict: true} )+Math.floor(1000000+Math.random()*99999)

exports.adminRegister = async (req, res, next) => {
  try {
    const { email, password, gender, phone_number } = req.body;
    const user = new User();
    user.password = await bcrypt.hash(password, 9);
    user.email = email;
    user.gender = gender;
    user.phone_number = phone_number;
    user.user_type = "user";

    await user.save();

    res.status(200).json({
      message: "user added successfully.",
      data: user,
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "user already exist with this email"));
  }
};

exports.userLogin = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email: email }).select("+password");
    if (!user) {
      res.end("User is not found");
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      res.end("Incorrect password.");
    } else {
      const token = await jwt.sign({ _id: user._id }, "secret");
      user.password = undefined;
      res.json({
        message: "Login successfully",
        token,
        user,
      });
    }
  } catch (err) {
    return next(throwError(422, "Your password is incorrect"));
  }
};

exports.userGetProfile = async (req, res) => {
  const user = await User.findOne({ _id: req.user._id });
  res.json({
    message: "Your profile get successfully",
    data: user,
  });
};

exports.userUpdate = async (req, res, next) => {
  const user = await User.findOne({ _id: req.user._id });
  if (!user) {
    return next(throwError(404, "User not found."));
  }

  const { email, password, gender, phone_number } = req.body;
  user.password = password;
  user.email = email;
  user.phone_number = phone_number;
  user.gender = gender;
  await user.save();

  res.status(200).json({
    date: user,
    message: "Your Profile Is Update Successfuly",
  });
};

exports.customerRegister = async (req, res, next) => {
  try {
    const { email, password, gender, phone_number } = req.body;
    const user = new User();
    user.password = await bcrypt.hash(password, 9);
    user.email = email;
    user.gender = gender;
    user.phone_number = phone_number;
    user.user_type = "customer";

    await user.save();

    res.status(200).json({
      message: "user added successfully.",
      data: user,
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "user already exist with this email"));
  }
};

// exports.customerGetProfile = async (req, res) => {
//     const user = await User.findOne({ _id: req.user._id })
//     res.json({
//         message: "Your profile get successfully",
//         data: user
//     })
// }

// exports.customerUpdate = async (req, res, next) => {
//     const user = await User.findOne({ _id: req.user._id });
//     if (!user) {
//       return next(throwError(404, "User not found."));
//     }

//     const { email, password, gender,phone_number } = req.body;
//     user.password = password;
//     user.email = email;
//     user.phone_number = phone_number;
//     user.gender = gender;

//     await user.save();

//     res.status(200).json({
//       date: user,
//       message: "Your Profile Is Update Successfuly",
//     });
//   };
