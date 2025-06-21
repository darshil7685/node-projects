/**
 * SurveyController
 *
 * @description :: Server-side actions for handling incoming requests.
 * @help        :: See https://sailsjs.com/docs/concepts/actions
 */

const SurveyServices = require("../services/SurveyServices");



module.exports = {
    getSurveyAutopopulate:getSurveyAutopopulate,
    usp_output:usp_output,
};

//  getSurveyAutopopulate function
function getSurveyAutopopulate (req, response) {
    SurveyServices.getSurveyAutopopulate(req, function (err, res){
        if(err) {
            sails.log("error:controller:surveyAutopopulate")
            response.send(err)
        } else {
            sails.log("success:controller:surveyAutopopulate")
            response.send(res)
        }
    });
}

function usp_output (req, response) {
    SurveyServices.usp_output(req, function (err, res){
        if(err) {
            sails.log("error:controller:usp_output")
            response.send(err)
        } else {
            sails.log("success:controller:usp_output")
            response.send(res)
        }
    });
}