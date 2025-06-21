const { check, validationResult } = require("express-validator");
const User = require("../models/User");

exports.appointmentsAddValidator = [
  check("time")
    .notEmpty()
    .withMessage("Time field is required.")
    .bail()
    .matches("^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$")
    .withMessage("Please enter valid time."),
  check("date")
    .notEmpty()
    .withMessage("date field is required.")
    .bail()
    .isDate('YYYY/MM/DD')
    .withMessage("Please enter a valid date."),
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(422).json({ errors: errors.array() });
    } else {
      next();
    }
  },
];

exports.appointmentsUpdateValidator = [
    check("time")
    .notEmpty()
    .withMessage("Time field is required.")
    .bail()
    .matches("^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$")
    .withMessage("Please enter valid time."),
  check("date")
    .notEmpty()
    .withMessage("date field is required.")
    .bail()
    .isDate('YYYY/MM/DD')
    .withMessage("Please enter a valid date."),
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(422).json({ errors: errors.array() });
    } else {
      next();
    }
  },
];