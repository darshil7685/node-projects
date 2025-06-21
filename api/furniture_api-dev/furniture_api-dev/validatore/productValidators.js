const { check, validationResult } = require('express-validator');
const User = require('../models/User');


exports.productValidator = [
    check('product_name')
    .notEmpty()
    .withMessage('Product_name field is required.'),
    check('price')
    .notEmpty()
    .withMessage('Price field is required.')
    .bail()
    .isNumeric()
    .withMessage('Please enter a valid price .'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        } else {
            next()
        }
    }
]