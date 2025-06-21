const { check, validationResult } = require('express-validator');




exports.ServicesValidator = [
    check('services_name')
    .notEmpty()
    .withMessage('services_name field is required.'),
    check('services_time')
    .notEmpty()
    .withMessage('services_time field is required.')
    .bail()
    .isNumeric()
    .withMessage('please enter a valid service_time'),
    check('services_charges')
    .notEmpty()
    .withMessage('services_charges field is required.')
    .bail()
    .isNumeric()
    .withMessage('please enter a valid services_charges'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        } else {
            next()
        }
    }
]

exports.Services_updateValidator = [
    check('services_name')
    .notEmpty()
    .withMessage('services_name field is required.'),
    check('services_time')
    .notEmpty()
    .withMessage('services_time field is required.')
    .bail()
    .isNumeric()
    .withMessage('please enter a valid service_time'),
    check('services_charges')
    .notEmpty()
    .withMessage('services_charges field is required.')
    .bail()
    .isNumeric()
    .withMessage('please enter a valid services_charges'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        } else {
            next()
        }
    }
]


