 ----=============================================
 ----Author:	  <Bayat,Mahnaz>
 ----Create date: <2026.01.20>
 ----Description: <SP_SabtSefaresh-Create_NewOrder>
 ----=============================================
ALTER PROCEDURE SP_Create_NewOrder @CustomerCode VARCHAR(10),@UserId INT,@Description NVARCHAR(200)=NULL
AS
BEGIN
	DECLARE @FACTNO INT
BEGIN TRY
	IF  @CustomerCode NOT IN (SELECT CustomerCode FROM Customers )
	BEGIN
		insert into Customers ( [CustomerCode], [CompanyName], [ContactName], [TitleCode], [CountryCode], [CityCode], [Phone], [Address] )
		VALUES(@CustomerCode,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
		SELECT 1 AS SUCCESS ,'Add new custumers before Create_NewOrder' AS MESSAGE 
	END
	BEGIN TRANSACTION
	INSERT INTO FactHeader 
		   ([FactDate], [RequiredDate], [CustomerCode], [UserId], [Description], [Miladi_FactDate], [Miladi_RequiredDate], [Miladi_TransferDate],  [StatusId])
	VALUES (NULL, NULL,@CustomerCode,@UserId ,@Description,GETDATE(),DATEADD(DAY,7,GETDATE()),NULL ,1)
	SET @FACTNO=SCOPE_IDENTITY()
	COMMIT TRANSACTION
	SELECT @FACTNO AS NewOrderNumber ,'Order Create successfully.Status: ثبت شده' AS MESSAGE
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
	SELECT 0 AS NewOrderNumber ,'ERROR Create Order  .Status: '+ ERROR_MESSAGE() AS MESSAGE
END CATCH
END
--EXEC SP_Create_NewOrder  'VINET',102,',N,NL.'
--SELECT * FROM DBO.MILADITOSHAMSI
 ----=============================================
 ----Author:	  <Bayat,Mahnaz>
 ----Create date: <2026.01.20>
 ----Description: <SP_SabtSefaresh-AddItemToOrder>
 ----=============================================
ALTER PROCEDURE SP_AddItemToOrder @FactNo INT ,@ProductCode INT,@Fee DECIMAL(18,2),@Qty INT,@DiscountPercent DECIMAL(5,2)  
AS
DECLARE @DiscountPrice  DECIMAL(18,2) SET @DiscountPrice =@DiscountPercent*@Fee*@Qty 
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM FactHeader WHERE FactNo=@FactNo AND StatusId>2)
		BEGIN
			SELECT 0 AS SUCCESS ,'Can Not Add Item  To Order  .Status: Order Is Not Editable ' AS MESSAGE 
			RETURN
		END
		BEGIN TRANSACTION
			INSERT INTO FactDetail([FactNo], [ProductCode], [Fee], [Qty], [DiscountPercent] , [DiscountPrice])
			VALUES(@FactNo,@ProductCode,@Fee,@Qty,@DiscountPercent ,@DiscountPrice)
			COMMIT TRANSACTION
			SELECT @FACTNO AS SUCCESS ,'Item Add To Order successfully.Status: ثبت شده' AS MESSAGE
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION
		SELECT 0 AS SUCCESS ,'ERROR Item Add To Order  .Status: '+ ERROR_MESSAGE() AS MESSAGE
	END CATCH
END
 ----=============================================
 ----Author:	  <Bayat,Mahnaz>
 ----Create date: <2026.01.20>
 ----Description: <SP_SabtSefaresh-ChengeStats>
 ----=============================================
 ALTER PROCEDURE SP_ChengeStats @FactNo INT,@NewStatusId TINYINT
AS
BEGIN
		DECLARE @CurrentStatusId TINYINT SELECT @CurrentStatusId=StatusId FROM FactHeader WHERE FactNo=@FactNo
		DECLARE @StatusName TINYINT SELECT @StatusName=@StatusName FROM FactHeader WHERE FactNo=@FactNo
		BEGIN TRY
		IF @CurrentStatusId>4 --??AND @NewStatusID <> @CurrentStatusID
		BEGIN
			SELECT 0 AS SUCCESS ,'Can Not Change Status .Status: Order Is Not Editable ' AS MESSAGE 
			RETURN
		END
		IF @CurrentStatusId>@NewStatusId --??AND @NewStatusID NOT IN (1, 6)
		BEGIN
			SELECT 0 AS SUCCESS ,'Can Not  Reverse to previous Status .Status: Order Is Not Reversable ' AS MESSAGE 
			RETURN
		END
		BEGIN TRANSACTION
			UPDATE FactHeader	SET StatusId=@NewStatusId FROM FactHeader	WHERE  FactNo=@FactNo
			IF @NewStatusId=4 UPDATE FactHeader	SET Miladi_TransferDate=GETDATE() FROM FactHeader	WHERE  FactNo=@FactNo
			IF @NewStatusId=5 UPDATE FactHeader	SET Miladi_RequiredDate=GETDATE() FROM FactHeader	WHERE  FactNo=@FactNo
			COMMIT TRANSACTION
			SELECT @FACTNO AS SUCCESS ,'OrderStatus Change successfully To Status:' + @StatusName  AS MESSAGE

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION
		SELECT 0 AS SUCCESS ,'Error Changing OrderStatus: '+ ERROR_MESSAGE() AS MESSAGE
	END CATCH
END