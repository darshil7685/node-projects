const User = require("../models/User");
const mongoose = require("mongoose");
const { throwError } = require("../middleware/throwErrors");


exports.customerGetProfile = async (req, res) => {
    const user = await User.find({user_type : "customer"})
    res.json({
        message: "Your profile get successfully",
        data: user
    })
}


exports.customerUpdate = async (req, res, next) => {
    const user = await User.findOne({ _id: req.user._id });
    if (!user) {
      return next(throwError(404, "User not found."));
    }
  
    const { email, full_name, address,phon_number } = req.body;
    user.full_name = full_name;
    user.email = email;
    user.address = address;
    user.phon_number = phon_number;
  
    await user.save();
  
    res.status(200).json({
      date: user,
      message: "Your Profile Is Update Successfuly",
    });
  };



  exports.deleteCustomer = async (req, res, next) => {
    try {
      const user = await User.findOneAndDelete({
        _id: mongoose.Types.ObjectId(req.params._id),
      });
      if (!user) return next(throwError(404, "User not found"));  
        res.status(200).json({
        status: true,
        message: "Your customer Deleted Successfully.",
      });
    } catch (err) {
      console.log(err);
      return next(throwError(422, "Something went wrong!"));
    }
  };
  

  