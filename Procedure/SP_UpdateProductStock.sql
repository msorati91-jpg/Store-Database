
--USE[Store]
-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <2026.03.11>
 --Description:	<UpdateProductStock>
 --=============================================
ALTER PROCEDURE SP_UpdateProductStock @ProductId INT,@ChangeQuantity INT,@ChangeType BIT
AS
BEGIN
	DECLARE @CurrentQuantity INT
	DECLARE @NewQuantity INT
	SELECT @CurrentQuantity=Quantity FROM ProductStock WHERE ProductId=@ProductId
	
	SET @NewQuantity=CASE WHEN @ChangeType=0 THEN  @CurrentQuantity-@ChangeQuantity
					 ELSE  @CurrentQuantity+@ChangeQuantity
					 END
	BEGIN TRY
		IF @NewQuantity<0 
		BEGIN
			SELECT 0 AS SUCCESS ,'Can Not Add Item To Order' AS MESSAGE
			RETURN
		END
		BEGIN TRANSACTION 
		INSERT INTO ProductStock (ProductId, Quantity,ChangeType, LastUpdate)
		VALUES (@ProductId,@NewQuantity,@ChangeType,GETDATE())
		UPDATE Product SET  CurrentStock=@NewQuantity
		WHERE Product.Id=@ProductId
		COMMIT TRANSACTION
		SELECT 1 AS SUCCESS ,'Quantity Is Successfully Chenged ' AS MESSAGE
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION
		SELECT 0 AS SUCCESS ,'Error Changing ProductQuantiy: '+ ERROR_MESSAGE() AS MESSAGE
	END CATCH
END
