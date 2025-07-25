USE [Users]
GO
/****** Object:  StoredProcedure [dbo].[insert_travelling_details]    Script Date: 7/2/2022 4:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

ALTER    PROCEDURE [dbo].[insert_travelling_details] 
	@trnidn bigint ,
	@flight_id bigint,
	@passenger_name varchar(512),
	@travel_date date
AS
BEGIN
	declare @default_from_date date = '2020-01-01'
	declare @default_to_date date ='2022-10-01'

	if exists ( 
	select top 1 1 from dbo.[flightmast] where flight_id=110 and 
	(@travel_date between 
	case when effective_from is null then @default_from_date else effective_from end and
	case when effective_to is null then @default_to_date else effective_to end ) and 
	exists (select value from string_split(day_of_operation,',') where value=datename(dw,@travel_date))
	)
	begin
		SET IDENTITY_INSERT [dbo].[travellingdet] ON 

		insert into dbo.travellingdet(trnidn,flight_id,passenger_name,travel_date) 
		values(@trnidn,@flight_id,@passenger_name,@travel_date)

		SET IDENTITY_INSERT [dbo].[travellingdet] OFF
		print 'Data inserted'

	end
	else
		print 'Flight not available'
END
