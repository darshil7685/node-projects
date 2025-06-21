const jwt = require("jsonwebtoken");
const User = require("../models/User");
const { throwError } = require("./throwErrors");
const { getUserById } = require("../heplers/userHelper");

exports.isAdmin = async (req, res, next) => {
  try {
    const token = req.headers["authorization"];
    if (!token) {
      return next(throwError(401, "Please authenticate."));
    }
    const decoded = await jwt.verify(token.replace("Bearer ", ""), "secret");
    // const user = await User.findOne({ _id: decoded._id });
    const user = await getUserById(decoded._id);
    if (!user) {
      return next(throwError(401, "Please authenticate."));
    }
    if (user.user_type != "admin") {
      return next(
        throwError(403, "You have not permission to access this route.")
      );
    }
    req.user = user;
    next();
  } catch (err) {
    console.log(err);
    return next(throwError(401, "Please authenticate."));
  }
};

exports.isShop = async (req, res, next) => {
  try {
    const token = req.headers["authorization"];
    if (!token) {
      return next(throwError(401, "Please authenticate."));
    }
    const decoded = await jwt.verify(token.replace("Bearer ", ""), "secret");
    const user = await getUserById(decoded._id);
    if (!user) {
      return next(throwError(401, "Please authenticate."));
    }
    if (user.user_type != "shop_user") {
      return next(
        throwError(403, "You have not permission to access this route.")
      );
    }
    req.user = user;
    next();
  } catch (err) {
    console.log(err);
    return next(throwError(401, "Please authenticate."));
  }
};

exports.isCustomer = async (req, res, next) => {
  try {
    const token = req.headers["authorization"];
    if (!token) {
      return next(throwError(401, "Please authenticate."));
    }
    const decoded = await jwt.verify(token.replace("Bearer ", ""), "secret");
    const user = await getUserById(decoded._id);
    if (!user) {
      return next(throwError(401, "Please authenticate."));
    }
    if (user.user_type != "customer") {
      return next(
        throwError(403, "You have not permission to access this route.")
      );
    }
    req.user = user;
    next();
  } catch (err) {
    console.log(err);
    return next(throwError(401, "Please authenticate."));
  }
};
