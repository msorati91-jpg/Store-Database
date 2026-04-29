-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	REPORT_SumSale_per_supliers
-- =============================================
CREATE VIEW VW_SumSale_per_supliers
AS
		SELECT S.Id,S.Name AS Company, c.Name AS City , CO.Name AS Country ,A.Street,A.PostalCode,SUM(FD.lineTotal) AS SumSale
		FROM  [Supplier] AS S
		INNER JOIN [Product] AS P ON  S.Id=P.SupplierId
		INNER JOIN [FactorDetail] AS FD	ON  p.Id=fd.ProductId
		INNER JOIN [Address] AS A ON s.AddressId=A.Id
		INNER JOIN [City] AS C ON A.CityId=c.Id
		INNER JOIN [Country] AS CO ON CO.Id=C.CountryId

		GROUP BY S.Id,S.Name, C.Name, CO.Name,A.Street,A.PostalCode
