select * from Sales.Customer
select * from Person.Address
select * from Sales.SalesTerritory

select * from Production.Product
select * from Purchasing.ProductVendor
select * from Purchasing.Vendor

select * from Sales.SalesOrderHeader
select * from Sales.SalesOrderDetail

select * from Production.WorkOrder
select * from Production.WorkOrderRouting
select * from Production.Location
select * from Production.ProductReview
select * from Production.ProductListPriceHistory

select * from Sales.SpecialOfferProduct
select * from Sales.SpecialOffer

select sop.ProductID,so.SpecialOfferID from  Sales.SpecialOfferProduct sop
left join Sales.SpecialOffer so  on so.SpecialOfferID=sop.SpecialOfferID

select distinct pv.BusinessEntityID,v.Name,p.ListPrice,p.SafetyStockLevel from Purchasing.ProductVendor pv
left join Purchasing.Vendor v on pv.BusinessEntityID=v.BusinessEntityID
left join Production.Product p on p.ProductID=pv.ProductID
where pv.ProductID not in (select ProductID 
from Sales.SalesOrderDetail)

select * from Sales.SalesOrderDetail 

select  count(1),sum(sod.OrderQty) qty,sum(sod.LineTotal) amount,
sod.ProductID,rank() over (order by sum(sod.LineTotal))  from Sales.SalesOrderDetail sod left join  
 Production.Product p on sod.ProductID=p.ProductID
 group by sod.ProductID 


 
select * from Sales.SalesOrderHeader
select * from Sales.SalesOrderDetail

select SOH.SalesOrderID,SOH.CustomerID,SOD.ProductID from Sales.SalesOrderHeader SOH
left join Sales.SalesOrderDetail SOD on SOH.SalesOrderID=SOD.SalesOrderID

select distinct  pr.ProductID  from  Production.ProductReview pr  left join 
Sales.SpecialOfferProduct sop on sop.ProductID=pr.ProductID
left join Sales.SpecialOffer so on so.SpecialOfferID=sop.SpecialOfferID
where so.Category='Customer'

select * from (
select SOH.TerritoryID t_id,ST.Name name from Sales.SalesOrderHeader SOH left join
Sales.SalesTerritory ST on ST.TerritoryID=SOH.TerritoryID
) t
pivot (
	count(t_id) for name in ([NorthWest],[Northeast],[central],[Canada],[Germany])
) as pvt 
