-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <2026.03.03>
-- Description:	< top CostomerSpent Between 2 Dates>
-- =============================================
ALTER PROCEDURE SP_CustomerSpent @top INT,@FromDate DATE ,@ToDate DATE 
AS
BEGIN
	IF @FromDate IS NULL SET @FromDate=DATEADD(YEAR,-1,GETDATE())
	IF @ToDate IS NULL SET @ToDate=GETDATE();
	WITH TotalSpent AS( SELECT SUM(SubTotal) AS TotalSpent FROM FactorDetail),
		 CustomerTotalSpent AS (	
								SELECT  TOP (20) RANK() OVER (ORDER BY SUM(SubTotal) DESC) AS Ranking,
								CONCAT(C.FirstName ,' ', C.LastName) AS Customer,CO.Name AS Country,CI.Name AS City,A.Street,A.ExtraInfo,A.PostalCode,C.Email,C.Phone,
								SUM(SubTotal) AS CustomerTotalSpent
								FROM FactorHeader AS FH
								INNER JOIN FactorDetail AS FD ON FD.FactorHeaderId=FH.Id
								RIGHT JOIN Customer AS C ON C.CustomerCod=FH.CustomerId
								INNER JOIN Address AS  A ON  A.Id=C.AddressId
								INNER JOIN City AS CI ON CI.Id=A.CityId
								INNER JOIN Country AS CO ON CI.CountryId=CO.Id
								WHERE FH.CreatedAt BETWEEN @FromDate  AND @ToDate 
								GROUP BY CONCAT(C.FirstName,' ',c.LastName),CO.Name,CI.Name,A.Street,A.ExtraInfo,A.PostalCode,C.Email,C.Phone
								)
		-------------------------------------------------------------------------------------------------
	SELECT
			 Ranking,Customer, Country, City, Street, ExtraInfo, PostalCode, Email, Phone,CustomerTotalSpent,
			 CAST(CustomerTotalSpent/TotalSpent * 100  AS numeric(18,2)) AS CustomerTotalSpentPercent
	FROM CustomerTotalSpent ,TotalSpent
	GROUP BY Customer, Country, City, Street, ExtraInfo, PostalCode, Email, Phone,CustomerTotalSpent,TotalSpent,Ranking
END
