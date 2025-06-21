const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const Shop = require("../models/Shop");
const { throwError } = require("../middleware/throwErrors");
const ShopTime = require("../models/ShopTime");
const config = require("../config");
const { getUserByEmail } = require("../heplers/userHelper");

exports.adminRegister = async (req, res, next) => {
  try {
    const { full_name, password, email, address } = req.body;
    const user = new User();
    user.password = await bcrypt.hash(password, 9);
    user.email = email;
    user.full_name = full_name;
    user.address = address;
    user.user_type = "admin";
    await user.save();

    res.status(200).json({
      message: "user added successfully.",
      data: user,
    });
  } catch (err) {
    return next(throwError(422, "user already exist with this email"));
  }
};

exports.shopRegister = async (req, res, next) => {
  try {
    const {
      full_name,
      shop_name,
      shop_address,
      address,
      pincode,
      logo,
      phon_number,
      email,
      password,
    } = req.body;

    const user = new User();
    user.password = await bcrypt.hash(password, 9);
    user.email = email;
    user.full_name = full_name;
    user.address = address;
    user.user_type = "shop_user";
    await user.save();

    const shop = new Shop();
    shop.shop_name = shop_name;
    shop.shop_address = shop_address;
    shop.pincode = pincode;
    shop.phon_number = phon_number;
    shop.logo = req.file.path.replace("public\\", "");
    shop.userId = user._id;
    await shop.save();
    for (let shop_time of config.shop_timing) {
      const shoptime = new ShopTime();
      shoptime.day = shop_time.day;
      shoptime.opentime = shop_time.opentime;
      shoptime.closetime = shop_time.closetime;
      shoptime.shop = shop._id;
      await shoptime.save();
    }

    res.status(200).json({
      message: "Shop user added successfully.",
      data: shop,
      user,
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "user already exist with this email"));
  }
};

exports.customerRegister = async (req, res, next) => {
  try {
    const { full_name, phon_number, address, email, password } = req.body;
    const user = new User();
    user.password = await bcrypt.hash(password, 9);
    user.email = email;
    user.full_name = full_name;
    user.phon_number = phon_number;
    user.address = address;
    user.user_type = "customer";
    await user.save();

    res.status(200).json({
      message: "shop_user added successfully.",
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

    const user = await getUserByEmail(email);

    if (user.length < 1) {
      return next(throwError(404, "User not found."));
    }
    const ismatch = await bcrypt.compare(password, user.password);
    if (!ismatch) {
      return next(throwError(422, "Invalid password."));
    }

    const token = await jwt.sign({ _id: user._id }, "secret");
    user.password = undefined;
    res.json({
      message: "Login successfully",
      token,
      user,
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "Something went wrong."));
  }
};
