create table [dbo].[flightmast](
	[flight_id] [bigint] identity,
	[origin] [varchar](512), 
	[destination] [bigint] ,
	[flight_number] [varchar](128), 
	[depart_time] [time](7) ,
	[arrival_time] [time](7) ,
	[Routing] [varchar](128) ,
	[day_of_operation] [varchar](64) ,
	[connection_flight_number] [varchar](128), 
	[effective_from] [date] ,
	[effective_to] [date] )

create table [dbo].[airportmast](
	[airport_id] [int] identity,
	[airport_name] [varchar](1024), 
	[city_id] [bigint] )

create table [dbo].[citymast](
	[city_id] [bigint] ,
	[city_name] [varchar](512), 
	[state_id] [bigint] )

create table [dbo].[statemast](
	[state_id] [bigint] ,
	[state_name] [varchar](512) ) 

create table [dbo].[travellingdet](
	[trnidn] [bigint] identity(1,1),
	[flight_id] [bigint] ,
	[passenger_name] [varchar](512), 
	[travel_date] [datetime] )

drop table [dbo].[travellingdet]