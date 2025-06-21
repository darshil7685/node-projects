const Shop = require("../models/Shop");
const user = require("../models/User");
const Appointment = require("../models/Appointment");

const mongoose = require("mongoose");

const { deleteLogo } = require("../middleware/logoDelete");
const { throwError } = require("../middleware/throwErrors");

exports.shopGetProfile = async (req, res) => {
  const shop = await Shop.find({}).populate("userId");
  res.json({
    message: "Your shopGetProfile get successfully",
    data: shop,
  });
};

exports.shop_userUpdate = async (req, res, next) => {
  const user = await User.findOne({ _id: req.user._id });
  if (!user) {
    return next(throwError(404, "User not found."));
  }

  const { email, full_name, address } = req.body;
  user.full_name = full_name;
  user.email = email;
  user.address = address;

  await user.save();

  res.status(200).json({
    date: user,
    message: "Your Profile Is Update Successfuly",
  });
};

exports.shopUpdate = async (req, res, next) => {
  try {
    const shop = await Shop.findOne({ userId: req.user._id });
    if (!shop) {
      return next(throwError(404, "Store not found."));
    }

    if (req.file) {
      shop.logo = req.file.path.replace("public\\", "");
      deleteLogo(shop.logo);
    }

    const { shop_name, shop_address, pincode, phon_number } = req.body;
    shop.shop_name = shop_name;
    shop.shop_address = shop_address;
    shop.pincode = pincode;
    shop.phon_number = phon_number;
    await shop.save();

    res.status(200).json({
      date: shop,
      message: "Your shop is update Successfuly",
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "user already exist with this email"));
  }
};

exports.deleteShopUser = async (req, res, next) => {
  try {
    const user = await User.findOneAndDelete({
      _id: mongoose.Types.ObjectId(req.params._id),
    });
    if (!user) return next(throwError(404, "User not found"));
    const shop = await Shop.findOneAndDelete({
      userId: mongoose.Types.ObjectId(req.params._id),
    });

    if (!shop) return next(throwError(404, "Shop not found"));
    if (shop.logo) {
      deleteLogo(shop.logo);
    }
    res.status(200).json({
      status: true,
      message: "Your Shop Deleted Successfully.",
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "Something went wrong!"));
  }
};


exports.shoptime = async (req, res,net) =>{
  
}


exports.appointmentsShopget = async (req, res, next) => {
  try {
    const appointments = await Appointment.aggregate([
      {
        $lookup: {
          from: "services",
          localField: "serviceId",
          foreignField: "_id",
          as: "service",
        },
      },
      {
        $unwind: {
          path: "$service",
          preserveNullAndEmptyArrays: true,
        },
      },
      {
        $match:{'service.shopId':mongoose.Types.ObjectId(req.user.shop_data._id)
      }
    }]);

    res.status(200).json({
      data: appointments,
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "Something went wrong"));
  }
};
