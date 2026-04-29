--=============================================
-- Author:		<Bayat,Mahnaz>
-- Create date: <2026-03-15 >
-- Description:	<Sale Rate In Month Rather Than Bevor>
-- =============================================
CREATE FUNCTION F_MonthSaleRate (@Year INT,@Month INT)
RETURNS @Result TABLE(Year INT,Month INT,MonthLineTotal DECIMAL(18,2),MonthSaleRate DECIMAL(18,2),MonthSaleRatePercent DECIMAL(3,0))
AS
BEGIN
	DECLARE @MonthSale TABLE(Year INT,Month INT,MonthLineTotal DECIMAL(18,2))
	INSERT INTO @MonthSale (Year,Month,MonthLineTotal)
	SELECT YEAR(FH.CreatedAt) AS Year,MONTH(FH.CreatedAt) AS Month ,SUM(lineTotal) AS MonthLineTotal 
	FROM FactorHeader AS FH
	INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
	WHERE YEAR(FH.CreatedAt)=CASE WHEN @Year=0 THEN YEAR(FH.CreatedAt)
								  ELSE @Year
								  END
    AND	MONTH(FH.CreatedAt)=CASE WHEN @Month=0 THEN MONTH(FH.CreatedAt)
								 ELSE @Month
								 END
	GROUP BY YEAR(FH.CreatedAt),MONTH(FH.CreatedAt)
		----------------------------------------------------------------------
		INSERT INTO @Result (Year,Month,MonthLineTotal,MonthSaleRate,MonthSaleRatePercent)
		SELECT  	Year,Month,MonthLineTotal
		,CAST(ISNULL(MonthLineTotal-(LAG(MonthLineTotal) OVER (ORDER BY MONTH,YEAR) ),0) AS DECIMAL(18,2)) AS MonthSaleRate
		,CAST(ISNULL(MonthLineTotal-(LAG(MonthLineTotal) OVER (ORDER BY MONTH,YEAR) ),0)/MonthLineTotal*100 AS DECIMAL(3,0))	AS MonthSaleRatePercent
		FROM @MonthSale
RETURN
END
