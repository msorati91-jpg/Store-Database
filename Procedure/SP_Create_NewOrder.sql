-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <2026.03.03>
-- Description:	< Create NewOrder>
-- =============================================
CREATE PROCEDURE SP_Create_NewOrder @CustomerCode INT,@UserId INT,@Description NVARCHAR(1500)
AS
BEGIN
	DECLARE @FactorNumber INT
BEGIN TRY	
	BEGIN TRANSACTION
	INSERT INTO FactorHeader (   [CreatedAt], [CustomerId], [PersonnelId], [Description], [StatusId]  )
	VALUES (GETDATE(),@CustomerCode,@UserId ,@Description,1)
	SET @FactorNumber=SCOPE_IDENTITY()
	COMMIT TRANSACTION
	SELECT @FactorNumber AS NewOrderNumber ,'Order Create successfully.Status: ثبت شده' AS MESSAGE
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
	SELECT 0 AS NewOrderNumber ,'Error With Create Order  .Status: '+ ERROR_MESSAGE() AS MESSAGE
END CATCH
END
