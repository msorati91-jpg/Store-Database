


-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <1404,09,21>
-- Description:	< TOTALSale for ANY Caregory UND ANY PRODUCT between 2 Dates>
-- =============================================

Alter PROCEDURE SP_Caregory_Sale  @DATE1 DATE, @DATE2 DATE, @CATEGORY INT	 
AS 

WITH TotalSaleCategory AS 	(SELECT  CA.CatCode,SUM(FD.Price) AS  PriceT
				FROM  FactDetail AS FD 
				INNER JOIN Products AS P ON P.ProductCode=FD.ProductCode
				INNER JOIN ProductCategory AS CA ON P.CatCode=CA.CatCode
				GROUP BY CA.CatCode
		        )

		SELECT     --CompanyName,CI.CityDesc,
		CA.CatDesc, T.PriceT 
		,P.ProductCode,P.ProductDesc,
		SUM(FD.Qty) AS ProductNamber,
		SUM(FD.Price) AS Totalspend
		FROM Products AS P
		INNER JOIN FactDetail AS FD ON P.ProductCode=FD.ProductCode
		INNER JOIN FactHeader AS FH ON FD.FactNo=FH.FactNo
		INNER JOIN ProductCategory AS CA ON P.CatCode=CA.CatCode
		INNER JOIN TotalSaleCategory AS T ON T.CatCode=CA.CatCode 

		WHERE FH.FactDate BETWEEN convert(char,@DATE1) AND convert(char,@DATE2) AND P.CatCode=
		case 
			when @CATEGORY=0 then P.CatCode
			else @CATEGORY
		end 

		GROUP BY   
		CA.CatDesc, T.PriceT ,
		P.ProductCode,P.ProductDesc 
		ORDER BY CA.CatDesc,P.ProductDesc