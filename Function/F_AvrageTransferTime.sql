-- =============================================
-- Author:		Bayat,Mahnaz
-- Create date: 12.03.2026
-- Description:	OrderDeliveryPerformance
-- =============================================
ALTER FUNCTION F_AvrageTransferTime (@STATUSID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
	DECLARE @AvrageTime DECIMAL(18,2)
	SELECT @AvrageTime=AVG(DATEDIFF(DAY, FH.CreatedAt,FSH.StatusDate)) 
	FROM FactorStatusHistory AS FSH
	INNER JOIN FactorHeader AS FH ON FH.Id=FSH.FactorHeaderId
	WHERE FSH.StatusId=@STATUSID  
	RETURN ISNULL(@AvrageTime,0)
END
