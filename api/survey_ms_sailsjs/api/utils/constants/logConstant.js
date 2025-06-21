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
/**
 * @author      :: Harsh Patel
 * @module      :: Constant: logConstant
 * @description ::
 * ----------------------------------------------------------------------------------
 * Modified By        | Modified Date  |    Note
 * ----------------------------------------------------------------------------------
 * Harsh Patel   | 11/02/2022     |    LOG related Constant
 *___________________________________________________________________________________
 * <p>
 * This file contains constant related to LOG
 * </p>
 */
module.exports = {
//******************* CODE LOGS ***********************//
  CODE_ERROR: "_500",
  CODE_SUCCESS: "_200",
  CODE_NOCONTENT: "_NO_CONTENT_200",
  CODE_NOT_ACCEPTABLE: "_406",
  CODE_MULTI_STATUS: "_207",
  CODE_BAD_REQUEST: "_400",
//******************* MSG LOGS ***********************//
  MSG_MAT: "SURVEY_MS_",
  MSG_SUCCESS: "The request fulfilled successfully.",
  MSG_PARTIAL: "The request fulfilled partially.",
  MSG_CONFLIT: "The request fulfilled successfully with Conflit.",
  MSG_PARTIAL_SUCCESS: "Failed to process few records",
  MSG_BAD_REQUEST: "Bad Request",
  MSG_ERROR: "Error fulfilling the request.",
  MSG_CONN_FAIL: "Connection failed !!!",
  MSG_WRONG: "Something is wrong.",
  MSG_EMPTY_LIST_FOUND: "Empty List Found.",
  MSG_EMPTY_LIST_FOUND_200: "Empty List Found. 200",
  MSG_INVALID_INPUT_PARAM: "_INVALID_INPUT_PARAM",
//******************* LOG PROCESS TYPE ***********************//
  LOG_SURVEY_GET: "SURVEY_GET",
  LOG_SURVEY_UPSERT: "SURVEY UPSERT",
  LOG_SURVEY_INSERT: "SURVEY INSERT",
  LOG_SURVEY_DETAILS: "GET_DETAILS",
  LOG_EMPLOYEE_GET: "GET_EMPLOYEE",
  LOG_EMPLOYEE_UPSERT: "UPSERT_EMPLOYEE",
  LOG_EMPLOYEE_DELETE: "DELETE_EMPLOYEE",
  LOG_UPSERT_DONE : "Upsert Done",
  LOG_UPSERT_NOT_DONE : "Upsert Not Done",
  LOG_DELETE_DATA : "Deleted Successfully",
  LOG_DATA_NOT_FOUND : "Data not found",
  LOG_DELETE_NOT : "Data Not Deleted",
  LOG_SURVEY_ANS_GET:"LOG_SURVEY_ANS_GET",
};
