-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	Report_All_Info
-- =============================================
ALTER VIEW Vw_All_Info
AS 
    SELECT  P.Name AS ProductName,P.Description  AS ProductDescription ,
    PC.Name AS Category,PU.Name AS Unit,S.Name AS SupplierName ,
    FH.Id AS FactorNumber,FH.Description AS FactorDescription,PE.PersonnelCod,
    CONCAT(PE.FirstName,' ',PE.LastName) AS PersonnelName , 
    C.CustomerCod,CONCAT(C.FirstName,' ',C.LastName) AS CustomerName, S.Phone,
    CO.Name AS Country,CI.Name AS City,
   FD.UnitPrice,FD.Quantity ,FD.DiscountPercent,FD.SubTotal,FD.TaxPercent,FD.lineTotal
   --SELECT * 
   FROM FactorHeader AS FH 
    INNER JOIN FactorDetail AS FD ON FH.Id=FD.FactorHeaderId
    INNER JOIN Customer AS C ON C.CustomerCod=FH.CustomerId
    INNER JOIN Personnel AS PE ON PE.PersonnelCod=FH.PersonnelId
    RIGHT JOIN Product AS P ON P.Id=FD.ProductId
    INNER JOIN ProductCategory AS PC ON PC.ID=P.CategoryId 
    INNER JOIN ProductUnit AS PU ON PU.ID=P.UnitId
    INNER JOIN Supplier  AS S ON S.Id=P.SupplierId
    LEFT JOIN Address AS A ON A.Id=C.AddressId
    LEFT JOIN City AS CI ON CI.Id=A.CityId
    LEFT JOIN Country AS CO ON CO.Id=CI.CountryId
