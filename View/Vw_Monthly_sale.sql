-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 11.01.2026
-- Description:	REPORT_Monthly_sale
-- =============================================
CREATE VIEW Vw_Monthly_sale
AS
    SELECT         YEAR  ( FH.CreatedAt ) AS YEAR ,
                   MONTH ( FH.CreatedAt ) AS MONTH
                   	,COUNT(DISTINCT(FD.FactorHeaderId)) AS TotalFactor
	,COUNT(DISTINCT(FH.CustomerId)) AS TotalCustomer
	,SUM(FD.Quantity) AS TotalQuantity
	,SUM(FD.SubTotal) AS MonthlySale
    ,DiscountPercent
	,sum(FD.DiscountAmount) AS DiscountAmount
    ,TaxPercent
    ,TaxAmount
	,SUM(FD.lineTotal) AS lineTotal
    FROM  FactorDetail FD 
    INNER JOIN FactorHeader FH    ON  fh.id=FD.FactorHeaderId 
    GROUP BY     YEAR  ( FH.CreatedAt )  ,  MONTH ( FH.CreatedAt ),   lineTotal,TaxAmount,DiscountPercent,TaxPercent
    ORDER BY YEAR  ( FH.CreatedAt )  ,  MONTH ( FH.CreatedAt ),   lineTotal DESC OFFSET 0 ROW
