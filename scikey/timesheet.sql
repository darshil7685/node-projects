select min(effective_from),origin from dbo.flightmast group by origin
select * from dbo.flightmast where origin='Doha'

create table dbo.timesheetData(
id int identity(1,1) not null primary key,
employee_name varchar(30) ,
t_date datetime default null,
project_name varchar(20),
t_hours float,
type varchar(20),
description varchar(100),
manager_id int,
approval_date datetime
)

insert into dbo.timesheetData(employee_name,t_date,project_name,t_hours,type,description,
manager_id,approval_date) values('Harsh','2022-06-25 10:22:00','Pure',8.50,
'Working Hours','Production issues',3,'2022-06-30 15:22:00')
 
 select * from dbo.timesheetData where manager_id=3

 update dbo.timesheetData set t_date='2022-06-26 10:22:00' where id=10
 select * from dbo.timesheetData

 select employee_name,sum(t_hours) total_hrs,count(1) total_days
 ,sum(datediff(DAY,t_date,approval_date)) approval_waiting_days,
 sum(datediff(HOUR,t_date,approval_date)) approval_waitng_hrs
 from dbo.timesheetData group by employee_name

 select sum(datediff(HOUR,t_date,approval_date)),employee_name from dbo.timesheetData
 group by employee_name

 select value from string_split('A,B,C,D',',') where value not in ('A','B')

