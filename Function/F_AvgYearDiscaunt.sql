--=============================================
-- Author:		<Bayat,Mahnaz>
-- Create date: <2026-03-15 >
-- Description:	<Average Discaunt In Year>
-- =============================================
CREATE FUNCTION F_AvgYearDiscaunt (	@FromDate DATE, @ToDate DATE )
RETURNS TABLE 
AS
RETURN 
(
	SELECT YEAR(FH.CreatedAt) AS Year,AVG(FD.DiscountAmount)  AS AVGDiscountAmount
	FROM FactorHeader AS FH
	INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
	WHERE CreatedAt BETWEEN @FromDate AND @ToDate--'2026-01-01' AND '2026-12-09'--
	GROUP BY YEAR(FH.CreatedAt)
	ORDER BY Year DESC OFFSET 0 ROWS
)
GO
