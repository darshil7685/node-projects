USE [Users]
GO
/****** Object:  StoredProcedure [dbo].[flight_dtl_by_city_depttime]    Script Date: 7/2/2022 4:28:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER PROCEDURE [dbo].[flight_dtl_by_city_depttime]
	@city varchar(10),
	@dept_time time

AS
BEGIN
	 
	select f.flight_id,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
	f.origin depart_from,c.city_name arrival_to
	from [dbo].[flightmast] f 
	left join [dbo].[citymast] c on f.destination=c.city_id
	left join [dbo].[airportmast] a on c.city_id=a.city_id
	where c.city_name=@city and f.depart_time=@dept_time
END
