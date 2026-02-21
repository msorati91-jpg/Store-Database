USE [Stor_faradars]  
--ALTER TABLE GEO.CITY
----ALTER COLUMN CITYDESC nVARCHAR(50)
--ADD CONSTRAINT UC_CITYDESC  UNIQUE (CITYDESC)

--================================INSERT======================
--ALTER PROCEDURE Sp_Insert  @CityDescription NVARCHAR(50) 
--AS
--	BEGIN TRY
--		BEGIN TRANSACTION
--		BEGIN TRY
--				WITH Check_CityName AS ( SELECT CityDesc FROM City )--cte
--				--IF   (LEN(@CityDescription) <=50,, )
--				--begin 
--					INSERT INTO City  VALUES ( @CityDescription) --WHERE (LEN(@CityDescription)) <=50 
--					--RETURN;
--				--end
--		END TRY
--		BEGIN CATCH
--					ROLLBACK TRANSACTION;
--					PRINT 	N'تعداد کاراکتر بیش از حد مجاز';
--					THROW;

--		END CATCH		
--		COMMIT TRANSACTION			
--	END TRY
--	BEGIN CATCH
--			 --CASE WHEN @CityDescription =Check_CityName THEN RAISERROR   (N'نام شهر تکراری است',16,1) ELSE
--				   ROLLBACK TRANSACTION 
--				   --PRINT ERROR-MASSAGE()
--				   RAISERROR    (N'نام شهر تکراری است',16,1)
--				 --END 
--			 RETURN
--	END CATCH

--================================DELETE======================

--CREATE PROCEDURE Sp_Delete  @CityDescription char(50) 
--AS
--	BEGIN TRY
--		delete from City  where CityDesc= @CityDescription
 
--	 END TRY 
--	 BEGIN CATCH
--		 RAISERROR   (N'امکان حذف وجود ندارد کاربرانی از فروشگاه به این شهر مربوط میباشند',16,1)
--		 RETURN 
--	 END CATCH


--=================================CostomerSalePercent=================
--ALTER PROCEDURE Sp_CostumerSale @Date1 CHAR(10),@Date2 CHAR(10)
--AS
--	WITH TotalSales AS( SELECT SUM(Price) AS TotalSale FROM FactDetail),
--		 CostumerTotalSales AS (	
--								SELECT CA.CountryDesc,CI.CityDesc,C.CompanyName,C.ContactName,C.Address,C.Phone,
--								SUM(Price) AS CostumerTotalSale 
--								FROM FactHeader AS FH
--								INNER JOIN FactDetail AS FD ON FH.FactNo=FD.FactNo
--								INNER JOIN Customers AS C ON FH.CustomerCode=C.CustomerCode
--								RIGHT JOIN Country AS CA ON C.CountryCode=CA.CountryCode
--								INNER JOIN City AS CI ON CA.CountryCode=CI.CityCode
--								WHERE FH.FactDate BETWEEN @Date1  AND @Date2 
--								GROUP BY CA.CountryDesc,CI.CityDesc,C.CompanyName,C.ContactName,C.Address,C.Phone
--								ORDER BY CostumerTotalSale DESC OFFSET 0 ROWS
--								)
--				----------------------------------------------------------------------

--	SELECT CountryDesc,CityDesc,CompanyName,ContactName,Address,Phone,CostumerTotalSale,TotalSale,
--	 CAST(CostumerTotalSale/TotalSale * 100  AS numeric(18,2)) AS CostumerTotalSalePercent
--	FROM CostumerTotalSales,TotalSales
--	GROUP BY CountryDesc,CityDesc,CompanyName,ContactName,Address,Phone,CostumerTotalSale,TotalSale
 
 --=========================================from procedure insert to table=============
 ALTER PROCEDURE Sp_SpInTable @Date1 CHAR(10),@Date2 CHAR(10)
 AS 
	DROP TABLE IF EXISTS BACKUPS
	CREATE TABLE BACKUPS (CountryDesc NVARCHAR(50) ,CityDesc NVARCHAR(50),CompanyName NVARCHAR(50),ContactName NVARCHAR(50),Address NVARCHAR(50),
	Phone NVARCHAR(50),CostumerTotalSale NUMERIC(18,2),TotalSale NUMERIC(18,2),
	 CostumerTotalSalePercent  NUMERIC(18,2) )
	INSERT INTO BACKUPS (CountryDesc,CityDesc,CompanyName,ContactName,Address,Phone,CostumerTotalSale,TotalSale,CostumerTotalSalePercent)
	EXEC Sp_CostumerSale @Date1,@Date2
	SELECT * FROM BACKUPS
	

--EXEC Sp_SpInTable '1401/01/01','1403/01/01'