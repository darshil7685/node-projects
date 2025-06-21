const Joi = require("joi");
const { Sails } = require("sails");
const { MSG_BAD_REQUEST, LOG_SURVEY_GET, CODE_SUCCESS } = require("../utils/constants/logConstant");
const { responseGenerator, validateError } = require("../utils/utility-functions");

module.exports = function (req, res, next) {
    sails.log("Enter:surveyBody:surveyBody")

    const schema = Joi.object().keys({
        table_name: Joi.string().required()
    });

    const validatereq = schema.validate(req.body)
    console.log(validatereq)

    validateError(validatereq,next)
}

