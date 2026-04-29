-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 12.03.2026
-- Description:	OrderDeliveryPerformance
-- =============================================
CREATE VIEW Vw_OrderDeliveryPerformance
AS
SELECT  FSH.FactorHeaderId,FSH.StatusId,FH.CreatedAt,FSH.StatusDate
  ,DATEDIFF(DAY, FH.CreatedAt,FSH.StatusDate) AS TRANSFERLANGE
  ,CASE WHEN DATEDIFF(DAY, FH.CreatedAt,FSH.StatusDate)=10 AND FSH.StatusId=6 THEN 'DELIVERRY ON TIME'
		WHEN DATEDIFF(DAY, FH.CreatedAt,FSH.StatusDate)<10  AND FSH.StatusId=6 THEN 'DELIVERY SOON'
		WHEN DATEDIFF(DAY, FH.CreatedAt,FSH.StatusDate)>10  AND FSH.StatusId=6 THEN 
		  'DELIVERY WITH '+CONVERT(VARCHAR(2),DATEDIFF(DAY, FH.CreatedAt,FSH.StatusDate))+' DAY RATE '
		WHEN DATEDIFF(DAY, FH.CreatedAt,GETDATE())>=10 AND FSH.StatusId<>6 THEN 'RATING IN PROCCESS '
		ELSE FS.Name
	END AS PERFORMANCE
  FROM FactorHeader AS FH
  INNER JOIN FactorStatusHistory AS FSH ON FH.Id=FSH.FactorHeaderId
  INNER JOIN FactorStatus AS FS ON FS.Id=FSH.StatusId
  GROUP BY FSH.FactorHeaderId,FSH.StatusId,FH.CreatedAt,FSH.StatusDate,FS.Name
  ORDER BY TRANSFERLANGE DESC OFFSET 0 ROWS
 
