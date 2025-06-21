/*
 **********************************************************************************
 * SRKAYCG
 * __________________
 *
 * 2022 - SRKAYCG All Rights Reserved.
 *
 * NOTICE: All information contained herein is, and remains the property of
 * SRKAYCG. The intellectual and technical concepts contained herein are
 * proprietary to SRKAYCG. Dissemination of this information or reproduction of
 * this material is strictly forbidden unless prior written permission is
 * obtained from SRKAYCG.
 *
 **********************************************************************************
 */

 const { json } = require('express/lib/response');
const { FIELD_ERROR_STATUS, FIELD_CODE, FIELD_MSG, FIELD_DATA } = require('./constants/jsonConstant');
const { CODE_ERROR, MSG_ERROR, MSG_SUCCESS, CODE_SUCCESS } = require('./constants/logConstant');

 /**
 * @author      :: Nishant Rudani
 * @module      :: Utility: utility-functions
 * @description ::
 * ----------------------------------------------------------------------------------
 * Modified By        | Modified Date  |    Note
 * ----------------------------------------------------------------------------------
 * Nishant Rudani   | 15/02/2022     |    utility related functions
 *___________________________________________________________________________________
 * <p>
 * This file contains utility related functions
 * </p>
 */
 module.exports = {
 
     dbCons: require('./constants/dbConstant'),
     jsonCons: require('./constants/jsonConstant'),
     logCons: require('./constants/logConstant'),
     routeCons: require('../../config/routes'),
 
     /**
      * This method will be used for generating response of API
      * @param {String} msg Message string
      * @param {String} code Response code
      * @param {Boolean} isError Response is for error or not
      * @param {Json} data Response data
      */
 
     responseGenerator: function (msg, code, isError, data) {
         var responseJson = {};
         responseJson[FIELD_ERROR_STATUS] = (isError) ? true : false;
         responseJson[FIELD_CODE] = (code) ? code : (isError) ? CODE_ERROR : CODE_SUCCESS;
         responseJson[FIELD_MSG] = (msg) ? msg : (isError) ? MSG_ERROR : MSG_SUCCESS;
         if (data && data.length !== 0) responseJson[FIELD_DATA] = data;
         return responseJson;
     },
 
    isjson(str) {
         try {
             JSON.parse(str);
         } catch (e) {
             return false;
         }
         return true;
     },
 
     SetParseMultiResponse(resObject) {
         var self = this
 
         if (typeof resObject !== undefined && resObject) {
             resObject.forEach(resItem => {
                 if (!resItem.hasOwnProperty('error_msg')) {
                     Object.keys(resItem).forEach(function (element) {
                         if (resItem[element] === "" || resItem[element] === null) {
                             delete resItem[element];
                         }
                         else {
                             if (self.isjson(resItem[element])) {
                                 resItem[element] = JSON.parse(resItem[element])
                             }
                         }
                     });
                 }
             });
             return resObject;
 
         }
 
     },
 
     validateError:function (validatereq,next){
        if(validatereq.error){
            sails.log("error:surveyBody:surveyBody")
            res.send(responseGenerator(MSG_BAD_REQUEST,LOG_SURVEY_GET + CODE_SUCCESS, false, validatereq))
        }else{
            sails.log("success:surveyBody:surveyBody")
            next()
        }
     },
 }

 
 
 