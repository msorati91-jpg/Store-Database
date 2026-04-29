-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <2026.03.10>
 --Description:	<ChengeStats>
 --=============================================
CREATE PROCEDURE SP_ChengeStats @FactorHeaderId INT,@NewStatusId INT
AS
BEGIN
	DECLARE @CurrentStatusId INT
	SELECT @CurrentStatusId=StatusId FROM FactorHeader WHERE Id=@FactorHeaderId
	BEGIN TRY
	    IF NOT EXISTS ( SELECT 1 FROM FactorHeader WHERE Id=@FactorHeaderId )
		BEGIN
			SELECT 0 AS SUCCESS ,'CAN NOT FAUN FACTORHEDER' AS MESSAGE
			RETURN
		END
		IF EXISTS ( SELECT 1 FROM FactorStatusHistory WHERE FactorHeaderId=@FactorHeaderId AND StatusId=@NewStatusId)
		BEGIN
			SELECT 0 AS SUCCESS ,'CAN NOT ADD RIPITABLE RECORD' AS MESSAGE
			RETURN
		END
		IF @NewStatusId<@CurrentStatusId 
		BEGIN
			SELECT 0 AS SUCCESS ,'CAN NOT REVERS' AS MESSAGE
			RETURN
		END
		IF @NewStatusId >6
		BEGIN
			SELECT 0 AS SUCCESS ,'CAN NOT CHENGE STATUS' AS MESSAGE
			RETURN
		END
		BEGIN TRANSACTION
		INSERT INTO FactorStatusHistory  (FactorHeaderId, StatusId, StatusDate)
		VALUES  (@FactorHeaderId,@NewStatusId,GETDATE())
		UPDATE FactorHeader SET StatusId=@NewStatusId WHERE Id=@FactorHeaderId
		COMMIT TRANSACTION
		SELECT 1 AS SUCCESS ,'Status Is Successfully Chenged ' AS MESSAGE
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION
		SELECT 0 AS SUCCESS ,'Error Changing OrderStatus: '+ ERROR_MESSAGE() AS MESSAGE
	END CATCH
END
