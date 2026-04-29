-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <2026.03.03>
-- Description:	< TotalSale For Any Caregory Und Any ProductT Between 2 Dates>
-- =============================================
CREATE PROCEDURE SP_CategorySale  @DATE1 DATE, @DATE2 DATE, @CATEGORY INT	 
AS 
WITH TotalSaleCategory AS 	(SELECT  CA.Id,SUM(FD.lineTotal) AS  TotalPrice
				FROM  FactorDetail AS FD 
				INNER JOIN Product AS P ON P.Id=FD.ProductId
				INNER JOIN ProductCategory AS CA ON P.CategoryId=CA.Id
				GROUP BY CA.Id )
		SELECT CA.Id AS CategoryId,CA.Name AS Category , T.TotalPrice ,P.Id AS ProductId,P.Name AS ProductName ,
		SUM(FD.Quantity) AS TotalProduct,SUM(FD.lineTotal) AS Totalspend
		FROM Product AS P
		INNER JOIN FactorDetail AS FD ON P.Id=FD.ProductId
		INNER JOIN FactorHeader AS FH ON FD.FactorHeaderId=FH.Id
		INNER JOIN ProductCategory AS CA ON P.CategoryId=CA.Id
		INNER JOIN TotalSaleCategory AS T ON T.Id=CA.Id
		WHERE FH.CreatedAt BETWEEN @DATE1 AND @DATE2 AND P.CategoryId=
		case 
			when @CATEGORY=0 then P.CategoryId
			else @CATEGORY
		end 
		GROUP BY CA.Id ,CA.Name  , T.TotalPrice ,P.Id  ,P.Name  
		ORDER BY CA.Name,P.Name
