 
select * from [dbo].[flightmast] 
select * from [dbo].[travellingdet]
select * from [dbo].[airportmast]
select * from [dbo].[citymast]
select * from [dbo].[statemast]

alter table dbo.travellingdet add constraint unique_trnidn unique(trnidn)
delete from dbo.travellingdet
SELECT DATENAME(dw, '2022-04-03')
select count(flight_id),origin,flight_number  from dbo.flightmast group by origin,flight_number  having origin='Abu Dhabi'
and count(flight_id) >40

select * from dbo.flightmast f join dbo.flightmast f1 on f.flight_number=f1.flight_number and f.destination=f1.destination

select f.flight_id,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
f.origin depart_from,c.city_name arrival_to
from [dbo].[flightmast] f 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id 

insert into [dbo].[travellingdet]([trnidn],[flight_id],[passenger_name],[travel_date])
values (1,109,'Kevin','2021-04-11') 

declare @from_date date='2020-01-01'
declare @travel_date date='2021-10-01'
select *,isdate(cast(effective_from as nvarchar))
from dbo.[flightmast] where flight_id=109 and 
case when isdate(cast(effective_from as nvarchar))=1 then 
'2020-02-02'>=effective_from

if (isnull('A','')='A')
@travel_date >='2021-10-01'
if exists ( isnull(effective_from,'')!='' and isnull(effective_to,'')!='' )
begin
@travel_date>=effective_from
end 
declare @travel_date1 date='2022-10-01'
select *
from dbo.[flightmast] where flight_id=113 and 
((effective_from is null and effective_to is not null and @travel_date1<=effective_to)
or (effective_from is not null and effective_to is null and @travel_date1>=effective_from)
or (effective_from is not null and effective_to is not null and @travel_date1>=effective_to and @travel_date1<=effective_from)
 )

  
case when effective_from is null then @from_date else effective_from end 
and case when effective_to is null then @to_date else effective_to end  

and exists (select value from string_split(day_of_operation,',') where value=datename(dw,'2022-04-06'))
 
exec dbo.insert_travelling_details  @trnidn=5,@flight_id=115,@passenger_name='Jemin',@travel_date='2021-04-06'

 
select f.flight_id,f.day_of_operation,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
f.origin depart_from,c.city_name arrival_to
from [dbo].[flightmast] f 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id
where f.effective_from between dateadd(m,-6,GETDATE()) and GETDATE()

create view dbo.passenger_details as
select t.flight_id,t.passenger_name,t.travel_date,a.airport_name,
f.origin depart_from,c.city_name arrival_to
from [dbo].[travellingdet]  t
left join [dbo].[flightmast] f on t.flight_id=f.flight_id 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id

select f.flight_id,f.day_of_operation,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
f.origin depart_from,c.city_name arrival_to
from [dbo].[flightmast] f 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id
where CHARINDEX('Wednesday',f.day_of_operation) >0 and 
CHARINDEX('Saturday',f.day_of_operation) >0 and
CHARINDEX('Monday',f.day_of_operation)=0

select f.flight_id,f.day_of_operation,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
f.origin depart_from,c.city_name arrival_to,convert(varchar(20),f.depart_time,100),
convert(varchar(20),f.arrival_time,100)
from [dbo].[flightmast] f 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id
where f.origin='Abu dhabi' and c.city_name='Ahmedabad' and 
convert(varchar(20),f.depart_time,100) >= '11:00AM' 

declare @a varchar
select substring('11:30PM',1,CHARINDEX('PM','11:30PM')-1)
select charindex(':',substring('11:30PM',1,CHARINDEX('PM','11:30PM')-1))
select substring('11:30PM',1,charindex(':',substring('11:30PM',1,CHARINDEX('PM','11:30PM')-1))-1),
substring('11:30PM',charindex(':',substring('11:30PM',1,CHARINDEX('PM','11:30PM')-1))+1,5)
select convert(varchar(20),'18:45:00',131)
select SUBSTRING('11:30PM',3,6)

select f.flight_id,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
f.origin depart_from,c.city_name arrival_to
from [dbo].[flightmast] f 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id
where f.origin='Abu Dhabi' and c.city_name='Srinagar' and f.Routing='Via BOM'


select f.flight_id,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
f.origin depart_from,c.city_name arrival_to,convert(varchar,f.depart_time,100)
from [dbo].[flightmast] f 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id
where c.city_name='Srinagar' and convert(varchar,f.depart_time,100)='11:30PM'

exec dbo.flight_dtl_by_city_depttime @city='Srinagar',@dept_time='23:30:00' 

select f.flight_id,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
f.origin depart_from,c.city_name arrival_to
from [dbo].[flightmast] f 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id
where datediff(hour,f.depart_time,f.arrival_time) between '05' and '06'

select * from dbo.flight_details()

select f.flight_id,a.airport_id,a.airport_name,f.depart_time,f.arrival_time,
f.origin depart_from,c.city_name arrival_to
from [dbo].[flightmast] f 
left join [dbo].[citymast] c on f.destination=c.city_id
left join [dbo].[airportmast] a on c.city_id=a.city_id
where f.Routing='Via DEL' and c.city_name not in ('Srinagar','Kolhapur','Mumbai')


create table dbo.day_of_operation(
flight_id int null,
Monday int null,
Tuesday int null,
Wednesday int null,
Thursday int null,
Saturday int null,
Sunday int null
)
alter table dbo.day_of_operation add Friday int null
select flight_id,day_of_operation from dbo.flightmast
select * from dbo.day_of_operation
insert into dbo.day_of_operation(flight_id,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday) select flight_id,
case when charindex('Monday',day_of_operation)>0 then flight_id else null end as Monday,
case when charindex('Tuesday',day_of_operation)>0 then flight_id else null end as Tuesday,
case when charindex('Wednesday',day_of_operation)>0 then flight_id else null end as Wednesday,
case when charindex('Thursday',day_of_operation)>0 then flight_id else null end as Thursday,
case when charindex('Friday',day_of_operation)>0 then flight_id else null end as Friday,
case when charindex('Saturday',day_of_operation)>0 then flight_id else null end as Saturday,
case when charindex('Sunday',day_of_operation)>0 then flight_id else null end as Sunday
from dbo.flightmast

select flight_id,day_of_operation from dbo.flightmast
where (select value from string_split(day_of_operation))

declare @day_of_operation varchar(200)=null
select @day_of_operation
set @day_of_operation=(select day_of_operation from dbo.flightmast where 
flight_id=109)
--select value from string_split(@day_of_operation,',')

if(charindex('Friday',@day_of_operation)>0)
begin
 select 1
end
if(charindex('Monday',@day_of_operation)>0)
select 2

 

