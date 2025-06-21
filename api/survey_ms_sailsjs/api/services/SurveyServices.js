var sql = require("mssql");
const { Sails } = require("sails");
const { config } = require("../../config/env/production");
const { PARAM_TABLE_NAME, SP_SURVEY_AUTOPOPULATE, SP_OUTPUT } = require("../utils/constants/dbConstant");
const { FIELD_TABLE_NAME } = require("../utils/constants/jsonConstant");
var func = require("../utils/utility-functions");

module.exports = {
    getSurveyAutopopulate: getSurveyAutopopulate,
    usp_output:usp_output,
}

function getSurveyAutopopulate(req, callback) {
    sails.log("Enter:service:surveyAutopopulate")
    sql.connect(config, function(err){
        sails.log("connect:service:surveyAutopopulate")
		if(err) {
            sails.log("error:service:surveyAutopopulate")
            sql.close();
            callback(func.responseGenerator(func.logCons.MSG_ERROR, func.logCons.LOG_SURVEY_GET + func.logCons.CODE_ERROR, true))
        }
        let sqlRequest = new sql.Request();

        sqlRequest.input(func.dbCons.PARAM_TABLE_NAME, req.body[func.jsonCons.FIELD_TABLE_NAME])
        sqlRequest.execute(func.dbCons.SCHEMA_HUMANRESOURCES+SP_SURVEY_AUTOPOPULATE ).then(function (data, err) {
            sails.log("execute:service:surveyAutopopulate")
			if (err) {
                sails.log("error:service:surveyAutopopulate")
                sql.close();
                callback(func.responseGenerator(func.logCons.MSG_ERROR, func.logCons.LOG_SURVEY_GET + func.logCons.CODE_ERROR, true))
            } else{
                sails.log("success:service:surveyAutopopulate")
                sql.close();
                callback(null,func.responseGenerator(func.logCons.MSG_SUCCESS, func.logCons.LOG_SURVEY_GET + func.logCons.CODE_SUCCESS, false, func.SetParseMultiResponse(data.recordset)))
            }
		});
	});
}

function usp_output(req, callback) {
    sails.log("Enter:service:usp_output")
    sql.connect(config, function(err){
        sails.log("connect:service:usp_output")
		if(err) {
            sails.log("error:service:usp_output")
            sql.close();
            callback(func.responseGenerator(func.logCons.MSG_ERROR, func.logCons.LOG_SURVEY_GET + func.logCons.CODE_ERROR, true))
        }
        let sqlRequest = new sql.Request();
        var tvp_usp_output = new sql.Table();

        tvp_usp_output.columns.add('department_name',sql.VarChar);
        tvp_usp_output.columns.add('department_key',sql.VarChar);

        console.log(req.body)

        // req.body.forEach(element => {
        //     tvp_usp_output.rows.add(
        //         element.department_id,
        //         element.department_name,
        //         element.department_key
        //     )
        // });

        req.body.forEach(element=>{
            tvp_usp_output.rows.add(
                element.department_name,
                element.department_key
            )
        })



        sqlRequest.input("outputs", tvp_usp_output)
        sqlRequest.execute(SP_OUTPUT ).then(function (data, err) {
            sails.log("execute:service:usp_output")
			if (err) {
                sails.log("error:service:usp_output")
                sql.close();
                callback(func.responseGenerator(func.logCons.MSG_ERROR, func.logCons.LOG_SURVEY_GET + func.logCons.CODE_ERROR, true))
            } else{
                sails.log("success:service:usp_output")
                sql.close();
                callback(null,func.responseGenerator(func.logCons.MSG_SUCCESS, func.logCons.LOG_SURVEY_GET + func.logCons.CODE_SUCCESS, false, func.SetParseMultiResponse(data.recordset)))
            }
		});
	});
}

