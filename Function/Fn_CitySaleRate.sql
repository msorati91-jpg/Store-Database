--=============================================
-- Author:		<Bayat,Mahnaz>
-- Create date: <2026-03-29 >
-- Description:	<Sale Rate In Citys>
-- =============================================
ALTER FUNCTION Fn_CitySaleRate (@FromDate CHAR(4),@ToDate CHAR(4),@CountryCode INT)
RETURNS TABLE
AS
RETURN
		SELECT RANK() OVER( ORDER BY SUM(lineTotal) DESC) AS RANKING,
		CO.Id AS CountryId ,CO.Name AS Country,CI.Name AS City,SUM(SubTotal) AS SubTotal ,SUM(lineTotal) AS lineTotal
		FROM FactorHeader AS FH 
		INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
		INNER JOIN Customer AS C ON FH.CustomerId=C.CustomerCod
		INNER JOIN Address AS A ON A.Id=C.AddressId
		INNER JOIN City AS CI ON CI.Id=A.CityId
		INNER JOIN Country AS CO ON CO.Id=CI.CountryId
		WHERE YEAR(FH.CreatedAt) BETWEEN @FromDate  AND @ToDate 
			  AND CO.Id=CASE WHEN @CountryCode=0 THEN  CO.Id
						ELSE @CountryCode
						END
		GROUP BY CO.ID,CO.Name,CI.Name
	
