-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	Repot_Topspent_Customer
-- =============================================
CREATE VIEW Vw_Topspent_Customer
AS
SELECT   Fh.CustomerId,CU.LastName,
COUNT(DISTINCT FD.FactorHeaderId) AS SumFactor,SUM(FD.SubTotal) AS SumSpent,
RANK() OVER (ORDER BY  SUM(FD.SubTotal) DESC) AS RankingCustomer
FROM FactorHeader AS FH 
INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
INNER JOIN Customer AS CU ON Fh.CustomerId=CU.CustomerCod
INNER JOIN Address AS A ON A.Id=CU.AddressId
INNER JOIN City AS CI ON CI.Id=A.CityId
INNER JOIN Country AS CO ON CO.Id=CI.CountryId
GROUP BY   Fh.CustomerId,CU.LastName
