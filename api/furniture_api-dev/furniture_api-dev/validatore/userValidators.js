const { check, validationResult } = require('express-validator');
const User = require('../models/User');


exports.userValidator = [
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
    check('gender')
    .notEmpty()
    .withMessage('Gender is required.')
    .bail()
    .isIn(['male', 'female', 'others'])
    .withMessage('Please enter a valid Gender.'),
    check('phone_number')
    .notEmpty()
    .withMessage('phone_number field is required.')
    .bail()
    .isNumeric()
    .withMessage('Please enter a valid phone_number.'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        } else {
            next()
        }
    }
]


exports.userLoginValidators = [
    check('email')
    .notEmpty()
    .withMessage('Email field is required.'),
    check('password')
    .notEmpty()
    .withMessage('Password field is required.'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        } else {
            next()
        }
    }
]

exports.userUpdateValidator = [
    check('email')
    .isEmail()
    .withMessage('Please enter a valid email.')
    .custom(async(email, { req, res }) => {
        const user = await User.findOne({ email, });
        if (user) return Promise.reject('Email already exist')
    }),
    check('password')
    .notEmpty()
    .withMessage('Password field is required.'),
    check('gender')
    .notEmpty()
    .withMessage('Gender is required.')
    .bail()
    .isIn(['male', 'female', 'others'])
    .withMessage('Please enter a valid Gender.'),
    check('phone_number')
    .notEmpty()
    .withMessage('phone_number field is required.')
    .bail()
    .isNumeric()
    .withMessage('Please enter a valid phone_number.'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        } else {
            next()
        }
    }
]
