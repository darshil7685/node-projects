const { check, validationResult } = require('express-validator');
const User = require('../models/User');




exports.customValidator = [
    check('full_name')
    .notEmpty()
    .withMessage('Name field is required.'),
    check('email')
    .notEmpty()
    .withMessage('Email field is required.')
    .bail()
    .isEmail()
    .withMessage('Please enter a valid email.')
    .custom(async(email, { req, res }) => {
        const user = await User.findOne({ email, });
        if (user) return Promise.reject('Email already exist')
    }),
    check('password')
    .notEmpty()
    .withMessage('Password field is required.'),
    check('address')
    .notEmpty()
    .withMessage('Address field is required.'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        } else {
            next()
        }
    }
]




exports.custom_updateValidator = [
    check('full_name')
    .notEmpty()
    .withMessage('Name field is required.'),
    check('email')
    .notEmpty()
    .withMessage('Email field is required.')
    .bail()
    .isEmail()
    .withMessage('Please enter a valid email.')
    .custom(async(email, { req, res }) => {
        const user = await User.findOne({ email, });
        if (user) return Promise.reject('Email already exist')
    }),
    check('address')
    .notEmpty()
    .withMessage('Address field is required.'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        } else {
            next()
        }
    }
]