-- =============================================
-- Author:		<Bayat,,Mahnaz>
-- Create date: <2026.03.03>
--Description:	<AddItemToOrder>
--=============================================
CREATE PROCEDURE SP_AddItemToOrder @FactorHeaderId INT, @ProductId INT, @Quantity SMALLINT, @UnitPrice DECIMAL(18,2), @DiscountPercent DECIMAL(5,2),  @TaxPercent DECIMAL(5,2)
AS
BEGIN
BEGIN TRY
	IF EXISTS (SELECT 1 FROM FactorHeader WHERE StatusId> 2 AND Id=@FactorHeaderId)
		BEGIN
			SELECT 0 AS SUCCESS ,'Can Not Add Item  To Order  .Status: Order Is Not Editable ' AS MESSAGE
			RETURN
		END
	IF EXISTS (SELECT 1 FROM ProductStock WHERE Quantity<@Quantity AND ProductId=@ProductId)
		BEGIN
			SELECT @Quantity AS QUANTITY,N'CAN NOT ADD DIESE NUMBER OF ITEM,Quantity ' AS MESSAGE
			RETURN
		END
	BEGIN TRANSACTION
	INSERT INTO FactorDetail ( FactorHeaderId, ProductId, Quantity, UnitPrice, DiscountPercent, TaxPercent)
	VALUES  ( @FactorHeaderId, @ProductId, @Quantity, @UnitPrice, @DiscountPercent,  @TaxPercent)
	COMMIT TRANSACTION
	SELECT @FactorHeaderId AS SUCCESS ,'Item Add To Order Successfully.Status: ثبت شده' AS MESSAGE
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
		ROLLBACK TRANSACTION
	SELECT 0 AS SUCCESS ,'Error Item Add To Order  .Status: '+ ERROR_MESSAGE() AS MESSAGE
END CATCH
END
