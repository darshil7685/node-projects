select * from dbo.EmployeeInfo
select * from dbo.EmployeePosition

drop table if exists #temp
declare @temp table(EmpID int, EmpPosition varchar(20),Salary bigint,GST int)
insert into @temp values (1,'Leakjdwe',8,5),(3,'sub-admin1',1000000,100)

--select * from @temp

declare @start datetime=SYSDATETIME()


merge into dbo.EmployeePosition dest
using @temp sou on sou.EmpID=dest.EmpID and sou.EmpPosition=dest.EmpPosition
when matched then
update set
dest.EmpPosition=sou.EmpPosition,
dest.Salary=sou.Salary,
dest.GST=sou.GST

when not matched by target then
insert (EmpID,EmpPosition,Salary,GST)
values(sou.EmpID,sou.EmpPosition,sou.Salary,sou.GST);

--declare @end datetime=SYSDATETIME()

--select datediff(MILLISECOND,@start,@end)

--update dest  set
--dest.EmpPosition=sou.EmpPosition,
--dest.Salary=sou.Salary,
--dest.GST=sou.GST
--from @temp sou
--left join dbo.EmployeePosition dest on sou.EmpID=dest.EmpID and sou.EmpPosition=dest.EmpPosition
--where dest.EmpID is not null and dest.EmpPosition is not null


--declare @start1 datetime=sysdatetime()
--insert into dbo.EmployeePosition (EmpID,EmpPosition,Salary,GST)
--select sou.EmpID,sou.EmpPosition,sou.Salary,sou.GST from @temp sou left join 
--dbo.EmployeePosition dest on sou.EmpID=dest.EmpID where dest.EmpID is null and dest.EmpPosition is null 


--declare @end1 datetime= sysdatetime()
--select DATEDIFF(MILLISECOND,@start1,@end1)

--declare @start2 datetime=sysdatetime()
--select sou.EmpID,sou.EmpPosition,sou.Salary,sou.GST into #temp from @temp sou left join 
--dbo.EmployeePosition dest on sou.EmpID=dest.EmpID where dest.EmpID is null
--insert into dbo.EmployeePosition (EmpID,EmpPosition,Salary,GST)
--select EmpID,EmpPosition,Salary,GST from #temp

--declare @end2 datetime= sysdatetime()
--select DATEDIFF(MILLISECOND,@start2,@end2)


select * from dbo.EmployeeInfo
select * from dbo.EmployeePosition

select  ei.EmpID,ep.EmpID from dbo.EmployeeInfo ei
join dbo.EmployeePosition ep on ei.EmpID=ep.EmpID

alter table dbo.EmployeeInfo add abcd tinyint default 0

alter table dbo.EmployeeInfo drop column abc
IF EXISTS 
(
  SELECT * 
  FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE table_name = 'EmployeeInfo' and TABLE_SCHEMA='dbo'
  AND column_name = 'a_bc'
)
begin
EXEC sp_rename 'dbo.EmployeeInfo.a_bc', 'abc', 'COLUMN';
end

insert into dbo.EmployeeInfo(Empname) values('Nion')