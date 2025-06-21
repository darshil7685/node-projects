DECLARE @json NVARCHAR(MAX) = N'[  
  {  
    "Order": {  
      "Number":"SO43659",  
      "Date":"2011-05-31T00:00:00"  
    },  
    "AccountNumber":"AW29825",  
    "Item": {  
      "Price":2024.9940,  
      "Quantity":1  
    }  
  },  
  {  
    "Order": {  
      "Number":"SO43661",  
      "Date":"2011-06-01T00:00:00"  
    },  
    "AccountNumber":"AW73565",  
    "Item": {  
      "Price":2024.9940,  
      "Quantity":3  
    }  
  }
]'



select * from openjson(@json)
WITH (
Number Varchar(200) '$.Order.Number',
count tinyint '$.sql:identity()'
)


DECLARE @json1 NVARCHAR(MAX),@json2 NVARCHAR(MAX)
SET @json1=N'{"name": "John", "surname":"Doe"}'
SET @json2=N'{"name": "John", "age":45}'
 
SELECT *
FROM OPENJSON(@json1)
UNION ALL
SELECT *
FROM OPENJSON(@json2)
WHERE [key] NOT IN (SELECT [key] FROM OPENJSON(@json1))

DECLARE @JSON NVARCHAR(MAX) = N'[
{
"OrderNumber":"SO43659",
"OrderDate":"2011-05-31T00:00:00",
"AccountNumber":"AW29825",
"ItemPrice":2024.9940,
"ItemQuantity":1
},
{
"OrderNumber":"SO43661",
"OrderDate":"2011-06-01T00:00:00",
"AccountNumber":"AW73565",
"ItemPrice":2024.9940,
"ItemQuantity":3
}
]'

SELECT root.[key] AS [Order],TheValues.[key], TheValues.[value]
FROM OPENJSON ( @JSON ) AS root
CROSS APPLY OPENJSON ( root.value) AS TheValues

select JSON_ARRAY(select value from string_split("a,b,c",","))
select JSON_ARRAY('2','s')


declare @js nvarchar(max)=N'{"stoneid":123456789,"a":"b"},{"stoneid":985632147,"a":"x"},{"stoneid":789,"a":"sdfsdc"}'

select JSON_VALUE(@js,'$.stoneid') stoneid from openjson(@js) a