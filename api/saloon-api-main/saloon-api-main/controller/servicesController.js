const Services = require("../models/Services");
const Shop = require("../models/Shop");

const mongoose = require("mongoose");
const { throwError } = require("../middleware/throwErrors");

exports.servicesAdd = async (req, res, next) => {
  try {
    const { services_name, services_time, services_charges } = req.body;
    const services = new Services();
    services.services_name = services_name;
    services.services_time = services_time;
    services.services_charges = services_charges;
    services.shopId = mongoose.Types.ObjectId(req.user.shop_data._id);
    await services.save();

    res.status(200).json({
      message: "Services added successfully.",
      data: services,
    });
  } catch (err) {
    return next(throwError(422, "Something went wrong"));
  }
};

exports.getAllServices = async (req, res, next) => {
  try {
    const services = await Services.find({
      shopId: mongoose.Types.ObjectId(req.user.shop_data._id),
    });
    if (!services) return next(throwError(404, "Services not found"));
    res.status(200).json({
      data: services,
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "Somthing went wrong"));
  }
};

exports.Services_Update = async (req, res, next) => {
  const service = await Services.findOne({
    _id: mongoose.Types.ObjectId(req.params._id),
    shopId: mongoose.Types.ObjectId(req.user.shop_data._id),
  });
  if (!service) {
    return next(throwError(404, "Service not found."));
  }

  const { services_name, services_time, services_charges } = req.body;
  service.services_name = services_name;
  service.services_time = services_time;
  service.services_charges = services_charges;
  await service.save();

  res.status(200).json({
    date: service,
    message: "Service updated Successfuly",
  });
};

exports.ServiceDelete = async (req, res, next) => {
    try {
        const service = await Services.findOneAndDelete({
            shopId:req.user.shop_data._id,
            _id:req.params._id,
          });
      if (!service) return next(throwError(404, "Service not found"));  
        res.status(200).json({
        status: true,
        message: "Your service Deleted Successfully.",
      });
    } catch (err) {
      console.log(err);
      return next(throwError(422, "Something went wrong!"));
    }
  };
  


  exports.shopgetAllServices = async (req, res, next) => {
    try {
      const services = await Services.find({
        shopId:req.params._id,
      });
      res.status(200).json({
        data: services,
      });
    } catch (err) {
      console.log(err);
      return next(throwError(422, "Somthing went wrong"));
    }
  };
  

  exports.shopgetoneServices = async (req, res, next) => {
    try {
      const services = await Services.findOne({
        _id:req.params._id,
      });
      res.status(200).json({
        data: services,
      });
    } catch (err) {
      console.log(err);
      return next(throwError(422, "Somthing went wrong"));
    }
  };