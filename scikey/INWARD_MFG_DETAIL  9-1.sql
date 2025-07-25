USE [dev_srk_db]
GO
/****** Object:  StoredProcedure [Stock].[usp_InwardMfgDetails_List]    Script Date: 09-01-2023 15:37:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************
*
* SRKAY CG
* __________________
*
* 2017 - SRKAY CG
* All Rights Reserved.
*
* NOTICE: All information contained herein is, and remains the property of SRKAY CG.
* The intellectual and technical concepts contained herein are proprietary to SRKAY CG.
* Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from SRKAY CG.
*
* STORED PROCEDURE :[Stock].[usp_InwardMfgDetails_List]
* DESCRIPTION	: NULL
*
** Change History
**************************
** PR	Date		Author				Description
** --	--------	-------			------------------------------------
** 1								This SP will create Combo of Stones for export preplan overview
** 2 	11-03-2020	Nikhil Sangani	 new column added for  	 
** 3 	16-03-2020  Megha Shroff 	 added new column for bl_id, shape_short_name
** 4    19/03/2020  Megha shroff 	 added none if htype and ctype is null
** 5 	21/03/2020  Megha shroff 	 added table , open , side , ex facet , h&a 
** 6 	26/03/2020  Megha shroff     individual inclusion key wise getting from function
** 7    16/07/2020  Megha shroff     added length,width ,extra
** 8    08/08/2020  Megha shroff     change fn_Get_Inclusion_Details_On_Inclusion_Type parameter
** 9    13/08/2020  Megha shroff     added join of stone_processes 
** 10   19/08/2020  Megha shroff     bussiness id from stone details instaeed of vendor stone details
** 11   03/09/2020  Nikhil Sangani   bussiness id from vendor stone details when stone details bussiness id is null
** 12   26/09/2020  Megha shroff     commented Packet.STONE_PROCESSES join and confirm_date null condition
** 13   19/10/2020  Nikhil Sangani   change join for bl master
** 14   20/10/2020  Megha shroff     added alias for all inclusions
** 15   15-12-2020  Megha shroff     added trnyear condition
** 16   17-12-2020  Hardik Patel     remove trnyear condition
** 17   29-12-2020  Hardik Patel     added certificate code of srk
-- =============================================
**************************/
--ALTER PROCEDURE [Stock].[usp_InwardMfgDetails_List]
 declare
 @INWARD_MFG_DETAIL  [Stock].[INWARD_MFG_DETAIL] 
 
 --AS
 BEGIN
 
	declare @mfg_data nvarchar(max)= N'[
    {
      "vendor_exportdatetime": "2022-11-26",
      "vendor_group_number": 4795,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-11-26",
      "vendor_group_number": 4795,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-11-26",
      "vendor_group_number": 4795,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-11-26",
      "vendor_group_number": 4795,
      "vendor_lot_code": "21356"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4781,
      "vendor_lot_code": "21357"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4781,
      "vendor_lot_code": "21359"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4781,
      "vendor_lot_code": "21360"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21356"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21357"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21359"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21360"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21361"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21362"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21363"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "21366"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "44852"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "44853"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "44854"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "66228"
    },
    {
      "vendor_exportdatetime": "2022-10-19",
      "vendor_group_number": 4782,
      "vendor_lot_code": "66229"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4775,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4775,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4776,
      "vendor_lot_code": "21357"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4777,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4777,
      "vendor_lot_code": "21356"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4777,
      "vendor_lot_code": "21357"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4777,
      "vendor_lot_code": "21362"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4777,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4777,
      "vendor_lot_code": "44852"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4777,
      "vendor_lot_code": "66228"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4778,
      "vendor_lot_code": "21357"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4778,
      "vendor_lot_code": "21359"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4778,
      "vendor_lot_code": "21360"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "21356"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "21357"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "21359"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "21361"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "21362"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "44853"
    },
    {
      "vendor_exportdatetime": "2022-10-18",
      "vendor_group_number": 4779,
      "vendor_lot_code": "66228"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4769,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4769,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4769,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4769,
      "vendor_lot_code": "21356"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4769,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4770,
      "vendor_lot_code": "21359"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4771,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4772,
      "vendor_lot_code": "21357"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4772,
      "vendor_lot_code": "21359"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4773,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4773,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4773,
      "vendor_lot_code": "21356"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4773,
      "vendor_lot_code": "21361"
    },
    {
      "vendor_exportdatetime": "2022-10-17",
      "vendor_group_number": 4773,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-15",
      "vendor_group_number": 4766,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-10-15",
      "vendor_group_number": 4766,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-10-15",
      "vendor_group_number": 4766,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-15",
      "vendor_group_number": 4766,
      "vendor_lot_code": "21356"
    },
    {
      "vendor_exportdatetime": "2022-10-15",
      "vendor_group_number": 4767,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-10-15",
      "vendor_group_number": 4767,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-10-15",
      "vendor_group_number": 4767,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-15",
      "vendor_group_number": 4767,
      "vendor_lot_code": "21356"
    },
    {
      "vendor_exportdatetime": "2022-10-15",
      "vendor_group_number": 4767,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-14",
      "vendor_group_number": 4762,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-10-14",
      "vendor_group_number": 4762,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-10-14",
      "vendor_group_number": 4762,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-14",
      "vendor_group_number": 4762,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-14",
      "vendor_group_number": 4764,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-10-14",
      "vendor_group_number": 4764,
      "vendor_lot_code": "21354"
    },
    {
      "vendor_exportdatetime": "2022-10-14",
      "vendor_group_number": 4764,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-14",
      "vendor_group_number": 4764,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-14",
      "vendor_group_number": 4764,
      "vendor_lot_code": "66228"
    },
    {
      "vendor_exportdatetime": "2022-10-13",
      "vendor_group_number": 4759,
      "vendor_lot_code": "21353"
    },
    {
      "vendor_exportdatetime": "2022-10-13",
      "vendor_group_number": 4759,
      "vendor_lot_code": "21355"
    },
    {
      "vendor_exportdatetime": "2022-10-13",
      "vendor_group_number": 4759,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-12",
      "vendor_group_number": 4756,
      "vendor_lot_code": "44851"
    },
    {
      "vendor_exportdatetime": "2022-10-12",
      "vendor_group_number": 4756,
      "vendor_lot_code": "66228"
    },
    {
      "vendor_exportdatetime": "2022-06-01",
      "vendor_group_number": 4432,
      "vendor_lot_code": "21193"
    },
    {
      "vendor_exportdatetime": "2022-06-01",
      "vendor_group_number": 4781,
      "vendor_lot_code": "21193"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4279,
      "vendor_lot_code": "21114"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4279,
      "vendor_lot_code": "21118"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4279,
      "vendor_lot_code": "21119"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4279,
      "vendor_lot_code": "21120"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4279,
      "vendor_lot_code": "21121"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4279,
      "vendor_lot_code": "21122"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "21125"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "21128"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "21129"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "21130"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44732"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44733"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44734"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44735"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44736"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44737"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44738"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44739"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44740"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "44741"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "66186"
    },
    {
      "vendor_exportdatetime": "2022-03-11",
      "vendor_group_number": 4280,
      "vendor_lot_code": "66187"
    },
    {
      "vendor_exportdatetime": "2022-02-22",
      "vendor_group_number": 4231,
      "vendor_lot_code": "21099"
    },
    {
      "vendor_exportdatetime": "2022-02-22",
      "vendor_group_number": 4231,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-22",
      "vendor_group_number": 4231,
      "vendor_lot_code": "21103"
    },
    {
      "vendor_exportdatetime": "2022-02-22",
      "vendor_group_number": 4231,
      "vendor_lot_code": "21105"
    },
    {
      "vendor_exportdatetime": "2022-02-22",
      "vendor_group_number": 4233,
      "vendor_lot_code": "21106"
    },
    {
      "vendor_exportdatetime": "2022-02-22",
      "vendor_group_number": 4233,
      "vendor_lot_code": "21108"
    },
    {
      "vendor_exportdatetime": "2022-02-22",
      "vendor_group_number": 4233,
      "vendor_lot_code": "21110"
    },
    {
      "vendor_exportdatetime": "2022-02-22",
      "vendor_group_number": 4233,
      "vendor_lot_code": "44720"
    },
    {
      "vendor_exportdatetime": "2022-02-22",
      "vendor_group_number": 4233,
      "vendor_lot_code": "44721"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4229,
      "vendor_lot_code": "21097"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4229,
      "vendor_lot_code": "21098"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4229,
      "vendor_lot_code": "21099"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4229,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4229,
      "vendor_lot_code": "21103"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4229,
      "vendor_lot_code": "21109"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4229,
      "vendor_lot_code": "21110"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4230,
      "vendor_lot_code": "44720"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4230,
      "vendor_lot_code": "44724"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4230,
      "vendor_lot_code": "44725"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4230,
      "vendor_lot_code": "44728"
    },
    {
      "vendor_exportdatetime": "2022-02-21",
      "vendor_group_number": 4230,
      "vendor_lot_code": "66184"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21096"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21097"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21098"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21099"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21100"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21103"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21106"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21107"
    },
    {
      "vendor_exportdatetime": "2022-02-18",
      "vendor_group_number": 4227,
      "vendor_lot_code": "21110"
    },
    {
      "vendor_exportdatetime": "2022-02-17",
      "vendor_group_number": 4225,
      "vendor_lot_code": "21097"
    },
    {
      "vendor_exportdatetime": "2022-02-17",
      "vendor_group_number": 4225,
      "vendor_lot_code": "21100"
    },
    {
      "vendor_exportdatetime": "2022-02-17",
      "vendor_group_number": 4226,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-17",
      "vendor_group_number": 4226,
      "vendor_lot_code": "21103"
    },
    {
      "vendor_exportdatetime": "2022-02-17",
      "vendor_group_number": 4226,
      "vendor_lot_code": "44722"
    },
    {
      "vendor_exportdatetime": "2022-02-17",
      "vendor_group_number": 4226,
      "vendor_lot_code": "44723"
    },
    {
      "vendor_exportdatetime": "2022-02-17",
      "vendor_group_number": 4226,
      "vendor_lot_code": "66183"
    },
    {
      "vendor_exportdatetime": "2022-02-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "21100"
    },
    {
      "vendor_exportdatetime": "2022-02-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-16",
      "vendor_group_number": 4224,
      "vendor_lot_code": "21096"
    },
    {
      "vendor_exportdatetime": "2022-02-16",
      "vendor_group_number": 4224,
      "vendor_lot_code": "21100"
    },
    {
      "vendor_exportdatetime": "2022-02-16",
      "vendor_group_number": 4224,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-16",
      "vendor_group_number": 4224,
      "vendor_lot_code": "21103"
    },
    {
      "vendor_exportdatetime": "2022-02-16",
      "vendor_group_number": 4224,
      "vendor_lot_code": "21107"
    },
    {
      "vendor_exportdatetime": "2022-02-16",
      "vendor_group_number": 4224,
      "vendor_lot_code": "21108"
    },
    {
      "vendor_exportdatetime": "2022-02-16",
      "vendor_group_number": 4224,
      "vendor_lot_code": "44721"
    },
    {
      "vendor_exportdatetime": "2022-02-15",
      "vendor_group_number": 123,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-15",
      "vendor_group_number": 4222,
      "vendor_lot_code": "21096"
    },
    {
      "vendor_exportdatetime": "2022-02-15",
      "vendor_group_number": 4222,
      "vendor_lot_code": "21098"
    },
    {
      "vendor_exportdatetime": "2022-02-15",
      "vendor_group_number": 4222,
      "vendor_lot_code": "21100"
    },
    {
      "vendor_exportdatetime": "2022-02-15",
      "vendor_group_number": 4222,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-15",
      "vendor_group_number": 4222,
      "vendor_lot_code": "21103"
    },
    {
      "vendor_exportdatetime": "2022-02-15",
      "vendor_group_number": 4222,
      "vendor_lot_code": "44719"
    },
    {
      "vendor_exportdatetime": "2022-02-14",
      "vendor_group_number": 4219,
      "vendor_lot_code": "21095"
    },
    {
      "vendor_exportdatetime": "2022-02-14",
      "vendor_group_number": 4219,
      "vendor_lot_code": "21096"
    },
    {
      "vendor_exportdatetime": "2022-02-14",
      "vendor_group_number": 4219,
      "vendor_lot_code": "21097"
    },
    {
      "vendor_exportdatetime": "2022-02-14",
      "vendor_group_number": 4219,
      "vendor_lot_code": "21098"
    },
    {
      "vendor_exportdatetime": "2022-02-14",
      "vendor_group_number": 4219,
      "vendor_lot_code": "21100"
    },
    {
      "vendor_exportdatetime": "2022-02-14",
      "vendor_group_number": 4219,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-14",
      "vendor_group_number": 4220,
      "vendor_lot_code": "44718"
    },
    {
      "vendor_exportdatetime": "2022-02-14",
      "vendor_group_number": 4220,
      "vendor_lot_code": "44719"
    },
    {
      "vendor_exportdatetime": "2022-02-14",
      "vendor_group_number": 4220,
      "vendor_lot_code": "44720"
    },
    {
      "vendor_exportdatetime": "2022-02-12",
      "vendor_group_number": 4217,
      "vendor_lot_code": "21088"
    },
    {
      "vendor_exportdatetime": "2022-02-12",
      "vendor_group_number": 4217,
      "vendor_lot_code": "21090"
    },
    {
      "vendor_exportdatetime": "2022-02-11",
      "vendor_group_number": 4215,
      "vendor_lot_code": "21087"
    },
    {
      "vendor_exportdatetime": "2022-02-11",
      "vendor_group_number": 4215,
      "vendor_lot_code": "21093"
    },
    {
      "vendor_exportdatetime": "2022-02-11",
      "vendor_group_number": 4216,
      "vendor_lot_code": "21097"
    },
    {
      "vendor_exportdatetime": "2022-02-11",
      "vendor_group_number": 4216,
      "vendor_lot_code": "21098"
    },
    {
      "vendor_exportdatetime": "2022-02-11",
      "vendor_group_number": 4216,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-11",
      "vendor_group_number": 4216,
      "vendor_lot_code": "44716"
    },
    {
      "vendor_exportdatetime": "2022-02-11",
      "vendor_group_number": 4216,
      "vendor_lot_code": "44720"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "44719"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "44720"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4213,
      "vendor_lot_code": "21093"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "21096"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "21100"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "44715"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "44716"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "44717"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "44718"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "44719"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "44720"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "44721"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "44724"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "66181"
    },
    {
      "vendor_exportdatetime": "2022-02-10",
      "vendor_group_number": 4214,
      "vendor_lot_code": "66182"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4211,
      "vendor_lot_code": "21086"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4211,
      "vendor_lot_code": "21091"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "21093"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "21095"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "21096"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "21100"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "44713"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "44714"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "44715"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "44716"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "44717"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "44720"
    },
    {
      "vendor_exportdatetime": "2022-02-09",
      "vendor_group_number": 4212,
      "vendor_lot_code": "44724"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 123,
      "vendor_lot_code": "44719"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4208,
      "vendor_lot_code": "21082"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4208,
      "vendor_lot_code": "21084"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4208,
      "vendor_lot_code": "21085"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "21093"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "21094"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "21095"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "44714"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "44716"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "44717"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "44718"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "44719"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "44720"
    },
    {
      "vendor_exportdatetime": "2022-02-08",
      "vendor_group_number": 4209,
      "vendor_lot_code": "66181"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4203,
      "vendor_lot_code": "21081"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4204,
      "vendor_lot_code": "21079"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21078"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21086"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21087"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21090"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21091"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21092"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21093"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21094"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21095"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21096"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "21101"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "44712"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "44713"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4205,
      "vendor_lot_code": "44715"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4206,
      "vendor_lot_code": "44714"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4206,
      "vendor_lot_code": "44716"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4206,
      "vendor_lot_code": "44718"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4206,
      "vendor_lot_code": "44720"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4206,
      "vendor_lot_code": "66179"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4206,
      "vendor_lot_code": "66180"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4206,
      "vendor_lot_code": "66181"
    },
    {
      "vendor_exportdatetime": "2022-02-07",
      "vendor_group_number": 4206,
      "vendor_lot_code": "66182"
    },
    {
      "vendor_exportdatetime": "2022-02-05",
      "vendor_group_number": 4202,
      "vendor_lot_code": "21078"
    },
    {
      "vendor_exportdatetime": "2022-02-05",
      "vendor_group_number": 4202,
      "vendor_lot_code": "21082"
    },
    {
      "vendor_exportdatetime": "2022-02-05",
      "vendor_group_number": 4202,
      "vendor_lot_code": "21085"
    },
    {
      "vendor_exportdatetime": "2022-02-04",
      "vendor_group_number": 4199,
      "vendor_lot_code": "21085"
    },
    {
      "vendor_exportdatetime": "2022-02-04",
      "vendor_group_number": 4199,
      "vendor_lot_code": "44712"
    },
    {
      "vendor_exportdatetime": "2022-02-04",
      "vendor_group_number": 4199,
      "vendor_lot_code": "44714"
    },
    {
      "vendor_exportdatetime": "2022-02-04",
      "vendor_group_number": 4199,
      "vendor_lot_code": "44715"
    },
    {
      "vendor_exportdatetime": "2022-02-04",
      "vendor_group_number": 4200,
      "vendor_lot_code": "66179"
    },
    {
      "vendor_exportdatetime": "2022-02-04",
      "vendor_group_number": 4200,
      "vendor_lot_code": "66180"
    },
    {
      "vendor_exportdatetime": "2022-01-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "21074"
    },
    {
      "vendor_exportdatetime": "2022-01-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "44706"
    },
    {
      "vendor_exportdatetime": "2022-01-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "44707"
    },
    {
      "vendor_exportdatetime": "2022-01-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "44708"
    },
    {
      "vendor_exportdatetime": "2022-01-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "44709"
    },
    {
      "vendor_exportdatetime": "2022-01-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "44710"
    },
    {
      "vendor_exportdatetime": "2022-01-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "44711"
    },
    {
      "vendor_exportdatetime": "2022-01-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "21072"
    },
    {
      "vendor_exportdatetime": "2022-01-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "21074"
    },
    {
      "vendor_exportdatetime": "2022-01-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "21075"
    },
    {
      "vendor_exportdatetime": "2022-01-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "21072"
    },
    {
      "vendor_exportdatetime": "2022-01-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "21074"
    },
    {
      "vendor_exportdatetime": "2022-01-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "44707"
    },
    {
      "vendor_exportdatetime": "2022-01-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "21072"
    },
    {
      "vendor_exportdatetime": "2022-01-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "44699"
    },
    {
      "vendor_exportdatetime": "2022-01-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "44700"
    },
    {
      "vendor_exportdatetime": "2022-01-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "44704"
    },
    {
      "vendor_exportdatetime": "2022-01-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "44699"
    },
    {
      "vendor_exportdatetime": "2022-01-19",
      "vendor_group_number": 123,
      "vendor_lot_code": "21067"
    },
    {
      "vendor_exportdatetime": "2022-01-19",
      "vendor_group_number": 123,
      "vendor_lot_code": "44696"
    },
    {
      "vendor_exportdatetime": "2022-01-19",
      "vendor_group_number": 123,
      "vendor_lot_code": "44698"
    },
    {
      "vendor_exportdatetime": "2022-01-19",
      "vendor_group_number": 123,
      "vendor_lot_code": "44699"
    },
    {
      "vendor_exportdatetime": "2022-01-19",
      "vendor_group_number": 123,
      "vendor_lot_code": "44700"
    },
    {
      "vendor_exportdatetime": "2022-01-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "21056"
    },
    {
      "vendor_exportdatetime": "2022-01-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "21064"
    },
    {
      "vendor_exportdatetime": "2022-01-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "21065"
    },
    {
      "vendor_exportdatetime": "2022-01-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "21072"
    },
    {
      "vendor_exportdatetime": "2022-01-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "44694"
    },
    {
      "vendor_exportdatetime": "2022-01-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "44696"
    },
    {
      "vendor_exportdatetime": "2022-01-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "44698"
    },
    {
      "vendor_exportdatetime": "2022-01-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "44699"
    },
    {
      "vendor_exportdatetime": "2022-01-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "44699"
    },
    {
      "vendor_exportdatetime": "2022-01-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "44705"
    },
    {
      "vendor_exportdatetime": "2022-01-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "21054"
    },
    {
      "vendor_exportdatetime": "2022-01-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "44694"
    },
    {
      "vendor_exportdatetime": "2022-01-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "21056"
    },
    {
      "vendor_exportdatetime": "2022-01-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "44694"
    },
    {
      "vendor_exportdatetime": "2022-01-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "44698"
    },
    {
      "vendor_exportdatetime": "2022-01-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "44699"
    },
    {
      "vendor_exportdatetime": "2022-01-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "44700"
    },
    {
      "vendor_exportdatetime": "2022-01-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "44705"
    },
    {
      "vendor_exportdatetime": "2022-01-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "66175"
    },
    {
      "vendor_exportdatetime": "2022-01-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "21048"
    },
    {
      "vendor_exportdatetime": "2022-01-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "21055"
    },
    {
      "vendor_exportdatetime": "2022-01-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "21057"
    },
    {
      "vendor_exportdatetime": "2022-01-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "21061"
    },
    {
      "vendor_exportdatetime": "2022-01-08",
      "vendor_group_number": 123,
      "vendor_lot_code": "21051"
    },
    {
      "vendor_exportdatetime": "2022-01-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "21063"
    },
    {
      "vendor_exportdatetime": "2022-01-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "44699"
    },
    {
      "vendor_exportdatetime": "2022-01-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "21043"
    },
    {
      "vendor_exportdatetime": "2022-01-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "21045"
    },
    {
      "vendor_exportdatetime": "2022-01-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "21052"
    },
    {
      "vendor_exportdatetime": "2022-01-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "21055"
    },
    {
      "vendor_exportdatetime": "2022-01-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "44699"
    },
    {
      "vendor_exportdatetime": "2022-01-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "44700"
    },
    {
      "vendor_exportdatetime": "2022-01-05",
      "vendor_group_number": 123,
      "vendor_lot_code": "21043"
    },
    {
      "vendor_exportdatetime": "2022-01-05",
      "vendor_group_number": 123,
      "vendor_lot_code": "21052"
    },
    {
      "vendor_exportdatetime": "2022-01-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "21045"
    },
    {
      "vendor_exportdatetime": "2022-01-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "44698"
    },
    {
      "vendor_exportdatetime": "2022-01-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21043"
    },
    {
      "vendor_exportdatetime": "2022-01-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21044"
    },
    {
      "vendor_exportdatetime": "2022-01-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21045"
    },
    {
      "vendor_exportdatetime": "2022-01-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21047"
    },
    {
      "vendor_exportdatetime": "2021-12-30",
      "vendor_group_number": 123,
      "vendor_lot_code": "44690"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "21033"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "21035"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "21037"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "21041"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44684"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44685"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44687"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44688"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44689"
    },
    {
      "vendor_exportdatetime": "2021-12-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44690"
    },
    {
      "vendor_exportdatetime": "2021-12-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "21034"
    },
    {
      "vendor_exportdatetime": "2021-12-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "21037"
    },
    {
      "vendor_exportdatetime": "2021-12-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "21039"
    },
    {
      "vendor_exportdatetime": "2021-12-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "44685"
    },
    {
      "vendor_exportdatetime": "2021-12-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "21033"
    },
    {
      "vendor_exportdatetime": "2021-12-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "21034"
    },
    {
      "vendor_exportdatetime": "2021-12-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "21035"
    },
    {
      "vendor_exportdatetime": "2021-12-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "21037"
    },
    {
      "vendor_exportdatetime": "2021-12-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "44682"
    },
    {
      "vendor_exportdatetime": "2021-12-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "44684"
    },
    {
      "vendor_exportdatetime": "2021-12-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "44685"
    },
    {
      "vendor_exportdatetime": "2021-12-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "44690"
    },
    {
      "vendor_exportdatetime": "2021-12-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "21033"
    },
    {
      "vendor_exportdatetime": "2021-12-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "21033"
    },
    {
      "vendor_exportdatetime": "2021-12-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "21034"
    },
    {
      "vendor_exportdatetime": "2021-12-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "21035"
    },
    {
      "vendor_exportdatetime": "2021-12-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "21037"
    },
    {
      "vendor_exportdatetime": "2021-12-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "44682"
    },
    {
      "vendor_exportdatetime": "2021-12-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "44690"
    },
    {
      "vendor_exportdatetime": "2021-12-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "21033"
    },
    {
      "vendor_exportdatetime": "2021-12-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "21034"
    },
    {
      "vendor_exportdatetime": "2021-12-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "21035"
    },
    {
      "vendor_exportdatetime": "2021-12-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "21037"
    },
    {
      "vendor_exportdatetime": "2021-12-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "44682"
    },
    {
      "vendor_exportdatetime": "2021-12-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "21028"
    },
    {
      "vendor_exportdatetime": "2021-12-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "21034"
    },
    {
      "vendor_exportdatetime": "2021-12-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "21035"
    },
    {
      "vendor_exportdatetime": "2021-12-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "21037"
    },
    {
      "vendor_exportdatetime": "2021-12-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "44682"
    },
    {
      "vendor_exportdatetime": "2021-12-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "44688"
    },
    {
      "vendor_exportdatetime": "2021-12-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "44690"
    },
    {
      "vendor_exportdatetime": "2021-12-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "21028"
    },
    {
      "vendor_exportdatetime": "2021-12-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "21030"
    },
    {
      "vendor_exportdatetime": "2021-12-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "21031"
    },
    {
      "vendor_exportdatetime": "2021-12-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "21033"
    },
    {
      "vendor_exportdatetime": "2021-12-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "21034"
    },
    {
      "vendor_exportdatetime": "2021-12-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "44684"
    },
    {
      "vendor_exportdatetime": "2021-12-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "21025"
    },
    {
      "vendor_exportdatetime": "2021-12-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "21026"
    },
    {
      "vendor_exportdatetime": "2021-12-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "21029"
    },
    {
      "vendor_exportdatetime": "2021-12-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "21030"
    },
    {
      "vendor_exportdatetime": "2021-12-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "21034"
    },
    {
      "vendor_exportdatetime": "2021-12-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "21037"
    },
    {
      "vendor_exportdatetime": "2021-12-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "21025"
    },
    {
      "vendor_exportdatetime": "2021-12-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "21026"
    },
    {
      "vendor_exportdatetime": "2021-12-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "21028"
    },
    {
      "vendor_exportdatetime": "2021-12-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "21025"
    },
    {
      "vendor_exportdatetime": "2021-12-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "21028"
    },
    {
      "vendor_exportdatetime": "2021-12-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "21030"
    },
    {
      "vendor_exportdatetime": "2021-12-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "44678"
    },
    {
      "vendor_exportdatetime": "2021-12-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "44690"
    },
    {
      "vendor_exportdatetime": "2021-12-15",
      "vendor_group_number": 123,
      "vendor_lot_code": "21025"
    },
    {
      "vendor_exportdatetime": "2021-12-15",
      "vendor_group_number": 123,
      "vendor_lot_code": "21026"
    },
    {
      "vendor_exportdatetime": "2021-12-14",
      "vendor_group_number": 123,
      "vendor_lot_code": "21016"
    },
    {
      "vendor_exportdatetime": "2021-12-14",
      "vendor_group_number": 123,
      "vendor_lot_code": "21025"
    },
    {
      "vendor_exportdatetime": "2021-12-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "21018"
    },
    {
      "vendor_exportdatetime": "2021-12-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "21025"
    },
    {
      "vendor_exportdatetime": "2021-12-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "21026"
    },
    {
      "vendor_exportdatetime": "2021-12-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "44674"
    },
    {
      "vendor_exportdatetime": "2021-12-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "21016"
    },
    {
      "vendor_exportdatetime": "2021-12-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "21023"
    },
    {
      "vendor_exportdatetime": "2021-12-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "44674"
    },
    {
      "vendor_exportdatetime": "2021-12-09",
      "vendor_group_number": 123,
      "vendor_lot_code": "21016"
    },
    {
      "vendor_exportdatetime": "2021-12-09",
      "vendor_group_number": 123,
      "vendor_lot_code": "21017"
    },
    {
      "vendor_exportdatetime": "2021-12-09",
      "vendor_group_number": 123,
      "vendor_lot_code": "21018"
    },
    {
      "vendor_exportdatetime": "2021-12-09",
      "vendor_group_number": 123,
      "vendor_lot_code": "21025"
    },
    {
      "vendor_exportdatetime": "2021-12-09",
      "vendor_group_number": 123,
      "vendor_lot_code": "44674"
    },
    {
      "vendor_exportdatetime": "2021-12-09",
      "vendor_group_number": 123,
      "vendor_lot_code": "44675"
    },
    {
      "vendor_exportdatetime": "2021-12-08",
      "vendor_group_number": 123,
      "vendor_lot_code": "21016"
    },
    {
      "vendor_exportdatetime": "2021-12-08",
      "vendor_group_number": 123,
      "vendor_lot_code": "21018"
    },
    {
      "vendor_exportdatetime": "2021-12-08",
      "vendor_group_number": 123,
      "vendor_lot_code": "44674"
    },
    {
      "vendor_exportdatetime": "2021-12-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "21016"
    },
    {
      "vendor_exportdatetime": "2021-12-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "21017"
    },
    {
      "vendor_exportdatetime": "2021-12-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "21018"
    },
    {
      "vendor_exportdatetime": "2021-12-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "44674"
    },
    {
      "vendor_exportdatetime": "2021-12-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "66167"
    },
    {
      "vendor_exportdatetime": "2021-12-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "21010"
    },
    {
      "vendor_exportdatetime": "2021-12-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "21014"
    },
    {
      "vendor_exportdatetime": "2021-12-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "21016"
    },
    {
      "vendor_exportdatetime": "2021-12-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "44674"
    },
    {
      "vendor_exportdatetime": "2021-12-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "21009"
    },
    {
      "vendor_exportdatetime": "2021-12-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "21010"
    },
    {
      "vendor_exportdatetime": "2021-12-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "21014"
    },
    {
      "vendor_exportdatetime": "2021-12-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21005"
    },
    {
      "vendor_exportdatetime": "2021-12-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21006"
    },
    {
      "vendor_exportdatetime": "2021-12-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21009"
    },
    {
      "vendor_exportdatetime": "2021-12-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21010"
    },
    {
      "vendor_exportdatetime": "2021-12-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21012"
    },
    {
      "vendor_exportdatetime": "2021-12-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "21013"
    },
    {
      "vendor_exportdatetime": "2021-12-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "44669"
    },
    {
      "vendor_exportdatetime": "2021-12-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "44674"
    },
    {
      "vendor_exportdatetime": "2021-12-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "66167"
    },
    {
      "vendor_exportdatetime": "2021-12-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "21005"
    },
    {
      "vendor_exportdatetime": "2021-12-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "21009"
    },
    {
      "vendor_exportdatetime": "2021-12-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "21010"
    },
    {
      "vendor_exportdatetime": "2021-12-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "21011"
    },
    {
      "vendor_exportdatetime": "2021-12-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "21012"
    },
    {
      "vendor_exportdatetime": "2021-12-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "21016"
    },
    {
      "vendor_exportdatetime": "2021-12-01",
      "vendor_group_number": 123,
      "vendor_lot_code": "21005"
    },
    {
      "vendor_exportdatetime": "2021-12-01",
      "vendor_group_number": 123,
      "vendor_lot_code": "21006"
    },
    {
      "vendor_exportdatetime": "2021-12-01",
      "vendor_group_number": 123,
      "vendor_lot_code": "21010"
    },
    {
      "vendor_exportdatetime": "2021-12-01",
      "vendor_group_number": 123,
      "vendor_lot_code": "44669"
    },
    {
      "vendor_exportdatetime": "2021-12-01",
      "vendor_group_number": 123,
      "vendor_lot_code": "44671"
    },
    {
      "vendor_exportdatetime": "2021-12-01",
      "vendor_group_number": 123,
      "vendor_lot_code": "44674"
    },
    {
      "vendor_exportdatetime": "2021-11-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "21005"
    },
    {
      "vendor_exportdatetime": "2021-11-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "21010"
    },
    {
      "vendor_exportdatetime": "2021-11-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44669"
    },
    {
      "vendor_exportdatetime": "2021-11-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44671"
    },
    {
      "vendor_exportdatetime": "2021-11-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44674"
    },
    {
      "vendor_exportdatetime": "2021-11-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "44669"
    },
    {
      "vendor_exportdatetime": "2021-11-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "44671"
    },
    {
      "vendor_exportdatetime": "2021-11-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "44671"
    },
    {
      "vendor_exportdatetime": "2021-10-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44669"
    },
    {
      "vendor_exportdatetime": "2021-10-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "44671"
    },
    {
      "vendor_exportdatetime": "2021-10-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "66163"
    },
    {
      "vendor_exportdatetime": "2021-10-29",
      "vendor_group_number": 123,
      "vendor_lot_code": "66165"
    },
    {
      "vendor_exportdatetime": "2021-10-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "84663"
    },
    {
      "vendor_exportdatetime": "2021-10-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "84665"
    },
    {
      "vendor_exportdatetime": "2021-10-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "84666"
    },
    {
      "vendor_exportdatetime": "2021-10-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "84667"
    },
    {
      "vendor_exportdatetime": "2021-10-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "87424"
    },
    {
      "vendor_exportdatetime": "2021-10-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "87425"
    },
    {
      "vendor_exportdatetime": "2021-10-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "87427"
    },
    {
      "vendor_exportdatetime": "2021-10-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "84661"
    },
    {
      "vendor_exportdatetime": "2021-10-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "84663"
    },
    {
      "vendor_exportdatetime": "2021-10-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "84664"
    },
    {
      "vendor_exportdatetime": "2021-10-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "84666"
    },
    {
      "vendor_exportdatetime": "2021-10-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "87423"
    },
    {
      "vendor_exportdatetime": "2021-10-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "87425"
    },
    {
      "vendor_exportdatetime": "2021-10-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "84664"
    },
    {
      "vendor_exportdatetime": "2021-10-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "84666"
    },
    {
      "vendor_exportdatetime": "2021-10-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "84660"
    },
    {
      "vendor_exportdatetime": "2021-10-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "84661"
    },
    {
      "vendor_exportdatetime": "2021-10-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "84664"
    },
    {
      "vendor_exportdatetime": "2021-10-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "84666"
    },
    {
      "vendor_exportdatetime": "2021-10-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "84667"
    },
    {
      "vendor_exportdatetime": "2021-10-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "87413"
    },
    {
      "vendor_exportdatetime": "2021-10-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "84660"
    },
    {
      "vendor_exportdatetime": "2021-10-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "84661"
    },
    {
      "vendor_exportdatetime": "2021-10-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "87410"
    },
    {
      "vendor_exportdatetime": "2021-10-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "87413"
    },
    {
      "vendor_exportdatetime": "2021-10-19",
      "vendor_group_number": 123,
      "vendor_lot_code": "87410"
    },
    {
      "vendor_exportdatetime": "2021-10-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "84660"
    },
    {
      "vendor_exportdatetime": "2021-10-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "84664"
    },
    {
      "vendor_exportdatetime": "2021-10-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "84666"
    },
    {
      "vendor_exportdatetime": "2021-10-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "87413"
    },
    {
      "vendor_exportdatetime": "2021-10-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "84657"
    },
    {
      "vendor_exportdatetime": "2021-10-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "84660"
    },
    {
      "vendor_exportdatetime": "2021-10-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "84661"
    },
    {
      "vendor_exportdatetime": "2021-10-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "87406"
    },
    {
      "vendor_exportdatetime": "2021-10-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "87407"
    },
    {
      "vendor_exportdatetime": "2021-10-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "87413"
    },
    {
      "vendor_exportdatetime": "2021-10-14",
      "vendor_group_number": 123,
      "vendor_lot_code": "84660"
    },
    {
      "vendor_exportdatetime": "2021-10-14",
      "vendor_group_number": 123,
      "vendor_lot_code": "84666"
    },
    {
      "vendor_exportdatetime": "2021-10-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "87399"
    },
    {
      "vendor_exportdatetime": "2021-10-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "87406"
    },
    {
      "vendor_exportdatetime": "2021-10-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "87407"
    },
    {
      "vendor_exportdatetime": "2021-10-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "84653"
    },
    {
      "vendor_exportdatetime": "2021-10-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "87402"
    },
    {
      "vendor_exportdatetime": "2021-10-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "87407"
    },
    {
      "vendor_exportdatetime": "2021-10-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "87411"
    },
    {
      "vendor_exportdatetime": "2021-10-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "87413"
    },
    {
      "vendor_exportdatetime": "2021-10-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "84653"
    },
    {
      "vendor_exportdatetime": "2021-10-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "84661"
    },
    {
      "vendor_exportdatetime": "2021-10-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "87402"
    },
    {
      "vendor_exportdatetime": "2021-10-09",
      "vendor_group_number": 123,
      "vendor_lot_code": "86154"
    },
    {
      "vendor_exportdatetime": "2021-10-08",
      "vendor_group_number": 123,
      "vendor_lot_code": "84653"
    },
    {
      "vendor_exportdatetime": "2021-10-08",
      "vendor_group_number": 123,
      "vendor_lot_code": "84655"
    },
    {
      "vendor_exportdatetime": "2021-10-08",
      "vendor_group_number": 123,
      "vendor_lot_code": "87399"
    },
    {
      "vendor_exportdatetime": "2021-10-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "84653"
    },
    {
      "vendor_exportdatetime": "2021-10-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "87395"
    },
    {
      "vendor_exportdatetime": "2021-10-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "87406"
    },
    {
      "vendor_exportdatetime": "2021-10-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "84653"
    },
    {
      "vendor_exportdatetime": "2021-10-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "87395"
    },
    {
      "vendor_exportdatetime": "2021-10-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "87397"
    },
    {
      "vendor_exportdatetime": "2021-10-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "87399"
    },
    {
      "vendor_exportdatetime": "2021-10-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "84653"
    },
    {
      "vendor_exportdatetime": "2021-10-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "86154"
    },
    {
      "vendor_exportdatetime": "2021-10-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "87394"
    },
    {
      "vendor_exportdatetime": "2021-10-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "87397"
    },
    {
      "vendor_exportdatetime": "2021-10-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "87400"
    },
    {
      "vendor_exportdatetime": "2021-09-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "84649"
    },
    {
      "vendor_exportdatetime": "2021-09-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "84650"
    },
    {
      "vendor_exportdatetime": "2021-09-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "84648"
    },
    {
      "vendor_exportdatetime": "2021-09-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "84649"
    },
    {
      "vendor_exportdatetime": "2021-09-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "87392"
    },
    {
      "vendor_exportdatetime": "2021-09-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "87392"
    },
    {
      "vendor_exportdatetime": "2021-09-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "84648"
    },
    {
      "vendor_exportdatetime": "2021-09-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "84649"
    },
    {
      "vendor_exportdatetime": "2021-09-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "84650"
    },
    {
      "vendor_exportdatetime": "2021-09-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "87392"
    },
    {
      "vendor_exportdatetime": "2021-09-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "84648"
    },
    {
      "vendor_exportdatetime": "2021-09-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "87392"
    },
    {
      "vendor_exportdatetime": "2021-09-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "84646"
    },
    {
      "vendor_exportdatetime": "2021-09-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "84648"
    },
    {
      "vendor_exportdatetime": "2021-09-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "84649"
    },
    {
      "vendor_exportdatetime": "2021-09-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "84643"
    },
    {
      "vendor_exportdatetime": "2021-09-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "84646"
    },
    {
      "vendor_exportdatetime": "2021-09-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "87392"
    },
    {
      "vendor_exportdatetime": "2021-09-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "84647"
    },
    {
      "vendor_exportdatetime": "2021-09-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "84648"
    },
    {
      "vendor_exportdatetime": "2021-09-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "84646"
    },
    {
      "vendor_exportdatetime": "2021-09-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "87377"
    },
    {
      "vendor_exportdatetime": "2021-09-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "84646"
    },
    {
      "vendor_exportdatetime": "2021-09-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "87377"
    },
    {
      "vendor_exportdatetime": "2021-09-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "87383"
    },
    {
      "vendor_exportdatetime": "2021-09-14",
      "vendor_group_number": 123,
      "vendor_lot_code": "86151"
    },
    {
      "vendor_exportdatetime": "2021-09-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "84646"
    },
    {
      "vendor_exportdatetime": "2021-09-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "87376"
    },
    {
      "vendor_exportdatetime": "2021-09-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "87377"
    },
    {
      "vendor_exportdatetime": "2021-09-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "87375"
    },
    {
      "vendor_exportdatetime": "2021-09-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "87363"
    },
    {
      "vendor_exportdatetime": "2021-09-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "87369"
    },
    {
      "vendor_exportdatetime": "2021-09-08",
      "vendor_group_number": 123,
      "vendor_lot_code": "87369"
    },
    {
      "vendor_exportdatetime": "2021-09-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "87367"
    },
    {
      "vendor_exportdatetime": "2021-09-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "87369"
    },
    {
      "vendor_exportdatetime": "2021-09-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "87362"
    },
    {
      "vendor_exportdatetime": "2021-09-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "87360"
    },
    {
      "vendor_exportdatetime": "2021-09-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "87360"
    },
    {
      "vendor_exportdatetime": "2021-09-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "87362"
    },
    {
      "vendor_exportdatetime": "2021-08-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "84632"
    },
    {
      "vendor_exportdatetime": "2021-08-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "87351"
    },
    {
      "vendor_exportdatetime": "2021-08-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "84632"
    },
    {
      "vendor_exportdatetime": "2021-08-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "84633"
    },
    {
      "vendor_exportdatetime": "2021-08-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "87349"
    },
    {
      "vendor_exportdatetime": "2021-08-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "84632"
    },
    {
      "vendor_exportdatetime": "2021-08-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "87340"
    },
    {
      "vendor_exportdatetime": "2021-08-11",
      "vendor_group_number": 123,
      "vendor_lot_code": "87342"
    },
    {
      "vendor_exportdatetime": "2021-08-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "84632"
    },
    {
      "vendor_exportdatetime": "2021-08-09",
      "vendor_group_number": 123,
      "vendor_lot_code": "84632"
    },
    {
      "vendor_exportdatetime": "2021-08-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "87341"
    },
    {
      "vendor_exportdatetime": "2021-08-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "84632"
    },
    {
      "vendor_exportdatetime": "2021-08-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "84627"
    },
    {
      "vendor_exportdatetime": "2021-08-03",
      "vendor_group_number": 123,
      "vendor_lot_code": "86146"
    },
    {
      "vendor_exportdatetime": "2021-08-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "86142"
    },
    {
      "vendor_exportdatetime": "2021-07-31",
      "vendor_group_number": 123,
      "vendor_lot_code": "87338"
    },
    {
      "vendor_exportdatetime": "2021-07-28",
      "vendor_group_number": 123,
      "vendor_lot_code": "84625"
    },
    {
      "vendor_exportdatetime": "2021-07-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "84624"
    },
    {
      "vendor_exportdatetime": "2021-07-26",
      "vendor_group_number": 123,
      "vendor_lot_code": "84625"
    },
    {
      "vendor_exportdatetime": "2021-07-26",
      "vendor_group_number": 123,
      "vendor_lot_code": "84626"
    },
    {
      "vendor_exportdatetime": "2021-07-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "87327"
    },
    {
      "vendor_exportdatetime": "2021-07-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "84620"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "87329"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3819,
      "vendor_lot_code": "87320"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3819,
      "vendor_lot_code": "87321"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3819,
      "vendor_lot_code": "87323"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3820,
      "vendor_lot_code": "84616"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3820,
      "vendor_lot_code": "84617"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3820,
      "vendor_lot_code": "84618"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3820,
      "vendor_lot_code": "87324"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3820,
      "vendor_lot_code": "87325"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3820,
      "vendor_lot_code": "87326"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3820,
      "vendor_lot_code": "87328"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3820,
      "vendor_lot_code": "87329"
    },
    {
      "vendor_exportdatetime": "2021-07-22",
      "vendor_group_number": 3820,
      "vendor_lot_code": "87330"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "84617"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "87326"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3813,
      "vendor_lot_code": "87313"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3813,
      "vendor_lot_code": "87315"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3814,
      "vendor_lot_code": "87312"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3814,
      "vendor_lot_code": "87313"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3814,
      "vendor_lot_code": "87315"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3814,
      "vendor_lot_code": "87316"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3814,
      "vendor_lot_code": "87317"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3815,
      "vendor_lot_code": "87319"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3815,
      "vendor_lot_code": "87320"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3815,
      "vendor_lot_code": "87321"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3815,
      "vendor_lot_code": "87322"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3815,
      "vendor_lot_code": "87323"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "84616"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "84617"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "84618"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "84619"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "84620"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "84621"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "84622"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "84623"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "84624"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "87318"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "87324"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "87325"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "87326"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "87327"
    },
    {
      "vendor_exportdatetime": "2021-07-21",
      "vendor_group_number": 3816,
      "vendor_lot_code": "87329"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "84617"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "84624"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 123,
      "vendor_lot_code": "87323"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3810,
      "vendor_lot_code": "84611"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3810,
      "vendor_lot_code": "84615"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3810,
      "vendor_lot_code": "84616"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3810,
      "vendor_lot_code": "84617"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3810,
      "vendor_lot_code": "84618"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3810,
      "vendor_lot_code": "84619"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3810,
      "vendor_lot_code": "84620"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3810,
      "vendor_lot_code": "84623"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3811,
      "vendor_lot_code": "84621"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3811,
      "vendor_lot_code": "84622"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3811,
      "vendor_lot_code": "84624"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3811,
      "vendor_lot_code": "87323"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3811,
      "vendor_lot_code": "87324"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3811,
      "vendor_lot_code": "87325"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3811,
      "vendor_lot_code": "87326"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3811,
      "vendor_lot_code": "87327"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3811,
      "vendor_lot_code": "87328"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3812,
      "vendor_lot_code": "87317"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3812,
      "vendor_lot_code": "87318"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3812,
      "vendor_lot_code": "87320"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3812,
      "vendor_lot_code": "87321"
    },
    {
      "vendor_exportdatetime": "2021-07-20",
      "vendor_group_number": 3812,
      "vendor_lot_code": "87322"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 123,
      "vendor_lot_code": "84618"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 123,
      "vendor_lot_code": "84619"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3807,
      "vendor_lot_code": "87313"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3807,
      "vendor_lot_code": "87315"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87311"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87312"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87313"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87314"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87315"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87316"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87317"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87318"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87319"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3808,
      "vendor_lot_code": "87321"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84613"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84614"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84615"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84616"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84617"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84618"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84619"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84620"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84621"
    },
    {
      "vendor_exportdatetime": "2021-07-19",
      "vendor_group_number": 3809,
      "vendor_lot_code": "84622"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "87320"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3804,
      "vendor_lot_code": "87298"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3804,
      "vendor_lot_code": "87311"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3804,
      "vendor_lot_code": "87312"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3804,
      "vendor_lot_code": "87314"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3804,
      "vendor_lot_code": "87316"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3804,
      "vendor_lot_code": "87317"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3804,
      "vendor_lot_code": "87318"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3805,
      "vendor_lot_code": "87313"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3805,
      "vendor_lot_code": "87315"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87311"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87312"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87313"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87314"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87315"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87316"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87317"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87318"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87319"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87320"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87321"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87322"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87323"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87324"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87325"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87326"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87327"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87328"
    },
    {
      "vendor_exportdatetime": "2021-07-17",
      "vendor_group_number": 3806,
      "vendor_lot_code": "87329"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "87319"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 123,
      "vendor_lot_code": "87323"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3801,
      "vendor_lot_code": "87313"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3801,
      "vendor_lot_code": "87315"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3802,
      "vendor_lot_code": "87311"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3802,
      "vendor_lot_code": "87312"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3802,
      "vendor_lot_code": "87313"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3802,
      "vendor_lot_code": "87314"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3802,
      "vendor_lot_code": "87315"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3802,
      "vendor_lot_code": "87316"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3802,
      "vendor_lot_code": "87317"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3802,
      "vendor_lot_code": "87318"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3802,
      "vendor_lot_code": "87319"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84610"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84613"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84614"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84615"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84616"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84617"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84618"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84619"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84620"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84621"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84622"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84623"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "84624"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "86137"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "86138"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "86139"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "86140"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "87320"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "87321"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "87322"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "87323"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "87324"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "87325"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "87326"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "87327"
    },
    {
      "vendor_exportdatetime": "2021-07-16",
      "vendor_group_number": 3803,
      "vendor_lot_code": "87329"
    },
    {
      "vendor_exportdatetime": "2021-07-15",
      "vendor_group_number": 123,
      "vendor_lot_code": "84617"
    },
    {
      "vendor_exportdatetime": "2021-07-15",
      "vendor_group_number": 123,
      "vendor_lot_code": "87311"
    },
    {
      "vendor_exportdatetime": "2021-07-15",
      "vendor_group_number": 123,
      "vendor_lot_code": "87319"
    },
    {
      "vendor_exportdatetime": "2021-07-14",
      "vendor_group_number": 123,
      "vendor_lot_code": "84612"
    },
    {
      "vendor_exportdatetime": "2021-07-13",
      "vendor_group_number": 123,
      "vendor_lot_code": "84610"
    },
    {
      "vendor_exportdatetime": "2021-07-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "84609"
    },
    {
      "vendor_exportdatetime": "2021-07-12",
      "vendor_group_number": 123,
      "vendor_lot_code": "84610"
    },
    {
      "vendor_exportdatetime": "2021-07-10",
      "vendor_group_number": 123,
      "vendor_lot_code": "87308"
    },
    {
      "vendor_exportdatetime": "2021-07-09",
      "vendor_group_number": 123,
      "vendor_lot_code": "84609"
    },
    {
      "vendor_exportdatetime": "2021-07-07",
      "vendor_group_number": 123,
      "vendor_lot_code": "84609"
    },
    {
      "vendor_exportdatetime": "2021-07-06",
      "vendor_group_number": 123,
      "vendor_lot_code": "87301"
    },
    {
      "vendor_exportdatetime": "2021-07-05",
      "vendor_group_number": 123,
      "vendor_lot_code": "87296"
    },
    {
      "vendor_exportdatetime": "2021-07-05",
      "vendor_group_number": 123,
      "vendor_lot_code": "87301"
    },
    {
      "vendor_exportdatetime": "2021-07-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "84610"
    },
    {
      "vendor_exportdatetime": "2021-07-02",
      "vendor_group_number": 123,
      "vendor_lot_code": "87295"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "84603"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 3742,
      "vendor_lot_code": "84601"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 3742,
      "vendor_lot_code": "84602"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 3742,
      "vendor_lot_code": "84603"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 3742,
      "vendor_lot_code": "84604"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 3742,
      "vendor_lot_code": "87284"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 3742,
      "vendor_lot_code": "87289"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 3742,
      "vendor_lot_code": "87290"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 3742,
      "vendor_lot_code": "87291"
    },
    {
      "vendor_exportdatetime": "2021-06-24",
      "vendor_group_number": 3742,
      "vendor_lot_code": "87292"
    },
    {
      "vendor_exportdatetime": "2021-06-23",
      "vendor_group_number": 3737,
      "vendor_lot_code": "87285"
    },
    {
      "vendor_exportdatetime": "2021-06-22",
      "vendor_group_number": 3733,
      "vendor_lot_code": "87285"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87269"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87270"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87271"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87272"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87273"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87274"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87275"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87276"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87277"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87278"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87279"
    },
    {
      "vendor_exportdatetime": "2021-06-17",
      "vendor_group_number": 3722,
      "vendor_lot_code": "87280"
    },
    {
      "vendor_exportdatetime": "2021-06-16",
      "vendor_group_number": 3717,
      "vendor_lot_code": "87275"
    },
    {
      "vendor_exportdatetime": "2021-06-16",
      "vendor_group_number": 3719,
      "vendor_lot_code": "87285"
    },
    {
      "vendor_exportdatetime": "2021-06-15",
      "vendor_group_number": 3713,
      "vendor_lot_code": "87275"
    },
    {
      "vendor_exportdatetime": "2021-06-14",
      "vendor_group_number": 3712,
      "vendor_lot_code": "84599"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84583"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84593"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84594"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84595"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84596"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84597"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84598"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84599"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84600"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "84601"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87257"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87258"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87259"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87260"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87261"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87262"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87263"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87264"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87265"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87266"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87267"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87268"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87269"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87270"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87271"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87272"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87273"
    },
    {
      "vendor_exportdatetime": "2021-06-09",
      "vendor_group_number": 3702,
      "vendor_lot_code": "87274"
    },
    {
      "vendor_exportdatetime": "2021-05-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "84585"
    },
    {
      "vendor_exportdatetime": "2021-05-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "84587"
    },
    {
      "vendor_exportdatetime": "2021-05-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "84589"
    },
    {
      "vendor_exportdatetime": "2021-05-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "84590"
    },
    {
      "vendor_exportdatetime": "2021-05-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "84591"
    },
    {
      "vendor_exportdatetime": "2021-05-27",
      "vendor_group_number": 123,
      "vendor_lot_code": "84592"
    },
    {
      "vendor_exportdatetime": "2021-05-25",
      "vendor_group_number": 123,
      "vendor_lot_code": "84591"
    },
    {
      "vendor_exportdatetime": "2021-05-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "87241"
    },
    {
      "vendor_exportdatetime": "2021-05-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "84585"
    },
    {
      "vendor_exportdatetime": "2021-05-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "87251"
    },
    {
      "vendor_exportdatetime": "2021-05-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "87253"
    },
    {
      "vendor_exportdatetime": "2021-05-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "84582"
    },
    {
      "vendor_exportdatetime": "2021-05-18",
      "vendor_group_number": 123,
      "vendor_lot_code": "87250"
    },
    {
      "vendor_exportdatetime": "2021-05-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "84578"
    },
    {
      "vendor_exportdatetime": "2021-05-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "84582"
    },
    {
      "vendor_exportdatetime": "2021-05-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "87241"
    },
    {
      "vendor_exportdatetime": "2021-05-17",
      "vendor_group_number": 123,
      "vendor_lot_code": "87250"
    },
    {
      "vendor_exportdatetime": "2021-05-06",
      "vendor_group_number": 3641,
      "vendor_lot_code": "87218"
    },
    {
      "vendor_exportdatetime": "2021-05-05",
      "vendor_group_number": 3640,
      "vendor_lot_code": "87231"
    },
    {
      "vendor_exportdatetime": "2021-05-05",
      "vendor_group_number": 3640,
      "vendor_lot_code": "87241"
    },
    {
      "vendor_exportdatetime": "2021-05-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "84572"
    },
    {
      "vendor_exportdatetime": "2021-05-04",
      "vendor_group_number": 123,
      "vendor_lot_code": "87226"
    },
    {
      "vendor_exportdatetime": "2021-05-01",
      "vendor_group_number": 3635,
      "vendor_lot_code": "87217"
    },
    {
      "vendor_exportdatetime": "2021-05-01",
      "vendor_group_number": 3635,
      "vendor_lot_code": "87218"
    },
    {
      "vendor_exportdatetime": "2021-05-01",
      "vendor_group_number": 3635,
      "vendor_lot_code": "87220"
    },
    {
      "vendor_exportdatetime": "2021-05-01",
      "vendor_group_number": 3635,
      "vendor_lot_code": "87221"
    },
    {
      "vendor_exportdatetime": "2021-05-01",
      "vendor_group_number": 3635,
      "vendor_lot_code": "87222"
    },
    {
      "vendor_exportdatetime": "2021-04-24",
      "vendor_group_number": 123,
      "vendor_lot_code": "87210"
    },
    {
      "vendor_exportdatetime": "2021-04-23",
      "vendor_group_number": 123,
      "vendor_lot_code": "87210"
    },
    {
      "vendor_exportdatetime": "2021-04-22",
      "vendor_group_number": 123,
      "vendor_lot_code": "87210"
    },
    {
      "vendor_exportdatetime": "2021-04-21",
      "vendor_group_number": 123,
      "vendor_lot_code": "87204"
    },
    {
      "vendor_exportdatetime": "2021-04-19",
      "vendor_group_number": 123,
      "vendor_lot_code": "87204"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3581,
      "vendor_lot_code": "87185"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3582,
      "vendor_lot_code": "87189"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3582,
      "vendor_lot_code": "87192"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3583,
      "vendor_lot_code": "87191"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3583,
      "vendor_lot_code": "87193"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3584,
      "vendor_lot_code": "87197"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "84559"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "84560"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "84562"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "84564"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "86120"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "86121"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "86122"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "87199"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "87200"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "87201"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "87202"
    },
    {
      "vendor_exportdatetime": "2021-04-12",
      "vendor_group_number": 3585,
      "vendor_lot_code": "87204"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "84558"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "84559"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "84561"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "84562"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "84563"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "84564"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "84565"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "84566"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "87192"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "87195"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "87196"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "87197"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "87198"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "87200"
    },
    {
      "vendor_exportdatetime": "2021-04-09",
      "vendor_group_number": 3580,
      "vendor_lot_code": "87201"
    },
    {
      "vendor_exportdatetime": "2021-03-31",
      "vendor_group_number": 123,
      "vendor_lot_code": "87176"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "86107"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "86109"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "87119"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "87120"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "87121"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "87122"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "87123"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "87130"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "87131"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "87133"
    },
    {
      "vendor_exportdatetime": "2021-02-18",
      "vendor_group_number": 3472,
      "vendor_lot_code": "87134"
    },
    {
      "vendor_exportdatetime": "2019-11-29",
      "vendor_group_number": 2761,
      "vendor_lot_code": "83325"
    },
    {
      "vendor_exportdatetime": "2019-11-29",
      "vendor_group_number": 2761,
      "vendor_lot_code": "84337"
    },
    {
      "vendor_exportdatetime": "2019-11-29",
      "vendor_group_number": 2761,
      "vendor_lot_code": "84339"
    },
    {
      "vendor_exportdatetime": "2019-11-29",
      "vendor_group_number": 2761,
      "vendor_lot_code": "84342"
    },
    {
      "vendor_exportdatetime": "2019-11-28",
      "vendor_group_number": 2758,
      "vendor_lot_code": "83327"
    },
    {
      "vendor_exportdatetime": "2019-11-28",
      "vendor_group_number": 2758,
      "vendor_lot_code": "83328"
    },
    {
      "vendor_exportdatetime": "2019-11-28",
      "vendor_group_number": 2759,
      "vendor_lot_code": "83321"
    },
    {
      "vendor_exportdatetime": "2019-11-28",
      "vendor_group_number": 2759,
      "vendor_lot_code": "83324"
    },
    {
      "vendor_exportdatetime": "2019-11-28",
      "vendor_group_number": 2759,
      "vendor_lot_code": "83325"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2755,
      "vendor_lot_code": "83326"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2755,
      "vendor_lot_code": "83327"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "83321"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "83322"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "83323"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "83324"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "83325"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "83326"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "83329"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "84337"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "84339"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "84340"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "84341"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2756,
      "vendor_lot_code": "84342"
    },
    {
      "vendor_exportdatetime": "2019-11-27",
      "vendor_group_number": 2757,
      "vendor_lot_code": "11746"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2752,
      "vendor_lot_code": "83316"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2752,
      "vendor_lot_code": "83320"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2752,
      "vendor_lot_code": "83326"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2752,
      "vendor_lot_code": "83328"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "83321"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "83322"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "83324"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "83325"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "83329"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "84336"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "84337"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "84338"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "84339"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "84340"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2753,
      "vendor_lot_code": "84342"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2754,
      "vendor_lot_code": "11748"
    },
    {
      "vendor_exportdatetime": "2019-11-26",
      "vendor_group_number": 2754,
      "vendor_lot_code": "11750"
    },
    {
      "vendor_exportdatetime": "2019-11-25",
      "vendor_group_number": 2750,
      "vendor_lot_code": "83319"
    },
    {
      "vendor_exportdatetime": "2019-11-25",
      "vendor_group_number": 2750,
      "vendor_lot_code": "83326"
    },
    {
      "vendor_exportdatetime": "2019-11-25",
      "vendor_group_number": 2751,
      "vendor_lot_code": "83318"
    },
    {
      "vendor_exportdatetime": "2019-11-25",
      "vendor_group_number": 2751,
      "vendor_lot_code": "83325"
    },
    {
      "vendor_exportdatetime": "2019-11-23",
      "vendor_group_number": 2747,
      "vendor_lot_code": "83316"
    },
    {
      "vendor_exportdatetime": "2019-11-23",
      "vendor_group_number": 2747,
      "vendor_lot_code": "83317"
    },
    {
      "vendor_exportdatetime": "2019-11-23",
      "vendor_group_number": 2747,
      "vendor_lot_code": "83318"
    },
    {
      "vendor_exportdatetime": "2019-11-23",
      "vendor_group_number": 2748,
      "vendor_lot_code": "83315"
    },
    {
      "vendor_exportdatetime": "2019-11-23",
      "vendor_group_number": 2748,
      "vendor_lot_code": "83319"
    },
    {
      "vendor_exportdatetime": "2019-11-21",
      "vendor_group_number": 2743,
      "vendor_lot_code": "83319"
    },
    {
      "vendor_exportdatetime": "2019-10-23",
      "vendor_group_number": 2741,
      "vendor_lot_code": "83319"
    },
    {
      "vendor_exportdatetime": "2019-10-22",
      "vendor_group_number": 2739,
      "vendor_lot_code": "83319"
    },
    {
      "vendor_exportdatetime": "2019-10-22",
      "vendor_group_number": 2739,
      "vendor_lot_code": "83320"
    },
    {
      "vendor_exportdatetime": "2019-10-19",
      "vendor_group_number": 2728,
      "vendor_lot_code": "83309"
    },
    {
      "vendor_exportdatetime": "2019-10-19",
      "vendor_group_number": 2729,
      "vendor_lot_code": "84329"
    },
    {
      "vendor_exportdatetime": "2019-10-19",
      "vendor_group_number": 2733,
      "vendor_lot_code": "83313"
    },
    {
      "vendor_exportdatetime": "2019-10-18",
      "vendor_group_number": 2720,
      "vendor_lot_code": "83297"
    },
    {
      "vendor_exportdatetime": "2019-10-17",
      "vendor_group_number": 2713,
      "vendor_lot_code": "83301"
    },
    {
      "vendor_exportdatetime": "2019-10-17",
      "vendor_group_number": 2716,
      "vendor_lot_code": "83302"
    },
    {
      "vendor_exportdatetime": "2019-10-17",
      "vendor_group_number": 2718,
      "vendor_lot_code": "83302"
    },
    {
      "vendor_exportdatetime": "2019-10-12",
      "vendor_group_number": 2696,
      "vendor_lot_code": "83285"
    },
    {
      "vendor_exportdatetime": "2019-10-12",
      "vendor_group_number": 2696,
      "vendor_lot_code": "83286"
    },
    {
      "vendor_exportdatetime": "2019-10-12",
      "vendor_group_number": 2696,
      "vendor_lot_code": "83291"
    },
    {
      "vendor_exportdatetime": "2019-10-12",
      "vendor_group_number": 2696,
      "vendor_lot_code": "83293"
    },
    {
      "vendor_exportdatetime": "2019-10-12",
      "vendor_group_number": 2696,
      "vendor_lot_code": "83296"
    },
    {
      "vendor_exportdatetime": "2019-10-11",
      "vendor_group_number": 2691,
      "vendor_lot_code": "83289"
    },
    {
      "vendor_exportdatetime": "2019-10-11",
      "vendor_group_number": 2691,
      "vendor_lot_code": "83291"
    },
    {
      "vendor_exportdatetime": "2019-10-09",
      "vendor_group_number": 2686,
      "vendor_lot_code": "83299"
    },
    {
      "vendor_exportdatetime": "2019-10-09",
      "vendor_group_number": 2687,
      "vendor_lot_code": "83285"
    },
    {
      "vendor_exportdatetime": "2019-10-09",
      "vendor_group_number": 2687,
      "vendor_lot_code": "83289"
    },
    {
      "vendor_exportdatetime": "2019-10-09",
      "vendor_group_number": 2687,
      "vendor_lot_code": "83301"
    },
    {
      "vendor_exportdatetime": "2019-10-09",
      "vendor_group_number": 2688,
      "vendor_lot_code": "11742"
    },
    {
      "vendor_exportdatetime": "2019-10-08",
      "vendor_group_number": 2683,
      "vendor_lot_code": "83279"
    },
    {
      "vendor_exportdatetime": "2019-10-08",
      "vendor_group_number": 2683,
      "vendor_lot_code": "83285"
    },
    {
      "vendor_exportdatetime": "2019-10-07",
      "vendor_group_number": 2681,
      "vendor_lot_code": "83288"
    },
    {
      "vendor_exportdatetime": "2019-10-04",
      "vendor_group_number": 2675,
      "vendor_lot_code": "83280"
    },
    {
      "vendor_exportdatetime": "2019-10-04",
      "vendor_group_number": 2675,
      "vendor_lot_code": "83289"
    },
    {
      "vendor_exportdatetime": "2019-10-03",
      "vendor_group_number": 2673,
      "vendor_lot_code": "84325"
    },
    {
      "vendor_exportdatetime": "2019-09-27",
      "vendor_group_number": 2661,
      "vendor_lot_code": "83273"
    },
    {
      "vendor_exportdatetime": "2019-09-26",
      "vendor_group_number": 2659,
      "vendor_lot_code": "83268"
    },
    {
      "vendor_exportdatetime": "2019-09-26",
      "vendor_group_number": 2659,
      "vendor_lot_code": "83273"
    },
    {
      "vendor_exportdatetime": "2019-09-26",
      "vendor_group_number": 2660,
      "vendor_lot_code": "84321"
    },
    {
      "vendor_exportdatetime": "2019-09-25",
      "vendor_group_number": 2657,
      "vendor_lot_code": "83267"
    },
    {
      "vendor_exportdatetime": "2019-09-25",
      "vendor_group_number": 2657,
      "vendor_lot_code": "83269"
    },
    {
      "vendor_exportdatetime": "2019-09-25",
      "vendor_group_number": 2658,
      "vendor_lot_code": "84312"
    },
    {
      "vendor_exportdatetime": "2019-09-24",
      "vendor_group_number": 2655,
      "vendor_lot_code": "83258"
    },
    {
      "vendor_exportdatetime": "2019-09-24",
      "vendor_group_number": 2655,
      "vendor_lot_code": "83267"
    },
    {
      "vendor_exportdatetime": "2019-09-24",
      "vendor_group_number": 2656,
      "vendor_lot_code": "84312"
    },
    {
      "vendor_exportdatetime": "2019-09-24",
      "vendor_group_number": 2656,
      "vendor_lot_code": "84314"
    },
    {
      "vendor_exportdatetime": "2019-09-23",
      "vendor_group_number": 2654,
      "vendor_lot_code": "83258"
    },
    {
      "vendor_exportdatetime": "2019-09-23",
      "vendor_group_number": 2654,
      "vendor_lot_code": "83264"
    },
    {
      "vendor_exportdatetime": "2019-09-20",
      "vendor_group_number": 2652,
      "vendor_lot_code": "83260"
    },
    {
      "vendor_exportdatetime": "2019-09-20",
      "vendor_group_number": 2652,
      "vendor_lot_code": "84313"
    },
    {
      "vendor_exportdatetime": "2019-09-19",
      "vendor_group_number": 2651,
      "vendor_lot_code": "83256"
    },
    {
      "vendor_exportdatetime": "2019-09-19",
      "vendor_group_number": 2651,
      "vendor_lot_code": "84309"
    },
    {
      "vendor_exportdatetime": "2019-09-18",
      "vendor_group_number": 2648,
      "vendor_lot_code": "83252"
    },
    {
      "vendor_exportdatetime": "2019-09-17",
      "vendor_group_number": 2645,
      "vendor_lot_code": "83252"
    },
    {
      "vendor_exportdatetime": "2019-09-17",
      "vendor_group_number": 2646,
      "vendor_lot_code": "83254"
    },
    {
      "vendor_exportdatetime": "2019-09-17",
      "vendor_group_number": 2646,
      "vendor_lot_code": "83256"
    },
    {
      "vendor_exportdatetime": "2019-09-16",
      "vendor_group_number": 2642,
      "vendor_lot_code": "83251"
    },
    {
      "vendor_exportdatetime": "2019-09-16",
      "vendor_group_number": 2642,
      "vendor_lot_code": "83256"
    },
    {
      "vendor_exportdatetime": "2019-09-16",
      "vendor_group_number": 2643,
      "vendor_lot_code": "84308"
    },
    {
      "vendor_exportdatetime": "2019-09-14",
      "vendor_group_number": 2641,
      "vendor_lot_code": "83252"
    },
    {
      "vendor_exportdatetime": "2019-09-14",
      "vendor_group_number": 2641,
      "vendor_lot_code": "83256"
    },
    {
      "vendor_exportdatetime": "2019-09-13",
      "vendor_group_number": 2639,
      "vendor_lot_code": "83245"
    },
    {
      "vendor_exportdatetime": "2019-09-13",
      "vendor_group_number": 2639,
      "vendor_lot_code": "83246"
    },
    {
      "vendor_exportdatetime": "2019-09-13",
      "vendor_group_number": 2640,
      "vendor_lot_code": "83255"
    },
    {
      "vendor_exportdatetime": "2019-09-10",
      "vendor_group_number": 2633,
      "vendor_lot_code": "83240"
    },
    {
      "vendor_exportdatetime": "2019-09-10",
      "vendor_group_number": 2634,
      "vendor_lot_code": "83245"
    },
    {
      "vendor_exportdatetime": "2019-08-30",
      "vendor_group_number": 2612,
      "vendor_lot_code": "11726"
    },
    {
      "vendor_exportdatetime": "2019-08-30",
      "vendor_group_number": 2612,
      "vendor_lot_code": "11727"
    },
    {
      "vendor_exportdatetime": "2019-08-28",
      "vendor_group_number": 2607,
      "vendor_lot_code": "11727"
    },
    {
      "vendor_exportdatetime": "2019-08-21",
      "vendor_group_number": 2593,
      "vendor_lot_code": "11725"
    },
    {
      "vendor_exportdatetime": "2019-08-21",
      "vendor_group_number": 2593,
      "vendor_lot_code": "11726"
    },
    {
      "vendor_exportdatetime": "2019-08-12",
      "vendor_group_number": 2580,
      "vendor_lot_code": "11723"
    },
    {
      "vendor_exportdatetime": "2019-08-12",
      "vendor_group_number": 2580,
      "vendor_lot_code": "11724"
    },
    {
      "vendor_exportdatetime": "2019-08-07",
      "vendor_group_number": 2569,
      "vendor_lot_code": "11722"
    },
    {
      "vendor_exportdatetime": "2019-07-31",
      "vendor_group_number": 2555,
      "vendor_lot_code": "83185"
    },
    {
      "vendor_exportdatetime": "2019-07-31",
      "vendor_group_number": 2556,
      "vendor_lot_code": "83183"
    },
    {
      "vendor_exportdatetime": "2019-07-31",
      "vendor_group_number": 2556,
      "vendor_lot_code": "83186"
    },
    {
      "vendor_exportdatetime": "2019-07-30",
      "vendor_group_number": 2552,
      "vendor_lot_code": "83194"
    },
    {
      "vendor_exportdatetime": "2019-07-30",
      "vendor_group_number": 2553,
      "vendor_lot_code": "83187"
    },
    {
      "vendor_exportdatetime": "2019-07-30",
      "vendor_group_number": 2554,
      "vendor_lot_code": "83184"
    },
    {
      "vendor_exportdatetime": "2019-07-30",
      "vendor_group_number": 2554,
      "vendor_lot_code": "83185"
    },
    {
      "vendor_exportdatetime": "2019-07-30",
      "vendor_group_number": 2554,
      "vendor_lot_code": "83188"
    },
    {
      "vendor_exportdatetime": "2019-07-30",
      "vendor_group_number": 2554,
      "vendor_lot_code": "83189"
    },
    {
      "vendor_exportdatetime": "2019-07-29",
      "vendor_group_number": 2551,
      "vendor_lot_code": "83190"
    },
    {
      "vendor_exportdatetime": "2019-07-29",
      "vendor_group_number": 2551,
      "vendor_lot_code": "83191"
    },
    {
      "vendor_exportdatetime": "2019-07-29",
      "vendor_group_number": 2551,
      "vendor_lot_code": "83192"
    },
    {
      "vendor_exportdatetime": "2019-07-27",
      "vendor_group_number": 2547,
      "vendor_lot_code": "83187"
    },
    {
      "vendor_exportdatetime": "2019-07-27",
      "vendor_group_number": 2548,
      "vendor_lot_code": "83183"
    },
    {
      "vendor_exportdatetime": "2019-07-27",
      "vendor_group_number": 2548,
      "vendor_lot_code": "83184"
    },
    {
      "vendor_exportdatetime": "2019-07-27",
      "vendor_group_number": 2548,
      "vendor_lot_code": "83186"
    },
    {
      "vendor_exportdatetime": "2019-07-27",
      "vendor_group_number": 2548,
      "vendor_lot_code": "83188"
    },
    {
      "vendor_exportdatetime": "2019-07-27",
      "vendor_group_number": 2549,
      "vendor_lot_code": "83191"
    },
    {
      "vendor_exportdatetime": "2019-07-27",
      "vendor_group_number": 2549,
      "vendor_lot_code": "83192"
    },
    {
      "vendor_exportdatetime": "2019-07-26",
      "vendor_group_number": 2545,
      "vendor_lot_code": "83187"
    },
    {
      "vendor_exportdatetime": "2019-07-26",
      "vendor_group_number": 2546,
      "vendor_lot_code": "83183"
    },
    {
      "vendor_exportdatetime": "2019-07-26",
      "vendor_group_number": 2546,
      "vendor_lot_code": "83184"
    },
    {
      "vendor_exportdatetime": "2019-07-26",
      "vendor_group_number": 2546,
      "vendor_lot_code": "83185"
    },
    {
      "vendor_exportdatetime": "2019-07-26",
      "vendor_group_number": 2546,
      "vendor_lot_code": "83186"
    },
    {
      "vendor_exportdatetime": "2019-07-26",
      "vendor_group_number": 2546,
      "vendor_lot_code": "83187"
    },
    {
      "vendor_exportdatetime": "2019-07-26",
      "vendor_group_number": 2546,
      "vendor_lot_code": "83188"
    },
    {
      "vendor_exportdatetime": "2019-07-25",
      "vendor_group_number": 2543,
      "vendor_lot_code": "83180"
    },
    {
      "vendor_exportdatetime": "2019-07-25",
      "vendor_group_number": 2543,
      "vendor_lot_code": "83181"
    },
    {
      "vendor_exportdatetime": "2019-07-25",
      "vendor_group_number": 2543,
      "vendor_lot_code": "83185"
    },
    {
      "vendor_exportdatetime": "2019-07-25",
      "vendor_group_number": 2543,
      "vendor_lot_code": "83187"
    },
    {
      "vendor_exportdatetime": "2019-07-24",
      "vendor_group_number": 2539,
      "vendor_lot_code": "83181"
    },
    {
      "vendor_exportdatetime": "2019-07-24",
      "vendor_group_number": 2539,
      "vendor_lot_code": "83185"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2536,
      "vendor_lot_code": "11721"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2537,
      "vendor_lot_code": "83181"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2538,
      "vendor_lot_code": "83178"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2538,
      "vendor_lot_code": "83179"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2538,
      "vendor_lot_code": "83182"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2538,
      "vendor_lot_code": "83184"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2538,
      "vendor_lot_code": "83185"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2538,
      "vendor_lot_code": "83186"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2538,
      "vendor_lot_code": "83188"
    },
    {
      "vendor_exportdatetime": "2019-07-23",
      "vendor_group_number": 2538,
      "vendor_lot_code": "83189"
    },
    {
      "vendor_exportdatetime": "2019-07-22",
      "vendor_group_number": 2533,
      "vendor_lot_code": "83180"
    },
    {
      "vendor_exportdatetime": "2019-07-22",
      "vendor_group_number": 2533,
      "vendor_lot_code": "83187"
    },
    {
      "vendor_exportdatetime": "2019-07-22",
      "vendor_group_number": 2534,
      "vendor_lot_code": "83178"
    },
    {
      "vendor_exportdatetime": "2019-07-22",
      "vendor_group_number": 2534,
      "vendor_lot_code": "83179"
    },
    {
      "vendor_exportdatetime": "2019-07-22",
      "vendor_group_number": 2534,
      "vendor_lot_code": "83182"
    },
    {
      "vendor_exportdatetime": "2019-07-22",
      "vendor_group_number": 2534,
      "vendor_lot_code": "83183"
    },
    {
      "vendor_exportdatetime": "2019-07-22",
      "vendor_group_number": 2534,
      "vendor_lot_code": "83186"
    },
    {
      "vendor_exportdatetime": "2019-07-20",
      "vendor_group_number": 2531,
      "vendor_lot_code": "83180"
    },
    {
      "vendor_exportdatetime": "2019-07-20",
      "vendor_group_number": 2531,
      "vendor_lot_code": "83181"
    },
    {
      "vendor_exportdatetime": "2019-07-20",
      "vendor_group_number": 2532,
      "vendor_lot_code": "83178"
    },
    {
      "vendor_exportdatetime": "2019-07-20",
      "vendor_group_number": 2532,
      "vendor_lot_code": "83179"
    },
    {
      "vendor_exportdatetime": "2019-07-20",
      "vendor_group_number": 2532,
      "vendor_lot_code": "83181"
    },
    {
      "vendor_exportdatetime": "2019-07-20",
      "vendor_group_number": 2532,
      "vendor_lot_code": "83182"
    },
    {
      "vendor_exportdatetime": "2019-07-20",
      "vendor_group_number": 2532,
      "vendor_lot_code": "83184"
    },
    {
      "vendor_exportdatetime": "2019-07-20",
      "vendor_group_number": 2532,
      "vendor_lot_code": "83185"
    },
    {
      "vendor_exportdatetime": "2019-07-20",
      "vendor_group_number": 2532,
      "vendor_lot_code": "83186"
    },
    {
      "vendor_exportdatetime": "2019-07-19",
      "vendor_group_number": 2530,
      "vendor_lot_code": "83179"
    },
    {
      "vendor_exportdatetime": "2019-07-19",
      "vendor_group_number": 2530,
      "vendor_lot_code": "83181"
    },
    {
      "vendor_exportdatetime": "2019-07-19",
      "vendor_group_number": 2530,
      "vendor_lot_code": "83182"
    },
    {
      "vendor_exportdatetime": "2019-07-19",
      "vendor_group_number": 2530,
      "vendor_lot_code": "83184"
    },
    {
      "vendor_exportdatetime": "2019-07-19",
      "vendor_group_number": 2530,
      "vendor_lot_code": "83185"
    },
    {
      "vendor_exportdatetime": "2019-07-19",
      "vendor_group_number": 2530,
      "vendor_lot_code": "83186"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2527,
      "vendor_lot_code": "83180"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2527,
      "vendor_lot_code": "83181"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2528,
      "vendor_lot_code": "83173"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2528,
      "vendor_lot_code": "83174"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2528,
      "vendor_lot_code": "83175"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2528,
      "vendor_lot_code": "83176"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2528,
      "vendor_lot_code": "83178"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2528,
      "vendor_lot_code": "83179"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2528,
      "vendor_lot_code": "83182"
    },
    {
      "vendor_exportdatetime": "2019-07-18",
      "vendor_group_number": 2528,
      "vendor_lot_code": "83184"
    },
    {
      "vendor_exportdatetime": "2019-07-16",
      "vendor_group_number": 2523,
      "vendor_lot_code": "83176"
    },
    {
      "vendor_exportdatetime": "2019-07-16",
      "vendor_group_number": 2523,
      "vendor_lot_code": "83177"
    },
    {
      "vendor_exportdatetime": "2019-07-15",
      "vendor_group_number": 2521,
      "vendor_lot_code": "83169"
    },
    {
      "vendor_exportdatetime": "2019-07-15",
      "vendor_group_number": 2521,
      "vendor_lot_code": "83170"
    },
    {
      "vendor_exportdatetime": "2019-07-15",
      "vendor_group_number": 2521,
      "vendor_lot_code": "83171"
    },
    {
      "vendor_exportdatetime": "2019-07-15",
      "vendor_group_number": 2521,
      "vendor_lot_code": "83173"
    },
    {
      "vendor_exportdatetime": "2019-07-15",
      "vendor_group_number": 2521,
      "vendor_lot_code": "83175"
    },
    {
      "vendor_exportdatetime": "2019-07-13",
      "vendor_group_number": 2519,
      "vendor_lot_code": "83170"
    },
    {
      "vendor_exportdatetime": "2019-07-13",
      "vendor_group_number": 2519,
      "vendor_lot_code": "83171"
    },
    {
      "vendor_exportdatetime": "2019-07-13",
      "vendor_group_number": 2519,
      "vendor_lot_code": "83172"
    },
    {
      "vendor_exportdatetime": "2019-07-13",
      "vendor_group_number": 2519,
      "vendor_lot_code": "83173"
    },
    {
      "vendor_exportdatetime": "2019-07-12",
      "vendor_group_number": 2518,
      "vendor_lot_code": "83170"
    },
    {
      "vendor_exportdatetime": "2019-07-12",
      "vendor_group_number": 2518,
      "vendor_lot_code": "83171"
    },
    {
      "vendor_exportdatetime": "2019-07-12",
      "vendor_group_number": 2518,
      "vendor_lot_code": "83173"
    },
    {
      "vendor_exportdatetime": "2019-07-12",
      "vendor_group_number": 2518,
      "vendor_lot_code": "83175"
    },
    {
      "vendor_exportdatetime": "2019-07-12",
      "vendor_group_number": 2518,
      "vendor_lot_code": "83176"
    },
    {
      "vendor_exportdatetime": "2019-07-12",
      "vendor_group_number": 2518,
      "vendor_lot_code": "83177"
    },
    {
      "vendor_exportdatetime": "2019-07-11",
      "vendor_group_number": 2516,
      "vendor_lot_code": "83170"
    },
    {
      "vendor_exportdatetime": "2019-07-11",
      "vendor_group_number": 2516,
      "vendor_lot_code": "83171"
    },
    {
      "vendor_exportdatetime": "2019-07-11",
      "vendor_group_number": 2516,
      "vendor_lot_code": "83173"
    },
    {
      "vendor_exportdatetime": "2019-07-11",
      "vendor_group_number": 2516,
      "vendor_lot_code": "83175"
    },
    {
      "vendor_exportdatetime": "2019-07-11",
      "vendor_group_number": 2516,
      "vendor_lot_code": "83176"
    },
    {
      "vendor_exportdatetime": "2019-07-11",
      "vendor_group_number": 2516,
      "vendor_lot_code": "83177"
    },
    {
      "vendor_exportdatetime": "2019-07-10",
      "vendor_group_number": 2514,
      "vendor_lot_code": "83173"
    },
    {
      "vendor_exportdatetime": "2019-07-10",
      "vendor_group_number": 2514,
      "vendor_lot_code": "83176"
    },
    {
      "vendor_exportdatetime": "2019-07-10",
      "vendor_group_number": 2515,
      "vendor_lot_code": "11720"
    },
    {
      "vendor_exportdatetime": "2019-07-09",
      "vendor_group_number": 2511,
      "vendor_lot_code": "83171"
    },
    {
      "vendor_exportdatetime": "2019-07-09",
      "vendor_group_number": 2511,
      "vendor_lot_code": "83173"
    },
    {
      "vendor_exportdatetime": "2019-07-09",
      "vendor_group_number": 2511,
      "vendor_lot_code": "83175"
    },
    {
      "vendor_exportdatetime": "2019-07-09",
      "vendor_group_number": 2512,
      "vendor_lot_code": "11719"
    },
    {
      "vendor_exportdatetime": "2019-07-08",
      "vendor_group_number": 2509,
      "vendor_lot_code": "83170"
    },
    {
      "vendor_exportdatetime": "2019-07-08",
      "vendor_group_number": 2509,
      "vendor_lot_code": "83171"
    },
    {
      "vendor_exportdatetime": "2019-07-08",
      "vendor_group_number": 2509,
      "vendor_lot_code": "83173"
    },
    {
      "vendor_exportdatetime": "2019-07-06",
      "vendor_group_number": 2507,
      "vendor_lot_code": "83170"
    },
    {
      "vendor_exportdatetime": "2019-07-06",
      "vendor_group_number": 2507,
      "vendor_lot_code": "83171"
    },
    {
      "vendor_exportdatetime": "2019-07-06",
      "vendor_group_number": 2507,
      "vendor_lot_code": "83173"
    },
    {
      "vendor_exportdatetime": "2019-07-05",
      "vendor_group_number": 2504,
      "vendor_lot_code": "83170"
    },
    {
      "vendor_exportdatetime": "2019-07-05",
      "vendor_group_number": 2504,
      "vendor_lot_code": "83171"
    },
    {
      "vendor_exportdatetime": "2019-07-04",
      "vendor_group_number": 2502,
      "vendor_lot_code": "11719"
    },
    {
      "vendor_exportdatetime": "2019-06-26",
      "vendor_group_number": 2483,
      "vendor_lot_code": "11718"
    },
    {
      "vendor_exportdatetime": "2019-06-20",
      "vendor_group_number": 2466,
      "vendor_lot_code": "11718"
    },
    {
      "vendor_exportdatetime": "2019-06-10",
      "vendor_group_number": 2443,
      "vendor_lot_code": "11714"
    },
    {
      "vendor_exportdatetime": "2019-06-07",
      "vendor_group_number": 2440,
      "vendor_lot_code": "11713"
    },
    {
      "vendor_exportdatetime": "2019-06-07",
      "vendor_group_number": 2440,
      "vendor_lot_code": "11714"
    },
    {
      "vendor_exportdatetime": "2019-06-03",
      "vendor_group_number": 2434,
      "vendor_lot_code": "83121"
    },
    {
      "vendor_exportdatetime": "2019-05-31",
      "vendor_group_number": 2430,
      "vendor_lot_code": "83116"
    },
    {
      "vendor_exportdatetime": "2019-05-31",
      "vendor_group_number": 2430,
      "vendor_lot_code": "83118"
    },
    {
      "vendor_exportdatetime": "2019-05-31",
      "vendor_group_number": 2432,
      "vendor_lot_code": "83109"
    },
    {
      "vendor_exportdatetime": "2019-05-31",
      "vendor_group_number": 2432,
      "vendor_lot_code": "83113"
    },
    {
      "vendor_exportdatetime": "2019-05-31",
      "vendor_group_number": 2432,
      "vendor_lot_code": "83120"
    },
    {
      "vendor_exportdatetime": "2019-05-31",
      "vendor_group_number": 2433,
      "vendor_lot_code": "83114"
    },
    {
      "vendor_exportdatetime": "2019-05-31",
      "vendor_group_number": 2433,
      "vendor_lot_code": "83116"
    },
    {
      "vendor_exportdatetime": "2019-05-31",
      "vendor_group_number": 2433,
      "vendor_lot_code": "83120"
    },
    {
      "vendor_exportdatetime": "2019-05-30",
      "vendor_group_number": 2428,
      "vendor_lot_code": "83109"
    },
    {
      "vendor_exportdatetime": "2019-05-30",
      "vendor_group_number": 2428,
      "vendor_lot_code": "83110"
    },
    {
      "vendor_exportdatetime": "2019-05-30",
      "vendor_group_number": 2428,
      "vendor_lot_code": "83111"
    },
    {
      "vendor_exportdatetime": "2019-05-30",
      "vendor_group_number": 2428,
      "vendor_lot_code": "83113"
    },
    {
      "vendor_exportdatetime": "2019-05-30",
      "vendor_group_number": 2428,
      "vendor_lot_code": "83115"
    },
    {
      "vendor_exportdatetime": "2019-05-30",
      "vendor_group_number": 2428,
      "vendor_lot_code": "83116"
    },
    {
      "vendor_exportdatetime": "2019-05-30",
      "vendor_group_number": 2429,
      "vendor_lot_code": "83117"
    },
    {
      "vendor_exportdatetime": "2019-05-30",
      "vendor_group_number": 2429,
      "vendor_lot_code": "83118"
    },
    {
      "vendor_exportdatetime": "2019-05-30",
      "vendor_group_number": 2429,
      "vendor_lot_code": "83119"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2424,
      "vendor_lot_code": "83106"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2424,
      "vendor_lot_code": "83109"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2424,
      "vendor_lot_code": "83110"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2424,
      "vendor_lot_code": "83111"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2424,
      "vendor_lot_code": "83112"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2425,
      "vendor_lot_code": "11711"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2425,
      "vendor_lot_code": "11712"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2426,
      "vendor_lot_code": "83115"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2426,
      "vendor_lot_code": "83116"
    },
    {
      "vendor_exportdatetime": "2019-05-29",
      "vendor_group_number": 2426,
      "vendor_lot_code": "83117"
    },
    {
      "vendor_exportdatetime": "2019-05-28",
      "vendor_group_number": 2422,
      "vendor_lot_code": "83106"
    },
    {
      "vendor_exportdatetime": "2019-05-28",
      "vendor_group_number": 2422,
      "vendor_lot_code": "83107"
    },
    {
      "vendor_exportdatetime": "2019-05-28",
      "vendor_group_number": 2422,
      "vendor_lot_code": "83109"
    },
    {
      "vendor_exportdatetime": "2019-05-27",
      "vendor_group_number": 2419,
      "vendor_lot_code": "83105"
    },
    {
      "vendor_exportdatetime": "2019-05-27",
      "vendor_group_number": 2420,
      "vendor_lot_code": "83104"
    },
    {
      "vendor_exportdatetime": "2019-05-27",
      "vendor_group_number": 2420,
      "vendor_lot_code": "83109"
    },
    {
      "vendor_exportdatetime": "2019-05-27",
      "vendor_group_number": 2420,
      "vendor_lot_code": "83113"
    },
    {
      "vendor_exportdatetime": "2019-05-27",
      "vendor_group_number": 2420,
      "vendor_lot_code": "83115"
    },
    {
      "vendor_exportdatetime": "2019-05-25",
      "vendor_group_number": 2417,
      "vendor_lot_code": "83105"
    },
    {
      "vendor_exportdatetime": "2019-05-25",
      "vendor_group_number": 2417,
      "vendor_lot_code": "83106"
    },
    {
      "vendor_exportdatetime": "2019-05-25",
      "vendor_group_number": 2418,
      "vendor_lot_code": "83104"
    },
    {
      "vendor_exportdatetime": "2019-05-24",
      "vendor_group_number": 2415,
      "vendor_lot_code": "83106"
    },
    {
      "vendor_exportdatetime": "2019-05-24",
      "vendor_group_number": 2416,
      "vendor_lot_code": "83098"
    },
    {
      "vendor_exportdatetime": "2019-05-24",
      "vendor_group_number": 2416,
      "vendor_lot_code": "83101"
    },
    {
      "vendor_exportdatetime": "2019-05-24",
      "vendor_group_number": 2416,
      "vendor_lot_code": "83106"
    },
    {
      "vendor_exportdatetime": "2019-05-23",
      "vendor_group_number": 2412,
      "vendor_lot_code": "83102"
    },
    {
      "vendor_exportdatetime": "2019-05-23",
      "vendor_group_number": 2412,
      "vendor_lot_code": "83103"
    },
    {
      "vendor_exportdatetime": "2019-05-23",
      "vendor_group_number": 2413,
      "vendor_lot_code": "83105"
    },
    {
      "vendor_exportdatetime": "2019-05-23",
      "vendor_group_number": 2414,
      "vendor_lot_code": "83105"
    },
    {
      "vendor_exportdatetime": "2019-05-23",
      "vendor_group_number": 2414,
      "vendor_lot_code": "83110"
    },
    {
      "vendor_exportdatetime": "2019-05-22",
      "vendor_group_number": 2409,
      "vendor_lot_code": "83105"
    },
    {
      "vendor_exportdatetime": "2019-05-22",
      "vendor_group_number": 2410,
      "vendor_lot_code": "83102"
    },
    {
      "vendor_exportdatetime": "2019-05-22",
      "vendor_group_number": 2410,
      "vendor_lot_code": "83103"
    },
    {
      "vendor_exportdatetime": "2019-05-21",
      "vendor_group_number": 2406,
      "vendor_lot_code": "83100"
    },
    {
      "vendor_exportdatetime": "2019-05-21",
      "vendor_group_number": 2407,
      "vendor_lot_code": "83095"
    },
    {
      "vendor_exportdatetime": "2019-05-21",
      "vendor_group_number": 2407,
      "vendor_lot_code": "83096"
    },
    {
      "vendor_exportdatetime": "2019-05-21",
      "vendor_group_number": 2407,
      "vendor_lot_code": "83098"
    },
    {
      "vendor_exportdatetime": "2019-05-21",
      "vendor_group_number": 2407,
      "vendor_lot_code": "83100"
    },
    {
      "vendor_exportdatetime": "2019-05-21",
      "vendor_group_number": 2408,
      "vendor_lot_code": "83099"
    },
    {
      "vendor_exportdatetime": "2019-05-21",
      "vendor_group_number": 2408,
      "vendor_lot_code": "83101"
    },
    {
      "vendor_exportdatetime": "2019-05-21",
      "vendor_group_number": 2408,
      "vendor_lot_code": "83102"
    },
    {
      "vendor_exportdatetime": "2019-05-21",
      "vendor_group_number": 2408,
      "vendor_lot_code": "83103"
    },
    {
      "vendor_exportdatetime": "2019-05-07",
      "vendor_group_number": 2403,
      "vendor_lot_code": "83100"
    },
    {
      "vendor_exportdatetime": "2019-05-07",
      "vendor_group_number": 2404,
      "vendor_lot_code": "83103"
    },
    {
      "vendor_exportdatetime": "2019-05-07",
      "vendor_group_number": 2405,
      "vendor_lot_code": "83098"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2398,
      "vendor_lot_code": "83095"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2398,
      "vendor_lot_code": "83096"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2398,
      "vendor_lot_code": "83098"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2398,
      "vendor_lot_code": "83099"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2400,
      "vendor_lot_code": "83094"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2400,
      "vendor_lot_code": "83096"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2400,
      "vendor_lot_code": "83097"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2400,
      "vendor_lot_code": "83098"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2400,
      "vendor_lot_code": "83101"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2400,
      "vendor_lot_code": "83102"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2401,
      "vendor_lot_code": "83103"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2401,
      "vendor_lot_code": "83108"
    },
    {
      "vendor_exportdatetime": "2019-05-04",
      "vendor_group_number": 2401,
      "vendor_lot_code": "83116"
    },
    {
      "vendor_exportdatetime": "2019-05-03",
      "vendor_group_number": 2396,
      "vendor_lot_code": "83094"
    },
    {
      "vendor_exportdatetime": "2019-05-03",
      "vendor_group_number": 2396,
      "vendor_lot_code": "83095"
    },
    {
      "vendor_exportdatetime": "2019-05-03",
      "vendor_group_number": 2396,
      "vendor_lot_code": "83096"
    },
    {
      "vendor_exportdatetime": "2019-05-03",
      "vendor_group_number": 2396,
      "vendor_lot_code": "83100"
    },
    {
      "vendor_exportdatetime": "2019-05-02",
      "vendor_group_number": 2392,
      "vendor_lot_code": "83094"
    },
    {
      "vendor_exportdatetime": "2019-05-02",
      "vendor_group_number": 2393,
      "vendor_lot_code": "83096"
    },
    {
      "vendor_exportdatetime": "2019-05-02",
      "vendor_group_number": 2393,
      "vendor_lot_code": "83097"
    },
    {
      "vendor_exportdatetime": "2019-05-02",
      "vendor_group_number": 2393,
      "vendor_lot_code": "83098"
    },
    {
      "vendor_exportdatetime": "2019-05-02",
      "vendor_group_number": 2393,
      "vendor_lot_code": "83099"
    },
    {
      "vendor_exportdatetime": "2019-05-02",
      "vendor_group_number": 2393,
      "vendor_lot_code": "83106"
    },
    {
      "vendor_exportdatetime": "2019-05-02",
      "vendor_group_number": 2393,
      "vendor_lot_code": "83109"
    },
    {
      "vendor_exportdatetime": "2019-04-30",
      "vendor_group_number": 2388,
      "vendor_lot_code": "83093"
    },
    {
      "vendor_exportdatetime": "2019-04-30",
      "vendor_group_number": 2389,
      "vendor_lot_code": "83091"
    },
    {
      "vendor_exportdatetime": "2019-04-30",
      "vendor_group_number": 2389,
      "vendor_lot_code": "83092"
    },
    {
      "vendor_exportdatetime": "2019-04-30",
      "vendor_group_number": 2390,
      "vendor_lot_code": "11710"
    },
    {
      "vendor_exportdatetime": "2019-04-27",
      "vendor_group_number": 2385,
      "vendor_lot_code": "83087"
    },
    {
      "vendor_exportdatetime": "2019-04-27",
      "vendor_group_number": 2386,
      "vendor_lot_code": "83089"
    },
    {
      "vendor_exportdatetime": "2019-04-27",
      "vendor_group_number": 2386,
      "vendor_lot_code": "83091"
    },
    {
      "vendor_exportdatetime": "2019-04-27",
      "vendor_group_number": 2386,
      "vendor_lot_code": "83092"
    },
    {
      "vendor_exportdatetime": "2019-04-27",
      "vendor_group_number": 2387,
      "vendor_lot_code": "83093"
    },
    {
      "vendor_exportdatetime": "2019-04-26",
      "vendor_group_number": 2382,
      "vendor_lot_code": "83087"
    },
    {
      "vendor_exportdatetime": "2019-04-26",
      "vendor_group_number": 2383,
      "vendor_lot_code": "83088"
    },
    {
      "vendor_exportdatetime": "2019-04-26",
      "vendor_group_number": 2383,
      "vendor_lot_code": "83089"
    },
    {
      "vendor_exportdatetime": "2019-04-26",
      "vendor_group_number": 2383,
      "vendor_lot_code": "83090"
    },
    {
      "vendor_exportdatetime": "2019-04-26",
      "vendor_group_number": 2384,
      "vendor_lot_code": "83092"
    },
    {
      "vendor_exportdatetime": "2019-04-25",
      "vendor_group_number": 2380,
      "vendor_lot_code": "83087"
    },
    {
      "vendor_exportdatetime": "2019-04-25",
      "vendor_group_number": 2381,
      "vendor_lot_code": "83089"
    },
    {
      "vendor_exportdatetime": "2019-04-25",
      "vendor_group_number": 2381,
      "vendor_lot_code": "83090"
    },
    {
      "vendor_exportdatetime": "2019-04-24",
      "vendor_group_number": 2377,
      "vendor_lot_code": "83087"
    },
    {
      "vendor_exportdatetime": "2019-04-24",
      "vendor_group_number": 2378,
      "vendor_lot_code": "83079"
    },
    {
      "vendor_exportdatetime": "2019-04-24",
      "vendor_group_number": 2378,
      "vendor_lot_code": "83083"
    },
    {
      "vendor_exportdatetime": "2019-04-24",
      "vendor_group_number": 2378,
      "vendor_lot_code": "83085"
    },
    {
      "vendor_exportdatetime": "2019-04-24",
      "vendor_group_number": 2379,
      "vendor_lot_code": "83088"
    },
    {
      "vendor_exportdatetime": "2019-04-22",
      "vendor_group_number": 2376,
      "vendor_lot_code": "11702"
    },
    {
      "vendor_exportdatetime": "2019-04-22",
      "vendor_group_number": 2376,
      "vendor_lot_code": "11707"
    },
    {
      "vendor_exportdatetime": "2019-04-22",
      "vendor_group_number": 2376,
      "vendor_lot_code": "11709"
    },
    {
      "vendor_exportdatetime": "2019-04-22",
      "vendor_group_number": 2376,
      "vendor_lot_code": "11710"
    },
    {
      "vendor_exportdatetime": "2019-04-20",
      "vendor_group_number": 2373,
      "vendor_lot_code": "83084"
    },
    {
      "vendor_exportdatetime": "2019-04-20",
      "vendor_group_number": 2375,
      "vendor_lot_code": "83088"
    },
    {
      "vendor_exportdatetime": "2019-04-20",
      "vendor_group_number": 2375,
      "vendor_lot_code": "83089"
    },
    {
      "vendor_exportdatetime": "2019-04-19",
      "vendor_group_number": 2368,
      "vendor_lot_code": "83074"
    },
    {
      "vendor_exportdatetime": "2019-04-19",
      "vendor_group_number": 2369,
      "vendor_lot_code": "83087"
    },
    {
      "vendor_exportdatetime": "2019-04-19",
      "vendor_group_number": 2370,
      "vendor_lot_code": "83081"
    },
    {
      "vendor_exportdatetime": "2019-04-19",
      "vendor_group_number": 2370,
      "vendor_lot_code": "83082"
    },
    {
      "vendor_exportdatetime": "2019-04-19",
      "vendor_group_number": 2370,
      "vendor_lot_code": "83084"
    },
    {
      "vendor_exportdatetime": "2019-04-19",
      "vendor_group_number": 2370,
      "vendor_lot_code": "83085"
    },
    {
      "vendor_exportdatetime": "2019-04-18",
      "vendor_group_number": 2365,
      "vendor_lot_code": "83077"
    },
    {
      "vendor_exportdatetime": "2019-04-18",
      "vendor_group_number": 2366,
      "vendor_lot_code": "83080"
    },
    {
      "vendor_exportdatetime": "2019-04-18",
      "vendor_group_number": 2367,
      "vendor_lot_code": "83079"
    },
    {
      "vendor_exportdatetime": "2019-04-17",
      "vendor_group_number": 2363,
      "vendor_lot_code": "83071"
    },
    {
      "vendor_exportdatetime": "2019-04-17",
      "vendor_group_number": 2363,
      "vendor_lot_code": "83075"
    },
    {
      "vendor_exportdatetime": "2019-04-16",
      "vendor_group_number": 2358,
      "vendor_lot_code": "83065"
    },
    {
      "vendor_exportdatetime": "2019-04-16",
      "vendor_group_number": 2359,
      "vendor_lot_code": "83066"
    },
    {
      "vendor_exportdatetime": "2019-04-16",
      "vendor_group_number": 2359,
      "vendor_lot_code": "83072"
    },
    {
      "vendor_exportdatetime": "2019-04-16",
      "vendor_group_number": 2359,
      "vendor_lot_code": "83073"
    },
    {
      "vendor_exportdatetime": "2019-04-16",
      "vendor_group_number": 2359,
      "vendor_lot_code": "83075"
    },
    {
      "vendor_exportdatetime": "2019-04-16",
      "vendor_group_number": 2359,
      "vendor_lot_code": "83077"
    },
    {
      "vendor_exportdatetime": "2019-04-16",
      "vendor_group_number": 2359,
      "vendor_lot_code": "83079"
    },
    {
      "vendor_exportdatetime": "2019-04-16",
      "vendor_group_number": 2361,
      "vendor_lot_code": "83065"
    },
    {
      "vendor_exportdatetime": "2019-04-12",
      "vendor_group_number": 2355,
      "vendor_lot_code": "83066"
    },
    {
      "vendor_exportdatetime": "2019-04-12",
      "vendor_group_number": 2355,
      "vendor_lot_code": "83072"
    },
    {
      "vendor_exportdatetime": "2019-04-12",
      "vendor_group_number": 2355,
      "vendor_lot_code": "83073"
    },
    {
      "vendor_exportdatetime": "2019-04-11",
      "vendor_group_number": 2351,
      "vendor_lot_code": "83065"
    },
    {
      "vendor_exportdatetime": "2019-04-11",
      "vendor_group_number": 2351,
      "vendor_lot_code": "83069"
    },
    {
      "vendor_exportdatetime": "2019-04-09",
      "vendor_group_number": 2343,
      "vendor_lot_code": "83061"
    },
    {
      "vendor_exportdatetime": "2019-04-09",
      "vendor_group_number": 2344,
      "vendor_lot_code": "83055"
    },
    {
      "vendor_exportdatetime": "2019-04-09",
      "vendor_group_number": 2344,
      "vendor_lot_code": "83058"
    },
    {
      "vendor_exportdatetime": "2019-04-09",
      "vendor_group_number": 2346,
      "vendor_lot_code": "83064"
    },
    {
      "vendor_exportdatetime": "2019-04-09",
      "vendor_group_number": 2346,
      "vendor_lot_code": "83065"
    },
    {
      "vendor_exportdatetime": "2019-04-08",
      "vendor_group_number": 2338,
      "vendor_lot_code": "83059"
    },
    {
      "vendor_exportdatetime": "2019-04-08",
      "vendor_group_number": 2339,
      "vendor_lot_code": "83061"
    },
    {
      "vendor_exportdatetime": "2019-04-08",
      "vendor_group_number": 2342,
      "vendor_lot_code": "83066"
    },
    {
      "vendor_exportdatetime": "2019-04-05",
      "vendor_group_number": 2335,
      "vendor_lot_code": "83058"
    },
    {
      "vendor_exportdatetime": "2019-04-05",
      "vendor_group_number": 2335,
      "vendor_lot_code": "83059"
    },
    {
      "vendor_exportdatetime": "2019-04-05",
      "vendor_group_number": 2335,
      "vendor_lot_code": "83060"
    },
    {
      "vendor_exportdatetime": "2019-04-04",
      "vendor_group_number": 2331,
      "vendor_lot_code": "83059"
    },
    {
      "vendor_exportdatetime": "2019-04-04",
      "vendor_group_number": 2333,
      "vendor_lot_code": "83056"
    },
    {
      "vendor_exportdatetime": "2019-04-03",
      "vendor_group_number": 2330,
      "vendor_lot_code": "83054"
    },
    {
      "vendor_exportdatetime": "2019-04-02",
      "vendor_group_number": 2326,
      "vendor_lot_code": "83054"
    },
    {
      "vendor_exportdatetime": "2019-04-02",
      "vendor_group_number": 2326,
      "vendor_lot_code": "83055"
    },
    {
      "vendor_exportdatetime": "2019-04-02",
      "vendor_group_number": 2328,
      "vendor_lot_code": "83057"
    },
    {
      "vendor_exportdatetime": "2019-04-02",
      "vendor_group_number": 2328,
      "vendor_lot_code": "83059"
    },
    {
      "vendor_exportdatetime": "2019-03-28",
      "vendor_group_number": 2322,
      "vendor_lot_code": "83053"
    },
    {
      "vendor_exportdatetime": "2019-03-26",
      "vendor_group_number": 2319,
      "vendor_lot_code": "83049"
    },
    {
      "vendor_exportdatetime": "2019-03-26",
      "vendor_group_number": 2319,
      "vendor_lot_code": "83052"
    },
    {
      "vendor_exportdatetime": "2019-03-25",
      "vendor_group_number": 2317,
      "vendor_lot_code": "83043"
    },
    {
      "vendor_exportdatetime": "2019-03-25",
      "vendor_group_number": 2317,
      "vendor_lot_code": "83046"
    },
    {
      "vendor_exportdatetime": "2019-03-23",
      "vendor_group_number": 2313,
      "vendor_lot_code": "83036"
    },
    {
      "vendor_exportdatetime": "2019-03-19",
      "vendor_group_number": 2307,
      "vendor_lot_code": "83039"
    },
    {
      "vendor_exportdatetime": "2019-03-19",
      "vendor_group_number": 2308,
      "vendor_lot_code": "83042"
    },
    {
      "vendor_exportdatetime": "2019-03-18",
      "vendor_group_number": 2305,
      "vendor_lot_code": "83037"
    },
    {
      "vendor_exportdatetime": "2019-03-15",
      "vendor_group_number": 2300,
      "vendor_lot_code": "83027"
    },
    {
      "vendor_exportdatetime": "2019-03-15",
      "vendor_group_number": 2300,
      "vendor_lot_code": "83028"
    },
    {
      "vendor_exportdatetime": "2019-03-15",
      "vendor_group_number": 2300,
      "vendor_lot_code": "83029"
    },
    {
      "vendor_exportdatetime": "2019-03-15",
      "vendor_group_number": 2300,
      "vendor_lot_code": "83031"
    },
    {
      "vendor_exportdatetime": "2019-03-15",
      "vendor_group_number": 2303,
      "vendor_lot_code": "83032"
    },
    {
      "vendor_exportdatetime": "2019-03-14",
      "vendor_group_number": 2297,
      "vendor_lot_code": "83029"
    },
    {
      "vendor_exportdatetime": "2019-03-14",
      "vendor_group_number": 2297,
      "vendor_lot_code": "83031"
    },
    {
      "vendor_exportdatetime": "2019-03-13",
      "vendor_group_number": 2294,
      "vendor_lot_code": "83029"
    },
    {
      "vendor_exportdatetime": "2019-03-11",
      "vendor_group_number": 2286,
      "vendor_lot_code": "83016"
    },
    {
      "vendor_exportdatetime": "2019-03-11",
      "vendor_group_number": 2287,
      "vendor_lot_code": "83028"
    },
    {
      "vendor_exportdatetime": "2019-03-11",
      "vendor_group_number": 2287,
      "vendor_lot_code": "83031"
    },
    {
      "vendor_exportdatetime": "2019-03-09",
      "vendor_group_number": 2283,
      "vendor_lot_code": "83021"
    },
    {
      "vendor_exportdatetime": "2019-03-08",
      "vendor_group_number": 2279,
      "vendor_lot_code": "83021"
    },
    {
      "vendor_exportdatetime": "2019-03-08",
      "vendor_group_number": 2280,
      "vendor_lot_code": "83017"
    },
    {
      "vendor_exportdatetime": "2019-03-08",
      "vendor_group_number": 2280,
      "vendor_lot_code": "83027"
    },
    {
      "vendor_exportdatetime": "2019-03-08",
      "vendor_group_number": 2281,
      "vendor_lot_code": "83033"
    },
    {
      "vendor_exportdatetime": "2019-03-08",
      "vendor_group_number": 2282,
      "vendor_lot_code": "11698"
    },
    {
      "vendor_exportdatetime": "2019-03-07",
      "vendor_group_number": 2277,
      "vendor_lot_code": "83021"
    },
    {
      "vendor_exportdatetime": "2019-03-06",
      "vendor_group_number": 2274,
      "vendor_lot_code": "83020"
    },
    {
      "vendor_exportdatetime": "2019-03-05",
      "vendor_group_number": 2271,
      "vendor_lot_code": "83018"
    },
    {
      "vendor_exportdatetime": "2019-03-05",
      "vendor_group_number": 2271,
      "vendor_lot_code": "83021"
    },
    {
      "vendor_exportdatetime": "2019-03-05",
      "vendor_group_number": 2272,
      "vendor_lot_code": "83016"
    },
    {
      "vendor_exportdatetime": "2019-03-05",
      "vendor_group_number": 2272,
      "vendor_lot_code": "83020"
    },
    {
      "vendor_exportdatetime": "2019-03-04",
      "vendor_group_number": 2269,
      "vendor_lot_code": "83018"
    },
    {
      "vendor_exportdatetime": "2019-03-04",
      "vendor_group_number": 2270,
      "vendor_lot_code": "83016"
    },
    {
      "vendor_exportdatetime": "2019-03-01",
      "vendor_group_number": 2268,
      "vendor_lot_code": "11692"
    },
    {
      "vendor_exportdatetime": "2019-03-01",
      "vendor_group_number": 2268,
      "vendor_lot_code": "11694"
    },
    {
      "vendor_exportdatetime": "2019-02-28",
      "vendor_group_number": 2263,
      "vendor_lot_code": "83014"
    },
    {
      "vendor_exportdatetime": "2019-02-28",
      "vendor_group_number": 2264,
      "vendor_lot_code": "83012"
    },
    {
      "vendor_exportdatetime": "2019-02-27",
      "vendor_group_number": 2261,
      "vendor_lot_code": "83007"
    },
    {
      "vendor_exportdatetime": "2019-02-27",
      "vendor_group_number": 2261,
      "vendor_lot_code": "83010"
    },
    {
      "vendor_exportdatetime": "2019-02-26",
      "vendor_group_number": 2255,
      "vendor_lot_code": "83002"
    },
    {
      "vendor_exportdatetime": "2019-02-26",
      "vendor_group_number": 2255,
      "vendor_lot_code": "83004"
    },
    {
      "vendor_exportdatetime": "2019-02-26",
      "vendor_group_number": 2255,
      "vendor_lot_code": "83007"
    },
    {
      "vendor_exportdatetime": "2019-02-26",
      "vendor_group_number": 2256,
      "vendor_lot_code": "83014"
    },
    {
      "vendor_exportdatetime": "2019-02-26",
      "vendor_group_number": 2257,
      "vendor_lot_code": "83009"
    },
    {
      "vendor_exportdatetime": "2019-02-25",
      "vendor_group_number": 2251,
      "vendor_lot_code": "83001"
    },
    {
      "vendor_exportdatetime": "2019-02-25",
      "vendor_group_number": 2251,
      "vendor_lot_code": "83007"
    },
    {
      "vendor_exportdatetime": "2019-02-25",
      "vendor_group_number": 2253,
      "vendor_lot_code": "83006"
    },
    {
      "vendor_exportdatetime": "2019-02-25",
      "vendor_group_number": 2253,
      "vendor_lot_code": "83008"
    },
    {
      "vendor_exportdatetime": "2019-02-25",
      "vendor_group_number": 2253,
      "vendor_lot_code": "83009"
    },
    {
      "vendor_exportdatetime": "2019-02-22",
      "vendor_group_number": 2249,
      "vendor_lot_code": "83006"
    },
    {
      "vendor_exportdatetime": "2019-02-21",
      "vendor_group_number": 2246,
      "vendor_lot_code": "82993"
    },
    {
      "vendor_exportdatetime": "2019-02-21",
      "vendor_group_number": 2246,
      "vendor_lot_code": "82998"
    },
    {
      "vendor_exportdatetime": "2019-02-20",
      "vendor_group_number": 2243,
      "vendor_lot_code": "82997"
    },
    {
      "vendor_exportdatetime": "2019-02-20",
      "vendor_group_number": 2243,
      "vendor_lot_code": "82998"
    },
    {
      "vendor_exportdatetime": "2019-02-20",
      "vendor_group_number": 2245,
      "vendor_lot_code": "83000"
    },
    {
      "vendor_exportdatetime": "2019-02-18",
      "vendor_group_number": 2239,
      "vendor_lot_code": "82995"
    },
    {
      "vendor_exportdatetime": "2019-02-16",
      "vendor_group_number": 2237,
      "vendor_lot_code": "82988"
    },
    {
      "vendor_exportdatetime": "2019-02-15",
      "vendor_group_number": 2234,
      "vendor_lot_code": "82992"
    },
    {
      "vendor_exportdatetime": "2019-02-12",
      "vendor_group_number": 2228,
      "vendor_lot_code": "82986"
    },
    {
      "vendor_exportdatetime": "2019-02-12",
      "vendor_group_number": 2229,
      "vendor_lot_code": "82989"
    },
    {
      "vendor_exportdatetime": "2019-02-11",
      "vendor_group_number": 2226,
      "vendor_lot_code": "82986"
    },
    {
      "vendor_exportdatetime": "2019-02-11",
      "vendor_group_number": 2227,
      "vendor_lot_code": "82985"
    },
    {
      "vendor_exportdatetime": "2019-02-11",
      "vendor_group_number": 2227,
      "vendor_lot_code": "82988"
    },
    {
      "vendor_exportdatetime": "2019-02-09",
      "vendor_group_number": 2224,
      "vendor_lot_code": "82986"
    },
    {
      "vendor_exportdatetime": "2019-02-09",
      "vendor_group_number": 2225,
      "vendor_lot_code": "82983"
    },
    {
      "vendor_exportdatetime": "2019-02-09",
      "vendor_group_number": 2225,
      "vendor_lot_code": "82984"
    },
    {
      "vendor_exportdatetime": "2019-02-09",
      "vendor_group_number": 2225,
      "vendor_lot_code": "82988"
    },
    {
      "vendor_exportdatetime": "2019-02-08",
      "vendor_group_number": 2220,
      "vendor_lot_code": "82984"
    },
    {
      "vendor_exportdatetime": "2019-02-08",
      "vendor_group_number": 2221,
      "vendor_lot_code": "11688"
    },
    {
      "vendor_exportdatetime": "2019-02-08",
      "vendor_group_number": 2223,
      "vendor_lot_code": "82988"
    },
    {
      "vendor_exportdatetime": "2019-02-07",
      "vendor_group_number": 2219,
      "vendor_lot_code": "82978"
    },
    {
      "vendor_exportdatetime": "2019-02-07",
      "vendor_group_number": 2219,
      "vendor_lot_code": "82984"
    },
    {
      "vendor_exportdatetime": "2019-02-07",
      "vendor_group_number": 2219,
      "vendor_lot_code": "82985"
    },
    {
      "vendor_exportdatetime": "2019-02-06",
      "vendor_group_number": 2217,
      "vendor_lot_code": "82978"
    },
    {
      "vendor_exportdatetime": "2019-02-06",
      "vendor_group_number": 2217,
      "vendor_lot_code": "82979"
    },
    {
      "vendor_exportdatetime": "2019-02-05",
      "vendor_group_number": 2215,
      "vendor_lot_code": "82982"
    },
    {
      "vendor_exportdatetime": "2019-02-04",
      "vendor_group_number": 2213,
      "vendor_lot_code": "82978"
    },
    {
      "vendor_exportdatetime": "2019-01-31",
      "vendor_group_number": 2208,
      "vendor_lot_code": "82973"
    },
    {
      "vendor_exportdatetime": "2019-01-31",
      "vendor_group_number": 2209,
      "vendor_lot_code": "82975"
    },
    {
      "vendor_exportdatetime": "2019-01-30",
      "vendor_group_number": 2203,
      "vendor_lot_code": "82963"
    },
    {
      "vendor_exportdatetime": "2019-01-30",
      "vendor_group_number": 2203,
      "vendor_lot_code": "82968"
    },
    {
      "vendor_exportdatetime": "2019-01-30",
      "vendor_group_number": 2205,
      "vendor_lot_code": "82976"
    },
    {
      "vendor_exportdatetime": "2019-01-28",
      "vendor_group_number": 2196,
      "vendor_lot_code": "82963"
    },
    {
      "vendor_exportdatetime": "2019-01-28",
      "vendor_group_number": 2198,
      "vendor_lot_code": "82971"
    },
    {
      "vendor_exportdatetime": "2019-01-28",
      "vendor_group_number": 2199,
      "vendor_lot_code": "82968"
    },
    {
      "vendor_exportdatetime": "2019-01-25",
      "vendor_group_number": 2188,
      "vendor_lot_code": "82967"
    },
    {
      "vendor_exportdatetime": "2019-01-25",
      "vendor_group_number": 2190,
      "vendor_lot_code": "82968"
    },
    {
      "vendor_exportdatetime": "2019-01-24",
      "vendor_group_number": 2186,
      "vendor_lot_code": "82962"
    },
    {
      "vendor_exportdatetime": "2019-01-23",
      "vendor_group_number": 2183,
      "vendor_lot_code": "82965"
    },
    {
      "vendor_exportdatetime": "2019-01-21",
      "vendor_group_number": 2178,
      "vendor_lot_code": "82953"
    },
    {
      "vendor_exportdatetime": "2019-01-19",
      "vendor_group_number": 2176,
      "vendor_lot_code": "82954"
    },
    {
      "vendor_exportdatetime": "2019-01-19",
      "vendor_group_number": 2176,
      "vendor_lot_code": "82961"
    },
    {
      "vendor_exportdatetime": "2019-01-18",
      "vendor_group_number": 2173,
      "vendor_lot_code": "82958"
    },
    {
      "vendor_exportdatetime": "2019-01-17",
      "vendor_group_number": 2170,
      "vendor_lot_code": "82960"
    },
    {
      "vendor_exportdatetime": "2019-01-16",
      "vendor_group_number": 2169,
      "vendor_lot_code": "11686"
    },
    {
      "vendor_exportdatetime": "2019-01-15",
      "vendor_group_number": 2166,
      "vendor_lot_code": "82953"
    },
    {
      "vendor_exportdatetime": "2019-01-12",
      "vendor_group_number": 2164,
      "vendor_lot_code": "82954"
    },
    {
      "vendor_exportdatetime": "2019-01-11",
      "vendor_group_number": 2161,
      "vendor_lot_code": "82953"
    },
    {
      "vendor_exportdatetime": "2019-01-10",
      "vendor_group_number": 2157,
      "vendor_lot_code": "82946"
    },
    {
      "vendor_exportdatetime": "2019-01-10",
      "vendor_group_number": 2157,
      "vendor_lot_code": "82953"
    },
    {
      "vendor_exportdatetime": "2019-01-09",
      "vendor_group_number": 2154,
      "vendor_lot_code": "82954"
    },
    {
      "vendor_exportdatetime": "2019-01-01",
      "vendor_group_number": 2143,
      "vendor_lot_code": "82944"
    },
    {
      "vendor_exportdatetime": "2018-12-31",
      "vendor_group_number": 2137,
      "vendor_lot_code": "82939"
    },
    {
      "vendor_exportdatetime": "2018-12-31",
      "vendor_group_number": 2140,
      "vendor_lot_code": "82940"
    },
    {
      "vendor_exportdatetime": "2018-12-29",
      "vendor_group_number": 2136,
      "vendor_lot_code": "82940"
    },
    {
      "vendor_exportdatetime": "2018-12-28",
      "vendor_group_number": 2130,
      "vendor_lot_code": "82933"
    },
    {
      "vendor_exportdatetime": "2018-12-28",
      "vendor_group_number": 2132,
      "vendor_lot_code": "82935"
    },
    {
      "vendor_exportdatetime": "2018-12-28",
      "vendor_group_number": 2133,
      "vendor_lot_code": "82939"
    },
    {
      "vendor_exportdatetime": "2018-12-25",
      "vendor_group_number": 2125,
      "vendor_lot_code": "82931"
    },
    {
      "vendor_exportdatetime": "2018-12-22",
      "vendor_group_number": 2121,
      "vendor_lot_code": "82931"
    },
    {
      "vendor_exportdatetime": "2018-12-20",
      "vendor_group_number": 2116,
      "vendor_lot_code": "82927"
    },
    {
      "vendor_exportdatetime": "2018-12-19",
      "vendor_group_number": 2112,
      "vendor_lot_code": "82922"
    },
    {
      "vendor_exportdatetime": "2018-12-19",
      "vendor_group_number": 2114,
      "vendor_lot_code": "82918"
    },
    {
      "vendor_exportdatetime": "2018-12-19",
      "vendor_group_number": 2114,
      "vendor_lot_code": "82927"
    },
    {
      "vendor_exportdatetime": "2018-12-18",
      "vendor_group_number": 2108,
      "vendor_lot_code": "82922"
    },
    {
      "vendor_exportdatetime": "2018-12-18",
      "vendor_group_number": 2110,
      "vendor_lot_code": "82924"
    },
    {
      "vendor_exportdatetime": "2018-12-17",
      "vendor_group_number": 2105,
      "vendor_lot_code": "82920"
    },
    {
      "vendor_exportdatetime": "2018-12-14",
      "vendor_group_number": 2102,
      "vendor_lot_code": "82921"
    },
    {
      "vendor_exportdatetime": "2018-12-12",
      "vendor_group_number": 2098,
      "vendor_lot_code": "82911"
    },
    {
      "vendor_exportdatetime": "2018-12-11",
      "vendor_group_number": 2095,
      "vendor_lot_code": "82913"
    },
    {
      "vendor_exportdatetime": "2018-12-10",
      "vendor_group_number": 2094,
      "vendor_lot_code": "82915"
    },
    {
      "vendor_exportdatetime": "2018-12-08",
      "vendor_group_number": 2091,
      "vendor_lot_code": "82907"
    },
    {
      "vendor_exportdatetime": "2018-12-08",
      "vendor_group_number": 2091,
      "vendor_lot_code": "82908"
    },
    {
      "vendor_exportdatetime": "2018-12-05",
      "vendor_group_number": 2083,
      "vendor_lot_code": "82908"
    },
    {
      "vendor_exportdatetime": "2018-12-04",
      "vendor_group_number": 2079,
      "vendor_lot_code": "82902"
    },
    {
      "vendor_exportdatetime": "2018-12-04",
      "vendor_group_number": 2080,
      "vendor_lot_code": "82908"
    },
    {
      "vendor_exportdatetime": "2018-12-04",
      "vendor_group_number": 2081,
      "vendor_lot_code": "82910"
    },
    {
      "vendor_exportdatetime": "2018-11-30",
      "vendor_group_number": 2070,
      "vendor_lot_code": "82899"
    },
    {
      "vendor_exportdatetime": "2018-10-30",
      "vendor_group_number": 2060,
      "vendor_lot_code": "82895"
    },
    {
      "vendor_exportdatetime": "2018-10-30",
      "vendor_group_number": 2062,
      "vendor_lot_code": "82904"
    },
    {
      "vendor_exportdatetime": "2018-10-29",
      "vendor_group_number": 2059,
      "vendor_lot_code": "82892"
    },
    {
      "vendor_exportdatetime": "2018-10-27",
      "vendor_group_number": 2057,
      "vendor_lot_code": "82892"
    },
    {
      "vendor_exportdatetime": "2018-10-25",
      "vendor_group_number": 2050,
      "vendor_lot_code": "82892"
    },
    {
      "vendor_exportdatetime": "2018-10-24",
      "vendor_group_number": 2048,
      "vendor_lot_code": "82887"
    },
    {
      "vendor_exportdatetime": "2018-10-23",
      "vendor_group_number": 2043,
      "vendor_lot_code": "82883"
    },
    {
      "vendor_exportdatetime": "2018-10-23",
      "vendor_group_number": 2044,
      "vendor_lot_code": "82885"
    },
    {
      "vendor_exportdatetime": "2018-10-22",
      "vendor_group_number": 2040,
      "vendor_lot_code": "82880"
    },
    {
      "vendor_exportdatetime": "2018-10-22",
      "vendor_group_number": 2040,
      "vendor_lot_code": "82883"
    },
    {
      "vendor_exportdatetime": "2018-10-20",
      "vendor_group_number": 2037,
      "vendor_lot_code": "82880"
    },
    {
      "vendor_exportdatetime": "2018-10-18",
      "vendor_group_number": 2032,
      "vendor_lot_code": "82883"
    },
    {
      "vendor_exportdatetime": "2018-10-18",
      "vendor_group_number": 2033,
      "vendor_lot_code": "82878"
    },
    {
      "vendor_exportdatetime": "2018-10-17",
      "vendor_group_number": 2031,
      "vendor_lot_code": "82880"
    },
    {
      "vendor_exportdatetime": "2018-10-16",
      "vendor_group_number": 2027,
      "vendor_lot_code": "82875"
    },
    {
      "vendor_exportdatetime": "2018-10-15",
      "vendor_group_number": 2022,
      "vendor_lot_code": "82877"
    },
    {
      "vendor_exportdatetime": "2018-10-11",
      "vendor_group_number": 2014,
      "vendor_lot_code": "82869"
    },
    {
      "vendor_exportdatetime": "2018-09-26",
      "vendor_group_number": 1990,
      "vendor_lot_code": "82852"
    },
    {
      "vendor_exportdatetime": "2018-09-25",
      "vendor_group_number": 1989,
      "vendor_lot_code": "82846"
    },
    {
      "vendor_exportdatetime": "2018-09-24",
      "vendor_group_number": 1987,
      "vendor_lot_code": "82846"
    },
    {
      "vendor_exportdatetime": "2018-09-18",
      "vendor_group_number": 1982,
      "vendor_lot_code": "82838"
    },
    {
      "vendor_exportdatetime": "2018-09-13",
      "vendor_group_number": 1975,
      "vendor_lot_code": "82832"
    },
    {
      "vendor_exportdatetime": "2018-09-10",
      "vendor_group_number": 1967,
      "vendor_lot_code": "82821"
    },
    {
      "vendor_exportdatetime": "2018-08-30",
      "vendor_group_number": 1955,
      "vendor_lot_code": "82818"
    },
    {
      "vendor_exportdatetime": "2018-08-28",
      "vendor_group_number": 1952,
      "vendor_lot_code": "82814"
    },
    {
      "vendor_exportdatetime": "2018-08-27",
      "vendor_group_number": 1950,
      "vendor_lot_code": "82812"
    },
    {
      "vendor_exportdatetime": "2018-08-22",
      "vendor_group_number": 1941,
      "vendor_lot_code": "82808"
    },
    {
      "vendor_exportdatetime": "2018-08-16",
      "vendor_group_number": 1937,
      "vendor_lot_code": "82804"
    }
  ]
'

	insert into @INWARD_MFG_DETAIL
	SELECT 	JSON_VALUE(jsonTable.Value,'$.vendor_exportdatetime') vendor_exportdatetime,
			JSON_VALUE(jsonTable.Value,'$.vendor_group_number') vendor_group_number,
			JSON_VALUE(jsonTable.Value,'$.vendor_lot_code') vendor_lot_code
			FROM OPENJSON(@mfg_data) jsonTable 
	
	drop table if exists #vendor_stone_details
	drop table if exists #vendor_user_master
	select * into #vendor_stone_details from Packet.VENDOR_STONE_DETAILS
	select vendor_code,user_code,is_primary into #vendor_user_master from master.VENDOR_USER_MASTER

 	declare @grd_Department smallint = Master.getDepartmentCode('GRD')
	DECLARE @srk_certi_code int = (select certificate_code from master.CERTIFICATE_MASTER WITH(NOLOCK) WHERE certificate_key = 'SRK')
 	
 	SELECT
		case when grd_confirm.stoneid = VendorStone.stoneid and process_confirm_date is null then 1 else 0 end as is_grading_outwarded,
	is_mfg_verify, 
	is_inward_smarti_verify, 
	is_inward_stone_verify,
	VendorStone.stoneid,
	ShapeMast.shape_name,
	ShapeMast.shape_short_name, 
	format(VendorStone.issue_carat, '0.00') as issue_carat,ClarityMast.clarity_short_name, ColorMast.color_short_name,
	VendorStone.packet_rate, VendorStone.packet_percentage,round ((VendorStone.packet_rate * VendorStone.issue_carat),2,1) packet_amount,
	CutMast.cut_short_name, PolishMast.polish_short_name, SymMast.symmetry_short_name, FloMast.floro_short_name,
	VendorStone.diameter_ratio, VendorStone.measurement, VendorStone.total_depth, VendorStone.diameter_length , VendorStone.diameter_width,
	VendorStone.tabled,
	''comments,
	@srk_certi_code certificate_code,
	CertMast.certificate_name,
	VendorStone.packet_base_rate,
	VendorStone.outward_datetime,VendorStone.vendor_group_number,
	VendorStone.vendor_exportdatetime as vendor_exportdate_time,
	VendorStone.is_stock_inward, VendorStone.vendor_code, VendorStone.vendor_user_code,VendorStone.is_stock_final,
	VendorStone.inward_datetime,VendorStone.lab_control_no,VendorStone.rfid_tag,
	VendorStone.vendor_lot_code,CertMast.certificate_short_name,
	case when sd.business_logic_code is null then VendorStone.business_logic_code else sd.business_logic_code end as bl_id,
	SourceLM.location_short_name,
	SourceDM.department_short_name,
	SourceSPM.process_short_name,
	SourceSSM.status_short_name as status,
	isnull(SourceHTM.hold_type_name, 'None') as h_type,
	isnull(SourceCTM.confirm_type_name,'None') as confirm_type_name,
	--convert(bit,isnull((select top 1 case when stoneid is not null then 1 else 0 end 
	--					from Packet.STONE_PROCESSES stone_process WITH(NOLOCK) 
	--					where stoneid = VendorStone.stoneid 
	--					and to_department_code = @grd_Department
	--					and process_confirm_date is null),0) )as is_grading_outwarded	,
	--convert(bit,isnull((select top 1 case when stoneid is not null then 1 else 0 end 
	--					from Packet.STONE_PROCESSES stone_process WITH(NOLOCK) 
	--					where stoneid = VendorStone.stoneid 
	--					and to_department_code = @grd_Department
	--					and process_confirm_date is not null),0))as is_grading_inwarded,
	case when process_confirm_date is not null then 1 else 0 end as is_grading_inwarded,
	TWinc_Code, TWinc_name TW_name,	TWinc_short_name TW_short_name,TWinc_display_order,TWinc_location_short_name TW_location_short_name, TWinc_location_name TW_location_name, TWinc_type_name TW_type_name ,TWinc_type_short_name TW_type_short_name
	,TWinc_visibility_short_name, TWinc_visibility_name,
	TBinc_Code,TBinc_name TB_name ,TBinc_short_name TB_short_name ,TBinc_display_order,TBinc_location_short_name TB_location_short_name,TBinc_location_name TB_location_name, TBinc_type_name TB_type_name, TBinc_type_short_name TB_type_short_name
	,TBinc_visibility_short_name,TBinc_visibility_name,
	TSinc_Code,TSinc_name  ,TSinc_short_name,TSinc_display_order,TSinc_location_short_name,TSinc_location_name,TSinc_visibility_short_name,TSinc_visibility_name,
	SWinc_Code,SWinc_name  SW_name,SWinc_short_name SW_short_name,SWinc_display_order,SWinc_location_short_name,SWinc_location_name,SWinc_visibility_short_name,SWinc_visibility_name,SWinc_type_name,SWinc_type_short_name,
	SBinc_Code,SBinc_name SB_name,SBinc_short_name SB_short_name,SBinc_display_order,SBinc_location_short_name SB_location_short_name,SBinc_location_name SB_location_name,SBinc_visibility_short_name,SBinc_visibility_name,SBinc_type_name SB_type_name, SBinc_type_short_name SB_type_short_name,
	SSinc_Code,SSinc_name SS_name,SSinc_short_name SS_short_name,SSinc_display_order,SSinc_location_short_name SS_location_short_name,SSinc_location_name SS_location_name,SSinc_visibility_short_name,SSinc_visibility_name,SSinc_type_name SS_type_name, SSinc_type_short_name SS_type_short_name,
	TOinc_Code,TOinc_name TO_name,TOinc_short_name TO_short_name,TOinc_display_order,TOinc_location_short_name TO_location_short_name,TOinc_location_name TO_location_name,TOinc_visibility_short_name,TOinc_visibility_name,TOinc_type_name TO_type_name, TOinc_type_short_name TO_type_short_name,
	COinc_Code,COinc_name CO_name,COinc_short_name CO_short_name,COinc_display_order,COinc_location_short_name CO_location_short_name,COinc_location_name CO_location_name,COinc_visibility_short_name,COinc_visibility_name,COinc_type_name CO_type_name, COinc_type_short_name CO_type_short_name,
	POinc_Code,POinc_name PO_name,POinc_short_name PO_short_name,POinc_display_order,POinc_location_short_name PO_location_short_name,POinc_location_name PO_location_name,POinc_visibility_short_name,POinc_visibility_name,POinc_type_name PO_type_name, POinc_type_short_name PO_type_short_name,
	GOinc_Code,GOinc_name GO_name ,GOinc_short_name GO_short_name,GOinc_display_order,GOinc_location_short_name GO_location_short_name,GOinc_location_name GO_location_name,GOinc_visibility_short_name,GOinc_visibility_name,GOinc_type_name GO_type_name, GOinc_type_short_name GO_type_short_name,
	TEFinc_Code,TEFinc_name TEF_name,TEFinc_short_name TEF_short_name,TEFinc_display_order,TEFinc_location_short_name ,TEFinc_location_name TEF_location_name,TEFinc_visibility_short_name TEF_location_short_name,TEFinc_visibility_name,TEFinc_type_name TEF_type_name, TEFinc_type_short_name TEF_type_short_name,
	CEFinc_Code,CEFinc_name CEF_name,CEFinc_short_name CEF_short_name,CEFinc_display_order,CEFinc_location_short_name CEF_location_short_name,CEFinc_location_name CEF_location_name,CEFinc_visibility_short_name,CEFinc_visibility_name,CEFinc_type_name CEF_type_name, CEFinc_type_short_name CEF_type_short_name,
	 PEFinc_Code,PEFinc_name PEF_name,PEFinc_short_name PEF_short_name,PEFinc_display_order,PEFinc_location_short_name PEF_location_short_name,PEFinc_location_name PEF_location_name,PEFinc_visibility_short_name,PEFinc_visibility_name,PEFinc_type_name PEF_type_name, PEFinc_type_short_name PEF_type_short_name,
	Tinc_Code,Tinc_name Tinge_name,Tinc_short_name Tinge_short_name ,Tinc_display_order,Tinc_location_short_name Tinge_location_short_name,Tinc_location_name Tinge_location_name,Tinc_visibility_short_name,Tinc_visibilit_name,Tinc_type_name Tinge_type_name, Tinc_type_short_name Tinge_type_short_name,
	Ginc_Code,Ginc_name G_name,Ginc_short_name G_short_name,Ginc_display_order,Ginc_location_short_name G_location_short_name,Ginc_location_name G_location_name,Ginc_visibility_short_name,Ginc_visibilit_name,Ginc_type_name G_type_name, Ginc_type_short_name G_type_short_name,
	Linc_Code,Linc_name L_name,Linc_short_name L_short_name,Linc_display_order,Linc_location_short_name L_location_short_name,Linc_location_name L_location_name,Linc_visibility_short_name,Linc_visibilit_name,Linc_type_name L_type_name, Linc_type_short_name L_type_short_name,
	Cinc_Code,Cinc_name C_name,Cinc_short_name C_short_name,Cinc_display_order,Cinc_location_short_name C_location_short_name,Cinc_location_name C_location_name,Cinc_visibility_short_name,Cinc_visibilit_name,Cinc_type_name C_type_name, Cinc_type_short_name C_type_short_name,
	GDinc_Code,GDinc_name,GDinc_short_name,GDinc_display_order,GDinc_location_short_name,GDinc_location_name,GDinc_visibility_short_name,GDinc_visibilit_name,GDinc_type_name, GDinc_type_short_name,
	HA_Code,HA_name HA_name,HA_short_name HA_short_name,HA_display_order,HA_location_short_name HA_location_short_name,HA_location_name HA_location_name,HA_visibility_short_name,HA_visibilit_name,HA_type_name HA_type_name, HA_type_short_name HA_type_short_name,
	TYinc_Code,TYinc_name TY_name,TYinc_short_name TY_short_name,TYinc_display_order,TYinc_location_short_name TY_location_short_name,TYinc_location_name TY_location_name,TYinc_visibility_short_name,TYinc_visibilit_name,TYinc_type_name TY_type_name, TYinc_type_short_name TY_type_short_name,
	IClean_Code,IClean_name IClean_name,IClean_short_name IClean_short_name,IClean_display_order,IClean_location_short_name IClean_location_short_name,IClean_location_name IClean_location_name,IClean_visibility_short_name,IClean_visibilit_name,IClean_type_name IClean_type_name, IClean_type_short_name IClean_type_short_name,
	Rinc_Code,Rinc_name R_name,Rinc_short_name R_short_name,Rinc_display_order,Rinc_location_short_name R_location_short_name,Rinc_location_name R_location_name,Rinc_visibility_short_name,Rinc_visibilit_name,Rinc_type_name R_type_name, Rinc_type_short_name R_type_short_name,
	FUPinc_Code,FUPinc_name FUP_name,FUPinc_short_name FUP_short_name,FUPinc_display_order,FUPinc_location_short_name FUP_location_short_name,FUPinc_location_name FUP_location_name,FUPinc_visibility_short_name,FUPinc_visibilit_name,FUPinc_type_name FUP_type_name, FUPinc_type_short_name FUP_type_short_name,
	ExtraInc_Code,ExtraInc_name EXTRA_name,ExtraInc_short_name EXTRA_short_name,ExtraInc_display_order,ExtraInc_location_short_name EXTRA_location_short_name,ExtraInc_location_name EXTRA_location_name,ExtraInc_visibility_short_name,ExtraInc_type_name EXTRA_type_name, ExtraInc_type_short_name EXTRA_type_short_name,
	ExtraInc_visibilit_name
	FROM #vendor_stone_details VendorStone WITH(NOLOCK)
	LEFT JOIN #vendor_user_master VendorUserMast WITH(NOLOCK) ON VendorUserMast.user_code = VendorStone.vendor_user_code AND VendorStone.vendor_code = VendorUserMast.vendor_code
	LEFT JOIN Master.SHAPE_MASTER ShapeMast WITH(NOLOCK) ON ShapeMast.shape_code = VendorStone.shape_code
	LEFT JOIN Master.CLARITY_MASTER ClarityMast WITH(NOLOCK) ON ClarityMast.clarity_code = VendorStone.clarity_code
	LEFT JOIN Master.COLOR_MASTER ColorMast WITH(NOLOCK) ON ColorMast.color_code = VendorStone.color_code
	LEFT JOIN Master.CUT_MASTER CutMast WITH(NOLOCK) ON CutMast.cut_code = VendorStone.cut_code
	LEFT JOIN Master.POLISH_MASTER PolishMast WITH(NOLOCK) ON PolishMast.polish_code = VendorStone.polish_code
	LEFT JOIN Master.SYMMETRY_MASTER SymMast WITH(NOLOCK) ON SymMast.symmetry_code = VendorStone.symmetry_code
	LEFT JOIN Master.FLORO_MASTER FloMast WITH(NOLOCK) ON FloMast.floro_code = VendorStone.fluorescence_code
	LEFT JOIN @INWARD_MFG_DETAIL MFG ON CONVERT(DATE,MFG.vendor_exportdatetime) = CONVERT(DATE,VendorStone.vendor_exportdatetime) AND MFG.vendor_group_number = VendorStone.vendor_group_number
	LEFT JOIN Master.CERTIFICATE_MASTER CertMast WITH(NOLOCK) ON CertMast.CERTIFICATE_CODE = VendorStone.certificate_code AND MFG.vendor_lot_code = VendorStone.vendor_lot_code
	-- left join Packet.STONE_PROCESSES stone_process WITH(NOLOCK) ON stone_process.stoneid = VendorStone.stoneid and 
	--	to_department_code = master.getDepartmentCode('GRD') 
	LEFT JOIN Packet.STONE_DETAILS sd WITH(NOLOCK) ON sd.stoneid = VendorStone.stoneid
	LEFT JOIN Master.PROCESS_STATUS_LOCATION_DEPARTMENT_HOLD_CONFIRM SourceBLKey WITH(NOLOCK) ON SourceBLKey.process_status_location_department_hold_confirm_code = (case when sd.business_logic_code is null then VendorStone.business_logic_code else sd.business_logic_code end)
	left Join Master.LOCATION_MASTER	SourceLM WITH(NOLOCK) ON SourceLM.location_code = SourceBLKey.location_code
	left Join Master.DEPARTMENT_MASTER	SourceDM WITH(NOLOCK) ON SourceDM.department_code = SourceBLKey.department_code
	left Join Master.PROCESS_STATUS	SourcePS WITH(NOLOCK) ON SourcePS.process_status_code = SourceBLKey.process_status_code
	left Join Master.STONE_PROCESS_MASTER	SourceSPM WITH(NOLOCK) ON SourcePS.process_code = SourceSPM.process_code 
	left Join Master.STONE_STATUS_MASTER	SourceSSM WITH(NOLOCK) ON SourcePS.status_code = SourceSSM.status_code
	Left Join Master.HOLD_TYPE_MASTER	SourceHTM WITH(NOLOCK) ON SourceHTM.hold_Type_code = SourceBLKey.hold_type_code
	Left Join Master.Confirm_Type_Master SourceCTM WITH(NOLOCK) ON SourceCTM.confirm_type_code = SourceBLKey.confirm_type_code
	left join [Stock].[view_inclusion_data] inc WITH(NOLOCK) ON inc.stoneid = VendorStone.stoneid
	left join 
	(
		select stoneid,process_confirm_date
		from Packet.STONE_PROCESSES stone_process WITH(NOLOCK) 
		where  to_department_code = @grd_Department						
	)as grd_confirm on grd_confirm.stoneid = VendorStone.stoneid
	WHERE CONVERT(DATE,VendorStone.vendor_exportdatetime) = CONVERT(DATE,MFG.vendor_exportdatetime)
	AND VendorStone.vendor_group_number = MFG.vendor_group_number
	AND MFG.vendor_lot_code = VendorStone.vendor_lot_code
	AND VendorUserMast.is_primary = 1
	order by is_inward_stone_verify,is_grading_inwarded,is_grading_outwarded

	SELECT VendorStone.stoneid, StoneLabComm.comment_id, comment_name, comment_short_name, comment_type_key
	FROM #vendor_stone_details VendorStone WITH(NOLOCK)
	LEFT JOIN #vendor_user_master VendorUserMast WITH(NOLOCK) ON VendorUserMast.user_code = VendorStone.vendor_user_code
		AND VendorStone.vendor_code = VendorUserMast.vendor_code
	LEFT JOIN @INWARD_MFG_DETAIL MFG ON convert(date ,MFG.vendor_exportdatetime ) = CONVERT(DATE,VendorStone.vendor_exportdatetime)
		AND MFG.vendor_group_number = VendorStone.vendor_group_number
	LEFT JOIN Packet.VENDOR_STONE_LAB_COMMENTS StoneLabComm WITH(NOLOCK) ON StoneLabComm.stoneid = VendorStone.stoneid
		AND StoneLabComm.vendor_user_code = VendorStone.vendor_user_code AND StoneLabComm.certificate_code = VendorStone.certificate_code
	LEFT JOIN Master.STONE_COMMENT_MASTER ComMast WITH(NOLOCK) ON ComMast.comment_id = StoneLabComm.comment_id

	WHERE comment_type_key IN ( 'sgs_comment', 'mfg_lab_comment', 'key_to_symbol' )
	AND CONVERT(DATE,VendorStone.vendor_exportdatetime) = convert(date ,CONVERT(datetime,MFG.vendor_exportdatetime, 103) ) 
	AND VendorStone.vendor_group_number = MFG.vendor_group_number
	AND MFG.vendor_lot_code = VendorStone.vendor_lot_code
	AND VendorUserMast.is_primary = 1
	--and VendorStone.stoneid not in (select stoneid 
	--			from Packet.STONE_PROCESSES stone_process 
	--			where stoneid = VendorStone.stoneid 
	--			and to_department_code = @grd_Department)
	ORDER BY comment_type_key

END
