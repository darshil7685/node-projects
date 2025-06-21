--select * from dbo.EmployeeInfo
--select * from dbo.EmployeePosition
--select * from dbo.EmployeeInfo ei left join dbo.EmployeePosition ep on ei.EmpID=ep.EmpID where --ei.EmpID=ep.EmpID 
----and 
--ep.EmpID is  null and ei.Empname='Alex'
declare  @temp table(stoneid int ,certificate_code int,descript varchar(10))
insert into @temp values(101,2,'gia'),(101,3,'hrd'),(102,2,'gia'),(103,3,'hrd'),(103,2,'gia'),(104,3,'gia'),(105,2,'igi'),(106,4,'igi')
declare  @temp1 table(stoneid int ,des varchar(10) null)
insert into @temp1 values(101,'a'),(101,'b'),(102,'a'),(103,'b'),(103,'a'),(104,'a')

declare  @temp2 table(stoneid int ,shape varchar(10) null)
insert into @temp2 values(101,'round'),(102,'r'),(103,'r')
declare  @temp3 table(stoneid int ,color varchar(10) null)
insert into @temp3 values(101,'g'),(102,'d'),(103,'d')


select  t.stoneid,t.certificate_code,t1.stoneid,t1.des from @temp t 
left join @temp1 t1 on t.stoneid=t1.stoneid and t1.des ='a' 

select  t.stoneid,t.certificate_code,t1.stoneid,t1.des from @temp t 
left join @temp1 t1 on t.stoneid=t1.stoneid and t1.des ='a' 
where (t.certificate_code<>2 or (t.certificate_code=2 and  t1.stoneid is not null)) 

--select * from @temp
--select * from @temp1

--select t.stoneid,t.certificate_code,t1.des,t1.stoneid from @temp t
--left join (
--select  t.stoneid,t.certificate_code,t1.des from @temp t 
--left join @temp1 t1 on 
--t.stoneid=t1.stoneid where t.certificate_code=2 and t1.des ='a') t1
--on t1.stoneid=t.stoneid and t.certificate_code=t1.certificate_code and t.stoneid is not null--where  t1.stoneid=t.stoneid

--and t.stoneid=t1.stoneid

