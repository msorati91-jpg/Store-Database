-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <2026.03.03>
-- Description:	< Insert City>
-- =============================================
CREATE PROCEDURE Sp_InsertCity  @CityName NVARCHAR(50) 
AS
	BEGIN TRY
		BEGIN TRANSACTION
		BEGIN TRY
				WITH Check_CityName AS ( SELECT Name FROM City )--cte

				IF   (LEN(@CityName) <=50  )
				begin 
					INSERT INTO City VALUES ( @CityName) --WHERE (LEN(@CityName)) <=50 
					RETURN;
				end
		END TRY
		BEGIN CATCH
					ROLLBACK TRANSACTION;
					PRINT 	N'تعداد کاراکتر بیش از حد مجاز';
					THROW;

		END CATCH		
		COMMIT TRANSACTION			
	END TRY
	BEGIN CATCH
			 CASE WHEN @CityName =Check_CityName THEN RAISERROR   (N'نام شهر تکراری است',16,1) ELSE
				   ROLLBACK TRANSACTION 
				   PRINT ERROR-MASSAGE()
				   --RAISERROR    (N'نام شهر تکراری است',16,1)
			 END 
			 RETURN
	END CATCH
