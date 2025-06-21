const jwt = require("jsonwebtoken");
const User = require("../models/User");
const { throwError } = require("./throwErrors");

exports.authentication = async (req, res, next) => {
  try {
    const token = req.headers["authorization"];
    if (!token) {
      return next(throwError(401, "Please authenticate."));
    }
    const decoded = await jwt.verify(token.replace("Bearer ", ""), "secret");
    const user = await User.findOne({ _id: decoded._id });
    if (!user) {
      return next(throwError(401, "Please authenticate."));
    }
    req.user = user;
    next();
  } catch (err) {
    return next(throwError(401, "Please authenticate."));
  }
};



exports.isAdmin = async (req, res, next) => {
    try {
      const token = req.headers["authorization"];
      if (!token) {
        return next(throwError(401, "Please authenticate."));
      }
      const decoded = await jwt.verify(token.replace("Bearer ", ""), "secret");
      const user = await User.findOne({ _id: decoded._id });
      if (!user) {
        return next(throwError(401, "Please authenticate."));
      }
      req.user = user;
      next();
    } catch (err) {
      return next(throwError(401, "Please authenticate."));
    }
  };
  

  exports.isCostomer = async (req, res, next) => {
    try {
      const token = req.headers["authorization"];
      if (!token) {
        return next(throwError(401, "Please authenticate."));
      }
      const decoded = await jwt.verify(token.replace("Bearer ", ""), "secret");
      const user = await User.findOne({ _id: decoded._id });
      if (!user) {
        return next(throwError(401, "Please authenticate."));
      }
      req.user = user;
      next();
    } catch (err) {
      return next(throwError(401, "Please authenticate."));
    }
  };
  