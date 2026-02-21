--==========================================
--DESCRIPTION : ContryTotalSale_Persent BETWEEN 2 DATES UND LOWER THEN PERSENT

--==============================
ALTER PROCEDURE SP_ContryTotalSale_Persent2 @Date1 CHAR(10), @Date2 CHAR(10), @Persent NUMERIC(18,2)
AS 

WITH Totalsale AS (	SELECT SUM(FD.Price) AS Totalsale FROM FactDetail AS FD)
   , ContryTotalsale AS 
				(   select CO.CountryCode,CO.CountryDesc
							,CASE 
								when co.CountryCode  not in (select CountryCode from Customers)   THEN  0
								ELSE SUM(FD.Price)
							END AS ContryTotalsale
					FROM FactHeader AS FH
					INNER JOIN FactDetail AS FD ON FH.FactNo=FD.FactNo
					INNER JOIN Customers AS C ON FH.CustomerCode=C.CustomerCode
					RIGHT JOIN Country AS CO ON C.CountryCode=CO.CountryCode 
					WHERE FH.RequiredDate BETWEEN   @Date1 AND @Date2  
					group by  CO.CountryCode,CO.CountryDesc
						--HAVING SUM(FD.Price)/ContryTotalsale.TS*100  <= CASE WHEN @Persent =101 THEN CAST(SUM(FD.Price)/TS*100   AS NUMERIC( 18,2))  
						--ELSE @Persent

					 )

 				 
		SELECT  CountryCode,CountryDesc,ContryTotalsale, 
				CASE 
					when ContryTotalsale.CountryCode  not in (select CountryCode from Customers)   THEN  0
					ELSE CAST(ContryTotalsale / Totalsale *100  AS NUMERIC( 18,2))  
				  END  AS ContryTotalsalePersent

		FROM Totalsale,ContryTotalsale
		WHERE  CAST(ContryTotalsale / Totalsale *100  AS NUMERIC( 18,2))  <= @Persent
		ORDER BY ContryTotalsalePersent DESC OFFSET 0 ROWS

