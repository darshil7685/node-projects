USE [Users]
GO
/****** Object:  UserDefinedFunction [dbo].[flight_details]    Script Date: 7/2/2022 4:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[flight_details]
(	
)
RETURNS TABLE 
AS
RETURN 
(

select f.flight_id,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
f.origin depart_from,c.city_name arrival_to
from [dbo].[flightmast] f 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id
where datediff(hour,f.depart_time,f.arrival_time) between '05' and '06'
)
