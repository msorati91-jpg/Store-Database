
--====================================INDEX====================================
USE [Store]
CREATE INDEX IX_ProductImage_ProductId ON ProductImage(ProductId);
CREATE UNIQUE INDEX IX_ProductImage_IsMainImage ON ProductImage(ProductId) WHERE IsMainImage=1;
CREATE UNIQUE INDEX IX_Product_Name_SupplierId ON Product(Name,SupplierId);
CREATE INDEX IX_Product_CategoryId ON Product(CategoryId);
CREATE INDEX IX_Product_UnitId ON Product(UnitId);
CREATE INDEX IX_FactorHeader_CustomerId ON FactorHeader (CustomerId) ;
CREATE INDEX IX_FactorDetail_ProductId ON FactorDetail (ProductId) ;

--==================
INSERT INTO FactorStatus (name)
VALUES
(N'Created'),
(N'Paid'),
(N'Confirm'),
(N'Packed'),
(N'Shipped'),
(N'Delivered'),
(N'DeliveryFailed'),
(N'ReturnRequest'),
(N'Returnd'),
(N'Refunded'),
(N'Canceled');