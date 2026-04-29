-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <2026.03.08>
-- Description:	< Report_ProductSal In Year Und Month >
-- =============================================
CREATE PROCEDURE SP_ProductSale  @Year INT ,@Month INT
AS
	SELECT YEAR(FH.CreatedAt) AS YEAR,MONTH(FH.CreatedAt) AS MONTH,PC.Id,PC.Name,P.Id,P.Name 
	,COUNT(DISTINCT(FD.FactorHeaderId)) AS FactorCount
	,SUM( FD.Quantity) AS TotalQuantity
	,SUM(FD.UnitPrice*FD.Quantity) AS MonthSALE
    ,SUM(FD.DiscountPercent) AS DiscountPercent
	,SUM(FD.TaxPercent) AS TaxPercent
	,SUM(FD.lineTotal) AS lineTotal
	FROM FactorHeader AS FH 
	INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
	RIGHT JOIN Product AS P ON FD.ProductId=P.Id
	INNER JOIN ProductCategory AS PC ON P.CategoryId=PC.Id
	WHERE  YEAR(FH.CreatedAt)=CASE WHEN @Year ='' THEN  YEAR(FH.CreatedAt) ELSE @Year END
	AND   MONTH(FH.CreatedAt)=CASE WHEN @Month ='' THEN MONTH(FH.CreatedAt) ELSE @Month END  
	GROUP BY YEAR(FH.CreatedAt)  ,MONTH(FH.CreatedAt),PC.Id,PC.Name,P.Id,P.Name 
	ORDER BY PC.Id,P.Id  OFFSET 0 ROWS
