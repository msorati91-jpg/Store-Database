
ALTER PROCEDURE SP_ContryTotalSale_Persent @Date1 CHAR(10), @Date2 CHAR(10), @Persent NUMERIC(18,2)
AS 

WITH Totalsale AS (	SELECT SUM(FD.Price) AS S2 FROM FactDetail AS FD)
--WITH CustomersCountryCode AS (select CountryCode from Customers)

SELECT  CO.CountryDesc,  
		CASE 
			when CO.CountryCode  not in (select CountryCode from Customers)   THEN  0
			ELSE SUM(FD.Price)
		END AS ContryTotalsale
		, CASE 
			when CO.CountryCode  not in (select CountryCode from Customers)   THEN  0
			ELSE CAST(SUM(FD.Price) / S2 *100  AS NUMERIC( 18,2)) 
		  END  AS ContryTotalsalePersent

FROM FactHeader AS FH
INNER JOIN FactDetail AS FD ON FH.FactNo=FD.FactNo
INNER JOIN Customers AS C ON FH.CustomerCode=C.CustomerCode
RIGHT JOIN Country AS CO ON C.CountryCode=CO.CountryCode 
INNER JOIN Totalsale AS T ON 1=1
WHERE FH.RequiredDate BETWEEN @Date1 AND @Date2  
group by CO.CountryDesc,CO.CountryCode,S2
HAVING CAST(SUM(FD.Price) / S2 *100  AS NUMERIC( 18,2))<= CASE WHEN @Persent =101 THEN CAST(SUM(FD.Price) / S2 *100  AS NUMERIC( 18,2))
ELSE @Persent
END
ORDER BY ContryTotalsalePersent DESC OFFSET 0 ROWS

