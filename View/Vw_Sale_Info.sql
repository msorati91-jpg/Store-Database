-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	Vw_Sale_Info
-- =============================================
CREATE VIEW Vw_Sale_Info
AS 
SELECT  FH.CustomerId, CONCAT(C.FirstName,' ', C.LastName) AS CustomerName  ,CI.Name AS City,YEAR(FH.CreatedAt) AS SaleYear,
MONTH(FH.CreatedAt) AS SaleMonth,FH.[Description] ,
P.Id,P.Name,CA.Name AS Category,  FD.FactorHeaderId  AS FactorNamber,SUM(FD.Quantity) AS Quantity,
SUM(FD.SubTotal) AS Totalspend
FROM Product AS P
INNER JOIN FactorDetail AS FD ON P.Id=FD.ProductId
INNER JOIN FactorHeader AS FH ON FD.FactorHeaderId=FH.Id
LEFT JOIN Customer AS C ON FH.CustomerId=C.CustomerCod
INNER JOIN Address AS A ON A.Id=C.AddressId
INNER JOIN City AS CI ON A.CityId=CI.Id
INNER JOIN ProductCategory AS CA ON P.CategoryId=CA.Id
GROUP BY C.FirstName,C.LastName,CI.Name,FH.CreatedAt, FH.CustomerId , FH.[Description],
P.Id,P.Name,CA.Name,FD.FactorHeaderId  
