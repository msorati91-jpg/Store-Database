--=============================================
-- Author:		<Bayat,Mahnaz>
-- Create date: <2026-03-29 >
-- Description:	<Sale Rate In Years And Month>
-- =============================================
ALTER FUNCTION Fn_SaleRateInYearAndMonth (@FromYear CHAR(4),@ToYear CHAR(4))
RETURNS TABLE
AS
RETURN
	WITH MonthlineTotal AS (
		SELECT YEAR(CreatedAt) AS Years ,MONTH(CreatedAt) AS Month ,SUM(lineTotal) AS MonthlineTotal ,
				ROW_NUMBER() OVER( ORDER BY YEAR(CreatedAt),MONTH(CreatedAt) DESC) AS Range
		FROM FactorHeader AS FH 
		INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
		GROUP BY YEAR(CreatedAt) ,MONTH(CreatedAt) )
		-----------------------------------------------
		SELECT YEAR(CreatedAt) AS Years,MLT.Month ,SUM(lineTotal) AS YearlineTotal ,MonthlineTotal
		FROM FactorHeader AS FH 
		INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
		RIGHT JOIN MonthlineTotal AS MLT ON MLT.Years=YEAR(FH.CreatedAt)
		WHERE YEAR(CreatedAt) BETWEEN  @FromYear  AND @ToYear 
		GROUP BY YEAR(CreatedAt) ,MLT.Month ,MonthlineTotal
		ORDER BY YEAR(CreatedAt) DESC OFFSET 0 ROWS 
