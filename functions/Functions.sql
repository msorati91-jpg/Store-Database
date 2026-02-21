
--====================================Scalar_Function1========================
--ALTER FUNCTION Fn_miladitoschamsi_1 (@DATE DATETIME)
--RETURNS  CHAR(10)
--AS 
--BEGIN
--	DECLARE @RESULTDATE CHAR(50)
--	SELECT @RESULTDATE=FH.RequiredDate
--	FROM FactHeader AS FH
--	WHERE FH.Miladi_RequiredDate=@DATE
--RETURN @RESULTDATE
--END
--GO
----SELECT  CustomerCode ,DBO.Fn_miladitoschamsi_1(Miladi_RequiredDate) FROM FactHeader 

--====================================Scalar_Function2========================
--ALTER FUNCTION Fn_FactDiscount (@FactorNumber INT)
--RETURNS NUMERIC(18,2)
--AS
--BEGIN
	--	DECLARE @FactDiscount NUMERIC(18,2)
	--	SELECT @FactDiscount=CAST(SUM( Price * DiscountPercent) AS NUMERIC(18,2)) --AS FactDiscount    
	--	FROM FactHeader AS FH
	--	INNER JOIN FactDetail AS FD ON FH.FactNo=FD.FactNo
	--	WHERE  FD.FactNo=@FactorNumber
	--	GROUP BY FH.FactDate,FD.FactNo
	--	RETURN @FactDiscount
--END
--GO
--SELECT  * ,DBO.Fn_FactDiscount(FACTNO) AS FactorDiscountPrice  FROM FactDetail
--==========================================Inline_Function-- AvgYear_DiscountPrice
--ALTER FUNCTION Fn_AvgDiscaunt ( @DATE1 CHAR(10) , @DATE2 CHAR(10) )
--RETURNS TABLE
--AS
--RETURN
--	 ( 
--	 SELECT  LEFT(RequiredDate,4) AS YEARS,ROUND(AVG(Price*DiscountPercent),1,0   )AS AvgDiscountPrice
--	 FROM FactHeader AS FH
--	 INNER JOIN FactDetail AS FD ON FH.FactNo=FD.FactNo
--	 WHERE FH.RequiredDate BETWEEN  @DATE1 AND @DATE2 --'1401/01/01/'AND '1402/12/01'
--	 GROUP BY LEFT(RequiredDate,4)
--	 ORDER BY YEARS OFFSET 0 ROWS
--	 )
--GO
-- --SELECT * FROM  Fn_AvgDiscaunt('1401/01/01/', '1403/12/01')

--==============================================Inline_Function-_RateYears=============================
--ALTER FUNCTION Fn_RateYears (@YEAR1 CHAR(4),@YEAR2 CHAR(4) )
--RETURNS TABLE -- @Result(YEARS INT ,YearTotalPrice NUMERIC(18,10),roshd NUMERIC(18,10))
--AS
--RETURN
--			SELECT LEFT(FactDate,4) AS YEARS, SUM( Price) AS YearTotalPrice
--			,CAST((SUM( Price) - (LAG (SUM( Price)) OVER(ORDER BY LEFT(FactDate,4) )) /SUM( Price) ) AS NUMERIC(18,2)) AS RATE
--			FROM FactHeader AS FH
--			INNER JOIN FactDetail AS FD ON FH.FactNo=FD.FactNo
--			WHERE LEFT(FactDate,4) BETWEEN @YEAR1 AND @YEAR2
--			GROUP BY LEFT(FactDate,4)--,roshd
--SELECT * FROM Fn_RateYears('1401','1403')  
--===========================================MULTI VALUE FUNCTION-ControlSendFactors================
--ALTER FUNCTION Fn_ControlFactors (@YEAR INT )
--RETURNS   @Result   TABLE (YEARS INT , TotalFact INT,TotalFactOK INT,TotalFactDeley INT 
--						  ,PerTotalFactOK NUMERIC(18,2),PerTotalFactDeley NUMERIC(18,2))
--AS
--BEGIN
--			 --=======================@Total==================
--			 DECLARE @Total TABLE (Years INT,TotalFact INT)
--			 INSERT INTO @Total (Years  ,TotalFact  )
--			 SELECT YEAR(Miladi_FactDate),COUNT(FactNo) 
--			 FROM FactHeader  
--			 GROUP BY YEAR(Miladi_FactDate)
--			 --=======================@oK======================
--			 DECLARE @OK TABLE (Years INT,TotalFactOK INT)
--			 INSERT INTO @OK (Years  ,TotalFactOK  )
--			 SELECT YEAR(Miladi_FactDate),COUNT(FactNo)
--			 FROM FactHeader
--			 WHERE Miladi_TransferDate<=Miladi_RequiredDate
--			 GROUP BY YEAR(Miladi_FactDate)
--			 --=======================@Delay====================
--			 DECLARE @Delay TABLE (Years INT,TotalFactDeley INT)
--			 INSERT INTO @Delay (Years  ,TotalFactDeley  )
--			 SELECT YEAR(Miladi_FactDate),COUNT(FactNo) 
--			 FROM FactHeader
--			 WHERE ISNULL(Miladi_TransferDate,GETDATE())>Miladi_RequiredDate
--			 GROUP BY YEAR(Miladi_FactDate)
--			 --===========================================
--			 INSERT INTO @RESULT (YEARS  , TotalFact ,TotalFactOK ,TotalFactDeley,PerTotalFactOK ,PerTotalFactDeley )
--			 SELECT T.Years,TotalFact,TotalFactOK,TotalFactDeley,
--			 CAST(TotalFactOK  AS NUMERIC(18,2) )/TotalFact *100,
--			 CAST(TotalFactDeley AS NUMERIC(18,2)  ) /TotalFact *100
--			 FROM @OK AS O
--			 INNER JOIN @Delay AS D ON D.Years=O.Years
--			 INNER JOIN @Total AS T ON T.Years=D.Years
--			 WHERE T.YEARS = CASE WHEN  @YEAR=0 THEN T.YEARS
--							 ELSE @YEAR
--							 END
--RETURN 
--END
-- --SELECT * FROM    Fn_ControlFactors( 2023)

-- --=======================================RateSale======================================
-- CREATE FUNCTION Fn_MounthRateSale (@Year INT,@Mounth INT)
-- RETURNS @RESULT TABLE (Years INT , Months INT,SaleNow INT,SaleBefore INT,Rate NUMERIC(18,2))
-- AS
-- BEGIN
		-- --=============================@Sale 
		--	DECLARE @Sale  TABLE (Years INT , Months INT,MonthSale  INT)
		--	INSERT INTO @Sale  (Years  , Months ,MonthSale )
		--	SELECT LEFT(FH.FactDate,4)  ,SUBSTRING(FH.FactDate,6,2) ,SUM(FD.Price) AS MonthSale 
		--	FROM FactHeader AS FH 
		--		INNER JOIN FactDetail AS FD ON FH.FactNo=FD.FactNo
		--		WHERE LEFT(FH.FactDate,4)=CASE WHEN @Year =0 THEN LEFT(FH.FactDate,4) ELSE @Year END
		--		AND
		--		SUBSTRING(FH.FactDate,6,2)=CASE WHEN @Mounth =0 THEN SUBSTRING(FH.FactDate,6,2) ELSE @Mounth END
		--		GROUP BY  LEFT(FH.FactDate,4)  ,SUBSTRING(FH.FactDate,6,2)
		----===================================
		--	INSERT INTO @RESULT (Years  , Months ,SaleNow ,SaleBefore ,Rate)
		--	SELECT S.Years,S.Months,MonthSale,LAG( MonthSale ) over (ORDER BY Years  , Months),
		--	(MonthSale - (LAG( MonthSale ) over (ORDER BY Years  , Months)))*100
		--    FROM @Sale AS S
-- RETURN
-- END
-- --SELECT * FROM Fn_MounthRateSale (1401,0)

-- --=======================================RankCitySale======================================
-- ALTER FUNCTION Fn_RankCitySale (@Date1 CHAR(10),@Date2 CHAR(10),@CUontrycode smallint)
-- RETURNS TABLE
-- AS
-- RETURN	 
--		SELECT  CO.CountryCode,CO.CountryDesc,CI.CityCode,CI.CityDesc,SUM(FD.Price) CitySale--,SUBSTRING(FH.FactDate,1,4) AS Year
--		,ROW_NUMBER () OVER (PARTITION BY CO.CountryCode ORDER BY SUM(FD.Price) DESC) RankCity
--        FROM FactDetail AS FD 
--		INNER JOIN FactHeader AS FH ON FD.FactNo=FH.FactNo
--		INNER JOIN Customers AS C ON  FH.CustomerCode=C.CustomerCode
--		INNER JOIN Country AS CO ON C.CountryCode=CO.CountryCode
--		INNER JOIN City AS CI ON C.CityCode=CI.CityCode
--		WHERE CO.CountryCode=CASE WHEN @CUontrycode=0 THEN CO.CountryCode
--								ELSE @CUontrycode
--								END
--		AND FH.FactDate BETWEEN @Date1 AND @Date2
--		GROUP BY CO.CountryDesc, CO.CountryCode,CI.CityCode,CI.CityDesc--,SUBSTRING(FH.FactDate,1,4)
--		ORDER BY CO.CountryCode,CitySale DESC OFFSET 0 ROWS
-- GO
-- SELECT * FROM Fn_RankCitySale ('1401','1403',24)
-- --=======================================SaleCumulative======================================
 ALTER FUNCTION Fn_SaleCumulative (@Date1 CHAR(10),@Date2 CHAR(10))
 RETURNS TABLE 
 AS
 RETURN 
			SELECT Years,Months,MonthSale,SUM(MonthSale) OVER (ORDER BY RADIF ROWS  BETWEEN 11 PRECEDING AND CURRENT ROW  )SaleCumulative
			FROM 
			(SELECT YEAR(Miladi_FactDate)AS YEARs,MONTH(Miladi_FactDate) As MONTHs,SUM(Price) AS MonthSale
			,ROW_NUMBER() OVER (ORDER BY  YEAR(Miladi_FactDate),MONTH(Miladi_FactDate)) AS Radif
			FROM FactHeader AS FH 
			INNER JOIN FactDetail AS FD ON FH.FactNo=FD.FactNo
			WHERE FH.Miladi_FactDate BETWEEN @Date1 AND @Date2 
			GROUP BY YEAR(Miladi_FactDate),MONTH(Miladi_FactDate)
			ORDER BY YEARS,MONTHS OFFSET 0 ROWS )  SALE

 GO
 SELECT * FROM Fn_SaleCumulative('2022.01.01','2022.12.29')