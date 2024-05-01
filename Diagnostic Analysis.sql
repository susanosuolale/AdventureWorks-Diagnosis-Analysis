USE AdventureWorks2022
 
SELECT Year, Revenue, COGS, Salaries + SalesCommission + PromotionCost AS OperatingExpense, Revenue-COGS-(Salaries + SalesCommission + PromotionCost)
       AS NetProfit, (Revenue-COGS-(Salaries + SalesCommission + PromotionCost)) * 100/Revenue AS NetProfitMargin
FROM (SELECT DATEPART(Year,OrderDate) AS Year, 
       SUM(soh.SubTotal) AS Revenue, SUM(p.StandardCost * sod.OrderQty) AS COGS,
	   SUM(Rate *40*52) AS Salaries,
	   SUM(sp.CommissionPct) AS SalesCommission,
	   SUM(so.DiscountPct * soh.SubTotal) AS PromotionCost
	   
	   FROM HumanResources.EmployeePayHistory AS emp
       JOIN Sales.SalesPerson as sp ON emp.BusinessEntityID = sp.BusinessEntityID
       JOIN Sales.SalesOrderHeader AS soh ON soh.SalesPersonID = sp.BusinessEntityID
       JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
       JOIN Production.Product AS p ON p.ProductID = sod.ProductID
       JOIN Sales.SpecialOffer AS so ON so.SpecialOfferID = sod.SpecialOfferID
       GROUP BY DATEPART(Year,OrderDate)) AS table1
ORDER BY Year
