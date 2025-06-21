

create table dbo.EmployeeInfo(
EmpID int  identity(1,1) not null,
Empname varchar(450),
Department varchar(10),
Project varchar(5),
Address varchar(450),
DOB date,
Gender varchar(2) ,
primary key(EmpID)
)

create table dbo.EmployeePosition(
EmpID int not null,
EmpPosition varchar(10),
DateOfJoining date,
Salary float(10),
GST int,
finalSalary float(10) default null,
)

alter table dbo.EmployeeInfo add constraint unique_empname unique(Empname)
alter table dbo.EmployeeInfo drop constraint unique_empname
alter table dbo.EmployeePosition add constraint FK_EmployeeInfo_EmpID foreign key (EmpID) references dbo.EmployeeInfo(EmpID) on delete cascade
alter table dbo.EmployeePosition drop constraint FK_EmployeeInfo_EmpID 
insert into dbo.EmployeeInfo values ('Akash kg Mehra','HR','P1','Hyderabad(HYD)','1976-12-01','M'),('Ananya Mishrakg','Admin','P2','Delhi(DEL)','1968-05-02','F'),
('kgRohan Diwan','Account','P3','Mumbai(BOM)','1980-01-01','M'),('Prachikg Kulkarni','HR','P1','Hyderabad','1992-05-02','F'),('Ankit kgKapoor','Admin','P2','Delhi(DEL)','1994-07-03','M')
 
insert into dbo.EmployeePosition(EmpID,EmpPosition,DateOfJoining,Salary,GST) values(1,'Manager','2019-05-01',500000,18),(3,'Executive','2019-05-02',75000,20),
(4,'Manager','2019-05-02',90000,10),(3,'Lead','2019-05-02',85000,18),(2,'Executive','2019-05-01',300000,21)


select * from dbo.EmployeeInfo where EmpID in (
select cast(value as int) from string_split('10,11,12',',') )
 select  * from dbo.EmployeePosition 
select * from dbo.EmployeeInfo where EmpID in (select EmpID from dbo.EmployeePosition)
select case when DOB > '1990-12-01' then 'hr' else Department end as Department,* from dbo.EmployeeInfo 

select substring(Address,CHARINDEX('(',Address)+1,CHARINDEX(')',Address)-1),Address from dbo.EmployeeInfo

select * from dbo.EmployeeInfo union all select * from dbo.EmployeeInfo
select count(*) from dbo.EmployeeInfo where Department='HR'

select SUBSTRING(Empname,1,4) from dbo.EmployeeInfo

select Empname from dbo.EmployeeInfo where Empname like '_o%'
select * from dbo.EmployeeInfo where Empname not like (select top 1 value from string_split(Empname,' ') )and Empname not like 'Prachi%'
select top 1 value from string_split('A Z',' ')

select emp.Empname,em.Salary,count(*) from dbo.EmployeeInfo emp inner join dbo.EmployeePosition em on em.EmpID =emp.EmpID group by em.Salary having count(*)>1 

with highest_salary
as(
select distinct top 2 Salary from Dbo.EmployeePosition order by Salary desc
)
select top 1 Salary from highest_salary order by Salary
select  Salary from dbo.EmployeePosition order by Salary desc offset 1 rows fetch next 1 rows only;
select top 1 * from (select top 2 Salary from dbo.EmployeePosition order by Salary desc ) result order by Salary 

update dbo.EmployeePosition set Salary=Salary +(Salary*20/100)

select Empname,Department from dbo.EmployeeInfo

select * into dbo.copyEmployeeInfo from dbo.EmployeeInfo
select * from dbo.copyEmployeeInfo

select e.Department,count(e.Empname) from dbo.EmployeeInfo e group by (Select Department )

select * from dbo.EmployeeInfo

select Salary,count(Salary) from dbo.EmployeePosition group by Salary having count(Salary) >1

select * from dbo.EmployeeInfo where Empname like '[A-z]%'

select charindex('Express Edition', 'pr')

select Empname from dbo.EmployeeInfo where (Select top 1 value from string_split(Empname,' ')) not in ('Prachi','Niva')

select Empname from (Select top 1 value from string_split(Empname,'(') as Empname))

select  * from dbo.EmployeePosition 
select * from dbo.EmployeeInfo
select Empname from dbo.EmployeeInfo where Empname like '%_kg_%'
select Empname,left(len(Empname),3) from dbo.EmployeeInfo where charindex(' kg ',Empname)>0
select ef.Department,count(ef.Empname) totalEmployee,sum(ep.Salary) from dbo.EmployeeInfo ef 
join dbo.EmployeePosition ep on ef.EmpID=ep.EmpID
group by ef.Department

select e.Department,count(e.Empname) total_employee,
(select sum(Salary) total_salary from dbo.EmployeePosition ep where EmpID=e.EmpID ) as salary
from dbo.EmployeeInfo e group by Department 

select substring(Address,1,charindex('(',Address)-1) from dbo.EmployeeInfo

select substring(Address,1,5) from dbo.EmployeeInfo

create type dbo.emp_info as table(
empid int,
empname varchar(100),
department varchar(100)
)

drop type dbo.emp_info
declare @empinfo as dbo.emp_info
insert into @empinfo(empid,empname,department)values(1,'Ly','hr')

insert into @empinfo(empid,empname,department) select EmpID,Empname,Department from EmployeeInfo

select * from dbo.EmployeeInfo e join dbo.EmployeeInfo e1 on e.Empname=e1.Empname and e.Department=e1.Department and e.Project=e1.Project
and e.Address=e1.Address and e.DOB=e1.DOB and e.Gender=e1.Gender where e.EmpID=19
select * from dbo.EmployeeInfo
select Empname from dbo.EmployeeInfo where Empname='Akash kg Mehra' union all select Empname from dbo.EmployeeInfo where
Empname='Akash kg Mehra'
select Empname,Gender from dbo.EmployeeInfo where Empname='Akash kg Mehra' except select Empname,Gender from dbo.EmployeeInfo where
Empname='Akash kg Mehra'

create table dbo.extra(
id int identity(1,1),
a bit,
b bit,
c bit,
d bit,
e bit
)
insert into dbo.extra(a,b,c,d,e) values(1,1,1,1,1),(1,1,1,1,1),(0,0,0,0,0),(1,1,1,0,0),(0,0,0,0,0),(1,1,1,0,0),(1,1,1,1,0),(0,1,1,1,1)
select * from dbo.extra
select count(*) from(
select distinct a,b,c,d,e from dbo.extra  where id in(1,7,3)
) pvt

 select * from dbo.EmployeeInfo
 select * from dbo.EmployeePosition

 SELECT * FROM dbo.EmployeeInfo D 
OUTER APPLY 
   ( 
   SELECT * FROM dbo.EmployeePosition E 
   WHERE E.EmpID = D.EmpID
   ) A 

 delete ep from dbo.EmployeePosition ep  left join dbo.EmployeeInfo ei on ep.EmpID=ei.EmpID
 where ei.Department in('hr')

 update ep set ep.GST=ep.Salary from dbo.EmployeePosition ep  left join dbo.EmployeeInfo ei on ep.EmpID=ei.EmpID
 where ei.Department in('admin')

 select * from dbo.EmployeePosition
 select * from dbo.EmployeeInfo

 with a(EmpID) as (
 select ei.EmpID from dbo.EmployeePosition ep  left join dbo.EmployeeInfo ei on ep.EmpID=ei.EmpID
 )

 declare @tbl table (name varchar(max))

 insert into @tbl values('Grading Transaction - Inward Grading Transaction'),('Grading Transaction - Outward Grading Transaction'),
 (' T Grading Transaction - Certification')

 select * from @tbl

 if exists (select 1 from @tbl where name like '%Grading Transaction%')
 begin
  update @tbl set name=REPLACE(name,'Grading Transaction','Transaction') where name like '%Grading Transaction%'
 end
 --update @tbl set name='Transaction' where name like '%Grading Transaction%'
 select * from @tbl


 select * from dbo.EmployeeInfo for json path