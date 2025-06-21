select * from dbo.EmployeePosition



create table  stone_result(result_id int,stoneid int,action_type varchar(max),shape varchar(10),created_datetime datetime default getdate())


insert into stone_result(result_id,stoneid,action_type,shape) values 
--(1,1001,'New','d'),
--(2,1001,'New','e')
--(3,1001,'New','f')
(10,2001,'fo','d')

select * from dbo.stone_result
select * from (
select ROW_NUMBER() over(partition by gia.stoneid,gia.action_type order by gia.created_datetime desc) row_no,gia.stoneid
,gia.action_type from (
select a.*,b.id from dbo.stone_result a 
inner join (select action_type,stoneid,max(result_id) id   from dbo.stone_result group by action_type,stoneid) b on b.id=a.result_id
) as gia
left join (
select a.*,b.id from dbo.stone_result a 
inner join (select action_type,stoneid,max(result_id) id   from dbo.stone_result group by action_type,stoneid) b on b.id=a.result_id
)as recheck on gia.stoneid=recheck.stoneid and recheck.action_type='New'
where gia.action_type='Re' 
)m where row_no=1 
