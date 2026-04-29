--=============================================
-- Author:		<Bayat,Mahnaz>
-- Create date: <2026-03-15 >
-- Description:	<Sale Rate In Years>
-- =============================================
ALTER FUNCTION F_YearSaleRate (@FromYear CHAR(4),@ToYear CHAR(4))
RETURNS TABLE
AS
RETURN
(
	SELECT YEAR(FH.CreatedAt) AS Year,SUM(lineTotal) AS YearsLineTotal 
	,CAST(ISNULL(SUM(lineTotal)-(LAG(SUM(lineTotal)) OVER (ORDER BY YEAR(FH.CreatedAt)) ),0) AS decimal(18,2)) AS SaleRate
	,CAST(ISNULL(SUM(lineTotal)-(LAG(SUM(lineTotal)) OVER (ORDER BY YEAR(FH.CreatedAt)) ),0)/SUM(lineTotal)*100 AS decimal(2,0))	AS SaleRatePercent
	FROM FactorHeader AS FH
	INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
	WHERE  YEAR(FH.CreatedAt) BETWEEN @FromYear AND @ToYear
	GROUP BY YEAR(FH.CreatedAt)
)
