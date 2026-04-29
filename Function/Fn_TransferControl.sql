--=============================================
-- Author:		<Bayat,Mahnaz>
-- Create date: <2026-03-29 >
-- Description:	<Control Factors That Transfer>
-- =============================================
ALTER FUNCTION Fn_TransferControl (@Year INT)
RETURNS  @Result TABLE ( Year INT,  TotalFactors INT, NormalFact INT, DelayFact INT
						, NormalFactPercent DECIMAL(5,2), DelayFactPercent  DECIMAL(5,2)  )
AS
BEGIN
	--========================TotalFactors=============
	DECLARE @TotalFactors TABLE (Year INT,  TotalFactors INT)
	INSERT INTO @TotalFactors(Year  ,  TotalFactors)
	SELECT YEAR(CreatedAt),COUNT(Id) 
	FROM FactorHeader 
	GROUP BY YEAR(CreatedAt)
	--========================NormalFact=============
	DECLARE @Ok TABLE (Year INT,  NormalFactors INT)
	INSERT INTO @Ok(Year  ,  NormalFactors)
	SELECT YEAR(CreatedAt),COUNT(FH.Id) 
	FROM FactorHeader AS FH
	INNER JOIN FactorStatusHistory AS FSH ON FH.Id=FSH.FactorHeaderId AND FH.StatusId=FSH.StatusId
	WHERE  FSH.StatusId=6 AND DATEDIFF(DAY,FH.CreatedAt,FSH.StatusDate )<=10
	GROUP BY YEAR(CreatedAt)
	--========================DelayFact=============
	DECLARE @Delay TABLE (Year INT,  DelayFactors INT)
	INSERT INTO @Delay(Year  ,  DelayFactors)
	SELECT YEAR(CreatedAt),COUNT(FH.Id) 
	FROM FactorHeader AS FH
	INNER JOIN FactorStatusHistory AS FSH ON FH.Id=FSH.FactorHeaderId  AND FH.StatusId=FSH.StatusId
	WHERE  FSH.StatusId=6 AND DATEDIFF(DAY,FH.CreatedAt,FSH.StatusDate )>10
	GROUP BY YEAR(CreatedAt)
	---------------------------------------------------------------------------------
	INSERT INTO @Result (Year,TotalFactors,NormalFact, DelayFact, NormalFactPercent, DelayFactPercent)
	SELECT T.Year,TotalFactors,ISNULL(NormalFactors,0),ISNULL(DelayFactors,0)
			,ISNULL(CAST ( NormalFactors*100/TotalFactors  AS decimal(5,2)),0) AS NormalFactPercent
			,ISNULL(CAST ( DelayFactors*100/TotalFactors  AS decimal(5,2)),0) AS DelayFactPercent
	FROM @TotalFactors AS T
	LEFT JOIN @Ok AS O ON O.Year=T.Year
	LEFT JOIN @Delay AS D  ON D.Year=T.Year
	WHERE T.Year=CASE WHEN @Year=0 THEN T.Year
				ELSE  @Year
				END
RETURN
END
