SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [Grading].[usp_labinward_gia_upsert] @is_without_grading='false',@modified_by='49',@inward_details='[{"is_data":true,"is_bill":false,"upload_id":1680}]',@modified_iplocation_id='200',@apps_code='3',@is_carat_not_match_allowed='true',@action_id='25'
CREATE OR ALTER         procedure [Grading].[usp_labinward_gia_upsert]
@inward_details             VARCHAR(MAX) = '',
@action_id                  INT,
@is_without_grading         BIT,
@modified_by                INT,
@modified_iplocation_id     INT,
@apps_code                  INT,
@is_carat_not_match_allowed BIT
AS
BEGIN
DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorLine INT, @ErrorState INT;
BEGIN TRY
			--- EXCEUTION LOG ---
			DECLARE @validation_msg VARCHAR(MAX);
			DECLARE @error_msg VARCHAR(MAX);
			DECLARE @current_datetime DATETIME= Master.Fn_GetISTDATETIME();
			DECLARE @date_format VARCHAR(32)=(SELECT [Master].[getDateFormat]());
			DECLARE @D_STOCK_DEPARTMENT_CODE TINYINT= Master.getDepartmentCode('D_IMS');
			DECLARE @origin VARCHAR(16)= 'GRADING-MS';
			DECLARE @srk_certificate TINYINT= Master.getCertificateCode('SRK');
			DECLARE @certificate_code TINYINT= Master.getCertificateCode('GIA');
			DECLARE @Shape_Code TINYINT= Master.getShapeCode('RBC');
			DECLARE @Shape_Code_heart TINYINT= Master.getShapeCode('HB');
			DECLARE @Shape_Code_tri TINYINT= Master.getShapeCode('TRI');
			DECLARE @Shape_Code_other TINYINT= Master.getShapeCode('OT');

			
			DECLARE @form_id INT= [Master].[getGradingFormID]('outward', 1);
			DECLARE @srk TINYINT= ( SELECT lm.LABTYPE_CODE FROM Master.LABTYPE_MASTER lm  WITH(NOLOCK) WHERE lm.labtype_key = 'SRK'  );
			DECLARE @party TINYINT= (SELECT LABTYPE_CODE  FROM Master.LABTYPE_MASTER lm  WITH(NOLOCK)  WHERE lm.labtype_key = 'PARTY'  );
			DECLARE @girldIncCode SMALLINT= Master.getInclusionCode('GDinc');
			DECLARE @saletype_key SMALLINT= ( SELECT saletype_code  FROM master.saletype_master  WITH(NOLOCK)  WHERE saletype_key = 'RS.BILL' );
			DECLARE @conversion_rate NUMERIC(8, 3)= ( SELECT TOP 1 conversion_rate FROM master.CONVERSION_RATE_MASTER crm  WITH(NOLOCK) WHERE saletype_code = @saletype_key ORDER BY crm.created_datetime DESC );
			DECLARE @stoneid AS Stock.STONEID;
			DECLARE @memo_date DATE= NULL, @memo_number INT= 0;
			DECLARE @stoneid_with_order Stock.stoneid_with_request_transfer_detail_id;
			DECLARE @ValidationMessage Table(stoneid bigint, validation_message VARCHAR(MAX))
			declare @operation_remark varchar(max) = 'Lab Inward Certificate 
			'

			--============================comment saved==========================
			declare @ginc_type_code smallint = (SELECT inclusion_type_code FROM Master.inclusion_type_master im WITH(NOLOCK)  WHERE inclusion_type_id = 'ginc')
			declare @ig_inc_code smallint = (SELECT inclusion_code FROM Master.INCLUSION_MASTER im  WITH(NOLOCK) WHERE inclusion_type_id = 'ginc' AND im.inclusion_short_name = 'IG')
			declare @sg_inc_code smallint = (SELECT inclusion_code FROM Master.INCLUSION_MASTER im  WITH(NOLOCK) WHERE inclusion_type_id = 'ginc' AND im.inclusion_short_name = 'SG')
			declare @igsg_inc_code smallint = (SELECT inclusion_code FROM Master.INCLUSION_MASTER im WITH(NOLOCK)  WHERE inclusion_type_id = 'ginc' AND im.inclusion_short_name = 'IG SG')
			declare @none_inc_code smallint = (SELECT inclusion_code FROM Master.INCLUSION_MASTER im WITH(NOLOCK)  WHERE inclusion_type_id = 'ginc' AND im.inclusion_short_name = 'N')

			
			DECLARE @lab_location_code INT=
			(
				SELECT TOP 1 slr.lab_location_code FROM OPENJSON(@inward_details) AS inw
						LEFT JOIN Packet.STONE_LAB_RESULT slr WITH(NOLOCK) ON slr.upload_id = CONVERT(int,JSON_VALUE(inw.value, '$.upload_id'))
						WHERE CONVERT(BIT,JSON_VALUE(inw.value, '$.is_data')) = 1 AND isnull(slr.is_data_inwarded,0) = 0
			);

			
			
			IF EXISTS(SELECT 1 FROM OPENJSON(@inward_details) AS inw
						LEFT JOIN Packet.STONE_LAB_RESULT slr WITH(NOLOCK) ON slr.upload_id = CONVERT(int,JSON_VALUE(inw.value, '$.upload_id'))
						WHERE CONVERT(BIT,JSON_VALUE(inw.value, '$.is_data')) = 1 AND isnull(slr.is_data_inwarded,0) = 0)
			BEGIN
			
				-- ===================================== Create Inward TAble Variable Start ===================================
			DECLARE @inward_details_table TABLE
			(stone_lab_result_id BIGINT,
				invoice_date        DATE,
				invoice_number      VARCHAR(50),
				control_number      VARCHAR(50),
				stoneid             BIGINT,
				issue_carat         NUMERIC(8, 2),
				shape_code          INT,
				clarity_code        INT,
				certificate_number  VARCHAR(70),
				polish_code         INT,
				color_code          INT,
				cut_code            INT,
				symmetry_code       INT,
				floro_code          INT,
				crown_angle         NUMERIC(8, 2),
				crown_height        NUMERIC(8, 2),
				pavilion_height     NUMERIC(8, 2),
				pavilion_angle      NUMERIC(8, 2),
				diameter_length     NUMERIC(8, 2),
				diameter_width      NUMERIC(8, 2),
				girdle              NUMERIC(8, 2),
				height              NUMERIC(8, 2),
				tabled              NUMERIC(8, 2),
				total_depth         NUMERIC(8, 2),
				star_length         NUMERIC(8, 2),
				lower_half          NUMERIC(8, 2),
				certificate_date    DATE,
				document_number     VARCHAR(60),
				diameter_ratio      NUMERIC(8, 2),
				from_girdle_code    INT,
				to_girdle_code      INT,
				key_to_symbol       VARCHAR(max),
				lab_location_code   INT,
				party_code          INT,
				guarantor_code      INT,
				user_code           INT,
				broker_code         INT,
				final_dollar_amount NUMERIC(8, 2),
				final_rs_amount     NUMERIC(8, 2),
				upload_id           INT,
				is_without_bill     INT,
				polish_features     VARCHAR(max),
				symmetry_features   VARCHAR(max),
				color_descriptions  VARCHAR(max),
				fluorescence_color  VARCHAR(max),
				shape_desc          VARCHAR(max),
				job_number          VARCHAR(16),
				report_comments varchar(max),
				inclusion_code int,
				is_inscription_allowed bit,
				diamond_dossier varchar(max),
				clarity_status varchar(max),
				culet_size varchar(max),
				proportion varchar(max),
				inscription varchar(max),
				is_bill_inwarded bit
			);

			INSERT INTO @inward_details_table(stone_lab_result_id,
			invoice_date, 
			invoice_number,
			control_number,
			stoneid,
			issue_carat,
			shape_code,
			clarity_code,
			certificate_number
			 , polish_code,
			 color_code,
			 cut_code,
			 symmetry_code,
			 floro_code,
			 crown_angle,
			 crown_height,
			 pavilion_height,
			 pavilion_angle,
							girdle,
							height,
							tabled,
							total_depth,
							star_length,
							lower_half,
							certificate_date,
							document_number,
							diameter_length,
							diameter_width,
							diameter_ratio,
							from_girdle_code,
							to_girdle_code,
							key_to_symbol,
							lab_location_code,
							party_code,
							guarantor_code,
							user_code,
							broker_code,
							final_dollar_amount,
							final_rs_amount,
							upload_id,
							is_without_bill,
							polish_features,
							symmetry_features,
							color_descriptions,
							fluorescence_color,
							shape_desc,
							job_number,
							report_comments,
							inclusion_code,
							is_inscription_allowed,
							diamond_dossier,
							clarity_status,
							culet_size,
							proportion,
							inscription,
							is_bill_inwarded)
						   SELECT slr.stone_lab_result_id,
								  CASE WHEN slr.is_without_bill = 1 THEN CONVERT(DATE, @current_datetime) ELSE slr.invoice_date END AS invoice_date,
								  CASE WHEN slr.is_without_bill = 1 THEN replace(replace(convert(time,@current_datetime),':',''),'.','') ELSE slr.invoice_number END AS invoice_number,
								  slr.control_number,
								  trn.stoneid,
								  slr.weight AS issue_carat,
								  lab.shape_code AS shape_code,
								  cla_mapping.clarity_code AS clarity_code,
								  slr.report_number certificate_number,
								  lpm.polish_code AS polish_code,
								  color_mapping.color_code AS color_code,
								  case when isnull(final_cut,'') = '' then lab.cut_code ELSE cut_mapping.cut_code end as cut_code,
								  lsm.symmetry_code AS symmetry_code,
								  floro_mapping.floro_code AS floro_code,
								  CASE WHEN(lab.shape_code = @Shape_code) THEN CAST(ISNULL(NULLIF(slr.crown_angle, ''), 0) AS NUMERIC(8, 2)) ELSE lab.crown_angle END AS crown_angle,
								  CASE WHEN(lab.shape_code = @Shape_code) THEN CAST(ISNULL(NULLIF(slr.crown_height, ''), 0) AS NUMERIC(8, 2)) ELSE lab.crown_height END AS crown_height,
								  CASE WHEN(lab.shape_code = @Shape_code) THEN CAST(ISNULL(NULLIF(slr.pavilion_depth, ''), 0) AS NUMERIC(8, 2)) ELSE lab.pavilion_height END AS pavilion_height,
								  CASE WHEN(lab.shape_code = @Shape_code) THEN CAST(ISNULL(NULLIF(slr.pavilion_angle, ''), 0) AS NUMERIC(8, 2)) ELSE lab.pavilion_angle END AS pavilion_angle,
								  CASE WHEN CAST(ISNULL(NULLIF(slr.girdle_percentage, ''), 0) AS NUMERIC(8, 2)) <> 0 THEN CAST(ISNULL(NULLIF(slr.girdle_percentage, ''), 0) AS NUMERIC(8, 2)) ELSE lab.girdle END  AS girdle,

								  case when isnull(slr.depth,0) <> 0 THEN slr.depth ELSE lab.height end AS height,
								  case when CAST(ISNULL(NULLIF(slr.table_percentage, ''), 0) AS NUMERIC(8, 2))  <> 0 then CAST(ISNULL(NULLIF(slr.table_percentage, ''), 0) AS NUMERIC(8, 2)) else cast(lab.tabled		as numeric(8,2))  end AS tabled,
								  case when CAST(ISNULL(NULLIF(slr.depth_percentage, ''), 0) AS NUMERIC(8, 2))  <> 0 then CAST(ISNULL(NULLIF(slr.depth_percentage, ''), 0) AS NUMERIC(8, 2)) else cast(lab.total_depth	as numeric(8,2))  end AS total_depth,
								  case when CAST(ISNULL(NULLIF(slr.start_length, ''), 0) AS NUMERIC(8, 2))		<> 0 then CAST(ISNULL(NULLIF(slr.start_length, ''), 0) AS NUMERIC(8, 2))	 else cast(lab.star_length	as numeric(8,2))  end AS start_length,
								  case when CAST(ISNULL(NULLIF(slr.lower_half, ''), 0) AS NUMERIC(8, 2))		<> 0 then CAST(ISNULL(NULLIF(slr.lower_half, ''), 0) AS NUMERIC(8, 2))		 else cast(lab.lower_half   as numeric(8,2)) 	 end AS lower_half,

								  slr.report_date AS certificate_date,
								  NULL AS document_number,

								  CASE WHEN(lab.shape_code in( @Shape_code,@Shape_Code_heart,@Shape_Code_tri,@Shape_Code_other)) THEN (CASE WHEN length < width THEN length ELSE width END) ELSE (CASE WHEN length > width THEN length ELSE width END) END AS diameter_length,
								  CASE WHEN(lab.shape_code in( @Shape_code,@Shape_Code_heart,@Shape_Code_tri,@Shape_Code_other)) THEN (CASE WHEN length > width THEN length ELSE width END) ELSE (CASE WHEN length < width THEN length ELSE width END) END AS diameter_width,
								  CASE WHEN (lab.diameter_length <> 0 AND lab.diameter_width <> 0) THEN (CASE WHEN(lab.shape_code = @Shape_Code) THEN ((length + width)/2) ELSE (slr.length / slr.width) END) ELSE lab.diameter_ratio END AS diameter_ratio,
								  incfrom.inclusion_code from_girdle_code,
								  incto.inclusion_code to_girdle_code,
								  Replace(Replace(slr.key_to_symbols, '"', ''), ';', '') AS key_to_symbol,
								  slr.lab_location_code,
								  null as party_code,
								  null as guarantor_code,
								  null as user_code,
								  null as broker_code,
								  (amount.final_amount_dollar + ISNULL(slr.handling_charges_dollar, 0) + ISNULL(slr.handling_charges_cgst_dollar, 0) + ISNULL(slr.handling_charges_sgst_dollar, 0) + ISNULL(slr.shipping_charges_dollar, 0) + ISNULL(slr.shipping_charges_cgst_dollar, 0) + ISNULL(slr.shipping_charges_sgst_dollar, 0)) AS final_dollar_amount,
								  (amount.final_amount_rs + ISNULL(slr.handling_charges_rs, 0) + ISNULL(slr.handling_charges_cgst_rs, 0) + ISNULL(slr.handling_charges_sgst_rs, 0) + ISNULL(slr.shipping_charges_rs, 0) + ISNULL(slr.shipping_charges_cgst_rs, 0) + ISNULL(slr.shipping_charges_sgst_rs, 0)) AS final_rs_amount,
								  slr.upload_id,
								  slr.is_without_bill,
								  slr.polish_features,
								  slr.symmetry_features,
								  slr.color_descriptions,
								  slr.fluorescence_color,
								  slr.shape_desc,
								  slr.job_number,slr.report_comments, CASE
								WHEN (key_to_symbols like '%INTERNAL GRAINING%SURFACE GRAINING%' or report_comments like '%INTERNAL%SURFACE GRAINING%') THEN @igsg_inc_code
								WHEN (key_to_symbols like '%INTERNAL GRAINING%' or report_comments like '%INTERNAL GRAINING%')  THEN @ig_inc_code
								WHEN (key_to_symbols like '%SURFACE GRAINING%' or report_comments like '%SURFACE GRAINING%') THEN @sg_inc_code
								else @none_inc_code END  inclusion_code,
								CASE WHEN slr.weight < 1.00 then 1 
									 when slr.weight >= 1.00 AND isnull(slr.inscription,'') <> '' THEN 1 ELSE 0 END is_inscription_allowed,
								diamond_dossier,clarity_status,slr.culet_size,proportion,inscription,is_bill_inwarded
						   FROM OPENJSON(@inward_details) AS inw
								LEFT JOIN Packet.STONE_LAB_RESULT slr with(nolock) ON slr.upload_id = CONVERT(int,JSON_VALUE(inw.value, '$.upload_id'))
								LEFT JOIN Packet.STONE_DETAILS trn with(nolock) ON slr.client_reference = trn.stoneid
								LEFT JOIN Packet.STONE_LAB_MASTER lab with(nolock)  ON trn.stoneid = lab.stoneid
																		 AND lab.certificate_code = @srk_certificate--lab.certificate_code
								--LEFT JOIN Packet.STONE_PARTY_TRANSACTIONS spt with(nolock)  ON trn.stoneid = spt.stoneid
								OUTER APPLY
								(
									SELECT SUM(slrs.lab_service_fee_dollar + slrs.lab_service_fee_cgst_dollar + slrs.lab_service_fee_sgst_dollar) AS final_amount_dollar,
											SUM(slrs.lab_service_fee_rs + slrs.lab_service_fee_cgst_rs + slrs.lab_service_fee_sgst_rs) AS final_amount_rs
									FROM Packet.STONE_LAB_RESULT_SERVICES slrs WITH(NOLOCK)
									WHERE slrs.stone_lab_result_id = slr.stone_lab_result_id
									GROUP BY slrs.stone_lab_result_id
								) amount
								LEFT JOIN Master.inclusion_master incfrom with(nolock)  ON LEFT(slr.girdle, 3) = incfrom.inclusion_short_name AND incfrom.inclusion_type_code = @girldIncCode
								LEFT JOIN Master.inclusion_master incto with(nolock)  ON RIGHT(slr.girdle, 3) = incto.inclusion_short_name AND incto.inclusion_type_code = @girldIncCode
								LEFT JOIN Master.LAB_CLARITY_MAPPING cla_mapping with(nolock)  on slr.clarity = cla_mapping.clarity_name AND cla_mapping.certificate_code = @certificate_code
								LEFT JOIN Master.LAB_COLOR_MAPPING color_mapping with(nolock)  ON slr.color = color_mapping.color_name AND color_mapping.certificate_code = @certificate_code
								LEFT JOIN Master.LAB_CUT_MAPPING cut_mapping with(nolock)  ON slr.final_cut = cut_mapping.cut_name AND cut_mapping.certificate_code = @certificate_code
								LEFT JOIN Master.LAB_FLORO_MAPPING floro_mapping with(nolock)  ON slr.fluorescence_intensity = floro_mapping.floro_name AND floro_mapping.certificate_code = @certificate_code
								LEFT JOIN Master.LAB_POLISH_MAPPING lpm with(nolock)  ON slr.polish = lpm.polish_name AND lpm.certificate_code = @certificate_code
								LEFT JOIN Master.LAB_SYMMETRY_MAPPING lsm with(nolock)  ON  slr.symmetry = lsm.symmetry_name AND lsm.certificate_code = @certificate_code
								WHERE CONVERT(BIT,JSON_VALUE(inw.value, '$.is_data')) = 1 AND isnull(slr.is_data_inwarded,0) = 0



		   INSERT INTO @stoneid(STONEID)
		   SELECT stoneid FROM @inward_details_table;
		   INSERT INTO @stoneid_with_order(serial_number,stoneid, request_transfer_detail_id)
		   SELECT CONVERT(SMALLINT, ROW_NUMBER() OVER(ORDER BY stoneid)) serial_number, CONVERT(BIGINT, stoneid),  0 FROM @stoneid;

		   /*--------------------------------*/

			/*
			Get Max Process id for each stones to be outward
			*/
			DECLARE @StoneProcess AS [STOCK].[STONEID_WITH_PROCESS_ID]
			--DECLARE @StoneProcess Table(serial_number smallint, stoneid bigint, process_id bigint)
			INSERT INTO @StoneProcess (stoneid, process_id)
			SELECT Stone.stoneid, MAX(StoneProcess.process_id)
			FROM @stoneid Stone
			LEFT JOIN Packet.STONE_PROCESSES StoneProcess with(nolock) on StoneProcess.stoneid = Stone.stoneid
			where Stone.stoneid is not null and StoneProcess.stoneid is not null
			Group by Stone.stoneid
			/*--------------------------------*/

		   DECLARE @validate_stone_details TABLE
		   (
			stoneid bigint ,result_shape_code int , lab_shape_code int,org_carat numeric(8,3),lab_carat numeric(8,3),
			invoice_number varchar(64),invoice_date date,control_number varchar(16)
			)
			INSERT INTO @validate_stone_details
			(
				stoneid,result_shape_code,lab_shape_code,org_carat,lab_carat,invoice_number,invoice_date,control_number
			)
		   SELECT result.stoneid,result.shape_code result_shape_code,slm.shape_code lab_shape_code,slm.issue_carat org_carat ,result.issue_carat lab_carat,
				invoice_number, format(invoice_date, @date_format) invoice_date,result.control_number
		   FROM @inward_details_table result
		   LEFT JOIN Packet.STONE_DETAILS sd with(nolock)  ON result.stoneid = sd.stoneid
		   LEFT JOIN Packet.STONE_LAB_MASTER slm with(nolock)  ON sd.stoneid = slm.stoneid AND sd.certificate_code = slm.certificate_code
		   WHERE result.stoneid = sd.stoneid

			IF EXISTS (SELECT 1 FROM (SELECT result.stoneid, lab_carat, org_carat,ISNULL(CASE WHEN org_carat = lab_carat
											  THEN lab_carat WHEN org_carat = lab_carat + 0.01
											  THEN lab_carat + 0.01 WHEN org_carat = lab_carat - 0.01 THEN lab_carat - 0.01 END, 0) issue_carat
							FROM @validate_stone_details result
							WHERE result.org_carat NOT BETWEEN lab_carat + 0.01 AND lab_carat - 0.01
						) AS outResult
						WHERE outResult.issue_carat <= 0.000)
			BEGIN
				IF(@is_carat_not_match_allowed = 0)
				BEGIN
				
					SET @error_msg = 'Carat Not Match';
					SELECT CAST(( SELECT stoneid, org_carat, lab_carat,issue_carat, issue_carat - org_carat diff_carat, @validation_msg [error_message]
						FROM (SELECT stoneid,lab_carat lab_carat,org_carat org_carat,ISNULL(CASE WHEN org_carat = lab_carat
											  THEN lab_carat WHEN org_carat = lab_carat + 0.01
											  THEN lab_carat + 0.01 WHEN org_carat = lab_carat - 0.01 THEN lab_carat - 0.01 END, 0) issue_carat
							FROM @validate_stone_details
						) AS outResult
						WHERE outResult.issue_carat <= 0.000 FOR JSON PATH
					) AS NVARCHAR(MAX)) validation_carat_missmatch;

					RETURN;
				END	;
			END;

		
			IF EXISTS( SELECT 1 FROM @inward_details_table Stone WHERE Stone.stoneid IS NOT NULL)
			BEGIN
			
				/*
				Validate - stone outward
				*/
				INSERT INTO @ValidationMessage (stoneid, validation_message)
				select stoneid,[error_message] from (SELECT Stone.stoneid,ISNULL((
						SELECT [Packet].[usp_fn_outward_InternalStockConfirm](Stone.stoneid, process_id, @D_STOCK_DEPARTMENT_CODE, @D_STOCK_DEPARTMENT_CODE, 1,@action_id)
					), '') [error_message]
					FROM @StoneProcess Stone
				) AS outResult
				WHERE [error_message] <> ''

				
				IF EXISTS (SELECT 1 FROM @ValidationMessage)
				BEGIN
				
					SELECT CAST(( select stoneid, validation_message from @ValidationMessage FOR JSON PATH ) AS NVARCHAR(MAX)) validation_message;
					RETURN;
				END
			END;

			IF EXISTS ( SELECT 1 FROM Packet.STONE_PROCESSES with(nolock) WHERE stoneid IN (SELECT stoneid FROM @stoneid_with_order) AND is_sub_process_active = 1)
			BEGIN
			   /*
				Validate - Grading - Internal Transaction Receive
				*/
				INSERT INTO @ValidationMessage (stoneid, validation_message)
				SELECT stoneid, [error_message]
				FROM( SELECT Stone.stoneid, ISNULL(( SELECT Grading.usp_fn_StockViewInternalReceive_ChkSave(Stone.stoneid, process_id, @D_STOCK_DEPARTMENT_CODE, 0)), '') [error_message]
					FROM @StoneProcess stone ) AS outResult
				WHERE [error_message] <> ''

				IF EXISTS (SELECT 1 FROM @ValidationMessage)
				BEGIN
					SELECT CAST(( select stoneid, validation_message from @ValidationMessage FOR JSON PATH ) AS NVARCHAR(MAX)) validation_message;
					RETURN;
				END
			END;

	END

		 DECLARE @stoneids varchar(max) = (select STONEID from @stoneid_with_order)


		 DECLARE @stoneid_tvp table (stoneid bigint)
	   	 	INSERT INTO @stoneid_tvp 
		 	EXEC [Stock].[usp_check_stone_BL]
		 	@stoneid_list = @stoneids,
		 	@action_code  = @action_id

		 IF EXISTS (select 1 from @stoneid_tvp) 
		 BEGIN 
		 	--RAISERROR ('RESULTING BL NOT FOUND',16,1)
		 	select 'RESULTING BL NOT FOUND' as validation_msg
		 	RETURN;
		 END
				

		BEGIN TRY
			BEGIN TRANSACTION;
			
			--======================== IF DATA INWARDED================================================
			IF EXISTS(SELECT 1 FROM OPENJSON(@inward_details) AS inw
							LEFT JOIN Packet.STONE_LAB_RESULT slr with(nolock)  ON slr.upload_id = CONVERT(int,JSON_VALUE(inw.value, '$.upload_id'))
					WHERE CONVERT(bit,JSON_VALUE(inw.value, '$.is_data')) = 1 AND isnull(slr.is_data_inwarded,0) = 0)
			BEGIN
				BEGIN

					/*stock upsert*/

					/*
					Get Memo Number
					*/
					DECLARE @process_issue_memo_no SMALLINT = 0
					EXEC Grading.usp_FindMemoNumber_Insert @process_issue_memo_no OUTPUT, '', 0, @modified_by, @modified_iplocation_id,@current_datetime

					
					IF EXISTS( SELECT 1 FROM Packet.STONE_PROCESSES  with(nolock) WHERE stoneid IN(SELECT stoneid FROM @stoneid_with_order) AND is_sub_process_active = 1)
					BEGIN
						   Update sp
							SET is_sub_process_active = 0,
								sub_process_id = null,
								modified_datetime = @current_datetime,
								modified_by = @modified_by,
								modified_iplocation_id = @modified_iplocation_id,
								apps_code = @apps_code
							from Packet.STONE_PROCESSES sp with(nolock)
							WHERE process_id IN (select process_id from @StoneProcess)

							--Update ssp
							--Set user_receive_datetime = @current_datetime,
							--	receive_user_code = @modified_by,
							--	modified_by = @modified_by,
							--	modified_datetime = @current_datetime,
							--	modified_iplocation_id = @modified_iplocation_id,
							--	apps_code = @apps_code
							--from Packet.SUB_STONE_PROCESSES ssp with(nolock)
							--WHERE process_id IN (select process_id from @StoneProcess)
					END;

					/*Update Previous Record*/
					UPDATE sp
					SET next_to_department_code = @D_STOCK_DEPARTMENT_CODE,
						next_user_code = @modified_by,
						next_process_issue_date = @current_datetime,
						next_process_issue_time = @current_datetime,
						next_process_issue_memo_no = @process_issue_memo_no,
						modified_datetime = @current_datetime,
						modified_by = @modified_by,
						modified_iplocation_id = @modified_iplocation_id,
						apps_code = @apps_code
					from Packet.STONE_PROCESSES sp with(nolock)
					WHERE process_id IN (SELECT process_id from @StoneProcess)

					INSERT INTO Packet.STONE_PROCESSES
					(stoneid, from_department_code, to_department_code, process_issue_date, process_issue_time, process_issue_memo_no, remark, process_issue_user_code,
						process_issue_iplocation_id, created_by, created_iplocation_id, apps_code, outward_serial_id, user_code, is_inward_verify, notes, action_code)
					SELECT Stone.stoneid, @D_STOCK_DEPARTMENT_CODE, @D_STOCK_DEPARTMENT_CODE, @current_datetime, @current_datetime, @process_issue_memo_no, '', @modified_by,
						@modified_iplocation_id, @modified_by, @modified_iplocation_id, @apps_code, Stone.serial_number outward_serial_id, 0, 0, '', @action_id
					FROM @stoneid_with_order Stone
					LEFT JOIN Packet.STONE_DETAILS StoneDet with(nolock)  ON StoneDet.stoneid = Stone.stoneid
					WHERE StoneDet.TRNYEAR = 0
							AND Stone.stoneid IS NOT NULL
							AND StoneDet.stoneid IS NOT NULL;

					/*Generate View Request*/
					DECLARE @old_memo_date date,
							@old_memo_no smallint,
							@stoneid_list Stock.stoneid
				

					/*Change BL Key in Stone*/
					/*
		            -----------------------------------------
		            BL UPDATE
		            -----------------------------------------
		            */
		            
		            Declare @newBL_confirm_type_code smallint
		            Declare @newBL_hold_type_code smallint  
		            Declare @newBL_status_code smallint
		            Declare @newBL_process_code smallint 
		            Declare @newBL_location_code smallint
		            Declare @newBL_department_code smallint 
		            
		            DECLARE @stones as table (blc bigint, stoneid bigint)
		            Declare @output_business_logic_code bigint 
		            DECLARE @tablevar_stone_details_bl_update_v2 Stock.tablevar_stone_details_bl_update_v2 
					DECLARE @perform_action TABLE(is_perform_action BIT);
		            
		            
		            
		            IF(@is_without_grading = 0)
		            BEGIN
		            
		            	SET @newBL_confirm_type_code  = master.getConfirmCode('None')
		            	SET @newBL_hold_type_code =  master.getHoldCode('None')
		            	SET @newBL_status_code =  master.getStoneStatusCode('RFL')
		            	SET @newBL_process_code  = Master.getprocessCode('NEW_STOCK')
		            	SET @newBL_location_code  = Master.getlocationCode('EX_TRANSIT')
		            	SET @newBL_department_code  = Master.getDepartmentCode('D_IMS')
		            
		            	INSERT INTO @stones (blc,stoneid)
		            	SELECT sd.business_logic_code,a.stoneid
		            	FROM  Packet.stone_Details sd 
		            	INNER JOIN  @stoneid_with_order a
		            	on a.stoneid = sd.stoneid 
		            
		            	SET @output_business_logic_code  = (
		            	SELECT BL.process_status_location_department_hold_confirm_code
		            	FROM Master.PROCESS_STATUS_LOCATION_DEPARTMENT_HOLD_CONFIRM BL WITH (NOLOCK) 
		            	INNER JOIN Master.PROCESS_STATUS PS WITH (NOLOCK) ON PS.process_status_code = BL.process_status_code
		            	WHERE BL.location_code = @newBL_location_code 
		            	       AND BL.department_code = @newBL_department_code 
		            	       AND BL.hold_type_code = @newBL_hold_type_code 
		            	       AND BL.confirm_type_code = @newBL_confirm_type_code
		            	       AND PS.process_code = @newBL_process_code
		            	       AND PS.status_code = @newBL_status_code)
		            
		            	
		            	INSERT INTO @tablevar_stone_details_bl_update_v2 ([id],[confirm_type_code],[hold_type_code],[status_code],
		            	[process_code],[department_code],[location_code],[input_business_logic_code],[output_business_logic_code])
		            	SELECT stoneid,@newBL_confirm_type_code,@newBL_hold_type_code,@newBL_status_code,@newBL_process_code,
		            	@newBL_department_code,@newBL_location_code,blc,@output_business_logic_code FROM @stones
		            
		            
						
						
						INSERT INTO @perform_action(is_perform_action)
		            	EXEC [Stock].[usp_Stone_Details_Bl_Update_v2] 
                              @tablevar_stone_details_bl_update_v2 = @tablevar_stone_details_bl_update_v2, 
                              @modified_by = @modified_by, 
                              @action_id = @action_id, 
                              @form_name = '', 
                              @origin = @origin, 
                              @apps_code = @apps_code, 
                              @modified_iplocation_id = @modified_iplocation_id,
		               		  @modified_datetime = @current_datetime;
							  

		            
		            END
		            ELSE
		            BEGIN
		            
		            	SET @newBL_confirm_type_code  = master.getConfirmCode('None')
		            	SET @newBL_hold_type_code =  master.getHoldCode('None')
		            	SET @newBL_status_code =  master.getStoneStatusCode('LAB_REJECTION')
		            	SET @newBL_process_code  = Master.getprocessCode('NEW_STOCK')
		            	SET @newBL_location_code  = Master.getlocationCode('EX_TRANSIT')
		            	SET @newBL_department_code  = Master.getDepartmentCode('D_IMS')
		            
		            	INSERT INTO @stones (blc,stoneid)
		            	SELECT sd.business_logic_code,a.stoneid
		            	FROM  Packet.stone_Details sd 
		            	INNER JOIN  @stoneid_with_order a
		            	on a.stoneid = sd.stoneid 
		            
		            	SET @output_business_logic_code = (SELECT BL.process_status_location_department_hold_confirm_code
		            	FROM Master.PROCESS_STATUS_LOCATION_DEPARTMENT_HOLD_CONFIRM BL WITH (NOLOCK) 
		            	INNER JOIN Master.PROCESS_STATUS PS WITH (NOLOCK) ON PS.process_status_code = BL.process_status_code
		            	WHERE BL.location_code = @newBL_location_code 
		            	       AND BL.department_code = @newBL_department_code 
		            	       AND BL.hold_type_code = @newBL_hold_type_code 
		            	       AND BL.confirm_type_code = @newBL_confirm_type_code
		            	       AND PS.process_code = @newBL_process_code
		            	       AND PS.status_code = @newBL_status_code)
		            
		            
		            	INSERT INTO @tablevar_stone_details_bl_update_v2 ([id],[confirm_type_code],[hold_type_code],[status_code],
		            	[process_code],[department_code],[location_code],[input_business_logic_code],[output_business_logic_code])
		            	SELECT stoneid,@newBL_confirm_type_code,@newBL_hold_type_code,@newBL_status_code,@newBL_process_code,
		            	@newBL_department_code,@newBL_location_code,blc,@output_business_logic_code FROM @stones
		            
		            
						
						INSERT INTO @perform_action(is_perform_action)
		            	EXEC [Stock].[usp_Stone_Details_Bl_Update_v2] 
                              @tablevar_stone_details_bl_update_v2 = @tablevar_stone_details_bl_update_v2, 
                              @modified_by = @modified_by, 
                              @action_id = @action_id, 
                              @form_name = '', 
                              @origin = @origin, 
                              @apps_code = @apps_code, 
                              @modified_iplocation_id = @modified_iplocation_id,
		            	@modified_datetime = @current_datetime;
		            END



					-- ============================= Nishit Langaliya ======================================================

					declare @rfl_status_code smallint = (select status_code from master.STONE_STATUS_MASTER with(nolock) where status_key = 'RFL')

					update sdrfl
					set sdrfl.return_from_lab_stone_datetime = @current_datetime,
						sdrfl.modified_datetime = @current_datetime,
						sdrfl.modified_by = @modified_by,
						sdrfl.modified_iplocation_id = @modified_iplocation_id
					from @inward_details_table idt
					left join packet.stone_details sd with(nolock) on idt.stoneid = sd.stoneid
					left join Grading.return_from_lab_stone_details sdrfl with(nolock) on sdrfl.stoneid = idt.stoneid
					where sdrfl.stoneid = idt.stoneid
					and sd.stone_status_code = @rfl_status_code
					and sdrfl.stoneid is not null

					insert into Grading.return_from_lab_stone_details (stoneid, return_from_lab_stone_datetime, apps_code, created_datetime, created_by, created_iplocation_id)
					select idt.stoneid, @current_datetime, @apps_code, @current_datetime, @modified_by, @modified_iplocation_id
					from @inward_details_table idt
					left join packet.stone_details sd with(nolock) on idt.stoneid = sd.stoneid
					left join Grading.return_from_lab_stone_details sdrfl with(nolock) on sdrfl.stoneid = idt.stoneid
					where sd.stone_status_code = @rfl_status_code
					and sdrfl.stoneid is null

				END;
				
				IF(@is_without_grading = 0)
					BEGIN

						-- ===================================== Insert Lab Inward Details Start ====================================

						INSERT INTO Grading.LAB_INWARD_DETAILS
						(invoice_date,
						 invoice_number,
						 lab_location_code,
						 certificate_code,
						 conversion_rate,
						 apps_code,
						 created_by,
						 created_iplocation_id--,job_number
						)
							   SELECT inw.invoice_date,
									  inw.invoice_number,
									  lab_location_code,
									  @certificate_code,
									  @conversion_rate,
									  @apps_code,
									  @modified_by,
									  @modified_iplocation_id --,job_number
							   FROM @inward_details_table inw
							   GROUP BY inw.invoice_date,
										inw.invoice_number,
										lab_location_code;

										

						MERGE INTO Grading.LAB_INWARD_STONE_DETAILS AS Dest
						USING
						(
							SELECT inward.inward_id,
								   '' AS reference_number,
								   stone_lab_result_id,inw.invoice_date, inw.invoice_number,control_number,stoneid,issue_carat,shape_code,clarity_code,
									certificate_number, polish_code,color_code,cut_code,symmetry_code,floro_code,crown_angle,crown_height,pavilion_height,pavilion_angle,
									diameter_length,diameter_width,girdle,height,tabled,total_depth,star_length,lower_half,certificate_date,document_number,diameter_ratio,
									from_girdle_code,to_girdle_code,key_to_symbol,inw.lab_location_code,party_code,guarantor_code,user_code,broker_code,final_dollar_amount,final_rs_amount,
									upload_id,is_without_bill,polish_features,symmetry_features,color_descriptions,fluorescence_color,shape_desc,inw.job_number,
								   0 amount_dollar,
								   0 tax_dollar,
								   0 discount_percentage,
								   0 credit_dollar,
								   @operation_remark remark,
								   @current_datetime certificate_inward_datetime,
								   diamond_dossier,clarity_status,culet_size,proportion,inscription,is_bill_inwarded
							FROM @inward_details_table inw
								 LEFT JOIN Grading.LAB_INWARD_DETAILS inward  with(nolock) ON inw.invoice_date = inward.invoice_date
																				AND ISNULL(inw.invoice_number, 0) = ISNULL(inward.invoice_number, 0)
						) AS Sou
						ON Dest.stoneid = Sou.stoneid
						   AND Dest.inward_id = Sou.inward_id
							WHEN MATCHED
							THEN UPDATE SET
											Dest.stoneid = Sou.stoneid,
											dest.certificate_code = @certificate_code,
											Dest.reference_number = Sou.reference_number,
											Dest.shape_code = Sou.shape_code,
											Dest.issue_carat = Sou.issue_carat,
											Dest.clarity_code = Sou.clarity_code,
											Dest.certificate_number = Sou.certificate_number,
											Dest.color_code = Sou.color_code,
											Dest.cut_code = Sou.cut_code,
											Dest.polish_code = Sou.polish_code,
											Dest.symmetry_code = Sou.symmetry_code,
											Dest.fluorescence_code = Sou.floro_code,
											Dest.crown_angle = Sou.crown_angle,
											Dest.crown_height = Sou.crown_height,
											Dest.pavilion_height = Sou.pavilion_height,
											Dest.pavilion_angle = Sou.pavilion_angle,
											Dest.diameter_length = Sou.diameter_length,
											Dest.diameter_width = Sou.diameter_width,
											Dest.girdle = Sou.girdle,
											Dest.height = Sou.height,
											Dest.tabled = Sou.tabled,
											Dest.total_depth = Sou.total_depth,
											Dest.star_length = Sou.star_length,
											Dest.lower_half = Sou.lower_half,
											Dest.certificate_date = Sou.certificate_date,
											Dest.from_girdle_code = Sou.from_girdle_code,
											Dest.to_girdle_code = Sou.to_girdle_code,
											Dest.amount_dollar = Sou.amount_dollar,
											Dest.tax_dollar = Sou.tax_dollar,
											Dest.discount_percentage = Sou.discount_percentage,
											Dest.credit_dollar = Sou.credit_dollar,
											Dest.remark = Sou.remark,
											Dest.modified_by = @modified_by,
											Dest.modified_datetime = @current_datetime,
											Dest.modified_iplocation_id = @modified_iplocation_id,
											Dest.certificate_inward_datetime = Sou.certificate_inward_datetime,
											dest.shape_description = sou.shape_desc,
											Dest.color_descriptions = Sou.color_descriptions,
											Dest.control_number = Sou.control_number,
											Dest.job_number = Sou.job_number,
											Dest.diamond_dossier = Sou.diamond_dossier,
											Dest.clarity_status = Sou.clarity_status,
											Dest.culet_size = Sou.culet_size,
											Dest.proportion = Sou.proportion,
											Dest.inscription = Sou.inscription,
											Dest.is_bill_inwarded = Sou.is_bill_inwarded
							WHEN NOT MATCHED
							THEN
							  INSERT(inward_id,
									 stoneid,
									 certificate_code,
									 reference_number,
									 shape_code,
									 issue_carat,
									 clarity_code,
									 certificate_number,
									 color_code,
									 cut_code,
									 polish_code,
									 symmetry_code,
									 fluorescence_code,
									 crown_angle,
									 crown_height,
									 pavilion_height,
									 pavilion_angle,
									 diameter_length,
									 diameter_width,
									 girdle,
									 height,
									 tabled,
									 total_depth,
									 star_length,
									 lower_half,
									 certificate_date,
									 from_girdle_code,
									 to_girdle_code,
									 amount_dollar,
									 tax_dollar,
									 discount_percentage,
									 credit_dollar,
									 remark,
									 created_by,
									 created_datetime,
									 created_iplocation_id,
									 certificate_inward_datetime,
									 apps_code,
									 shape_description,
									 color_descriptions,
									 control_number,job_number,diamond_dossier,clarity_status,culet_size,proportion,inscription,is_bill_inwarded)
							  VALUES
						(sou.inward_id,
						 stoneid,
						 @certificate_code,
						 reference_number,
						 shape_code,
						 issue_carat,
						 clarity_code,
						 certificate_number,
						 color_code,
						 cut_code,
						 polish_code,
						 symmetry_code,
						 sou.floro_code,
						 crown_angle,
						 crown_height,
						 pavilion_height,
						 pavilion_angle,
						 diameter_length,
						 diameter_width,
						 girdle,
						 height,
						 tabled,
						 total_depth,
						 star_length,
						 lower_half,
						 certificate_date,
						 from_girdle_code,
						 to_girdle_code,
						 amount_dollar,
						 tax_dollar,
						 discount_percentage,
						 credit_dollar,
						 remark,
						 @modified_by,
						 @current_datetime,
						 @modified_iplocation_id,
						 certificate_inward_datetime,
						 @apps_code,
						 shape_desc,
						 color_descriptions,
						 control_number, job_number, diamond_dossier,clarity_status,culet_size,proportion,inscription,is_bill_inwarded
						);


	
						--========================================= Purchase Entry ==========================================

						DECLARE @current_year VARCHAR(16)=(SELECT config.configuration_value FROM Master.CONFIGURATION_MASTER config WITH(NOLOCK) WHERE config.configuration_key = 'SRK_CURRENT_YEAR' );
						DECLARE @transfer_number SMALLINT, @transaction_type_code TINYINT
						
						--========================================= Weight Loss Entry ==========================================
						DECLARE @LabEntry_json_Detail VARCHAR(MAX)= N'{}';
						SET @transfer_number = (SELECT  ISNULL(MAX(transaction_number),0)+1 FROM STransfer.TRANSACTION_DETAILS WITH (NOLOCK)  WHERE transaction_year = CONVERT(SMALLINT,@current_year))
					
						SET @transaction_type_code = Master.getTransactionTypeCode('loss');
						DECLARE @Dept_Weight_Loss SMALLINT= ( SELECT sdm.department_code FROM Master.STONE_DEPARTMENT_MASTER sdm WITH(NOLOCK) WHERE sdm.size_type_key = 'WL' );
						
						SET @LabEntry_json_Detail = JSON_MODIFY(@LabEntry_json_Detail, '$.transfer_detail',
						(
							SELECT @current_year transfer_year,
								   @transfer_number + CONVERT(SMALLINT, ROW_NUMBER() OVER(
								   ORDER BY stone.stoneid)) transfer_number,
								   ( @current_datetime) currentdate,
								   @transaction_type_code transaction_type_code, --lab.issue_carat before_carat,stone.issue_carat after_carat,
								   CASE WHEN(stone.issue_carat > lab.issue_carat) THEN @Dept_Weight_Loss ELSE To_dept.department_code END from_department_code,
								   CASE WHEN(stone.issue_carat > lab.issue_carat) THEN To_dept.department_code ELSE @Dept_Weight_Loss END to_department_code,
								   'Lab Inward' remark,
								   stone.invoice_number invoice_number,
								   abs(stone.issue_carat - lab.issue_carat) AS lab_carat,
								   stone.shape_code,
								   1 packet_rate,
								   (1 * stone.issue_carat) AS packet_amount,
								   @modified_by modified_by,
								   @modified_iplocation_id modified_iplocation_id,
								   stone.stoneid stoneid_list,
								   1 total_pcs,
								   @apps_code AS apps_code,
								   invoice_date,
								   @conversion_rate conversion_rate
							FROM @inward_details_table stone
								 LEFT JOIN Packet.STONE_DETAILS trn  with(nolock) ON stone.stoneid = trn.stoneid
								 LEFT JOIN Packet.STONE_LAB_MASTER lab  with(nolock) ON trn.stoneid = lab.stoneid
																		  AND trn.certificate_code = lab.certificate_code
								 LEFT JOIN Packet.STONE_RATES rate  with(nolock) ON stone.stoneid = rate.stoneid
								 LEFT JOIN Master.CERTIFICATE_MASTER cm  with(nolock) ON @certificate_code = cm.certificate_code
								 LEFT JOIN Master.STONE_DEPARTMENT_MASTER To_dept  with(nolock) ON To_dept.size_type_key = 'LABEXP'
																					 AND lab.issue_carat BETWEEN To_dept.from_size AND To_dept.to_size
																					 AND lab.color_code BETWEEN To_dept.from_color_code AND To_dept.to_color_code
							WHERE stone.issue_carat <> lab.issue_carat FOR JSON AUTO
						));
						IF(@LabEntry_json_Detail != '{}')
							BEGIN
								EXEC Grading.usp_WebService_LabInward_TransferEntry_Insert
									 @transferEntry_json_Detail = @LabEntry_json_Detail;
						END;

						--========================================= Weight Loss Entry =========================================

						--================================weight loss dept transfer entry==================================
						DECLARE @transferEntry_json_Detail VARCHAR(MAX)= N'{}';
						
						SET @transaction_type_code= Master.getTransactionTypeCode('transfer');
						
						--========================================== weight loss Dept Transfer Entry===========================================
						--========================================== Color Dept Transfer Entry===========================================
						SET @transfer_number = (SELECT  ISNULL(MAX(transaction_number),0)+1 FROM STransfer.TRANSACTION_DETAILS WITH (NOLOCK)  WHERE transaction_year = CONVERT(SMALLINT,@current_year))
						SET @transferEntry_json_Detail = JSON_MODIFY(@transferEntry_json_Detail, '$.transfer_detail',
						(
							SELECT @current_year transfer_year,
									--@transfer_number + CONVERT(SMALLINT, dense_rank() OVER (ORDER BY from_department_code,to_department_code)) transfer_number,
								   @transfer_number  + ROW_NUMBER() OVER (PARTITION BY @transfer_number order by from_department_code,to_department_code)transfer_number,
								   a.invoice_number,
								   a.from_department_code,
								   a.to_department_code,
								   'department transfer Lab Inward' remark,
								   @transaction_type_code transaction_type_code,
								   (@current_datetime) currentdate,
								   a.shape_code,
								   packet_amount,
								   @conversion_rate conversion_rate,
								   a.lab_carat,
								   a.party_code,
								   a.broker_code,
								   a.guarantor_code,
								   a.user_code,
								   a.stoneid_list,
								   @modified_by modified_by,
								   @modified_iplocation_id modified_iplocation_id,
								   @apps_code AS apps_code,
								   total_pcs,
								   invoice_date,
								   packet_rate
							FROM
							(
								SELECT stone.invoice_number invoice_number,
									   From_dept.department_code from_department_code,
									   To_dept.department_code to_department_code,
									   CASE
										   WHEN COUNT(DISTINCT lab.shape_code) = 1
										   THEN MIN(lab.shape_code)
										   ELSE Master.getShapeCode('MIX')
									   END AS shape_code,
									   SUM(stone.issue_carat) lab_carat,
									   SUM(rate.packet_rate * stone.issue_carat) / SUM(stone.issue_carat) packet_rate,
									   SUM(rate.packet_rate * stone.issue_carat) AS packet_amount,
									   stone.party_code,
									   stone.broker_code,
									   stone.guarantor_code,
									   stone.user_code,
									   string_agg(CAST(stone.stoneid AS nvarchar(max)),',') stoneid_list,
									   invoice_date,
									   COUNT(1) total_pcs
								FROM @inward_details_table stone
									 LEFT JOIN Packet.STONE_DETAILS trn  with(nolock) ON trn.stoneid = stone.stoneid
									 --LEFT JOIN @stoneid_with_order inv ON inv.stoneid = trn.stoneid
									 LEFT JOIN Packet.STONE_LAB_MASTER lab  with(nolock) ON lab.stoneid = trn.stoneid
																			  AND lab.certificate_code = trn.certificate_code
									 LEFT JOIN Packet.STONE_RATES rate  with(nolock) ON rate.stoneid = stone.stoneid
									 LEFT JOIN Master.STONE_DEPARTMENT_MASTER From_dept  with(nolock) ON From_dept.size_type_key = 'LABEXP'
																						   AND lab.issue_carat BETWEEN From_dept.from_size AND From_dept.to_size
																						   AND lab.color_code BETWEEN From_dept.from_color_code AND From_dept.to_color_code
									 LEFT JOIN Master.STONE_DEPARTMENT_MASTER To_dept  with(nolock) ON To_dept.size_type_key = 'LABEXP'
																						 AND stone.issue_carat BETWEEN To_dept.from_size AND To_dept.to_size
																						 AND stone.color_code BETWEEN To_dept.from_color_code AND To_dept.to_color_code
									WHERE from_dept.department_code <> to_dept.department_code
									GROUP BY From_dept.department_code,
										 To_dept.department_code,
										 stone.party_code,
										 stone.broker_code,
										 stone.guarantor_code,
										 stone.user_code,
										 invoice_date,
										 invoice_number
							) AS a FOR JSON AUTO
						));
						IF(@transferEntry_json_Detail != '{}')
							BEGIN
								EXEC Grading.usp_WebService_LabInward_TransferEntry_Insert
									 @transferEntry_json_Detail = @transferEntry_json_Detail;
						END;

					
						--========================================== Color Dept Transfer Entry ===========================================


						--========================================= Start Lab Remark ==========================================
						declare @remark_type_codes varchar(max)= (SELECT STRING_AGG(cast(remark_type_code as varchar(max)),',') remark_type_code FROM Master.REMARK_TYPE_MASTER with(nolock)
								  WHERE REMARK_TYPE_KEY in ('packet_polish_Remark','packet_symm_Remark','packet_fluo_remark'))

						IF EXISTS (
							select 1 from Packet.STONE_LAB_REMARKS dest with(nolock)
							inner join @inward_details_table sou on dest.stoneid = sou.stoneid AND dest.certificate_code = @certificate_code
							where source_type_code in (select value from string_split(@remark_type_codes,','))
							AND dest.stoneid=sou.stoneid
							AND certificate_code = @certificate_code
						)
						begin
							update dest
							set
							is_active = 0,
							dest.modified_datetime = @current_datetime,
							dest.modified_by = @modified_by,
							dest.modified_iplocation_id = @modified_iplocation_id,
							dest.apps_code = @apps_code
							from Packet.STONE_LAB_REMARKS dest WITH(NOLOCK)
							inner join @inward_details_table sou on dest.stoneid = sou.stoneid AND dest.certificate_code = @certificate_code
							where source_type_code in (select value from string_split(@remark_type_codes,','))
							AND dest.stoneid=sou.stoneid
							AND certificate_code = @certificate_code
						end


						MERGE INTO Packet.STONE_LAB_REMARKS dest
						USING
						(
							SELECT stoneid,
								   stone_remark,
								   source_type_code
							FROM
							(
								SELECT stoneid,
									   polish_features AS stone_remark,
									   Master.getRemarkCode('packet_polish_Remark') AS source_type_code
								FROM @inward_details_table inw
								UNION ALL
								SELECT stoneid,
									   symmetry_features AS stone_remark,
									   Master.getRemarkCode('packet_symm_Remark') AS source_type_code
								FROM @inward_details_table inw
								UNION ALL
								SELECT stoneid,
									   fluorescence_color AS stone_remark,
									   Master.getRemarkCode('packet_fluo_remark') AS source_type_code
								FROM @inward_details_table inw
							) remarks
							WHERE ISNULL(remarks.stone_remark, '') <> ''
						) sou
						ON dest.stoneid = sou.stoneid
						   AND dest.stone_remark = sou.stone_remark
						   AND dest.source_type_code = sou.source_type_code
						   AND dest.certificate_code = @certificate_code
							WHEN NOT MATCHED
							THEN
							  INSERT(stoneid,
									 stone_remark,
									 source_type_code,
									 certificate_code,
									 apps_code,
									 created_by,
									 created_datetime,
									 created_iplocation_id,is_active)
							  VALUES
						(sou.stoneid,
						 sou.stone_remark,
						 sou.source_type_code,
						 @certificate_code,
						 @apps_code,
						 @modified_by,
						 @current_datetime,
						 @modified_iplocation_id,1
						)
							WHEN MATCHED
							THEN UPDATE SET dest.is_active=1,
											dest.modified_datetime = @current_datetime,
											dest.modified_by = @modified_by,
											dest.modified_iplocation_id = @modified_iplocation_id,
											dest.apps_code = @apps_code;




						--========================================= End Lab Remark =============================================
						--========================================= Start Lab Comment ==========================================

						DECLARE @comment_json VARCHAR(MAX)= '', @comment_type_key VARCHAR(50)= 'lab_comment';
						SET @comment_json =
						(
							SELECT stoneid,
								   comment_name,
								   display_order
							FROM
							(
								SELECT slr.stoneid,
									   ISNULL(ISNULL(NULLIF(LEFT(Value, 1), ''), '') + STUFF(Value, 1, 1, ''), '') AS comment_name,
								   ROW_NUMBER() OVER (PARTITION BY slr.stoneid order by slr.stoneid) AS display_order
								FROM @inward_details_table inw
									 LEFT JOIN Packet.STONE_LAB_RESULT slr  with(nolock) ON inw.stone_lab_result_id = slr.stone_lab_result_id
									 OUTER APPLY STRING_Split(slr.report_comments, '.') comment_name
								WHERE slr.stoneid IS NOT NULL
							
							) AS a FOR JSON AUTO
						);
						EXEC Grading.usp_Stone_Comment_Upsert
							 @comment_json,
							 @certificate_code,
							 @comment_type_key,
							 @modified_by,
							 @modified_iplocation_id,
							 @apps_code,
							 @current_datetime;

						--========================================= End Lab Comment ============================================
						--========================================= Start Key To Symbol Comment ================================

						SET @comment_json = '';
						SET @comment_type_key = 'key_to_symbol';
						SET @comment_json =
						(
							SELECT stoneid,
								   comment_name,
								   display_order
							FROM
							(
								SELECT slr.stoneid,
									   commentDetails.comment_name AS comment_name,
									   ROW_NUMBER() OVER (PARTITION BY slr.stoneid order by slr.stoneid) AS display_order
								FROM @inward_details_table inw
									 LEFT JOIN Packet.STONE_LAB_RESULT slr WITH(NOLOCK) ON inw.stone_lab_result_id = slr.stone_lab_result_id
									 OUTER APPLY
								(
									SELECT TRIM(value) AS comment_name
									FROM STRING_SPLIT(slr.key_to_symbols, ',')
								) commentDetails
								WHERE  slr.stoneid IS NOT NULL -- and ISNULL(commentDetails.comment_name, '') <> ''

							) temp FOR JSON AUTO
						);
						EXEC Grading.usp_Stone_Comment_Upsert
							 @comment_json,
							 @certificate_code,
							 @comment_type_key,
							 @modified_by,
							 @modified_iplocation_id,
							 @apps_code,
							 @current_datetime;

						--========================================= Start Auto Color & Clarity Comment ==========================================

						SELECT stone.stoneid, lab.color_code, graderStoneLab.color_sign, stone.color_code lab_color_code
						into #cte_color_details
						FROM @inward_details_table stone
						LEFT JOIN Packet.STONE_DETAILS trn  with(nolock) ON stone.stoneid = trn.stoneid
						LEFT JOIN Packet.STONE_LAB_MASTER lab  with(nolock) ON trn.stoneid = lab.stoneid AND trn.certificate_code = lab.certificate_code
						LEFT JOIN
						(
							SELECT gslm.stoneid,
								   gslm.certificate_code,
								   gslm.color_sign,
								   ROW_NUMBER() OVER(partition BY gslm.stoneid, gslm.certificate_code ORDER BY isnull(modified_datetime,gslm.created_datetime) DESC) AS row_id
							FROM Packet.GRADER_STONE_LAB_MASTER gslm WITH(NOLOCK)
							WHERE stoneid in (select stoneid from @inward_details_table)-- AND gslm.certificate_code = @certificate_code
						) graderStoneLab ON trn.stoneid = graderStoneLab.stoneid AND trn.certificate_code = graderStoneLab.certificate_code AND graderStoneLab.row_id = 1


						SELECT stone.stoneid, lab.clarity_code, graderStoneLab.lab_clarity_sign, stone.clarity_code lab_clarity_code
						into #cte_clarity_details
						FROM @inward_details_table stone
						LEFT JOIN Packet.STONE_DETAILS trn  with(nolock) ON stone.stoneid = trn.stoneid
						LEFT JOIN Packet.STONE_LAB_MASTER lab with(nolock)  ON trn.stoneid = lab.stoneid AND trn.certificate_code = lab.certificate_code
						LEFT JOIN
						(
							SELECT gslm.stoneid,
								   gslm.certificate_code,
								   gslm.lab_clarity_sign,
								  ROW_NUMBER() OVER(partition BY gslm.stoneid, gslm.certificate_code ORDER BY isnull(modified_datetime,gslm.created_datetime) DESC) AS row_id
							FROM Packet.GRADER_STONE_LAB_MASTER gslm WITH(NOLOCK)
							WHERE stoneid in (select stoneid from @inward_details_table)-- AND gslm.certificate_code = @certificate_code
						) graderStoneLab ON trn.stoneid = graderStoneLab.stoneid AND trn.certificate_code = graderStoneLab.certificate_code AND graderStoneLab.row_id = 1




						--========================================= End Auto Clarity Comment ==========================================


						--========================================= End Key To Symbol Comment ==================================

						MERGE INTO Packet.STONE_LAB_MASTER dest
						USING
						(
							SELECT  inw.invoice_date, inw.invoice_number,inw.control_number,inw.stoneid,inw.issue_carat,inw.shape_code,inw.clarity_code,
									inw.certificate_number, inw.polish_code,inw.color_code,inw.cut_code,inw.symmetry_code,inw.floro_code,
									inw.crown_angle,inw.crown_height,inw.pavilion_height,inw.pavilion_angle,
									inw.girdle,inw.height,inw.tabled,inw.total_depth,inw.star_length,inw.lower_half,certificate_date,inw.document_number,
									inw.diameter_length,inw.diameter_width,inw.diameter_ratio,
									inw.from_girdle_code,inw.to_girdle_code,key_to_symbol,inw.lab_location_code,party_code,guarantor_code,user_code,broker_code,final_dollar_amount,final_rs_amount,
									inw.upload_id,inw.is_without_bill,inw.polish_features,inw.symmetry_features,inw.color_descriptions,inw.fluorescence_color,inw.shape_desc,inw.job_number,
									clarity_sign.lab_clarity_sign,
									col_sign.lab_color_sign,
									CASE WHEN inw.issue_carat >= 1.00 THEN convert(numeric(8,2),(dollar/nullif(inw.issue_carat,0))) ELSE dollar END dollar,
								   dept.department_code stone_department_code,inw.is_inscription_allowed
							  FROM @inward_details_table inw
								 LEFT JOIN Master.DOLLAR_MASTER dm  with(nolock) ON inw.issue_carat BETWEEN dm.from_carat AND dm.to_carat
								 LEFT JOIN Master.STONE_DEPARTMENT_MASTER dept  with(nolock) ON inw.issue_carat BETWEEN dept.from_size AND dept.to_size
																				  AND dept.size_type_key = 'LABEXP'
																				  AND inw.color_code BETWEEN dept.from_color_code AND dept.to_color_code
								LEFT JOIN
								(

									select stone.stoneid,max(lcd.lab_color_sign) lab_color_sign
									FROM #cte_color_details stone
									LEFT JOIN Master.LAB_COLOR_DETAILS lcd  with(nolock) ON lcd.color_code = stone.color_code
									AND ((stone.color_sign IS NULL AND lcd.color_sign IS NULL) OR (lcd.color_sign = stone.color_sign)) AND lcd.lab_color_code = stone.lab_color_code AND is_active = 1 AND certificate_code = @certificate_code
									where ((stone.color_sign IS NULL AND lcd.color_sign IS NULL) OR (lcd.color_sign = stone.color_sign))
										AND lcd.lab_color_code = stone.lab_color_code AND is_active = 1 AND certificate_code = @certificate_code
									group by stoneid

								)col_sign on col_sign.stoneid = inw.stoneid
								left join
								(
									select stone.stoneid,max(lcd.lab_clarity_sign) lab_clarity_sign
									FROM #cte_clarity_details stone
									LEFT JOIN Master.LAB_CLARITY_DETAILS lcd with(nolock)  ON lcd.clarity_code = stone.clarity_code AND ((stone.lab_clarity_sign IS NULL AND lcd.clarity_sign IS NULL) OR (lcd.clarity_sign = stone.lab_clarity_sign))
										AND lcd.lab_clarity_code = stone.lab_clarity_code AND is_active = 1 AND lcd.certificate_code = @certificate_code
									where  ((stone.lab_clarity_sign IS NULL AND lcd.clarity_sign IS NULL) OR (lcd.clarity_sign = stone.lab_clarity_sign))
									AND lcd.lab_clarity_code = stone.lab_clarity_code AND lcd.is_active = 1 AND lcd.certificate_code = @certificate_code
									group by stoneid
								)clarity_sign on clarity_sign.stoneid = inw.stoneid
								--where ((col_sign.stoneid = inw.stoneid ) or( clarity_sign.stoneid = inw.stoneid ))
						) Sou
						ON dest.stoneid = Sou.stoneid
						   AND dest.certificate_code = @certificate_code
							WHEN NOT MATCHED
							THEN
							  INSERT(stoneid, certificate_code, shape_code, issue_carat, clarity_code, certificate_number, color_code, cut_code, polish_code, symmetry_code,
									fluorescence_code, crown_angle, crown_height, pavilion_height, pavilion_angle, diameter_length, diameter_width, girdle, height, tabled,
									total_depth, star_length, lower_half, created_by, created_datetime, created_iplocation_id, document_number, apps_code, diameter_ratio,
									from_girdle_code, to_girdle_code, operation_remark, lab_dollar,stone_department_code,color_sign,is_inscription_allowed)
							VALUES(stoneid, @certificate_code, shape_code, issue_carat, clarity_code, certificate_number, color_code, cut_code, polish_code, symmetry_code,
								floro_code, crown_angle, crown_height, pavilion_height, pavilion_angle, diameter_length, diameter_width, girdle, height, tabled, total_depth,
								star_length, lower_half, @modified_by, @current_datetime, @modified_iplocation_id, document_number, @apps_code, diameter_ratio,
								sou.from_girdle_code, sou.to_girdle_code, @operation_remark, dollar,stone_department_code,lab_color_sign,is_inscription_allowed)
							WHEN MATCHED
							THEN UPDATE SET
											dest.shape_code = sou.shape_code,
											dest.issue_carat = sou.issue_carat,
											dest.clarity_code = sou.clarity_code,
											dest.certificate_number = sou.certificate_number,
											dest.color_code = sou.color_code,
											dest.cut_code = sou.cut_code,
											dest.polish_code = sou.polish_code,
											dest.symmetry_code = sou.symmetry_code,
											dest.fluorescence_code = sou.floro_code,
											dest.crown_angle = sou.crown_angle,
											dest.crown_height = sou.crown_height,
											dest.pavilion_height = sou.pavilion_height,
											dest.pavilion_angle = sou.pavilion_angle,
											dest.diameter_length = sou.diameter_length,
											dest.diameter_width = sou.diameter_width,
											dest.girdle = sou.girdle,
											dest.height = sou.height,
											dest.tabled = sou.tabled,
											dest.total_depth = sou.total_depth,
											dest.star_length = sou.star_length,
											dest.lower_half = sou.lower_half,
											dest.document_number = sou.document_number,
											dest.modified_datetime = @current_datetime,
											dest.modified_by = @modified_by,
											dest.modified_iplocation_id = @modified_iplocation_id,
											dest.apps_code = @apps_code,
											dest.lab_clarity_sign = sou.lab_clarity_sign,
											dest.color_sign = lab_color_sign,
											dest.diameter_ratio = sou.diameter_ratio,
											dest.from_girdle_code = sou.from_girdle_code,
											dest.to_girdle_code = sou.to_girdle_code,
											dest.operation_remark = @operation_remark,
											dest.lab_dollar = dollar,
											dest.stone_department_code = sou.stone_department_code,
											dest.is_inscription_allowed = sou.is_inscription_allowed;


			
				--==============================Insert SGS & MFG comment nt in other lab================
						SELECT lab_comment_id,stoneid,SLCOM.certificate_code ,SLCOM.comment_id,comment_name,comment_type_key,com.is_active,SLCOM.display_order
						into #stone_lab_comment
						from Packet.STONE_LAB_COMMENTS SLCOM with(nolock)
						left JOIN master.stone_comment_master com   WITH(NOLOCK)  ON SLCOM.certificate_code =  com.certificate_code
								AND SLCOM.comment_id = com.comment_id
						WHERE stoneid in (select stoneid from  @inward_details_table inw)
						and SLCOM.is_active =1
						and comment_type_key in('sgs_comment','mfg_lab_comment')

						MERGE INTO Packet.STONE_LAB_COMMENTS dest
						USING(
						SELECT  slm.stoneid,slm.certificate_code, slcom.comment_id,
								case when isnull(comment.display_order,0) = 0
								then convert(bigint,ROW_NUMBER() OVER (PARTITION BY slm.stoneid,slm.certificate_code,SLCOM.comment_type_key order by slm.stoneid,slm.certificate_code,SLCOM.comment_type_key))
								else comment.display_order end display_order
								--display_order + ROW_NUMBER() OVER (PARTITION BY slm.stoneid,slm.certificate_code,slcom.comment_type_key order by slm.stoneid) AS  display_order1
							FROM
							(
								select stoneid ,comment_name,comment_type_key,max(isnull(display_order,0)) display_order
								from #stone_lab_comment
								group by  stoneid ,comment_name,comment_type_key
							) comment
							LEFT JOIN packet.STONE_LAB_MASTER slm with(nolock) ON slm.stoneid = comment.stoneid
							left JOIN master.stone_comment_master SLCOM WITH(NOLOCK)  ON --SLCOM.stoneid=@p_stoneid AND
																	SLCOM.certificate_code =  slm.certificate_code
																	AND SLCOM.comment_name = comment.comment_name
																	AND comment.comment_type_key = SLCOM.comment_type_key
							left join
							(
								select stoneid ,certificate_code,comment_id,comment_type_key, display_order
								from #stone_lab_comment
								)lab_comment on  lab_comment.stoneid=slm.stoneid   AND lab_comment.comment_id = SLCOM.comment_id
								and SLCOM.certificate_code =  lab_comment.certificate_code
							WHERE comment.comment_type_key in('sgs_comment','mfg_lab_comment')
							and lab_comment.comment_id is null
						) sou ON dest.stoneid = sou.stoneid AND dest.comment_id = sou.comment_id AND dest.certificate_code = sou.certificate_code
						WHEN MATCHED THEN
						UPDATE SET
							dest.is_active = 1,
							dest.modified_datetime = @current_datetime,
							dest.modified_by = @modified_by,
							dest.modified_iplocation_id = @modified_iplocation_id,
							dest.apps_code = @apps_code,
							dest.display_order = sou.display_order
						WHEN NOT MATCHED BY TARGET THEN
						INSERT(stoneid, certificate_code, comment_id, created_datetime, created_by, created_iplocation_id, apps_code, is_active,display_order)
						VALUES(sou.stoneid, certificate_code, sou.comment_id, @current_datetime, @modified_by, @modified_iplocation_id, @apps_code, 1,display_order);

						--==============================Insert SGS & MFG comment from lab inward in all lab================
						SELECT stoneid ,SLCOM.certificate_code,comment_type_key,SLCOM.display_order,SLCOM.comment_id
						into #lab_comment
						from packet.stone_lab_comments SLCOM with(nolock)
						left JOIN master.stone_comment_master com   WITH(NOLOCK)  ON SLCOM.certificate_code =  com.certificate_code
							AND SLCOM.comment_id = com.comment_id
						WHERE stoneid in (select stoneid from  @inward_details_table inw)
						and SLCOM.is_active =1
						and comment_type_key in('sgs_comment','mfg_lab_comment')

						MERGE INTO Packet.STONE_LAB_COMMENTS dest
							USING(
							select slm.stoneid,slm.certificate_code, c.comment_id,c.comment_name,c.comment_type_key,
								isnull(lab_comment.display_order,0)+ROW_NUMBER() OVER (PARTITION BY slm.stoneid,slm.certificate_code,c.comment_type_key order by slm.stoneid,slm.certificate_code,c.comment_type_key) display_order
							from (
									select stoneid,comment_name,comment_type_key
									from (
									select stone.stoneid,certificate_code,lccd.comment_id --,comment_name,comment_type_key
										FROM #cte_color_details stone
										LEFT JOIN Master.LAB_COLOR_DETAILS lcd with(nolock)  ON lcd.color_code = stone.color_code
											AND ((isnull(stone.color_sign,0) =0 AND isnull(lcd.color_sign,0) =0) OR (lcd.color_sign = stone.color_sign))
											AND lcd.lab_color_code = stone.lab_color_code AND is_active = 1 AND certificate_code = @certificate_code
										LEFT OUTER JOIN master.lab_color_comment_details lccd  with(nolock) ON lccd.lab_color_id = lcd.lab_color_id
										where  ((isnull(stone.color_sign,0) =0 AND isnull(lcd.color_sign,0) =0) OR (lcd.color_sign = stone.color_sign))
											AND lcd.lab_color_code = stone.lab_color_code AND lcd.is_active = 1 AND lcd.certificate_code = @certificate_code
									union all
									select stone.stoneid,certificate_code,lccd.comment_id --, lccd.comment_id,comment_name
									FROM #cte_clarity_details stone
									LEFT JOIN Master.LAB_CLARITY_DETAILS lcd with(nolock)  ON lcd.clarity_code = stone.clarity_code
										AND ((isnull(stone.lab_clarity_sign,0)=0 AND isnull(lcd.clarity_sign,0)=0) OR (lcd.clarity_sign = stone.lab_clarity_sign))
										AND lcd.lab_clarity_code = stone.lab_clarity_code AND is_active = 1 AND lcd.certificate_code = @certificate_code
									LEFT OUTER JOIN master.lab_clarity_comment_details lccd with(nolock)  ON lccd.lab_clarity_id = lcd.lab_clarity_id
									where   ((isnull(stone.lab_clarity_sign,0)=0 AND isnull(lcd.clarity_sign,0)=0) OR (lcd.clarity_sign = stone.lab_clarity_sign))
										AND lcd.lab_clarity_code = stone.lab_clarity_code AND lcd.is_active = 1 AND lcd.certificate_code = @certificate_code
										and lccd.lab_clarity_id = lcd.lab_clarity_id
									)as lab_com
									left join master.stone_comment_master com with(nolock) on com.comment_id = lab_com.comment_id and com.certificate_code= lab_com.certificate_code
									where comment_type_key in ('sgs_comment','mfg_lab_comment')
									group by stoneid,comment_name,comment_type_key

								)as lccd
								left join packet.stone_lab_master slm with(nolock) on slm.stoneid = lccd.stoneid
								left join master.stone_comment_master c  with(nolock) on c.comment_name = lccd.comment_name and lccd.comment_type_key = c.comment_type_key
								and c.certificate_code = slm.certificate_code
								left join
								(
									select stoneid ,certificate_code,comment_type_key,max(display_order) display_order
									from #lab_comment
									group by stoneid ,certificate_code,comment_type_key
								)lab_comment on  lab_comment.stoneid=lccd.stoneid   AND lab_comment.comment_type_key = c.comment_type_key
									and c.certificate_code =  lab_comment.certificate_code
								left join #lab_comment main_c on slm.stoneid=main_c.stoneid   AND main_c.comment_id = c.comment_id
									and c.certificate_code =  main_c.certificate_code
								and main_c.comment_id is null
								and lccd.comment_type_key = c.comment_type_key
				) sou ON dest.stoneid = sou.stoneid AND dest.comment_id = sou.comment_id AND dest.certificate_code = sou.certificate_code
						WHEN MATCHED AND (dest.is_active = 0 OR dest.is_active IS NULL) THEN
						UPDATE SET
							dest.is_active = 1,
							dest.modified_datetime = @current_datetime,
							dest.modified_by = @modified_by,
							dest.modified_iplocation_id = @modified_iplocation_id,
							dest.apps_code = @apps_code
							--dest.display_order = sou.display_order
						WHEN NOT MATCHED THEN
						INSERT(stoneid, certificate_code, comment_id, created_datetime, created_by, created_iplocation_id, apps_code, is_active,display_order)
						VALUES(sou.stoneid, sou.certificate_code, sou.comment_id, @current_datetime, @modified_by, @modified_iplocation_id, @apps_code, 1,sou.display_order);
				--==============================Insert SGS & MFG comment from lab inward in all lab================

				--========================================= Nishit Langaliya ==========================================

				select stoneid
					,case
						when fluorescence_color like '%Yellow%' THEN 'YELLOW FLUORESCENCE'
						when fluorescence_color like '%White%' THEN 'WHITE FLUORESCENCE'
						when fluorescence_color like '%green%' THEN 'GREEN FLUORESCENCE'
						when fluorescence_color like '%Red%' THEN 'RED FLUORESCENCE'
						when fluorescence_color like '%Orange%' THEN 'ORANGE FLUORESCENCE'
					end as fluorescence_color
				into #fluorescence_color_table
				from @inward_details_table
				where fluorescence_color in ( 'Yellow','White','green','Red','Orange')

				select l.stoneid ,s.comment_id,s.certificate_code, c.comment_type_key, s.display_order--l.stoneid,fluorescence_color,lab_comment_id
				into #main
				from #fluorescence_color_table l with(nolock)
				left join Packet.STONE_LAB_COMMENTS s with(nolock) on s.stoneid = l.stoneid
				left join master.STONE_COMMENT_MASTER c with(nolock) on c.comment_id = s.comment_id 
				where comment_type_key in ( 'sgs_comment','mfg_lab_comment')
				order by comment_type_key,s.display_order

				INSERT INTO Packet.STONE_LAB_COMMENTS(
					stoneid,certificate_code,comment_id,apps_code,created_datetime,created_by,created_iplocation_id,is_active,display_order
				)
				select s.stoneid,c.certificate_code,c.comment_id,@apps_code,@current_datetime,@modified_by,@modified_iplocation_id,1
					,isnull(d.display_order,0) + ROW_NUMBER() OVER (PARTITION BY slm.stoneid,slm.certificate_code,c.comment_type_key order by slm.stoneid,slm.certificate_code,c.comment_type_key) display_order
				from #fluorescence_color_table s with(nolock)
				left join Packet.STONE_LAB_MASTER slm with(nolock) on slm.stoneid = s.stoneid
				left join master.STONE_COMMENT_MASTER c with(nolock) on c.comment_name = s.fluorescence_color and c.certificate_code = slm.certificate_code 
					and comment_type_key in ('sgs_comment','mfg_lab_comment')
				left join #main as main with(nolock) on main.stoneid = s.stoneid and main.certificate_code = slm.certificate_code and main.comment_id = c.comment_id
				left join
				(
					select stoneid ,certificate_code,comment_type_key,max(display_order) display_order
					from #main
					group by stoneid ,certificate_code,comment_type_key
				)d on d.stoneid = s.stoneid AND d.comment_type_key = c.comment_type_key and d.certificate_code = slm.certificate_code
				where main.comment_id IS NULL
				

				--==================================================================================================================

						--===============================grader_sign=========================

					
						SELECT distinct stoneid
						into #lab_inc
						FROM packet.STONE_LAB_INCLUSIONS a  with(nolock)
						WHERE a.stoneid in (select stoneid from @inward_details_table)
						and a.certificate_code = @certificate_code

						IF EXISTS (SELECT 1 FROM Packet.STONE_LAB_INCLUSIONS inc  with(nolock)
										inner join @inward_details_table gia_inc on gia_inc.stoneid = inc.stoneid and @certificate_code = inc.certificate_code
										where inc.inclusion_type_code = @ginc_type_code)
						BEGIN
							UPDATE inc
							SET inc.inclusion_code = gia_inc.inclusion_code,
								inc.inclusion_visibility_code=null,
								inc.inclusion_location_code = null,
								inc.inclusion_percentage =null,
								inc.inclusion_visibility_percentage =null,
								inc.inclusion_location_percentage=null,
								inc.inclusion_factor_percentage=null,
								inc.modified_datetime=@current_datetime,
								inc.modified_by=@modified_by,
								inc.modified_iplocation_id=@modified_iplocation_id,
								inc.apps_code = @apps_code
							FROM @inward_details_table gia_inc
							left join Packet.STONE_LAB_INCLUSIONS inc with(nolock) on gia_inc.stoneid = inc.stoneid  and  inc.certificate_code =@certificate_code
							where gia_inc.stoneid = inc.stoneid  and  inc.certificate_code =@certificate_code and inc.inclusion_type_code = @ginc_type_code
						END

					    BEGIN
							INSERT INTO Packet.STONE_LAB_INCLUSIONS
							(stoneid, certificate_code, inclusion_type_code, inclusion_sequence_code, inclusion_code, inclusion_visibility_code, inclusion_location_code,
							inclusion_percentage,inclusion_visibility_percentage,inclusion_location_percentage,inclusion_factor_percentage,created_datetime,	created_by,created_iplocation_id, apps_code)

						SELECT inc.stoneid, @certificate_code certificate_code,
							 @ginc_type_code inclusion_type_code, 0 inclusion_sequence_code,inclusion_code,
							null inclusion_visibility_code,null inclusion_location_code ,
							null inclusion_percentage,null inclusion_visibility_percentage,null inclusion_location_percentage,null inclusion_factor_percentage ,@current_datetime,@modified_by,@modified_iplocation_id,@apps_code
						from #lab_inc inc
						left join @inward_details_table gia_inc on gia_inc.stoneid = inc.stoneid
						where inc.stoneid not in
						(	select stoneid from Packet.STONE_LAB_INCLUSIONS inc with(nolock) where stoneid in (select stoneid from #lab_inc)
							and certificate_code = @certificate_code and inc.inclusion_type_code = @ginc_type_code
						)
						END



						IF exists(select 1 from @inward_details_table where stoneid not in (select stoneid from #lab_inc))
						BEGIN
							INSERT INTO Packet.STONE_LAB_INCLUSIONS
							(stoneid, certificate_code, inclusion_type_code, inclusion_sequence_code, inclusion_code, inclusion_visibility_code, inclusion_location_code,
							inclusion_percentage,inclusion_visibility_percentage,inclusion_location_percentage,inclusion_factor_percentage,created_datetime,	created_by,created_iplocation_id, apps_code)

							select stoneid, certificate_code,inclusion_type_code, inclusion_sequence_code, inclusion_code,inclusion_visibility_code,inclusion_location_code ,
								inclusion_percentage, inclusion_visibility_percentage, inclusion_location_percentage, inclusion_factor_percentage,
								@current_datetime, @modified_by, @modified_iplocation_id, @apps_code
							from (
							SELECT s.stoneid, @certificate_code certificate_code,
								 inclusion_type_code, inclusion_sequence_code,case when i.inclusion_type_code = @ginc_type_code then s.inclusion_code else i.inclusion_code end inclusion_code,
								case when i.inclusion_type_code = @ginc_type_code then null else inclusion_visibility_code end inclusion_visibility_code,
								case when i.inclusion_type_code = @ginc_type_code then null else inclusion_location_code end inclusion_location_code ,
								case when i.inclusion_type_code = @ginc_type_code then null else inclusion_percentage end inclusion_percentage,
								case when i.inclusion_type_code = @ginc_type_code then null else inclusion_visibility_percentage end inclusion_visibility_percentage,
								case when i.inclusion_type_code = @ginc_type_code then null else inclusion_location_percentage end inclusion_location_percentage,
								case when i.inclusion_type_code = @ginc_type_code then null else inclusion_factor_percentage end inclusion_factor_percentage --,@current_datetime,@modified_by,@modified_iplocation_id,@apps_code
							FROM @inward_details_table s
							LEFT JOIN packet.STONE_DETAILS sd  with(nolock) ON sd.stoneid = s.stoneid
							LEFT JOIN packet.STONE_LAB_INCLUSIONS i  with(nolock) ON sd.stoneid = i.stoneid and sd.certificate_code= i.certificate_code
							where inclusion_type_code IS NOT NULL
							union
							SELECT s.stoneid, @certificate_code certificate_code,
								 @ginc_type_code inclusion_type_code, 0 inclusion_sequence_code,inclusion_code,
								null inclusion_visibility_code,null inclusion_location_code ,
								null inclusion_percentage,null inclusion_visibility_percentage,null inclusion_location_percentage,null inclusion_factor_percentage --,@current_datetime,@modified_by,@modified_iplocation_id,@apps_code
							FROM @inward_details_table s
							) as s
							WHERE s.stoneid NOT IN (select stoneid from #lab_inc)
							group by stoneid, certificate_code,inclusion_type_code, inclusion_sequence_code, inclusion_code,inclusion_visibility_code,inclusion_location_code ,
								inclusion_percentage, inclusion_visibility_percentage, inclusion_location_percentage, inclusion_factor_percentage

						END



						--=================================graing inc added========================================

						if exists (select 1 from packet.stone_rates WITH(NOLOCK) where stoneid in (select stoneid from @inward_details_table))
						begin

							update rate
							set
							rate.lab_dollar = CASE WHEN stone.issue_carat >= 1.00 THEN convert(numeric(8,2),(dollar/nullif(stone.issue_carat,0))) ELSE dollar END ,
							rate.modified_datetime = @current_datetime,
							rate.modified_by = @modified_by,
							rate.modified_iplocation_id = @modified_iplocation_id,
							rate.apps_code = @apps_code
							from @inward_details_table stone
							LEFT JOIN packet.stone_rates rate WITH(NOLOCK) on rate.stoneid = stone.stoneid
							LEFT JOIN master.dollar_master d WITH(NOLOCK) on stone.issue_carat BETWEEN from_carat AND to_carat
							where isnull(rate.lab_dollar,0) = 0
							AND rate.stoneid IS NOT NULL
						end

						--============================update stone Details ================================
					
						select stones.stoneid,
							Grading.usp_fn_LabInward_ActiveCertificate_Check(stones.stoneid, @certificate_code, stones.issue_carat, stones.color_code, stones.clarity_code, stones.floro_code) AS is_active_certi,
							stones.control_number
						into #update_stone_details
						from @inward_details_table stones
						

						update trn
						set trn.certificate_code = case when isnull(is_active_certi,0) = 1 then @certificate_code else trn.certificate_code end,
							trn.operation_remark = @operation_remark,
							trn.control_number = u.control_number,
							trn.rfid_tag = u.control_number,
							trn.modified_datetime = @current_datetime,
							trn.modified_by = @modified_by,
							trn.modified_iplocation_id = @modified_iplocation_id,
							trn.apps_code = @apps_code
						FROM #update_stone_details u
						left join Packet.STONE_DETAILS trn WITH(NOLOCK) on u.stoneid = trn.stoneid


						--========================================================================================================





					IF EXISTS (SELECT 1 FROM @inward_details_table stone
									LEFT JOIN Packet.STONE_DETAILS trn  with(nolock) ON trn.stoneid = stone.stoneid WHERE trn.stoneid = stone.stoneid and certificate_code <> @certificate_code)
					begin

					--========================================= Weight Loss Entry ==========================================
                        SET @transfer_number =
                        (
                            SELECT ISNULL(MAX(transaction_number), 0)
                            FROM STransfer.TRANSACTION_DETAILS with(nolock)
                            WHERE transaction_year = CONVERT(SMALLINT, @current_year)
                        );
                        SET @transaction_type_code = Master.getTransactionTypeCode('loss');
                       
                        SET @LabEntry_json_Detail = JSON_MODIFY(@LabEntry_json_Detail, '$.transfer_detail',
                        (
                            SELECT @current_year transfer_year, 
                                   @transfer_number + CONVERT(SMALLINT, ROW_NUMBER() OVER(
                                   ORDER BY stone.stoneid)) transfer_number, 
                                   (@current_datetime) currentdate, 
                                   @transaction_type_code transaction_type_code, 
                                   CASE WHEN(stone.issue_carat > lab.issue_carat) THEN @Dept_Weight_Loss ELSE To_dept.department_code END to_department_code,
                                   CASE WHEN(stone.issue_carat > lab.issue_carat) THEN To_dept.department_code ELSE @Dept_Weight_Loss END from_department_code, 
                                   'Live lab weightloss - Lab Inward' remark, 
                                   stone.invoice_number invoice_number, 
                                   abs(stone.issue_carat - lab.issue_carat) AS lab_carat, 
                                   stone.shape_code, 
                                   1 packet_rate, 
                                   (1 * stone.issue_carat) AS packet_amount, 
                                   @modified_by modified_by, 
                                   @modified_iplocation_id modified_iplocation_id, 
                                   stone.stoneid stoneid_list, 
                                   1 total_pcs, 
                                   @apps_code AS apps_code, 
                                   invoice_date
                            FROM @inward_details_table stone
                                 LEFT JOIN Packet.STONE_DETAILS trn with(nolock) ON stone.stoneid = trn.stoneid
                                 LEFT JOIN Packet.STONE_LAB_MASTER lab with(nolock) ON trn.stoneid = lab.stoneid
                                                                          AND trn.certificate_code = lab.certificate_code
                                 LEFT JOIN Packet.STONE_RATES rate with(nolock) ON stone.stoneid = rate.stoneid
                                 LEFT JOIN Master.STONE_DEPARTMENT_MASTER To_dept with(nolock) ON To_dept.size_type_key = 'LABEXP'
                                                                                     AND stone.issue_carat BETWEEN To_dept.from_size AND To_dept.to_size
                                                                                     AND stone.color_code BETWEEN To_dept.from_color_code AND To_dept.to_color_code
                            WHERE stone.issue_carat <> lab.issue_carat 
							and trn.stoneid = stone.stoneid and trn.certificate_code <> @certificate_code
							FOR JSON AUTO
                        ));
                        IF(@LabEntry_json_Detail != '{}')
                        BEGIN
                                EXEC Grading.usp_WebService_LabInward_TransferEntry_Insert 
                                     @transferEntry_json_Detail = @LabEntry_json_Detail;
                        END;

                        --========================================= Weight Loss Entry =========================================
                       

					--========================================color transfer entry=========================================================
						SET @transfer_number = (  SELECT ISNULL(MAX(transaction_number), 0) + 1  FROM STransfer.TRANSACTION_DETAILS WITH(NOLOCK) WHERE transaction_year = CONVERT(SMALLINT, @current_year));
						SET @transaction_type_code = Master.getTransactionTypeCode('transfer');
						SET @transferEntry_json_Detail = JSON_MODIFY(@transferEntry_json_Detail, '$.transfer_detail',
						(
							SELECT @current_year transfer_year,
								  @transfer_number  + ROW_NUMBER() OVER (PARTITION BY @transfer_number order by from_department_code,to_department_code)transfer_number,
								   a.invoice_number,
								   a.from_department_code,
								   a.to_department_code,
								   'Live Lab Transfer Entry' remark,
								   @transaction_type_code transaction_type_code,
								   ( @current_datetime) currentdate,
								   a.shape_code,
								   packet_amount,
								   @conversion_rate conversion_rate,
								   a.lab_carat,
								   a.party_code,
								   a.broker_code,
								   a.guarantor_code,
								   a.user_code,
								   a.stoneid_list,
								   @modified_by modified_by,
								   @modified_iplocation_id modified_iplocation_id,
								   @apps_code AS apps_code,
								   total_pcs,
								   invoice_date,
								   packet_rate
							FROM
							(
								SELECT stone.invoice_number invoice_number,
									   From_dept.department_code from_department_code,
									   To_dept.department_code to_department_code,
									   CASE
										   WHEN COUNT(DISTINCT lab.shape_code) = 1
										   THEN MIN(lab.shape_code)
										   ELSE Master.getShapeCode('MIX')
									   END AS shape_code,
									   SUM(lab.issue_carat) lab_carat,
									   SUM(rate.packet_rate * lab.issue_carat) / SUM(lab.issue_carat) packet_rate,
									   SUM(rate.packet_rate * lab.issue_carat) AS packet_amount,
									   stone.party_code,
									   stone.broker_code,
									   stone.guarantor_code,
									   stone.user_code,
									   string_agg(CAST(stone.stoneid AS nvarchar(max)),',') stoneid_list,
									   invoice_date,
									   COUNT(1) total_pcs
								FROM @inward_details_table stone
									 LEFT JOIN Packet.STONE_DETAILS trn  with(nolock) ON trn.stoneid = stone.stoneid
								     LEFT JOIN Packet.STONE_LAB_MASTER lab  with(nolock) ON lab.stoneid = trn.stoneid
																			  AND lab.certificate_code = trn.certificate_code
									 LEFT JOIN Packet.STONE_RATES rate  with(nolock) ON rate.stoneid = stone.stoneid
									 LEFT JOIN Master.STONE_DEPARTMENT_MASTER From_dept  with(nolock) ON From_dept.size_type_key = 'LABEXP'
																						   AND stone.issue_carat BETWEEN From_dept.from_size AND From_dept.to_size
																						   AND stone.color_code BETWEEN From_dept.from_color_code AND From_dept.to_color_code
									 LEFT JOIN Master.STONE_DEPARTMENT_MASTER To_dept  with(nolock) ON To_dept.size_type_key = 'LABEXP'
																						 AND lab.issue_carat BETWEEN To_dept.from_size AND To_dept.to_size
																						 AND lab.color_code BETWEEN To_dept.from_color_code AND To_dept.to_color_code
								WHERE 1 = 1
									  AND from_dept.department_code <> to_dept.department_code
									  and trn.stoneid = stone.stoneid and trn.certificate_code <> @certificate_code
								GROUP BY From_dept.department_code, To_dept.department_code, stone.party_code,stone.broker_code,stone.guarantor_code,stone.user_code,invoice_date,invoice_number
							) AS a FOR JSON AUTO
						));
						IF(@transferEntry_json_Detail != '{}')
							BEGIN
								EXEC Grading.usp_WebService_LabInward_TransferEntry_Insert
									 @transferEntry_json_Detail = @transferEntry_json_Detail;
							END;

						----========================================carat transfer entry=========================================================
						
						end

						UPDATE slr
						  SET
							  slr.is_data_inwarded = 1,
							  slr.data_inwarded_datetime =  @current_datetime ,
							  slr.modified_datetime = @current_datetime,
							  slr.modified_by = @modified_by,
							  slr.modified_iplocation_id = @modified_iplocation_id,
							  slr.apps_code = @apps_code
						FROM @inward_details_table idt
						LEFT JOIN Packet.STONE_LAB_RESULT slr WITH(NOLOCK) ON idt.upload_id = slr.upload_id
						WHERE slr.upload_id = idt.upload_id;
					
					if  exists (select 1 from stock.Stone_certification_details scd with(nolock)
					left join @inward_details_table inw on inw.stoneid=scd.stoneid
					WHERE  from_department_code = @D_STOCK_DEPARTMENT_CODE AND to_department_code = @D_STOCK_DEPARTMENT_CODE AND scd.stoneid =inw.stoneid AND
					scd.certificate_number =inw.certificate_number)
					begin
					 
						
							UPDATE scd
							SET  
							scd.certificate_verify = CAST(0 AS BIT),
							scd.certificate_outward_verify = CAST(0 AS BIT),
							scd.certificate_verify_datetime = NULL,
							scd.certificate_confirm_datetime = NULL,
							scd.certificate_confirm_user_code = NULL,
							scd.modified_datetime=@current_datetime,
							scd.modified_by=@modified_by,
							scd.modified_iplocation_id=@modified_iplocation_id
							
							from stock.Stone_certification_details scd 
							left join @inward_details_table inw on inw.stoneid=scd.stoneid					 
							WHERE  from_department_code = @D_STOCK_DEPARTMENT_CODE AND 
							to_department_code = @D_STOCK_DEPARTMENT_CODE 
							AND scd.stoneid =inw.stoneid AND  
							scd.certificate_number =inw.certificate_number
						End

					if  exists (select 1 from @inward_details_table inw where not exists (select 1 from 
				stock.Stone_certification_details scd with(nolock)
					WHERE  from_department_code = @D_STOCK_DEPARTMENT_CODE AND 
					to_department_code = @D_STOCK_DEPARTMENT_CODE AND scd.stoneid =inw.stoneid AND
					scd.certificate_number =inw.certificate_number))
					BEGIN
						INSERT INTO stock.Stone_certification_details
						(stoneid,
						 certificate_code,
						 certificate_number,
						 certificate_verify,
						 certificate_outward_verify,
						 certificate_issue_datetime,
						 from_department_code,
						 to_department_code,
						 remark,
						 created_by,
						 created_iplocation_id,
						 Certification_Status_id,
						 is_certificate_active,action_code
						)
							   SELECT inw.stoneid,
									  @certificate_code,
									  inw.certificate_number,
									  0,
									  0,
									  @current_datetime,
									  @D_STOCK_DEPARTMENT_CODE,
									  @D_STOCK_DEPARTMENT_CODE,
									  'lab inward',
									  @modified_by,
									  @modified_iplocation_id,
									  master.getcertificatestatuscode('certificate_inward'),
									  1,@action_id
							   FROM @inward_details_table inw 
							   left join stock.Stone_certification_details sd on sd.stoneid = inw.stoneid
							   where not exists(select 1 from stock.Stone_certification_details scd with(nolock)
												WHERE  from_department_code = @D_STOCK_DEPARTMENT_CODE AND 
												to_department_code = @D_STOCK_DEPARTMENT_CODE 
												AND scd.stoneid =inw.stoneid 
												AND scd.certificate_number =inw.certificate_number)
					
						End

				END;
			END ;
			
			--======================== IF BILL INWARDED================================================
			IF EXISTS(SELECT 1 FROM OPENJSON(@inward_details) AS inw
						LEFT JOIN Packet.STONE_LAB_RESULT slr WITH(NOLOCK) ON slr.upload_id=CONVERT(int,JSON_VALUE(inw.value, '$.upload_id'))
						WHERE CONVERT(BIT,JSON_VALUE(inw.value, '$.is_bill')) = 1 AND isnull(slr.is_bill_inwarded,0) = 0)
					BEGIN
						DECLARE @bill_inward_details_table TABLE
						(invoice_date        DATE,
						 invoice_number      VARCHAR(50),
						 control_number      VARCHAR(50),
						 stoneid             BIGINT,
						 issue_carat         NUMERIC(8, 2),
						 color_code          INT,
						 lab_location_code   INT,
						 party_code          INT,
						 guarantor_code      INT,
						 user_code           INT,
						 broker_code         INT,
						 final_dollar_amount NUMERIC(8, 2),
						 final_rs_amount     NUMERIC(8, 2),
						 upload_id           INT
						);
						INSERT INTO @bill_inward_details_table
						(invoice_date,
						 invoice_number,
						 control_number,
						 stoneid,
						 issue_carat,
						 color_code,
						 lab_location_code,
						 party_code,
						 guarantor_code,
						 user_code,
						 broker_code,
						 final_dollar_amount,
						 final_rs_amount,
						 upload_id
						)
							   SELECT slr.invoice_date,
									  slr.invoice_number,
									  slr.control_number,
									  trn.stoneid,
									  slr.weight AS issue_carat,
									  color_code,
									  slr.lab_location_code,
									  null as party_code,
									  null as guarantor_code,
									  null as user_code,
									  null as broker_code,
									  (amount.final_amount_dollar + ISNULL(slr.handling_charges_dollar, 0) + ISNULL(slr.handling_charges_cgst_dollar, 0) + ISNULL(slr.handling_charges_sgst_dollar, 0) + ISNULL(slr.shipping_charges_dollar, 0) + ISNULL(slr.shipping_charges_cgst_dollar, 0) + ISNULL(slr.shipping_charges_sgst_dollar, 0)) AS final_dollar_amount,
									  (amount.final_amount_rs + ISNULL(slr.handling_charges_rs, 0) + ISNULL(slr.handling_charges_cgst_rs, 0) + ISNULL(slr.handling_charges_sgst_rs, 0) + ISNULL(slr.shipping_charges_rs, 0) + ISNULL(slr.shipping_charges_cgst_rs, 0) + ISNULL(slr.shipping_charges_sgst_rs, 0)) AS final_rs_amount,
									  slr.upload_id
							   FROM OPENJSON(@inward_details) AS inw
									LEFT JOIN Packet.STONE_LAB_RESULT slr  with(nolock) ON CONVERT(int,JSON_VALUE(inw.value, '$.upload_id')) = slr.upload_id
									LEFT JOIN Packet.STONE_DETAILS trn with(nolock)  ON slr.client_reference = trn.stoneid
									LEFT JOIN Packet.STONE_LAB_MASTER lab  with(nolock) ON trn.stoneid = lab.stoneid
																			 AND trn.certificate_code = lab.certificate_code
									--LEFT JOIN Packet.STONE_PARTY_TRANSACTIONS spt with(nolock)  ON trn.stoneid = spt.stoneid
									OUTER APPLY
							   (
								   SELECT SUM(slrs.lab_service_fee_dollar + slrs.lab_service_fee_cgst_dollar + slrs.lab_service_fee_sgst_dollar) AS final_amount_dollar,
										  SUM(slrs.lab_service_fee_rs + slrs.lab_service_fee_cgst_rs + slrs.lab_service_fee_sgst_rs) AS final_amount_rs
								   FROM Packet.STONE_LAB_RESULT_SERVICES slrs with(nolock)
								   WHERE slrs.stone_lab_result_id = slr.stone_lab_result_id
								   GROUP BY slrs.stone_lab_result_id
							   ) amount
							   WHERE isnull(is_bill_inwarded,0) = 0 AND CONVERT(BIT,JSON_VALUE(inw.value, '$.is_bill')) = 1
									 AND slr.is_without_bill = 0 AND slr.is_data_inwarded = 1;

						DECLARE @transaction_number BIGINT, @transaction_year VARCHAR(4);
						SELECT @transaction_year = configuration_value FROM Master.CONFIGURATION_MASTER with(nolock) WHERE configuration_key = 'SRK_CURRENT_YEAR';
						SELECT @transaction_number = ISNULL(MAX(transaction_number), 0) FROM Packet.STONE_LAB_EXPENSE with(nolock) WHERE transaction_year = @transaction_year;

						INSERT INTO Packet.STONE_LAB_EXPENSE
						(transaction_number,
						 transaction_year,
						 transaction_date,
						 certificate_code,
						 lab_expense_type_code,
						 bill_date,
						 lab_location_code,
						 invoice_number,
						 party_code,
						 guarantor_code,
						 user_code,
						 shipping_dollar_rate,
						 shipping_rupees_rate,
						 transportation_dollar_rate,
						 transportation_rupees_rate,
						 discount_percentage,
						 credit_dollar_amount,
						 credit_rupees_amount,
						 final_dollar_amount,
						 final_rupees_amount,
						 conversion_rate,
						 apps_code,
						 created_by,
						 created_iplocation_id,
						 stoneid_list
						)
							   SELECT(@transaction_number + CONVERT(SMALLINT, ROW_NUMBER() OVER(
									  ORDER BY party_code,
											   guarantor_code,
											   user_code,
											   invoice_number,
											   invoice_date))) transaction_number,
									 @transaction_year transaction_year,
									 CONVERT(DATE, @current_datetime),
									 @certificate_code certificate_code,
									 (CASE
										  WHEN ISNULL(party_code, 0) <> 0
										  THEN @party
										  ELSE @srk
									  END) lab_expense_type_code,
									 stone.invoice_date bill_date,
									 stone.lab_location_code lab_location_code,
									 stone.invoice_number,
									 party_code,
									 guarantor_code,
									 user_code,
									 0 shipping_dollar_rate,
									 0 shipping_rupees_rate,
									 0 transportation_dollar_rate,
									 0 transportation_rupees_rate,
									 0 discount_percentage,
									 0 credit_dollar_amount,
									 0 credit_rupees_amount,
									 SUM(stone.final_dollar_amount) AS final_dollar_amount,
									 SUM(stone.final_rs_amount) AS final_rs_amount,
									 @conversion_rate conversion_rate,
									 @apps_code,
									 @modified_by,
									 @modified_iplocation_id,
									 string_agg(CAST(stone.stoneid AS nvarchar(max)),',')
							   FROM @bill_inward_details_table stone
							   GROUP BY party_code,
										guarantor_code,
										user_code,
										invoice_number,
										invoice_date,
										lab_location_code;

		
						INSERT INTO Packet.DEPARTMENTWISE_LAB_EXPENSE
						(transaction_number,
						 transaction_year,
						 department_code,
						 total_pcs,
						 total_carat,
						 total_dollar_amount,
						 total_rupees_amount,
						 apps_code,
						 created_by,
						 created_iplocation_id
						)
							   SELECT(@transaction_number + CONVERT(SMALLINT, ROW_NUMBER() OVER(PARTITION BY dept.department_code,@transaction_year
									  ORDER BY party_code,
											   guarantor_code,
											   user_code))) transaction_number,
									 @transaction_year transaction_year,
									 dept.department_code,
									 COUNT(1) total_pcs,
									 SUM(issue_carat) total_carat,
									 SUM(stone.final_dollar_amount) total_dollar_amount,
									 SUM(stone.final_rs_amount) total_rupees_amount,
									 @apps_code,
									 @modified_by,
									 @modified_iplocation_id
							   FROM @bill_inward_details_table stone
									LEFT JOIN Master.STONE_DEPARTMENT_MASTER dept with(nolock)  ON issue_carat BETWEEN dept.from_size AND dept.to_size
																					 AND dept.size_type_key = 'LABEXP'
																					 AND color_code BETWEEN dept.from_color_code AND dept.to_color_code
							   WHERE issue_carat BETWEEN dept.from_size AND dept.to_size
									 AND dept.size_type_key = 'LABEXP'
									 AND color_code BETWEEN dept.from_color_code AND dept.to_color_code
							   GROUP BY dept.department_code,
										party_code,
										guarantor_code,
										user_code,
										invoice_number,
										invoice_date;

						
						INSERT INTO Packet.LAB_EXPENSE_STONE_DETAILS
						(transaction_number,
						 transaction_year,
						 stoneid,
						 apps_code,
						 created_by,
						 created_iplocation_id,
						 amount_dollar,
						 amount_rs,
						 tax_percentage,
						 discount_percentage,
						 credit_dollar,
						 credit_rs,
						 final_amount_dollar,
						 final_amount_rs,
						 remark
						)
							   SELECT sle.transaction_number,
									  @transaction_year transaction_year,
									  stoneid,
									  @apps_code,
									  @modified_by,
									  @modified_iplocation_id,
									  0 AS amount_dollar,
									  0 AS amount_rs,
									  0 tax_percentage,
									  0 discount_percentage,
									  0 AS credit_dollar,
									  0 AS credit_rs,
									  stone.final_dollar_amount,
									  stone.final_rs_amount,
									  '' remark
							   FROM @bill_inward_details_table stone
									INNER JOIN Packet.STONE_LAB_EXPENSE sle with(nolock)  ON stone.invoice_number = sle.invoice_number
																			   AND stone.invoice_date = sle.bill_date
																			   AND ISNULL(stone.party_code, 0) = ISNULL(sle.party_code, 0)
																			   AND ISNULL(stone.guarantor_code, 0) = ISNULL(sle.guarantor_code, 0)
																			   AND ISNULL(stone.user_code, 0) = ISNULL(sle.user_code, 0);



						
						update i
						set i.is_bill_inwarded = 1
						FROM @bill_inward_details_table inw
						LEFT JOIN Grading.LAB_INWARD_DETAILS inward  with(nolock) ON inw.invoice_date = inward.invoice_date
																AND ISNULL(inw.invoice_number, 0) = ISNULL(inward.invoice_number, 0)
						LEFT JOIN Grading.lab_inward_stone_details i WITH(NOLOCK) on i.inward_id = inward.inward_id
						where inw.invoice_date = inward.invoice_date
							AND ISNULL(inw.invoice_number, 0) = ISNULL(inward.invoice_number, 0)
							and i.inward_id = inward.inward_id
						

						UPDATE slr
						  SET
							  slr.is_bill_inwarded = 1,
							  slr.bill_inwarded_datetime =  @current_datetime ,
							  slr.modified_datetime = @current_datetime,
							  slr.modified_by = @modified_by,
							  slr.modified_iplocation_id = @modified_iplocation_id,
							  slr.apps_code = @apps_code
						FROM @bill_inward_details_table idt
						LEFT JOIN Packet.STONE_LAB_RESULT slr WITH(NOLOCK) ON idt.upload_id = slr.upload_id
						WHERE slr.upload_id = idt.upload_id;

				END;

			
			/*
				-----------------------------------------------------
			*/
				  
			/* 
			Insert Audit table form details
			*/

			INSERT INTO [Audit].[OP_REMARKS_HISTORY]([STONEID],[HISTORY_DATETIME],[OP_REMARKS],[PAGE_NAME],[CREATED_BY],[CREATED_IP_LOCATION],[APPS_CODE])
			select	stoneid,@current_datetime,@operation_remark,'GIA - Lab Inward Form' ,@modified_by ,@modified_iplocation_id,@apps_code
			from @stoneid


				--EXEC [dbo].[LOGINFO] @ProcedureName = @PROCNAME, @LogType = 'INFO', @ErrorLine = NULL, @ErrorMessage = NULL, @ExecutedBy = NULL, @HostIPName = '', @FormName = '', @AdditionalInfo = 'EXCEUTION END';

			COMMIT TRANSACTION;
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION;
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorLine = ERROR_LINE(), @ErrorState = ERROR_STATE();
				EXEC [dbo].[LOGINFO]
					 @ProcedureName = 'Grading.usp_labinward_gia_upsert',@LogType = 'INFO',@ErrorLine = @ErrorLine, @ErrorMessage = @ErrorMessage, @ExecutedBy = NULL, @HostIPName = '', @FormName = '', @AdditionalInfo = 'CATCH BLOCK 1';
				SELECT @ErrorMessage AS 'error_msg', @ErrorState 'error_state', @ErrorSeverity 'error_severity';
			END CATCH;
		END TRY
		BEGIN CATCH
			SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorLine = ERROR_LINE(), @ErrorState = ERROR_STATE();
			-- EXECUTION ERROR LOG
			EXEC [dbo].[LOGINFO] @ProcedureName = 'Grading.usp_labinward_gia_upsert',@LogType = 'INFO',@ErrorLine = @ErrorLine,@ErrorMessage = @ErrorMessage,@ExecutedBy = NULL,@HostIPName = '',@FormName = '',@AdditionalInfo = 'CATCH BLOCK 2';
			--RAISERROR (@ErrorMessage,@ErrorState,@ErrorSeverity);
			SELECT @ErrorMessage AS 'error_msg', @ErrorState 'error_state', @ErrorSeverity 'error_severity';
	END CATCH;
END
GO