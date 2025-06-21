const mongoose = require("mongoose");
const User = require("../models/User");
const Appointment = require("../models/Appointment");

exports.getUserById = async (id) => {
  const users = await User.aggregate([
    {
      $match: { _id: mongoose.Types.ObjectId(id) },
    },
    {
      $lookup: {
        from: "shops",
        localField: "_id",
        foreignField: "userId",
        as: "shop_data",
      },
    },
    {
      $unwind: {
        path: "$shop_data",
        preserveNullAndEmptyArrays: true,
      },
    },
  ]);
  return users[0];
};

exports.getUserByEmail = async (email) => {
  const users = await User.aggregate([
    {
      $match: { email },
    },
    {
      $lookup: {
        from: "shops",
        localField: "_id",
        foreignField: "userId",
        as: "shop_data",
      },
    },
    {
      $unwind: {
        path: "$shop_data",
        preserveNullAndEmptyArrays: true,
      },
    },
  ]);

  return users[0];
};
