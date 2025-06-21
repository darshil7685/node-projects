SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER             PROCEDURE [Grading].[usp_LabInward_Upsert]
@lab_stone_result_Json VARCHAR(MAX) ='',
@is_without_grading BIT=0,
@certificate_code SMALLINT=0,
@invoice_date DATE = '',
@invoice_number VARCHAR(16) = '',
@lab_location_code SMALLINT = 0,
@shipping_dollar_rate NUMERIC(10,3) = 0,
@shipping_rupees_rate NUMERIC(10,3) = 0,
@transport_dollar_rate NUMERIC(10,3) = 0,
@transport_rupees_rate NUMERIC(10,3) = 0,
@apps_code tinyint=0,	
@modified_by smallint=0,
@modified_iplocation_id int=0,

@action_id INT,
--@tablevar_stone_details_bl_update_v2 Stock.TABLEVAR_STONE_DETAILS_BL_UPDATE_V2 READONLY,
@form_name varchar(128) = NULL,
@origin  varchar(128) =  NULL,
@comment_Json varchar(max) =''
--@inward_certificate varchar(16) = ''  --HRD,IGI,GIA
as
BEGIN


		--- EXCEUTION LOG ---
		--DECLARE @PROCNAME VARCHAR(50) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)
		--EXEC [dbo].[LOGINFO] @ProcedureName = @PROCNAME,@LogType = 'INFO',@ErrorLine = NULL,@ErrorMessage = NULL,@ExecutedBy = NULL,@HostIPName = '',@FormName = '',@AdditionalInfo = 'EXCEUTION STARTED'
    	
		DECLARE @shape_code_rbc smallint =  (SELECT sm.shape_code FROM Master.SHAPE_MASTER sm with(nolock) WHERE sm.shape_code_key IN ('RBC'))
		DECLARE @shape_code varchar(128) =  (SELECT STRING_AGG(sm.shape_code,',') FROM Master.SHAPE_MASTER sm  with(nolock) WHERE sm.shape_code_key IN ('RBC','HB','TRI','OT'))
        declare @operation_remark varchar(max) = 'Lab Inward Certificate Update'   
		DECLARE @srk_certificate TINYINT= Master.getCertificateCode('SRK');
		Declare @transaction_year VARCHAR(4)
		SELECT @transaction_year = configuration_value FROM Master.CONFIGURATION_MASTER  with(nolock) WHERE configuration_key = 'SRK_CURRENT_YEAR' 
		declare @certi_name varchar(24) = (select certificate_short_name from master.CERTIFICATE_MASTER with(nolock) where certificate_code  = @certificate_code)
		
		DECLARE @transfer_number SMALLINT = (SELECT  ISNULL(MAX(transaction_number),0) FROM STransfer.TRANSACTION_DETAILS with(nolock)  WHERE transaction_year = CONVERT(SMALLINT,@transaction_year))

		DECLARE @lab_inward_details table
		( 
			inward_id smallint,broker_code bigint,party_code bigint,user_code bigint,amount_dollar numeric(10,3),amount_rs numeric(10,3),tax_percentage numeric(10,3),
			discount_percentage numeric(10,3),credit_dollar numeric(10,3),credit_rs numeric(10,3),final_amount_dollar numeric(10,3),final_amount_rs numeric(10,3),remark varchar(1024),
			stoneid bigint, reference_number varchar(64),document_number varchar(64),shape_code smallint,issue_carat numeric(10,3),clarity_code tinyint,certificate_number varchar(16),
			color_code tinyint,cut_code tinyint,polish_code tinyint,symmetry_code tinyint,fluorescence_code tinyint,crown_angle numeric(10,3),
			crown_height numeric(10,3),pavilion_height numeric(10,3),pavilion_angle numeric(10,3),diameter_length numeric(10,3),diameter_width numeric(10,3),
			girdle numeric(10,3),height numeric(10,3),tabled numeric(10,3),total_depth numeric(10,3),star_length numeric(10,3),lower_half numeric(10,3),
			lab_comment_code int,certificate_date date,from_girdle_code smallint,to_girdle_code smallint,
			gridle_description varchar(512),heart_arrow varchar(64), guarantor_code BIGINT,
			lab_comment_remarks varchar(512),lab_comment_extra_info varchar(512),shape_description varchar(254),  validation_message varchar(512), serial_number smallint,
			is_inscription_allowed bit
		)
		
		INSERT INTO @lab_inward_details
		(
			inward_id,broker_code,party_code,user_code,amount_dollar,amount_rs,tax_percentage,discount_percentage,credit_dollar,credit_rs,
			final_amount_dollar,final_amount_rs,remark,stoneid,reference_number,document_number,shape_code,
			issue_carat,clarity_code,certificate_number,color_code,cut_code,polish_code,symmetry_code,fluorescence_code,
			crown_angle,crown_height,pavilion_height,pavilion_angle,girdle,star_length,lower_half,height,tabled,total_depth,diameter_length,diameter_width,--diameter_ratio,
			lab_comment_code,certificate_date,from_girdle_code,
			to_girdle_code,gridle_description,heart_arrow,guarantor_code,lab_comment_remarks,
			lab_comment_extra_info,shape_description,validation_message, serial_number,is_inscription_allowed
		)
		SELECT JSON_VALUE(Value,'$.inward_id') inward_id,JSON_VALUE(Value,'$.broker_code') broker_code,
			JSON_VALUE(Value,'$.party_code') party_code,JSON_VALUE(Value,'$.user_code') user_code,
			JSON_VALUE(Value,'$.amount_dollar') amount_dollar,JSON_VALUE(Value,'$.amount_rs') amount_rs,
			JSON_VALUE(Value,'$.tax_percentage') tax_percentage,JSON_VALUE(Value,'$.discount_percentage') discount_percentage,
			JSON_VALUE(Value,'$.credit_dollar_amount') credit_dollar,JSON_VALUE(Value,'$.credit_rupees_amount') credit_rs,
			JSON_VALUE(Value,'$.final_dollar_amount') final_amount_dollar,JSON_VALUE(Value,'$.final_rupees_amount') final_amount_rs,JSON_VALUE(Value,'$.remark') remark,
			JSON_VALUE(Value,'$.stoneid') stoneid,JSON_VALUE(Value,'$.reference_number') reference_number, JSON_VALUE(Value,'$.document_number') document_number, 
			JSON_VALUE(Value,'$.shape_code') shape_code,JSON_VALUE(Value,'$.issue_carat') issue_carat, JSON_VALUE(Value,'$.clarity_code') clarity_code, 
			JSON_VALUE(Value,'$.certificate_number') certificate_number,JSON_VALUE(Value,'$.color_code') color_code,
			CASE WHEN ((JSON_VALUE(Value,'$.cut_code') is null) or (JSON_VALUE(Value,'$.cut_code')='')) then slm.cut_code else JSON_VALUE(Value,'$.cut_code') end as cut_code,
			JSON_VALUE(Value,'$.polish_code') polish_code,JSON_VALUE(Value,'$.symmetry_code') symmetry_code, JSON_VALUE(Value,'$.fluorescence_code') fluorescence_code,

			CASE WHEN (JSON_VALUE(Value,'$.crown_angle') IS NULL OR JSON_VALUE(Value,'$.crown_angle') = '') THEN slm.crown_angle ELSE JSON_VALUE(Value,'$.crown_angle') END crown_angle, 
			CASE WHEN (JSON_VALUE(Value,'$.crown_height') IS NULL OR JSON_VALUE(Value,'$.crown_height') = '') THEN slm.crown_height ELSE JSON_VALUE(Value,'$.crown_height') END crown_height, 
			CASE WHEN (JSON_VALUE(Value,'$.pavilion_height') IS NULL OR JSON_VALUE(Value,'$.pavilion_height') = '') THEN slm.pavilion_height ELSE JSON_VALUE(Value,'$.pavilion_height') END pavilion_height, 
			CASE WHEN (JSON_VALUE(Value,'$.pavilion_angle') IS NULL OR JSON_VALUE(Value,'$.pavilion_angle') = '') THEN slm.pavilion_angle ELSE JSON_VALUE(Value,'$.pavilion_angle') END pavilion_angle, 
			CASE WHEN CAST(ISNULL(JSON_VALUE(Value,'$.girdle'), 0) AS NUMERIC(8, 2)) <> 0 THEN CAST(ISNULL(JSON_VALUE(Value,'$.girdle'), 0) AS NUMERIC(8, 2)) ELSE slm.girdle END  AS girdle,
			CASE WHEN (JSON_VALUE(Value,'$.star_length') IS NULL OR JSON_VALUE(Value,'$.star_length') = '') THEN slm.star_length ELSE JSON_VALUE(Value,'$.star_length') END star_length, 
			CASE WHEN (JSON_VALUE(Value,'$.lower_half') IS NULL OR JSON_VALUE(Value,'$.lower_half') = '') THEN slm.lower_half ELSE JSON_VALUE(Value,'$.lower_half') END lower_half, 
			CASE WHEN (JSON_VALUE(Value,'$.height') IS NULL OR JSON_VALUE(Value,'$.height') = '') THEN slm.height ELSE JSON_VALUE(Value,'$.height') END height, 
			CASE WHEN (JSON_VALUE(Value,'$.tabled') IS NULL OR JSON_VALUE(Value,'$.tabled') = '') THEN slm.tabled ELSE JSON_VALUE(Value,'$.tabled') END tabled, 
			CASE WHEN (JSON_VALUE(Value,'$.total_depth') IS NULL OR JSON_VALUE(Value,'$.total_depth') = '') THEN slm.total_depth ELSE JSON_VALUE(Value,'$.total_depth') END total_depth, 
			
			--JSON_VALUE(Value,'$.crown_angle') crown_angle,JSON_VALUE(Value,'$.crown_height') crown_height, JSON_VALUE(Value,'$.pavilion_height') pavilion_height,JSON_VALUE(Value,'$.pavilion_angle') pavilion_angle,
			--CASE WHEN(JSON_VALUE(Value,'$.shape_code') in( @Shape_code,@Shape_Code_heart,@Shape_Code_tri)) THEN JSON_VALUE(Value,'$.diameter_length') ELSE JSON_VALUE(Value,'$.diameter_width') END AS diameter_length,
   --         CASE WHEN(JSON_VALUE(Value,'$.shape_code') in( @Shape_code,@Shape_Code_heart,@Shape_Code_tri)) THEN JSON_VALUE(Value,'$.diameter_width') ELSE JSON_VALUE(Value,'$.diameter_length') END AS diameter_width,
			
			CASE WHEN(slm.shape_code in(SELECT value FROM string_split(@shape_code,','))) THEN (CASE WHEN cast(JSON_VALUE(Value,'$.diameter_length') as numeric(10,3)) < JSON_VALUE(Value,'$.diameter_width') THEN cast(JSON_VALUE(Value,'$.diameter_length')as numeric(10,3))  ELSE cast(JSON_VALUE(Value,'$.diameter_width')as numeric(10,3)) END)
                ELSE (CASE WHEN cast(JSON_VALUE(Value,'$.diameter_length') as numeric(10,3)) > cast(JSON_VALUE(Value,'$.diameter_width')  as numeric(10,3)) THEN cast(JSON_VALUE(Value,'$.diameter_length') as numeric(10,3)) ELSE cast(JSON_VALUE(Value,'$.diameter_width')as numeric(10,3)) END) END AS diameter_length,
            CASE WHEN(slm.shape_code in(SELECT value FROM string_split(@shape_code,','))) THEN (CASE WHEN cast( JSON_VALUE(Value,'$.diameter_length') as numeric(10,3)) > cast(JSON_VALUE(Value,'$.diameter_width') as numeric(10,3)) THEN cast(JSON_VALUE(Value,'$.diameter_length')as numeric(10,3)) ELSE JSON_VALUE(Value,'$.diameter_width') END)
                ELSE (CASE WHEN cast(JSON_VALUE(Value,'$.diameter_length')  as numeric(10,3)) < cast(JSON_VALUE(Value,'$.diameter_width') as numeric(10,3)) THEN cast(JSON_VALUE(Value,'$.diameter_length') as numeric(10,3)) ELSE cast(JSON_VALUE(Value,'$.diameter_width')as numeric(10,3)) END) END AS diameter_width,

			--CASE WHEN(JSON_VALUE(Value,'$.shape_code') in(SELECT value FROM string_split(@shape_code,','))) THEN (CASE WHEN JSON_VALUE(Value,'$.diameter_length') < JSON_VALUE(Value,'$.diameter_width') THEN JSON_VALUE(Value,'$.diameter_length') ELSE JSON_VALUE(Value,'$.diameter_width') END) 
			--	ELSE (CASE WHEN JSON_VALUE(Value,'$.diameter_length') > JSON_VALUE(Value,'$.diameter_width') THEN JSON_VALUE(Value,'$.diameter_length') ELSE JSON_VALUE(Value,'$.diameter_width') END) END AS diameter_length,
   --         CASE WHEN(JSON_VALUE(Value,'$.shape_code') in(SELECT value FROM string_split(@shape_code,','))) THEN (CASE WHEN JSON_VALUE(Value,'$.diameter_length') > JSON_VALUE(Value,'$.diameter_width') THEN JSON_VALUE(Value,'$.diameter_length') ELSE JSON_VALUE(Value,'$.diameter_width') END) 
			--	ELSE (CASE WHEN JSON_VALUE(Value,'$.diameter_length') < JSON_VALUE(Value,'$.diameter_width') THEN JSON_VALUE(Value,'$.diameter_length') ELSE JSON_VALUE(Value,'$.diameter_width') END) END AS diameter_width,
			
			--CASE WHEN (JSON_VALUE(Value,'$.shape_code') = @shape_code_rbc) THEN ((CAST(JSON_VALUE(Value,'$.diameter_width') as NUMERIC(10,3)) + CAST(JSON_VALUE(Value,'$.diameter_length') as NUMERIC(10,3))) / 2)
			--	ELSE (CAST(JSON_VALUE(Value,'$.diameter_length') AS NUMERIC(10,3)) / CAST(JSON_VALUE(Value,'$.diameter_width') AS NUMERIC(10,3))) END diameter_ratio,
			
			--CASE WHEN(JSON_VALUE(Value,'$.shape_code') in(@shape_code_rbc)) THEN ((CAST(JSON_VALUE(Value,'$.diameter_width') as NUMERIC(10,3)) + CAST(JSON_VALUE(Value,'$.diameter_length') as NUMERIC(10,3))) / 2)
			--	ELSE (cast((CASE WHEN JSON_VALUE(Value,'$.diameter_length') > JSON_VALUE(Value,'$.diameter_width') THEN JSON_VALUE(Value,'$.diameter_length') ELSE JSON_VALUE(Value,'$.diameter_width') END) AS numeric(10,3)) / 
			--			cast((CASE WHEN JSON_VALUE(Value,'$.diameter_length') < JSON_VALUE(Value,'$.diameter_width') THEN JSON_VALUE(Value,'$.diameter_length') ELSE JSON_VALUE(Value,'$.diameter_width') END) AS numeric(10,3))) END diameter_ratio,
			

			JSON_VALUE(Value,'$.lab_comment_code') lab_comment_code,
			JSON_VALUE(Value,'$.certificate_date') certificate_date,
			convert(smallint,JSON_VALUE(Value,'$.from_girdle_code')) from_girdle_code,
			convert(smallint,JSON_VALUE(Value,'$.to_girdle_code')  ) to_girdle_code,
			JSON_VALUE(Value,'$.gridle_description') gridle_description,JSON_VALUE(Value,'$.heart_arrow') heart_arrow,
			JSON_VALUE(Value,'$.guarantor_code') guarantor_code,JSON_VALUE(Value,'$.lab_comment_remarks') lab_comment_remarks,
			JSON_VALUE(Value,'$.lab_comment_extra_info') lab_comment_extra_info,JSON_VALUE(Value,'$.shape_description') shape_description,
			case when (sd.stoneid is null) then 'Stone not found' 
				when (JSON_VALUE(Value,'$.shape_code') <> slm.shape_code) then 'Shape is miss match' 
				else '' end validation_message,
			CONVERT(SMALLINT,ROW_NUMBER() OVER (ORDER BY sd.stoneid)) serial_number,
			convert(bit,JSON_VALUE(Value,'$.is_inscription_allowed')) is_inscription_allowed
			
		FROM OPENJSON(@lab_stone_result_json,'$.lab_stone_result')  lab
		left join Packet.STONE_DETAILS sd  with(nolock) on sd.stoneid = JSON_VALUE(Value,'$.stoneid')
		left join Packet.STONE_LAB_MASTER slm  with(nolock) ON sd.stoneid = slm.stoneid AND slm.certificate_code = @srk_certificate -- slm.certificate_code
		left join Packet.STONE_PROCESSES sp with(nolock)  ON sd.stoneid = sp.stoneid AND sp.is_process_active = 1 AND sp.process_confirm_date IS NOT NULL
		left join Packet.PROCESS_MEMO_DETAILS pmd with(nolock)  ON sp.process_issue_memo_no = pmd.process_issue_memo_no AND sp.process_issue_date = pmd.process_issue_date
		left join Master.LAB_LOCATION_MASTER llm with(nolock)  ON pmd.lab_location_code = llm.lab_location_code
		WHERE JSON_VALUE(Value,'$.stoneid') IS NOT null
		
		
		if exists(Select 1
		FROM @lab_inward_details
		WHERE validation_message <> '')
		begin 
			Select stoneid,	validation_message
			FROM @lab_inward_details
			WHERE validation_message <> ''

			return;
		end
		 
		Declare @transaction_number BIGINT = isnull((SELECT MAX(transaction_number) FROM Packet.STONE_LAB_EXPENSE with(nolock)  WHERE transaction_year = @transaction_year),0)
		DECLARE @current_datetime DATETIME = Master.Fn_GetISTDATETIME()
		DECLARE @memo_date DATE=NULL,@memo_number INT=0
		Declare @LabExp varchar(16) = 'LABEXP'
		DECLARE @inward_id INT
		Declare @mix_ShapeCode tinyint = Master.getShapeCode('MIX')
		DECLARE @stoneid_with_order Stock.stoneid_with_request_transfer_detail_id
		
            
		DECLARE @srk tinyint = (SELECT lm.LABTYPE_CODE FROM Master.LABTYPE_MASTER lm with(nolock)  WHERE lm.labtype_key = 'SRK')
		DECLARE @party tinyint = (SELECT LABTYPE_CODE FROM Master.LABTYPE_MASTER lm  with(nolock) WHERE lm.labtype_key = 'PARTY')
		Declare @department_date date = (Select max(department_date) From Master.STONE_DEPARTMENT_MASTER  with(nolock) Where size_type_key = @LabExp and department_date <= @current_datetime)
		DECLARE @saletype_key smallint = (SELECT saletype_code FROM master.saletype_master  with(nolock) WHERE saletype_key = 'RS.BILL' )
		DECLARE @conversion_rate NUMERIC(8,3) = (select top 1 conversion_rate from master.CONVERSION_RATE_MASTER crm  with(nolock) where saletype_code = @saletype_key order by crm.created_datetime desc)

		DECLARE @D_STOCK_DEPARTMENT_CODE TINYINT =  Master.getDepartmentCode('D_IMS')
		DECLARE @comp_disc_dollar numeric(9,3) = 0 , @comp_disc_rs numeric(9,3) =0
		Declare @is_have_no_party bit, @is_have_party bit, @is_have_all_party bit, @count_party int,@is_discount bit
		DECLARE @transaction_type_code TINYINT

		DECLARE @transferEntry_json_Detail VARCHAR(MAX) = N'{}' 
		DECLARE @transferEntryWithColor_json_Detail VARCHAR(MAX) = N'{}' 
		DECLARE @LabEntry_json_Detail VARCHAR(MAX) = N'{}' 
		DECLARE @Dept_Weight_Loss smallint = (SELECT sdm.department_code FROM Master.STONE_DEPARTMENT_MASTER sdm  with(nolock) WHERE sdm.size_type_key = 'WL')

		INSERT INTO @stoneid_with_order (serial_number,stoneid,request_transfer_detail_id)
		SELECT serial_number, stoneid, 0 FROM @lab_inward_details
		DECLARE @stoneid AS Stock.STONEID;
        
		--INSERT INTO @stoneid(STONEID)
  --      SELECT stoneid FROM @lab_inward_details;
  --      INSERT INTO @stoneid_with_order(serial_number,stoneid, request_transfer_detail_id)
  --      SELECT CONVERT(SMALLINT, ROW_NUMBER() OVER(ORDER BY stoneid)) serial_number, CONVERT(BIGINT, stoneid),  0 FROM @stoneid;
		/*
		Get Max Process id for each stones to be outward
		*/
		DECLARE @StoneProcess AS [STOCK].[STONEID_WITH_PROCESS_ID]
		--DECLARE @StoneProcess Table(serial_number smallint, stoneid bigint, process_id bigint)
		INSERT INTO @StoneProcess (stoneid, process_id)
		SELECT Stone.stoneid, MAX(StoneProcess.process_id) 
		FROM @stoneid_with_order Stone
		LEFT JOIN Packet.STONE_PROCESSES StoneProcess  with(nolock) on StoneProcess.stoneid = Stone.stoneid
		where Stone.stoneid is not null and StoneProcess.stoneid is not null
		Group by Stone.stoneid

		
		/*--------------------------------*/


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
		BEGIN TRANSACTION T1
		--=========================Insert value in Lab Expense ===============================================
		IF exists(select 1 from @lab_inward_details where (isnull(amount_dollar,0) <> 0 or isnull(tax_percentage,0) <> 0 or isnull(discount_percentage,0) <> 0 or isnull(credit_dollar,0) <> 0 or isnull(final_amount_dollar,0) <> 0))
		--(@shipping_dollar_rate <> 0 OR @shipping_rupees_rate <> 0 OR @transport_dollar_rate <> 0 OR @transport_rupees_rate <> 0)
		BEGIN
			Select @is_have_no_party = Case When (is_have_party = 0) Then 1 Else 0 End, 
				@is_have_all_party = Case When (total_party = totalrec) Then 1 Else 0 End,
				@is_have_party = Case When (total_party <> totalrec and is_have_party = 1) Then 1 Else 0 End,
				@count_party = Case When (total_party = totalrec) Then count_party Else 0 End,@is_discount=is_discount
			From(
				Select  Count(nullif(party_code,0)) total_party, Count(1) totalrec, max(case when (isnull(party_code,0) <> 0) Then 1 else 0 end) is_have_party,	
					count(distinct party_code) count_party,sum(case when (isnull(discount_percentage,0) <> 0) Then 1 else 0 end) is_discount
				From @lab_inward_details 
			) As lid
			
			IF EXISTS (select 1 from @lab_inward_details where (isnull(party_code,0) = 0 OR isnull(party_code,0) <> 0) AND discount_percentage <> 0)	
			BEGIN
				SELECT @comp_disc_dollar = sum(final_dollar_amount), @comp_disc_rs = sum(final_rupees_amount) 
				FROM(
					SELECT 
						case when (isnull(party_code,0) <> 0) THEN (CONVERT(NUMERIC(10,3),(sum(amount_dollar) + sum(amount_dollar /100*tax_percentage))/100 *  ((sum(amount_dollar /100*stone.discount_percentage) / sum(amount_dollar))*100))) ELSE 0 end final_dollar_amount,
						case when (isnull(party_code,0) <> 0) THEN (CONVERT(NUMERIC(10,3),(sum(amount_rs) + sum(amount_rs /100*tax_percentage))/100 *  ((sum(amount_rs /100*stone.discount_percentage) / sum(amount_rs))*100))) ELSE 0 end final_rupees_amount
					FROM @lab_inward_details stone
					GROUP BY party_code,guarantor_code,user_code
				)AS det
			END
			 
			INSERT INTO Packet.STONE_LAB_EXPENSE
			(transaction_number,transaction_year,transaction_date,certificate_code,lab_expense_type_code,bill_date,lab_location_code,invoice_number,party_code,guarantor_code,
			user_code,shipping_dollar_rate,shipping_rupees_rate,transportation_dollar_rate,transportation_rupees_rate,discount_percentage,discount_dollar_amount,
			discount_rupees_amount,credit_dollar_amount,credit_rupees_amount,final_dollar_amount,final_rupees_amount,conversion_rate,apps_code,created_by,created_iplocation_id,
			stoneid_list)
			SELECT (@transaction_number + CONVERT(SMALLINT, ROW_NUMBER() OVER (ORDER BY party_code,guarantor_code,user_code))) transaction_number,
				@transaction_year transaction_year,@current_datetime transaction_date,@certificate_code certificate_code,
				(CASE WHEN isnull(party_code,0) <> 0 THEN @party ELSE @srk end) lab_expense_type_code,@invoice_date bill_date,
				@lab_location_code lab_location_code,@invoice_number invoice_number,party_code,
				guarantor_code,user_code,
				(CASE WHEN @is_have_party = 1 AND isnull(party_code,0) = 0 THEN @shipping_dollar_rate WHEN @is_have_all_party = 1 THEN @shipping_dollar_rate / @count_party ELSE 0 end) shipping_dollar_rate,
				(CASE WHEN @is_have_party = 1 AND isnull(party_code,0) = 0 THEN @shipping_rupees_rate WHEN @is_have_all_party = 1 THEN @shipping_rupees_rate / @count_party ELSE 0 end) shipping_rupees_rate,
				(CASE WHEN @is_have_party = 1 AND isnull(party_code,0) = 0 THEN @transport_dollar_rate WHEN @is_have_all_party = 1 THEN @transport_dollar_rate / @count_party ELSE 0 end)  transportation_dollar_rate,
				(CASE WHEN @is_have_party = 1 AND isnull(party_code,0) = 0 THEN @transport_rupees_rate WHEN @is_have_all_party = 1 THEN @transport_rupees_rate / @count_party ELSE 0 end) transportation_rupees_rate,
				(CASE WHEN isnull(party_code,0) <> 0 THEN ((sum(amount_dollar /100*stone.discount_percentage) / sum(amount_dollar))*100) ELSE 0 end) discount_percentage,
				CASE WHEN isnull(party_code,0) <> 0 THEN (sum(amount_dollar) + sum(amount_dollar /100*tax_percentage))/100 *  ((sum(amount_dollar /100*stone.discount_percentage) / sum(amount_dollar))*100) else 0 end discount_dollar,
				CASE WHEN isnull(party_code,0) <> 0 THEN (sum(amount_rs) + sum(amount_rs /100*tax_percentage))/100 *  ((sum(amount_rs /100*stone.discount_percentage) / sum(amount_rs))*100) ELSE 0 end discount_rs,
				sum(stone.credit_dollar) credit_dollar_amount, sum(stone.credit_rs) credit_rupees_amount,
				(CASE 
					--WHEN not exists(select 1 from @lab_inward_details where isnull(party_code,0) <> 0) 
					-- THEN sum(amount_dollar) + sum(amount_dollar /100*tax_percentage) + @shipping_dollar_rate + @transport_dollar_rate 
						WHEN @is_have_all_party = 1
						THEN (CONVERT(NUMERIC(10,3),(@shipping_dollar_rate/@count_party)+(@transport_dollar_rate/@count_party) - sum(credit_dollar)+(sum(amount_dollar) + sum(amount_dollar /100*tax_percentage)) - (sum(amount_dollar) + sum(amount_dollar /100*tax_percentage))/100 *  ((sum(amount_dollar /100*stone.discount_percentage) / sum(amount_dollar))*100)))
						WHEN (@is_have_party = 1 AND isnull(party_code,0) = 0) OR @is_have_no_party = 1
						THEN (@shipping_dollar_rate + @transport_dollar_rate - sum(credit_dollar) + sum(amount_dollar) + sum(amount_dollar /100*tax_percentage)) + @comp_disc_dollar 
						WHEN @is_have_party = 1 AND isnull(party_code,0) <> 0
						THEN (sum(amount_dollar) + sum(amount_dollar /100*tax_percentage)) - (sum(amount_dollar) + sum(amount_dollar /100*tax_percentage))/100 *  ((sum(amount_dollar /100*stone.discount_percentage) / sum(amount_dollar))*100) - sum(credit_dollar)
						ELSE 0
				END) final_dollar_amount,
				(CASE  
					--WHEN not exists(select 1 from @lab_inward_details where isnull(party_code,0) <> 0) 
					-- THEN sum(amount_rs) + sum(amount_rs /100*tax_percentage)
						WHEN @is_have_all_party = 1
						THEN (CONVERT(NUMERIC(10,3),(@shipping_dollar_rate/@count_party)+(@transport_dollar_rate/@count_party)-sum(credit_rs)+(sum(amount_rs) + sum(amount_rs /100*tax_percentage)) - (sum(amount_rs) + sum(amount_rs /100*tax_percentage))/100 *  ((sum(amount_rs /100*stone.discount_percentage) / sum(amount_rs))*100)))
						WHEN (@is_have_party = 1 AND isnull(party_code,0) = 0) OR @is_have_no_party = 1
						THEN (@shipping_dollar_rate + @transport_dollar_rate -sum(credit_rs)+ sum(amount_rs) + sum(amount_rs /100*tax_percentage)) + @comp_disc_rs
						WHEN @is_have_party = 1 AND isnull(party_code,0) <> 0
						THEN (sum(amount_rs) + sum(amount_rs /100*tax_percentage)) - (sum(amount_rs) + sum(amount_rs /100*tax_percentage))/100 *  ((sum(amount_rs /100*stone.discount_percentage) / sum(amount_rs))*100) - sum(credit_rs)
						ELSE 0
				END) final_rupees_amount,
				@conversion_rate conversion_rate,@apps_code,@modified_by,@modified_iplocation_id,string_agg(CAST(stoneid AS nvarchar(max)),',') stoneid_list
				--sum(stone.amount_dollar) amount_dollar,sum(stone.amount_rs) amount_rs,
				--sum(amount_dollar /100*tax_percentage) tax_percentage_amount,
				--((sum(amount_dollar /100*tax_percentage) / sum(amount_dollar))*100) tax_percentage,
				--sum(amount_dollar) + sum(amount_dollar /100*tax_percentage) amount_tax,
			FROM @lab_inward_details stone
			GROUP BY party_code,guarantor_code,user_code
			 
			INSERT INTO Packet.DEPARTMENTWISE_LAB_EXPENSE(transaction_number,transaction_year,department_code,total_pcs,total_carat,total_dollar_amount,total_rupees_amount,created_by,created_iplocation_id,apps_code)
			SELECT (@transaction_number + CONVERT(SMALLINT, DENSE_RANK() OVER(ORDER BY party_code,guarantor_code,user_code))) transaction_number,
					@transaction_year transaction_year,dept.department_code,COUNT(1) total_pcs,
					SUM(issue_carat) total_carat,
					SUM(amount_dollar) total_dollar_amount,
					SUM(amount_rs) total_rupees_amount,
					@modified_by,@modified_iplocation_id,@apps_code
			FROM @lab_inward_details stone
			LEFT JOIN Master.STONE_DEPARTMENT_MASTER dept with(nolock)  ON dept.size_type_key = @LabExp And department_date = @department_date
				And issue_carat BETWEEN dept.from_size AND dept.to_size AND color_code BETWEEN dept.from_color_code AND dept.to_color_code
				-- need to cehck once if department needs to be bifercate by certificate or not. (as of now not actually the needs)
				And certificate_code = 0
			WHERE dept.size_type_key is not null
			GROUP BY dept.department_code,party_code,guarantor_code,user_code	
			
			INSERT INTO Packet.LAB_EXPENSE_STONE_DETAILS(transaction_number, transaction_year, stoneid, amount_dollar, amount_rs, tax_percentage, discount_percentage, 
				credit_dollar, credit_rs, final_amount_dollar, final_amount_rs, remark, 
				created_by, created_iplocation_id, apps_code)
			SELECT stone_det.transaction_number, stone_det.transaction_year, stoneid, amount_dollar, amount_rs, tax_percentage, discount_percentage,
				credit_dollar, credit_rs, final_amount_dollar + total_ship_tra_dollar final_amount_dollar, final_amount_rs  + total_ship_tra_rs final_amount_rs, remark,
				@modified_by,@modified_iplocation_id,@apps_code
			FROM (
				SELECT @transaction_number + DENSE_RANK() OVER(ORDER BY party_code,guarantor_code,user_code) transaction_number,			 
					@transaction_year transaction_year,stoneid,amount_dollar ,amount_rs ,tax_percentage ,
					CASE WHEN isnull(party_code,0) <> 0 THEN discount_percentage ELSE 0 end discount_percentage ,
					credit_dollar ,credit_rs ,lid.final_amount_dollar, final_amount_rs ,remark
				FROM @lab_inward_details lid
			)AS stone_det
			LEFT JOIN 
			(
				SELECT sle.transaction_number,sle.transaction_year,
						--sum(total_pcs) total_Stone ,
						CASE WHEN  max(isnull(party_code,0)) = 0 THEN ((shipping_dollar_rate+sle.transportation_dollar_rate ) /sum(total_pcs)) + (@comp_disc_dollar /sum(total_pcs))
						ELSE ((shipping_dollar_rate+sle.transportation_dollar_rate ) /sum(total_pcs)) end  total_ship_tra_dollar,
						CASE WHEN  max(isnull(party_code,0)) = 0 THEN ((sle.shipping_rupees_rate+sle.transportation_rupees_rate) /sum(total_pcs)) + (@comp_disc_rs /sum(total_pcs)) 
						else ((sle.shipping_rupees_rate+sle.transportation_rupees_rate) /sum(total_pcs)) end total_ship_tra_rs
						--,max(isnull(party_code,0)) party_code
				FROM Packet.STONE_LAB_EXPENSE sle  with(nolock) 
				left join Packet.DEPARTMENTWISE_LAB_EXPENSE dle with(nolock)  ON dle.transaction_number = sle.transaction_number AND dle.transaction_year = sle.transaction_year
				GROUP BY sle.transaction_number,sle.transaction_year,shipping_dollar_rate,sle.transportation_dollar_rate,sle.shipping_rupees_rate,sle.transportation_rupees_rate
			) sle ON stone_det.transaction_number = sle.transaction_number AND stone_det.transaction_year = sle.transaction_year
	
			IF (@is_discount = 1 AND @is_have_all_party = 1) 
			BEGIN
				SELECT @transaction_number = ISNULL(MAX(transaction_number),0) FROM Packet.STONE_LAB_EXPENSE  with(nolock) WHERE transaction_year = @transaction_year

				INSERT INTO Packet.STONE_LAB_EXPENSE
				(transaction_number,transaction_year,transaction_date,certificate_code,lab_expense_type_code,bill_date,lab_location_code,invoice_number,party_code,guarantor_code,
				user_code,shipping_dollar_rate,shipping_rupees_rate,transportation_dollar_rate,transportation_rupees_rate,discount_percentage,credit_dollar_amount,
				credit_rupees_amount,final_dollar_amount,final_rupees_amount,stoneid_list,conversion_rate,remark,apps_code,created_by,created_iplocation_id,is_auto_entry)
				SELECT (@transaction_number + 1) transaction_number,
					@transaction_year transaction_year,@current_datetime,@certificate_code certificate_code,@srk lab_expense_type_code,@invoice_date bill_date,
					@lab_location_code lab_location_code,@invoice_number invoice_number, 
					null party_code,null guarantor_code,null user_code,
					
					0 shipping_dollar_rate,
					0 shipping_rupees_rate ,
					0  transportation_dollar_rate,
					0 transportation_rupees_rate,

					0 discount_percentage,
					0 credit_dollar_amount,
					0 credit_rupees_amount,
					sum(final_dollar_amount) final_dollar_amount,
					sum(final_rupees_amount) final_rupees_amount,
					string_agg(CAST( stoneid_list AS nvarchar(max)),',') stoneid_list,@conversion_rate conversion_rate,
					'disocunt of ' + @invoice_number remark,@apps_code,@modified_by,@modified_iplocation_id,1
				FROM (
					SELECT  (CONVERT(NUMERIC(10,3),(sum(amount_dollar) + sum(amount_dollar /100*tax_percentage))/100 *  ((sum(amount_dollar /100*stone.discount_percentage) / sum(amount_dollar))*100) - sum(stone.credit_dollar))) final_dollar_amount,
						(CONVERT(NUMERIC(10,3),(sum(amount_rs) + sum(amount_rs /100*tax_percentage))/100 *  ((sum(amount_rs /100*stone.discount_percentage) / sum(amount_rs))*100) - sum(credit_rs))) final_rupees_amount,
						string_agg(CAST( stoneid AS nvarchar(max)),',') stoneid_list
					FROM @lab_inward_details stone
					GROUP BY party_code,guarantor_code,user_code
				)as det	
			END
		END 
		 
		--==================== Insert value in Lab Expense  ==========================================

		IF(@is_without_grading=0)
		BEGIN 
			
			MERGE INTO [Grading].[LAB_INWARD_DETAILS] AS Dest
			using(
				SELECT @invoice_date invoice_date, @invoice_number invoice_number, @shipping_dollar_rate shipping_dollar_rate, 
				@transport_dollar_rate transport_dollar_rate, @lab_location_code lab_location_code, @certificate_code certificate_code, @conversion_rate conversion_rate
			)AS Sou ON Dest.invoice_date=Sou.invoice_date AND Dest.invoice_number = Sou.invoice_number
			When Matched THEN
 			Update Set 
 				Dest.invoice_date=Sou.invoice_date,
 				Dest.invoice_number=Sou.invoice_number,
 				Dest.shipping_dollar_rate=Sou.shipping_dollar_rate,
 				Dest.transport_dollar_rate=Sou.transport_dollar_rate,
 				Dest.lab_location_code=Sou.lab_location_code,
 				Dest.certificate_code=Sou.certificate_code,
 				Dest.conversion_rate=Sou.conversion_rate,
 				Dest.modified_by=@modified_by,
 				Dest.modified_datetime=@current_datetime,
 				Dest.modified_iplocation_id=@modified_iplocation_id,
				Dest.apps_code=@apps_code
			WHEN Not Matched THEN
			INSERT(invoice_date,invoice_number,shipping_dollar_rate,transport_dollar_rate, lab_location_code,certificate_code,conversion_rate,created_by,created_datetime,created_iplocation_id,apps_code)
			VALUES(invoice_date,invoice_number,shipping_dollar_rate,transport_dollar_rate, lab_location_code,certificate_code,conversion_rate,@modified_by,@current_datetime,@modified_iplocation_id,@apps_code);

			MERGE INTO [Grading].[LAB_INWARD_STONE_DETAILS] AS Dest
			USING (
				SELECT inw.inward_id,stoneid,reference_number,shape_code,issue_carat,clarity_code, certificate_number,color_code, cut_code,polish_code,symmetry_code,fluorescence_code,crown_angle,crown_height,pavilion_height,pavilion_angle,
					diameter_length,diameter_width,girdle,height,tabled,total_depth,star_length,lower_half,certificate_date, amount_dollar,lab.tax_percentage tax_dollar,discount_percentage,credit_dollar,remark,
					@current_datetime certificate_inward_datetime,document_number,shape_description
				FROM @lab_inward_details lab
				LEFT JOIN Grading.LAB_INWARD_DETAILS inw with(nolock)  ON inw.invoice_date = @invoice_date AND inw.invoice_number = @invoice_number
				WHERE inw.invoice_date = @invoice_date AND inw.invoice_number = @invoice_number
			) AS Sou ON Dest.inward_id=Sou.inward_id AND Dest.stoneid = Sou.stoneid
			 WHEN MATCHED THEN
			 UPDATE SET 
				 Dest.stoneid=Sou.stoneid,
				 dest.certificate_code = @certificate_code,
				 Dest.reference_number=Sou.reference_number,
				 Dest.shape_code=Sou.shape_code,
				 Dest.issue_carat=Sou.issue_carat,
				 Dest.clarity_code=Sou.clarity_code,
				 Dest.certificate_number=Sou.certificate_number,
				 Dest.color_code=Sou.color_code,
				 Dest.cut_code=Sou.cut_code,
				 Dest.polish_code=Sou.polish_code,
				 Dest.symmetry_code=Sou.symmetry_code,
				 Dest.fluorescence_code=Sou.fluorescence_code,
				 Dest.crown_angle=Sou.crown_angle,
				 Dest.crown_height=Sou.crown_height,
				 Dest.pavilion_height=Sou.pavilion_height,
				 Dest.pavilion_angle=Sou.pavilion_angle,
				 Dest.diameter_length=Sou.diameter_length,
				 Dest.diameter_width=Sou.diameter_width,
				 Dest.girdle=Sou.girdle,
				 Dest.height=Sou.height,
				 Dest.tabled=Sou.tabled,
				 Dest.total_depth=Sou.total_depth,
				 Dest.star_length=Sou.star_length,
				 Dest.lower_half=Sou.lower_half,
				 Dest.certificate_date=Sou.certificate_date,
				 --Dest.from_girdle_code=Sou.from_girdle_code,
				 --Dest.to_girdle_code=Sou.to_girdle_code,
				 Dest.amount_dollar=Sou.amount_dollar,
				 Dest.tax_dollar=Sou.tax_dollar,
				 Dest.discount_percentage=Sou.discount_percentage,
				 Dest.credit_dollar=Sou.credit_dollar,
				 Dest.remark=Sou.remark,
				 Dest.modified_by=@modified_by,
				 Dest.modified_datetime=@current_datetime,
				 Dest.modified_iplocation_id=@modified_iplocation_id,
				 Dest.certificate_inward_datetime = Sou.certificate_inward_datetime,
				 Dest.apps_code = @apps_code,
				 Dest.document_number = Sou.document_number,
				 dest.shape_description = sou.shape_description
			WHEN Not Matched THEN
			INSERT
			(inward_id,stoneid,certificate_code,reference_number,shape_code,issue_carat,clarity_code,certificate_number,color_code, cut_code,polish_code,symmetry_code,fluorescence_code,crown_angle,crown_height,pavilion_height,pavilion_angle,
			diameter_length,diameter_width,girdle,height,tabled,total_depth,star_length,lower_half,certificate_date, amount_dollar,tax_dollar,discount_percentage, credit_dollar,remark ,created_by,created_datetime,created_iplocation_id, 
			certificate_inward_datetime,document_number,shape_description,apps_code)
			VALUES
			(inward_id,stoneid,@certificate_code,reference_number,shape_code,issue_carat,clarity_code,certificate_number,color_code, cut_code,polish_code,symmetry_code,fluorescence_code,crown_angle,crown_height,pavilion_height,pavilion_angle,
			diameter_length,diameter_width,girdle,height,tabled,total_depth,star_length,lower_half,certificate_date, amount_dollar,tax_dollar,discount_percentage, credit_dollar,remark ,@modified_by,@current_datetime,@modified_iplocation_id,
			certificate_inward_datetime,document_number,shape_description,@apps_code);
	 	
		
			
			--========================================= Weight Loss Entry ==========================================
			set @transfer_number = (SELECT  ISNULL(MAX(transaction_number),0) FROM STransfer.TRANSACTION_DETAILS WITH(NOLOCK) WHERE transaction_year = CONVERT(SMALLINT,@transaction_year))
		
			declare @transaction_type_code_loss smallint = Master.getTransactionTypeCode('loss')

			SET @LabEntry_json_Detail = 
				JSON_MODIFY(@LabEntry_json_Detail, '$.transfer_detail', (
					SELECT @transaction_year transfer_year,@transfer_number +CONVERT(SMALLINT, ROW_NUMBER() OVER (ORDER BY stone.stoneid)) transfer_number,
						( @current_datetime) currentdate,@transaction_type_code_loss transaction_type_code,--lab.issue_carat before_carat,stone.issue_carat after_carat,
						CASE WHEN (stone.issue_carat > lab.issue_carat) THEN @Dept_Weight_Loss ELSE To_dept.department_code END from_department_code,
						CASE WHEN (stone.issue_carat > lab.issue_carat) THEN To_dept.department_code ELSE @Dept_Weight_Loss END to_department_code,'Lab Inward' remark,
						@invoice_number invoice_number,abs(stone.issue_carat - lab.issue_carat) AS lab_carat,stone.shape_code,1 packet_rate,
						stone.amount_rs+((amount_rs) * (tax_percentage)/100) packet_amount,
						@modified_by modified_by,@modified_iplocation_id modified_iplocation_id,
						stone.stoneid  stoneid_list,
						1 total_pcs, @apps_code as apps_code,@invoice_date invoice_date,@conversion_rate conversion_rate
					FROM @lab_inward_details stone
					LEFT JOIN Packet.STONE_DETAILS trn with(nolock)  ON stone.stoneid = trn.stoneid
					LEFT JOIN Packet.STONE_LAB_MASTER lab  with(nolock) ON trn.stoneid = lab.stoneid AND trn.certificate_code = lab.certificate_code
					LEFT JOIN Packet.STONE_RATES sr with(nolock)  ON stone.stoneid = sr.stoneid
					LEFT JOIN Master.CERTIFICATE_MASTER cm  with(nolock) ON @certificate_code = cm.certificate_code
					LEFT JOIN Master.STONE_DEPARTMENT_MASTER To_dept with(nolock)  ON To_dept.size_type_key = @LabExp
						AND lab.issue_carat BETWEEN To_dept.from_size AND To_dept.to_size
						AND lab.color_code BETWEEN To_dept.from_color_code AND To_dept.to_color_code
					WHERE stone.issue_carat <> lab.issue_carat
				FOR JSON AUTO
				))
		
			-- Lab Entry
			EXEC Grading.usp_WebService_LabInward_TransferEntry_Insert @transferEntry_json_Detail = @LabEntry_json_Detail
			
			--========================================= Weight Loss Entry ==========================================
			SET @transfer_number  = ISNULL((SELECT MAX(transaction_number) FROM STransfer.TRANSACTION_DETAILS  with(nolock) WHERE transaction_year = CONVERT(SMALLINT,@transaction_year)),0)+1
			SET @transaction_type_code = Master.getTransactionTypeCode('transfer')

			SET @transferEntry_json_Detail = 
				JSON_MODIFY(@transferEntry_json_Detail, '$.transfer_detail', (
					SELECT @transaction_year transfer_year,--@transfer_number transfer_number,
					    @transfer_number  + ROW_NUMBER() OVER (PARTITION BY @transfer_number order by from_department_code,to_department_code)transfer_number,
						@invoice_number invoice_number,
						a.from_department_code, a.to_department_code,'department transfer Lab Inward' remark,
						( @current_datetime) currentdate,@transaction_type_code transaction_type_code, 
						a.shape_code, packet_amount,conversion_rate,
						a.lab_carat, a.party_code,a.broker_code, a.guarantor_code, a.user_code, a.stoneid_list,  total_pcs,@invoice_date invoice_date,packet_rate,
						@modified_by modified_by,@modified_iplocation_id modified_iplocation_id, @apps_code as apps_code
					FROM (
						SELECT From_dept.department_code from_department_code,To_dept.department_code to_department_code,
							CASE WHEN COUNT(DISTINCT lab.shape_code) = 1 THEN MIN(lab.shape_code) ELSE @mix_ShapeCode END as shape_code,
							sum(stone.issue_carat) lab_carat,sum(rate.packet_rate * stone.issue_carat)/sum(stone.issue_carat) packet_rate,
							sum(stone.amount_rs+((amount_rs) * (tax_percentage)/100)) packet_amount,
							@conversion_rate conversion_rate,string_agg(CAST( stone.stoneid AS nvarchar(max)),',')  stoneid_list,count(1) total_pcs,
							stone.party_code,stone.broker_code,stone.guarantor_code,stone.user_code
						FROM @lab_inward_details stone
						LEFT JOIN Packet.STONE_DETAILS trn with(nolock)  ON trn.stoneid = stone.stoneid
						--LEFT JOIN @stoneid_with_order inv ON inv.stoneid = trn.stoneid
						LEFT JOIN Packet.STONE_RATES rate WITH(NOLOCK)  ON rate.stoneid = trn.stoneid
						LEFT JOIN Packet.STONE_LAB_MASTER lab with(nolock)  ON lab.stoneid = trn.stoneid AND lab.certificate_code = trn.certificate_code
						LEFT JOIN Master.STONE_DEPARTMENT_MASTER From_dept with(nolock)  ON From_dept.size_type_key = @LabExp
							 AND lab.issue_carat BETWEEN From_dept.from_size AND From_dept.to_size
							 AND lab.color_code BETWEEN From_dept.from_color_code AND From_dept.to_color_code
						LEFT JOIN Master.STONE_DEPARTMENT_MASTER To_dept with(nolock)  ON To_dept.size_type_key = @LabExp
							AND stone.issue_carat BETWEEN To_dept.from_size AND To_dept.to_size
							AND stone.color_code BETWEEN To_dept.from_color_code AND To_dept.to_color_code
						--LEFT JOIN master.color_master lab_color with(nolock) on lab_color.color_code = lab.color_code
						--LEFT JOIN master.color_master stone_color with(nolock) on stone_color.color_code = stone.color_code
						WHERE from_dept.department_code <> to_dept.department_code
						--and isnull(lab_color.is_fancy_color,0) = isnull(stone_color.is_fancy_color ,0)
						GROUP BY From_dept.department_code,To_dept.department_code,stone.party_code,stone.broker_code,stone.guarantor_code,stone.user_code
					)AS a
				FOR JSON AUTO
				))
			
			-- carat wise
			EXEC Grading.usp_WebService_LabInward_TransferEntry_Insert @transferEntry_json_Detail = @transferEntry_json_Detail 
			 
			--========================================= Start Lab Comments ================================================
			DECLARE @display_order INT = 0;
			DECLARE @lab_comment_id INT = 0;

			SELECT @display_order = ISNULL(MAX(display_order),0) FROM Master.STONE_COMMENT_MASTER with(nolock)  WHERE certificate_code = @certificate_code AND comment_type_key = 'lab_comment';
			SELECT @lab_comment_id = ISNULL(MAX(comment_id),0) FROM Master.STONE_COMMENT_MASTER with(nolock) ;

			UPDATE Packet.STONE_LAB_COMMENTS SET
				is_active = 0,
				modified_datetime = @current_datetime,
				modified_by = @modified_by,
				modified_iplocation_id = @modified_iplocation_id,
				apps_code = @apps_code
			WHERE lab_comment_id IN (
				SELECT DISTINCT slc.lab_comment_id FROM OPENJSON(@comment_Json, '$.comment_Json') jsontable 
				LEFT JOIN Packet.STONE_LAB_COMMENTS slc WITH(NOLOCK) ON JSON_VALUE(jsontable.Value,'$.stoneid') = slc.stoneid AND certificate_code = @certificate_code
				LEFT JOIN Master.STONE_COMMENT_MASTER scm WITH(NOLOCK) ON slc.comment_id = scm.comment_id AND scm.comment_type_key = 'lab_comment'
				Where scm.comment_id is not null
			)
			 
			;WITH CTE(display_order, comment_id, comment_name) 
			AS (
				SELECT @display_order + ROW_NUMBER() OVER(ORDER BY comment_id) AS display_order, @lab_comment_id + ROW_NUMBER() OVER(ORDER BY comment_id) AS display_order, JSON_VALUE(jsontable.Value, '$.comment_name') comment_name
				FROM OPENJSON(@comment_Json, '$.comment_Json') jsontable 
				LEFT JOIN Master.STONE_COMMENT_MASTER scm WITH(NOLOCK) ON scm.comment_name = JSON_VALUE(jsontable.Value, '$.comment_name') AND scm.comment_type_key = 'lab_comment' AND certificate_code = @certificate_code
				WHERE scm.comment_id IS NULL
				GROUP BY JSON_VALUE(jsontable.Value, '$.comment_name'), scm.comment_id
			)
			INSERT INTO Master.STONE_COMMENT_MASTER(certificate_code, comment_name, comment_short_name, comment_type_key, display_order, is_active, created_datetime, created_by, created_iplocation_id, apps_code)
			SELECT @certificate_code, comment_name, comment_name, 'lab_comment', display_order, 1, @current_datetime, @modified_by, @modified_iplocation_id, @apps_code 
			FROM cte;
			
			MERGE INTO Packet.STONE_LAB_COMMENTS dest
			USING(
				SELECT scm.comment_id, JSON_VALUE(jsontable.Value, '$.comment_name') commnet_name, JSON_VALUE(jsontable.Value, '$.stoneid') stoneid
				FROM OPENJSON(@comment_Json, '$.comment_Json') jsontable
				LEFT JOIN Master.STONE_COMMENT_MASTER scm with(nolock)  ON scm.comment_name = JSON_VALUE(jsontable.Value, '$.comment_name') AND scm.comment_type_key = 'lab_comment' AND certificate_code = @certificate_code
			) sou ON dest.stoneid = sou.stoneid AND dest.comment_id = sou.comment_id AND dest.certificate_code = @certificate_code
			WHEN MATCHED AND (dest.is_active = 0 OR dest.is_active IS NULL) THEN
			UPDATE SET
				is_active = 1,
				modified_datetime = @current_datetime,
				modified_by = @modified_by,
				modified_iplocation_id = @modified_iplocation_id,
				apps_code = @apps_code
			WHEN NOT MATCHED BY TARGET THEN
			INSERT(stoneid, certificate_code, comment_id, created_datetime, created_by, created_iplocation_id, apps_code, is_active)
			VALUES(sou.stoneid, @certificate_code, sou.comment_id, @current_datetime, @modified_by, @modified_iplocation_id, @apps_code, 1);

			
			
			-- Last Entry in lab and stone detail ---
			MERGE INTO Packet.STONE_LAB_MASTER dest
			USING
			(
				SELECT @inward_id inward_id,inw.stoneid,inw.issue_carat, inw.reference_number, lab.shape_code,inw.clarity_code,inw.certificate_number, inw.polish_code,inw.color_code,
					case when inw.shape_code = @shape_code_rbc THEN inw.cut_code ELSE lab.cut_code END cut_code,
					inw.symmetry_code,inw.fluorescence_code,inw.crown_angle, inw.crown_height, inw.pavilion_height, inw.pavilion_angle, inw.diameter_length,inw.diameter_width, inw.girdle,
					inw.height,inw.tabled,inw.total_depth,inw.star_length, inw.lower_half,inw.certificate_date,inw.amount_dollar,inw.tax_percentage tax_dollar, 
					inw.discount_percentage,inw.credit_dollar,inw.remark,inw.document_number, lcd.lab_clarity_sign, lcd.lab_clarity_id, lcld.lab_color_sign, lcld.lab_color_id,
					CASE WHEN inw.issue_carat >= 1.00 THEN convert(numeric(8,2),(dollar/nullif(inw.issue_carat,0))) ELSE dollar END dollar,
					inw.from_girdle_code,inw.to_girdle_code,dept.department_code stone_department_code,
					CASE WHEN (inw.shape_code = @shape_code_rbc) THEN cast((inw.diameter_width + inw.diameter_length) as NUMERIC(10,3)) / 2 
													ELSE inw.diameter_length  / CAST(inw.diameter_width AS NUMERIC(10,3)) END diameter_ratio,
					inw.is_inscription_allowed
				FROM @lab_inward_details inw
				LEFT JOIN Packet.STONE_DETAILS trn with(nolock)  ON inw.stoneid = trn.stoneid
				LEFT JOIN Packet.STONE_LAB_MASTER lab with(nolock)  ON trn.stoneid = lab.stoneid AND trn.certificate_code = lab.certificate_code
				LEFT JOIN Master.LAB_CLARITY_DETAILS lcd with(nolock)  ON lcd.clarity_code = lab.clarity_code AND ((lab.lab_clarity_sign IS NULL AND lcd.clarity_sign IS NULL) OR (lcd.clarity_sign = lab.lab_clarity_sign)) AND lcd.lab_clarity_code = inw.clarity_code AND lcd.is_active = 1 AND lcd.certificate_code = @certificate_code
				LEFT JOIN Master.LAB_COLOR_DETAILS lcld with(nolock)  ON lcld.color_code = lab.color_code AND ((lab.color_sign IS NULL AND lcld.color_sign IS NULL) OR (lcld.color_sign = lab.color_sign)) AND lcld.lab_color_code = inw.color_code AND lcld.is_active = 1 AND lcld.certificate_code = @certificate_code
				LEFT JOIN Master.DOLLAR_MASTER dm with(nolock)  ON inw.issue_carat BETWEEN dm.from_carat AND dm.to_carat
				LEFT JOIN Master.STONE_DEPARTMENT_MASTER dept with(nolock)  ON dept.size_type_key = @LabExp And department_date = @department_date AND inw.issue_carat BETWEEN dept.from_size AND dept.to_size
						AND inw.color_code BETWEEN dept.from_color_code AND dept.to_color_code
			)Sou ON dest.stoneid = Sou.stoneid AND dest.certificate_code = @certificate_code
			WHEN MATCHED THEN
			UPDATE SET
				dest.shape_code = sou.shape_code,
				dest.issue_carat = sou.issue_carat,
				dest.clarity_code = sou.clarity_code,
				dest.certificate_number = sou.certificate_number,
				dest.color_code = sou.color_code,
				dest.cut_code = sou.cut_code,
				dest.polish_code = sou.polish_code,
				dest.symmetry_code = sou.symmetry_code,
				dest.fluorescence_code = sou.fluorescence_code,
				dest.crown_angle = sou.crown_angle,
				dest.crown_height = sou.crown_height,
				dest.pavilion_height = sou.pavilion_height,
				dest.pavilion_angle = sou.pavilion_angle,
				dest.diameter_length = sou.diameter_length,
				dest.diameter_width = sou.diameter_width,
				dest.diameter_ratio = sou.diameter_ratio ,
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
				dest.lab_clarity_sign = CASE WHEN sou.lab_clarity_id IS NULL THEN dest.lab_clarity_sign ELSE sou.lab_clarity_sign END,
				dest.color_sign = CASE WHEN sou.lab_color_id IS NULL THEN dest.color_sign ELSE sou.lab_color_sign END,
				
				dest.lab_dollar = dollar,
				dest.from_girdle_code=sou.from_girdle_code,
				dest.to_girdle_code=sou.to_girdle_code,
				dest.stone_department_code = sou.stone_department_code,
				dest.is_inscription_allowed = 1
			WHEN NOT MATCHED THEN
			INSERT (stoneid,certificate_code,shape_code,issue_carat,clarity_code,certificate_number,color_code,cut_code,polish_code,symmetry_code,fluorescence_code,
			crown_angle,crown_height,pavilion_height,pavilion_angle,diameter_length,diameter_width,girdle,height,tabled,total_depth,star_length,lower_half,
			created_by,created_datetime,created_iplocation_id,document_number,apps_code,diameter_ratio, lab_dollar,from_girdle_code,to_girdle_code,stone_department_code,is_inscription_allowed)
			VALUES (stoneid,@certificate_code,shape_code,issue_carat,clarity_code,certificate_number,color_code,cut_code,polish_code,symmetry_code,fluorescence_code,
			crown_angle,crown_height,pavilion_height,pavilion_angle,diameter_length,diameter_width,girdle,height,tabled,total_depth,star_length,lower_half,
			@modified_by,@current_datetime,@modified_iplocation_id,document_number,@apps_code,diameter_ratio, dollar,from_girdle_code,to_girdle_code,stone_department_code,1);
			
			
			--===================================================add SGS & MFG comment in other lab =================================
			select lab_comment_id,stoneid,SLCOM.certificate_code ,SLCOM.comment_id,comment_name,comment_type_key,com.is_active,SLCOM.display_order
				into #stone_lab_comment
				from Packet.STONE_LAB_COMMENTS SLCOM with(nolock) 
				left JOIN master.stone_comment_master com   WITH(NOLOCK)  ON SLCOM.certificate_code =  com.certificate_code 
						AND SLCOM.comment_id = com.comment_id
				WHERE stoneid in (select stoneid from  @lab_inward_details inw)
				and SLCOM.is_active =1
				and comment_type_key in('sgs_comment','mfg_lab_comment')


				
			MERGE INTO Packet.STONE_LAB_COMMENTS dest
				USING(
				SELECT  slm.stoneid,slm.certificate_code, slcom.comment_id,
						case when isnull(comment.display_order,0) = 0 
						then ROW_NUMBER() OVER (PARTITION BY slm.stoneid,slm.certificate_code,SLCOM.comment_type_key order by slm.stoneid,slm.certificate_code,SLCOM.comment_type_key) 
						else comment.display_order end display_order
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
						--group by stoneid ,certificate_code,comment_type_key
						)lab_comment on  lab_comment.stoneid=slm.stoneid   AND lab_comment.comment_id = SLCOM.comment_id 
						and SLCOM.certificate_code =  lab_comment.certificate_code
					WHERE comment.comment_type_key in('sgs_comment','mfg_lab_comment')
					and lab_comment.comment_id is null
			) sou ON dest.stoneid = sou.stoneid AND dest.comment_id = sou.comment_id AND dest.certificate_code = sou.certificate_code
			--WHEN MATCHED AND (dest.is_active = 0 OR dest.is_active IS NULL) THEN
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
			 
			--========================================= End Lab Comments ================================================
		

			insert into Packet.STONE_LAB_INCLUSIONS
				(stoneid, certificate_code, inclusion_type_code, inclusion_sequence_code, inclusion_code, inclusion_visibility_code, inclusion_location_code,
				inclusion_percentage,inclusion_visibility_percentage,inclusion_location_percentage,inclusion_factor_percentage,created_datetime,	created_by,created_iplocation_id, apps_code)
  					
				select s.stoneid, @certificate_code certificate_code,
 					inclusion_type_code, inclusion_sequence_code, inclusion_code, inclusion_visibility_code,inclusion_location_code ,
					inclusion_percentage, inclusion_visibility_percentage, inclusion_location_percentage, inclusion_factor_percentage ,@current_datetime,@modified_by,@modified_iplocation_id,@apps_code
				from @lab_inward_details s
				left join packet.STONE_DETAILS sd with(nolock)  on sd.stoneid = s.stoneid
				left join packet.STONE_LAB_INCLUSIONS i with(nolock)  on sd.stoneid = i.stoneid and sd.certificate_code= i.certificate_code
				where s.stoneid not in (select stoneid from packet.STONE_LAB_INCLUSIONS a WITH(NOLOCK) where a.stoneid = s.stoneid and a.certificate_code = @certificate_code)
				AND inclusion_type_code is not null


			IF EXISTS (select 1 from packet.stone_rates WITH(NOLOCK) where stoneid in (select stoneid from @lab_inward_details))
			begin
				update rate
				set 
				rate.lab_dollar = CASE WHEN stone.issue_carat >= 1.00 THEN convert(numeric(8,2),(dollar/nullif(stone.issue_carat,0))) ELSE dollar END ,
				rate.modified_datetime = @current_datetime,
				rate.modified_by = @modified_by,
				rate.modified_iplocation_id = @modified_iplocation_id,
				rate.apps_code = @apps_code
				from @lab_inward_details stone
				LEFT JOIN packet.stone_rates rate WITH(NOLOCK) on rate.stoneid = stone.stoneid 
				LEFT JOIN master.dollar_master d WITH(NOLOCK) on stone.issue_carat BETWEEN from_carat AND to_carat
				where isnull(rate.lab_dollar,0) = 0
				AND rate.stoneid IS NOT NULL
			end


			;WITH CTE(stoneid, active_certi) AS (
				SELECT stoneid, Grading.usp_fn_LabInward_ActiveCertificate_Check(inw.stoneid, @certificate_code, inw.issue_carat, inw.color_code, inw.clarity_code, inw.fluorescence_code) AS active_certi
				FROM @lab_inward_details inw
			)
			UPDATE trn
			SET 
				trn.certificate_code = @certificate_code ,
				trn.operation_remark =@operation_remark ,
				--trn.stone_process_code = @stone_process_code,
				trn.modified_datetime = @current_datetime,
				trn.modified_by = @modified_by,
				trn.modified_iplocation_id = @modified_iplocation_id,
				trn.apps_code = @apps_code
			FROM cte
			LEFT JOIN Packet.STONE_DETAILS trn WITH(NOLOCK) ON trn.stoneid = cte.stoneid	
			WHERE trn.stoneid = cte.stoneid AND cte.active_certi = 1
		
			------------------------------------------------live lab color transfer entry---------------------------
			IF EXISTS (SELECT 1 FROM @lab_inward_details stone
                                    LEFT JOIN Packet.STONE_DETAILS trn  with(nolock) ON trn.stoneid = stone.stoneid WHERE trn.stoneid = stone.stoneid and certificate_code <> @certificate_code)
			begin
			SET @transfer_number  = ISNULL((SELECT MAX(transaction_number) FROM STransfer.TRANSACTION_DETAILS  with(nolock) WHERE transaction_year = CONVERT(SMALLINT,@transaction_year)),0)+1
			
			--========================================= Weight Loss Entry ==========================================
                        SET @transfer_number =
                        (
                            SELECT ISNULL(MAX(transaction_number), 0)
                            FROM STransfer.TRANSACTION_DETAILS WITH(NOLOCK)
                            WHERE transaction_year = CONVERT(SMALLINT, @transaction_year)
                        );
                        SET @transaction_type_code = Master.getTransactionTypeCode('loss');
                       
                        SET @LabEntry_json_Detail = JSON_MODIFY(@LabEntry_json_Detail, '$.transfer_detail',
                        (
                            SELECT @transaction_year transfer_year, 
                                   @transfer_number + CONVERT(SMALLINT, ROW_NUMBER() OVER(
                                   ORDER BY stone.stoneid)) transfer_number, 
                                   CONVERT(DATE, @current_datetime) currentdate, 
                                   @transaction_type_code transaction_type_code, --lab.issue_carat before_carat,stone.issue_carat after_carat,
                                   CASE WHEN(stone.issue_carat > lab.issue_carat) THEN @Dept_Weight_Loss ELSE To_dept.department_code END from_department_code,
                                   CASE WHEN(stone.issue_carat > lab.issue_carat) THEN To_dept.department_code ELSE @Dept_Weight_Loss END to_department_code, 
                                   'Live lab weightloss - Lab Inward' remark, 
                                   @invoice_number invoice_number, 
                                   abs(stone.issue_carat - lab.issue_carat) AS lab_carat, 
                                   stone.shape_code, 
                                   1 packet_rate, 
                                   (1 * stone.issue_carat) AS packet_amount, 
                                   @modified_by modified_by, 
                                   @modified_iplocation_id modified_iplocation_id, 
                                   stone.stoneid stoneid_list, 
                                   1 total_pcs, 
                                   @apps_code AS apps_code, 
                                   @invoice_date invoice_date
                            FROM @lab_inward_details stone
                                 LEFT JOIN Packet.STONE_DETAILS trn with(nolock) ON stone.stoneid = trn.stoneid
                                 LEFT JOIN Packet.STONE_LAB_MASTER lab with(nolock) ON trn.stoneid = lab.stoneid
                                                                          AND trn.certificate_code = lab.certificate_code
                                 LEFT JOIN Packet.STONE_RATES rate with(nolock) ON stone.stoneid = rate.stoneid
                                 --LEFT JOIN Master.CERTIFICATE_MASTER cm with(nolock) ON @certificate_code = cm.certificate_code
                                 LEFT JOIN Master.STONE_DEPARTMENT_MASTER To_dept with(nolock) ON To_dept.size_type_key = 'LABEXP'
                                                                                     AND lab.issue_carat BETWEEN To_dept.from_size AND To_dept.to_size
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
                        SET @transaction_type_code = Master.getTransactionTypeCode('transfer');
            
			SET @transferEntry_json_Detail = 
				JSON_MODIFY(@transferEntry_json_Detail, '$.transfer_detail', (
					SELECT @transaction_year transfer_year, 
						--@transfer_number transfer_number,
						@transfer_number + ROW_NUMBER() OVER (PARTITION BY @transfer_number order by from_department_code,to_department_code) transfer_number,
						@invoice_number invoice_number,
						a.from_department_code, a.to_department_code,'Live Lab Transfer Entry' remark,
						( @current_datetime) currentdate,@transaction_type_code transaction_type_code, 
						a.shape_code, packet_amount,conversion_rate,
						a.lab_carat, a.party_code,a.broker_code, a.guarantor_code, a.user_code, a.stoneid_list,  total_pcs,@invoice_date invoice_date,packet_rate,
						@modified_by modified_by,@modified_iplocation_id modified_iplocation_id, @apps_code as apps_code
					FROM (
						SELECT From_dept.department_code from_department_code,To_dept.department_code to_department_code,
							CASE WHEN COUNT(DISTINCT lab.shape_code) = 1 THEN MIN(lab.shape_code) ELSE @mix_ShapeCode END as shape_code,
							sum(lab.issue_carat) lab_carat,sum(rate.packet_rate * lab.issue_carat)/sum(lab.issue_carat) packet_rate,
							--sum(stone.amount_rs+((amount_rs) * (tax_percentage)/100)) packet_amount,
							sum(rate.packet_rate * lab.issue_carat) packet_amount,
							@conversion_rate conversion_rate,string_agg(CAST( stone.stoneid AS nvarchar(max)),',')  stoneid_list,count(1) total_pcs,
							stone.party_code,stone.broker_code,stone.guarantor_code,stone.user_code
						FROM @lab_inward_details stone
						LEFT JOIN Packet.STONE_DETAILS trn with(nolock)  ON trn.stoneid = stone.stoneid
						LEFT JOIN @stoneid_with_order inv ON inv.stoneid = trn.stoneid
						LEFT JOIN Packet.STONE_RATES rate with(nolock)  ON rate.stoneid = trn.stoneid
						LEFT JOIN Packet.STONE_LAB_MASTER lab with(nolock)  ON lab.stoneid = trn.stoneid AND lab.certificate_code = trn.certificate_code
						LEFT JOIN Master.STONE_DEPARTMENT_MASTER From_dept with(nolock)  ON From_dept.size_type_key = @LabExp
							 AND stone.issue_carat BETWEEN From_dept.from_size AND From_dept.to_size
							 AND stone.color_code BETWEEN From_dept.from_color_code AND From_dept.to_color_code
						LEFT JOIN Master.STONE_DEPARTMENT_MASTER To_dept with(nolock)  ON To_dept.size_type_key = @LabExp
							AND lab.issue_carat BETWEEN To_dept.from_size AND To_dept.to_size
							AND lab.color_code BETWEEN To_dept.from_color_code AND To_dept.to_color_code
						WHERE 1=1
						AND from_dept.department_code <> to_dept.department_code
						--and trn.stoneid = stone.stoneid and trn.certificate_code <> @certificate_code
						GROUP BY From_dept.department_code,To_dept.department_code,stone.party_code,stone.broker_code,stone.guarantor_code,stone.user_code
					)AS a
				FOR JSON AUTO
				))
			
			-- carat wise
			EXEC Grading.usp_WebService_LabInward_TransferEntry_Insert @transferEntry_json_Detail = @transferEntry_json_Detail 

			end

			--========================================= Lab Expense Entry ==========================================
			SET @transfer_number  = ISNULL((SELECT MAX(transaction_number) FROM STransfer.TRANSACTION_DETAILS  with(nolock) WHERE transaction_year = CONVERT(SMALLINT,@transaction_year)),0)+1
			SET @transaction_type_code = Master.getTransactionTypeCode('Lab_Expense')
			
			SET @transferEntry_json_Detail = 
				JSON_MODIFY(@transferEntry_json_Detail, '$.transfer_detail', (
					SELECT @transaction_year transfer_year,--@transfer_number transfer_number,
					    @transfer_number  + ROW_NUMBER() OVER (PARTITION BY @transfer_number order by from_department_code,to_department_code)transfer_number,
						@invoice_number invoice_number,
						a.from_department_code, a.to_department_code,'Live Lab Lab_Expense Entry Lab Inward' remark,
						( @current_datetime) currentdate,@transaction_type_code transaction_type_code, 
						a.shape_code, packet_amount,conversion_rate,
						a.lab_carat, a.party_code,a.broker_code, a.guarantor_code, a.user_code, a.stoneid_list,  total_pcs,@invoice_date invoice_date,packet_rate,
						@modified_by modified_by,@modified_iplocation_id modified_iplocation_id, @apps_code as apps_code
					FROM (
						SELECT null as from_department_code,To_dept.department_code to_department_code,
							CASE WHEN COUNT(DISTINCT lab.shape_code) = 1 THEN MIN(lab.shape_code) ELSE @mix_ShapeCode END as shape_code,
							sum(stone.issue_carat) lab_carat,sum(rate.packet_rate * stone.issue_carat)/sum(stone.issue_carat) packet_rate,
							sum(stone.amount_rs+((amount_rs) * (tax_percentage)/100)) packet_amount,
							@conversion_rate conversion_rate,string_agg(CAST( stone.stoneid AS nvarchar(max)),',')  stoneid_list,count(1) total_pcs,
							stone.party_code,stone.broker_code,stone.guarantor_code,stone.user_code
						FROM @lab_inward_details stone
						LEFT JOIN Packet.STONE_DETAILS trn with(nolock)  ON trn.stoneid = stone.stoneid
						--LEFT JOIN @stoneid_with_order inv ON inv.stoneid = trn.stoneid
						LEFT JOIN Packet.STONE_RATES rate WITH(NOLOCK)  ON rate.stoneid = trn.stoneid
						LEFT JOIN Packet.STONE_LAB_MASTER lab with(nolock)  ON lab.stoneid = trn.stoneid AND lab.certificate_code = trn.certificate_code
						LEFT JOIN Master.STONE_DEPARTMENT_MASTER To_dept with(nolock)  ON To_dept.size_type_key = @LabExp
							AND stone.issue_carat BETWEEN To_dept.from_size AND To_dept.to_size
							AND stone.color_code BETWEEN To_dept.from_color_code AND To_dept.to_color_code
						--LEFT JOIN master.color_master lab_color with(nolock) on lab_color.color_code = lab.color_code
						--LEFT JOIN master.color_master stone_color with(nolock) on stone_color.color_code = stone.color_code
						--WHERE from_dept.department_code <> to_dept.department_code
						--and isnull(lab_color.is_fancy_color,0) = isnull(stone_color.is_fancy_color ,0)
						GROUP BY To_dept.department_code,stone.party_code,stone.broker_code,stone.guarantor_code,stone.user_code
					)AS a
				FOR JSON AUTO
				))
				 
			-- carat wise
			EXEC Grading.usp_WebService_LabInward_TransferEntry_Insert @transferEntry_json_Detail = @transferEntry_json_Detail 
 
				------------------------------------------------live lab carat transfer entry---------------------------
			

			
			 BEGIN   /* Packet.usp_Outward_InternalStockIssue_Upsert */

                    /*stock upsert*/

                    /*
					Get Memo Number
					*/
					DECLARE @process_issue_memo_no SMALLINT = 0
					EXEC Grading.usp_FindMemoNumber_Insert @process_issue_memo_no OUTPUT, '', 0, @modified_by, @modified_iplocation_id,@current_datetime
	
					--/*
					--Grading - Internal Transaction Receive
					--*/
      
				    IF EXISTS( SELECT 1 FROM Packet.STONE_PROCESSES  with(nolock) WHERE stoneid IN(SELECT stoneid FROM @stoneid_with_order) AND is_sub_process_active = 1)
                    BEGIN
                           Update Packet.STONE_PROCESSES
							SET is_sub_process_active = 0, 
								sub_process_id = null, 
								modified_datetime = @current_datetime, 
								modified_by = @modified_by, 
								modified_iplocation_id = @modified_iplocation_id, 
								apps_code = @apps_code
							WHERE process_id IN (select process_id from @StoneProcess) 

							--Update Packet.SUB_STONE_PROCESSES
							--Set user_receive_datetime = @current_datetime,
							--	receive_user_code = @modified_by,
							--	modified_by = @modified_by,
							--	modified_datetime = @current_datetime,
							--	modified_iplocation_id = @modified_iplocation_id,
							--	apps_code = @apps_code
							--WHERE process_id IN (select process_id from @StoneProcess) 
                    END;
                    
					/*Update Previous Record*/
                    UPDATE Packet.STONE_PROCESSES
					SET next_to_department_code = @D_STOCK_DEPARTMENT_CODE,
						next_user_code = @modified_by,
						next_process_issue_date = @current_datetime,
						next_process_issue_time = @current_datetime,
						next_process_issue_memo_no = @process_issue_memo_no,
						modified_datetime = @current_datetime,
						modified_by = @modified_by,
						modified_iplocation_id = @modified_iplocation_id,
						apps_code = @apps_code
					WHERE process_id IN (SELECT process_id from @StoneProcess)	
                   
				    INSERT INTO Packet.STONE_PROCESSES
                    (stoneid, from_department_code, to_department_code, process_issue_date, process_issue_time, process_issue_memo_no, remark, process_issue_user_code, 
						process_issue_iplocation_id, created_by, created_iplocation_id, apps_code, outward_serial_id, user_code, is_inward_verify, notes, action_code)
                    SELECT Stone.stoneid, @D_STOCK_DEPARTMENT_CODE, @D_STOCK_DEPARTMENT_CODE, @current_datetime, @current_datetime, @process_issue_memo_no, '', @modified_by, 
						@modified_iplocation_id, @modified_by, @modified_iplocation_id, @apps_code, Stone.serial_number outward_serial_id, 0, 0, '', @action_id                           
					FROM @stoneid_with_order Stone
                    LEFT JOIN Packet.STONE_DETAILS StoneDet  with(nolock) ON StoneDet.stoneid = Stone.stoneid
                    WHERE StoneDet.TRNYEAR = 0
                            AND Stone.stoneid IS NOT NULL
                            AND StoneDet.stoneid IS NOT NULL;
                    
					
					/*Generate View Request*/
					DECLARE @old_memo_date date, 
							@old_memo_no smallint,
							@stoneid_list Stock.stoneid


						
 					-- ============================= Nishit Langaliya ======================================================

					declare @rfl_status_code smallint = (select status_code from master.STONE_STATUS_MASTER with(nolock) where status_key = 'RFL')

					update sdrfl
					set sdrfl.return_from_lab_stone_datetime = @current_datetime,
						sdrfl.modified_datetime = @current_datetime,
						sdrfl.modified_by = @modified_by,
						sdrfl.modified_iplocation_id = @modified_iplocation_id
					from @lab_inward_details idt
					left join packet.stone_details sd with(nolock) on idt.stoneid = sd.stoneid
					left join Grading.return_from_lab_stone_details sdrfl with(nolock) on sdrfl.stoneid = idt.stoneid
					where sdrfl.stoneid = idt.stoneid
					and sd.stone_status_code = @rfl_status_code
					and sdrfl.stoneid is not null

					insert into Grading.return_from_lab_stone_details (stoneid, return_from_lab_stone_datetime, apps_code, created_datetime, created_by, created_iplocation_id)
					select idt.stoneid, @current_datetime, @apps_code, @current_datetime, @modified_by, @modified_iplocation_id
					from @lab_inward_details idt
					left join packet.stone_details sd with(nolock) on idt.stoneid = sd.stoneid
					left join Grading.return_from_lab_stone_details sdrfl with(nolock) on sdrfl.stoneid = idt.stoneid
					where sd.stone_status_code = @rfl_status_code
					and sdrfl.stoneid is null

					-- =======================================================================================================

                    /* Update Request against outward process*/

       --             EXEC [Stock].[usp_stone_request_transfer_detail_update] 
       --                  @stoneidwithprocessid = @StoneProcess, 
       --                  @to_department_code = @grd_Department_code, 
       --                  @from_department_code = @grd_department_code, 
       --                  @lab_location_code = @lab_location_code, 
       --                  @apps_code = @apps_code, 
       --                  @action_code = @action_id, 
       --                  @modified_by = @modified_by, 
       --                  @modified_ip_location = @modified_iplocation_id,
						 --@modified_datetime = @current_datetime
       --             SELECT @memo_date = @current_datetime, 
       --                    @memo_number = @process_issue_memo_no;
       --             IF @memo_number = 0
       --                 BEGIN
       --                     RAISERROR('memo_number not found', 18, 1);
       --             END;

                    /*stock upsert*/

                END;

 			--==================== certification module====================
			IF EXISTS(SELECT  1 FROM @lab_inward_details stone)
			BEGIN
				INSERT INTO stock.Stone_certification_details
				(stoneid,certificate_code,certificate_number,certificate_verify,certificate_outward_verify,certificate_issue_datetime,from_department_code,to_department_code,
				remark,created_by,created_iplocation_id,Certification_Status_id,is_certificate_active,action_code)
				SELECT  stoneid,@certificate_code,inw.certificate_number,0,0,@current_datetime,@D_STOCK_DEPARTMENT_CODE,@D_STOCK_DEPARTMENT_CODE,
				'lab inward',@modified_by,@modified_iplocation_id,master.getcertificatestatuscode('certificate_inward'),1,@action_id
				FROM @lab_inward_details inw
			
			END
			----------------------------data delete on offline-------------------
		END 

		
		
		


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


		INSERT INTO [Audit].[OP_REMARKS_HISTORY]([STONEID],[HISTORY_DATETIME],[OP_REMARKS],[PAGE_NAME],[CREATED_BY],[CREATED_IP_LOCATION],[APPS_CODE])
		select	stoneid,@current_datetime,@operation_remark,@certi_name +' - Lab Inward Form' ,@modified_by ,@modified_iplocation_id,@apps_code
		from @stoneid

		
		COMMIT TRANSACTION T1
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorLine INT, @ErrorState INT
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorLine = ERROR_LINE(), @ErrorState = ERROR_STATE()
		ROLLBACK TRANSACTION T1
		-- EXECUTION ERROR LOG
		EXEC [dbo].[LOGINFO] @ProcedureName = 'Grading.usp_LabInward_Upsert',@LogType = 'INFO',@ErrorLine = @ErrorLine,@ErrorMessage = @ErrorMessage,@ExecutedBy = NULL,@HostIPName = '',@FormName = '',@AdditionalInfo = 'CATCH BLOCK'
		SELECT @ErrorMessage as 'error_msg', @ErrorState ERROR_STATE, @ErrorSeverity ERROR_SEVERITY,1 error_status
	END CATCH
END
GO