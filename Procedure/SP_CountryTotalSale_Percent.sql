-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <2026.03.03>
-- Description:	< SP_CountryTotalSale_Percent Between 2 Dates>
-- =============================================
CREATE PROCEDURE SP_CountryTotalSale_Percent @Date1 CHAR(10), @Date2 CHAR(10), @Percent NUMERIC(18,2)
AS 
WITH Totalsale AS (	SELECT SUM(FD.lineTotal) AS Totalsale FROM FactorDetail AS FD)
   , CountryTotalsale AS 
				(   select CO.Id,CO.Name 
							,SUM(ISNULL(FD.lineTotal,0))
							--CASE 
							--	when A.Id  not in (select AddressId from Customer)   THEN  0
							--	ELSE SUM(FD.lineTotal)
							-- END 
							 AS CountryTotalsale
					FROM FactorHeader AS FH
					INNER JOIN FactorDetail AS FD ON FH.Id =FD.FactorHeaderId
					INNER JOIN Customer AS C ON FH.CustomerId=C.CustomerCod
					RIGHT JOIN Address AS A ON A.Id=C.AddressId
					INNER JOIN City AS CI ON A.CityId=CI.Id
					INNER JOIN Country AS CO ON CO.Id=CI.CountryId
					WHERE FH.CreatedAt BETWEEN   @Date1 AND @Date2  
					group by  CO.Id,CO.Name	 ) 	
					

		SELECT  Id,Name AS Country,CountryTotalsale, CAST(CountryTotalsale / Totalsale *100  AS NUMERIC( 18,2)) AS CountryTotalsalePersent
		FROM    Totalsale,CountryTotalsale
		WHERE   CAST(CountryTotalsale / Totalsale *100  AS NUMERIC( 18,2)) <= 
				CASE 
					WHEN @Percent =101 THEN  CAST(CountryTotalsale / Totalsale *100  AS NUMERIC( 18,2)) 
					ELSE @Percent
				END
		ORDER BY CountryTotalsalePersent DESC OFFSET 0 ROWS
