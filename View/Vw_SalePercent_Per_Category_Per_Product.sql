-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	Report_Vw_SalePercent_Per_Category_Per_Product
-- =============================================
CREATE VIEW Vw_SalePercent_Per_Category_Per_Product
AS
SELECT lTCSale.ID AS CategoryId ,lTCSale.Name AS CategoryName ,lineTotalCategorySale,
CAST (lineTotalCategorySale/lineTotalSale   *100  AS NUMERIC(18,2)) as lineTotalCategorySalepercent ,
P.ID as ProductId,P.Name AS ProductName ,lineTotalSale,
CAST ( sum (FD.lineTotal)/lineTotalSale   *100  AS NUMERIC(18,2)) as lineTotalSalepercent 
FROM  Product AS P 
INNER JOIN FactorDetail AS FD ON FD.ProductId=P.Id
INNER JOIN (select  SUM(lineTotal) AS lineTotalSale from FactorDetail) lineTotalSale on 1=1
INNER JOIN (
			select  PC.Id,PC.Name,SUM(lineTotal) AS lineTotalCategorySale 
			from FactorDetail AS FD
			INNER JOIN Product AS P ON P.Id=FD.ProductId
			INNER JOIN ProductCategory AS PC ON P.CategoryId=PC.Id
			GROUP BY   PC.Id,PC.Name
			) lTCSale ON  lTCSale.Id=p.CategoryId

GROUP BY  lTCSale.ID,lTCSale.Name,lineTotalCategorySale,p.id,p.Name ,lineTotalSale
ORDER BY lineTotalCategorySalepercent,lineTotalSalepercent   DESC OFFSET 0 ROW
