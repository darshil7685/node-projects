select * from dbo.airportmast
select * from dbo.citymast
select * from dbo.statemast
select * from dbo.copyEmployeeInfo

select * from dbo.statemast s 
inner join dbo.citymast c on s.state_id=c.state_id
inner join dbo.airportmast a on a.city_id=c.city_id
where c.state_id is not null

 update  dbo.users_history
set user_age =30 where user_id in(12,3)
insert into dbo.users values('Alis',12),('BOB',15)

select * from users
select * from dbo.users_history
 
declare @temp table(user_id int)
insert into @temp values(21),(22),(1)
 
 declare @temp1 table(user_id int)
insert into @temp1 values(21),(1)

merge into dbo.users_history as target
using (select t.user_id as user_id from @temp t inner join @temp1 t1 on t.user_id=t1.user_id) as source
on target.id=source.user_id

when not matched by target then 
	insert (user_id,user_name,user_age,action) values (5,'A',50,'insert')
when matched then update set 
	target.user_age=12345
when not matched by source then delete; 


update u 
set u.user_age=31
from @temp t
left join dbo.users_history u on t.user_id=u.user_id

select * from dbo.users u
left join dbo.users_history uh on u.user_id=uh.user_id
inner join  #u_temp ut on ut.user_id=u.user_id

--and u.user_age=uh.user_age
--where u.user_id is not null
select * from dbo.users u
inner join dbo.users_history uh on u.user_id=uh.user_id
left join  #u_temp ut on ut.user_id=u.user_id
and u.user_age=uh.user_age

select * from dbo.users u 
left join dbo.users_history uh 
on uh.user_id=u.user_id 

select user_id into #u_temp from dbo.users where user_id in(2,19)

declare @t table(user_id int)
insert into @t values(8)
delete u from @t t inner join dbo.users u on u.user_id=t.user_id

--insert into dbo.users_history(user_id,user_name,user_age,action) values(12,'Alis',12,'insert'),(2,'Allen',12,'delete')

select * from dbo.users
select * from dbo.users_history

declare @tmpuser table(user_id int)
insert into @tmpuser values(12),(18),(2)
select * from dbo.users u 
left join  @tmpuser t on   u.user_id=2	 where u.user_id=2 
left join dbo.users_history uh on  uh.user_id=u.user_id and uh.user_id=2

 select * from dbo.users u 
left outer join dbo.users_history uh on u.user_id=uh.user_id 
left join (select u.user_id from @tmpuser t left join dbo.users u on u.user_id=t.user_id ) tu on tu.user_id=u.user_id
  
 
SELECT * FROM dbo.users u 
OUTER APPLY 
   ( 
   SELECT *FROM dbo.users_history uh
   WHERE u.user_id = uh.user_id 
   ) A 


declare @json nvarchar(max)=N'{}'
set @json=(
select * from dbo.users u 
left join dbo.users_history uh 
on uh.user_id=u.user_id For JSON AUTO)
select @json

select * from openjson(@json) with (user_id int '$.user_id',username varchar(10) '$.user_name')
select JSON_VALUE(jsonT.Value,'$.user_i') user_id from openjson(@json) jsonT

select u.user_id,u.user_name as 'USER_DETAILS.User Name',u.user_age as 'USER_DETAILS.User Age' from dbo.users u 
left join dbo.users_history uh 
on uh.user_id=u.user_id For JSON PATH

select * from dbo.users u 
left join dbo.users_history uh on u.user_id=uh.user_id 
and uh.user_id=12 and u.user_name='Alish' 
