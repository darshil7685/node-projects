const Services = require("../models/Services");
const user = require("../models/User");
const Appointment = require("../models/Appointment");

const moment = require("moment");

const mongoose = require("mongoose");
const { throwError } = require("../middleware/throwErrors");

exports.appointmentsAdd = async (req, res, next) => {
  try {
    const { time, date, serviceId } = req.body;
    const service = await Services.findOne({
      _id: mongoose.Types.ObjectId(serviceId),
    });
    if (!service) {
      return next(throwError(404, "Service not found."));
    }

    const appointment = new Appointment();
    appointment.start_time = time;
    appointment.end_time = moment(time, "HH:mm")
      .add(service.services_time, "minutes")
      .format("HH:mm");
    appointment.date = date;
    appointment.serviceId = serviceId;
    appointment.customerId = req.user._id;
    await appointment.save();

    res.status(200).json({
      message: "appointments added successfully.",
      data: appointment,
    });
  } catch (err) {
    console.log(err);
    return next(throwError(422, "Something went wrong"));
  }
};



exports.appointmentsUpdate = async (req, res, next) => {
    try {
      const { time, date, serviceId } = req.body;
      const service = await Services.findOne({
        _id: mongoose.Types.ObjectId(serviceId),
      });
      if (!service) {
        return next(throwError(404, "Service not found."));
      }

      const appointment = await Appointment.findOne({
        _id: req.params._id,
      });
      if (!appointment) {
        return next(throwError(404, "appointment not found."));
      }
  
      appointment.start_time = time;
      appointment.end_time = moment(time, "HH:mm")
        .add(service.services_time, "minutes")
        .format("HH:mm");
      appointment.date = date;
      appointment.serviceId = serviceId;
      appointment.customerId = req.user._id;
      await appointment.save();
  
      res.status(200).json({
        message: "appointments Update  successfully.",
        data: appointment,
      });
    } catch (err) {
      console.log(err);
      return next(throwError(422, "Something went wrong"));
    }
  };
  
  
  
  exports.appointmentsdelete = async (req, res, next) => {
    try {
  
      const appointment = await Appointment.findOne({
        _id: req.params._id,
      });
      if (!appointment) {
        return next(throwError(404, "appointment not found."));
      }
  
    appointment.status="cancelled"
      await appointment.save();
  
      res.status(200).json({
        message: "appointments delete  successfully.",
        data: appointment,
      });
    } catch (err) {
      console.log(err);
      return next(throwError(422, "Something went wrong"));
    }
  };

 

  exports.appointmentsget = async (req, res, next) => {
    try {
        const appointment = await Appointment.find({
            customerId: mongoose.Types.ObjectId(req.user._id),
          });
      if (!user) {
        return next(throwError(404, "appointment not found."));
      }

      res.status(200).json({
        message: "appointments get  successfully.",
        data: appointment,
      });
    } catch (err) {
      console.log(err);
      return next(throwError(422, "Something went wrong"));
    }
  };
