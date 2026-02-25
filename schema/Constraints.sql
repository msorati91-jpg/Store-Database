--==========================constraints===========================
USE [Store]

ALTER TABLE City  ADD CONSTRAINT FK_City_Country FOREIGN KEY (CountryId) REFERENCES  Country(Id)

ALTER TABLE Address ADD CONSTRAINT FK_Address_City FOREIGN KEY (CityId)	REFERENCES  City(Id)

ALTER TABLE Supplier ADD CONSTRAINT FK_Supplier_Address  FOREIGN KEY (AddressId) REFERENCES  Address(Id)
	 
ALTER TABLE Personnel ADD CONSTRAINT FK_Personnel_Address  FOREIGN KEY (AddressId) REFERENCES  Address(Id)
ALTER TABLE Personnel ADD CONSTRAINT CK_BirthDay CHECK ( BirthDay < GETDATE()  )
ALTER TABLE Personnel ADD CONSTRAINT CK_Gender  CHECK (Gender IN (0, 1))
ALTER TABLE Personnel ADD DEFAULT (0) FOR IsDeleted

ALTER TABLE PersonnelAudit ADD CONSTRAINT FK_PersonnelAudit_Personnel  FOREIGN KEY (PersonnelId) REFERENCES  Personnel(PersonnelCod)
ALTER TABLE PersonnelAudit ADD CONSTRAINT FK_PersonnelAudit_Address_Old  FOREIGN KEY (OldAddressId) REFERENCES  Address(Id)
ALTER TABLE PersonnelAudit ADD CONSTRAINT FK_PersonnelAudit_Address  FOREIGN KEY (NewAddressId) REFERENCES  Address(Id)
ALTER TABLE PersonnelAudit ADD CONSTRAINT FK_PersonnelAudit_Personnel_c FOREIGN KEY (ChangeBy) REFERENCES Personnel(PersonnelCod)

ALTER TABLE Customer ADD CONSTRAINT FK_Customer_Address  FOREIGN KEY (AddressId) REFERENCES  Address(Id)
ALTER TABLE Customer ADD CONSTRAINT CK_Email CHECK ( Email LIKE '%@%.%'  )
ALTER TABLE Customer ADD DEFAULT (0) FOR IsDeleted

ALTER TABLE CustomerAudit ADD CONSTRAINT FK_CustomerAudit_Customer  FOREIGN KEY (CustomerId) REFERENCES  Customer(CustomerCod)
ALTER TABLE CustomerAudit ADD CONSTRAINT FK_CustomerAudit_Address_Old  FOREIGN KEY (OldAddressId) REFERENCES  Address(Id)
ALTER TABLE CustomerAudit ADD CONSTRAINT FK_CustomerAudit_Address  FOREIGN KEY (NewAddressId) REFERENCES  Address(Id)
ALTER TABLE CustomerAudit ADD CONSTRAINT FK_CustomerAudit_Personnel FOREIGN KEY (ChangeBy) REFERENCES Personnel(PersonnelCod)

ALTER TABLE ProductStock ADD DEFAULT (0) FOR Quantity 
ALTER TABLE ProductStock ADD DEFAULT (GETDATE()) FOR LastUpdate
ALTER TABLE ProductStock ADD CONSTRAINT  FK_ProductStock_Product FOREIGN KEY (ProductId) REFERENCES Product(Id)

ALTER TABLE Product ADD CONSTRAINT  FK_Product_ProductCategory FOREIGN KEY (CategoryId) REFERENCES ProductCategory(Id)
ALTER TABLE Product ADD CONSTRAINT  FK_Product_ProductUnit FOREIGN KEY (UnitId) REFERENCES ProductUnit(Id)
ALTER TABLE Product ADD CONSTRAINT  FK_Product_Supplier FOREIGN KEY (SupplierId) REFERENCES Supplier(Id)
ALTER TABLE Product ADD CONSTRAINT  FK_Product_ProductImage FOREIGN KEY (ImageId) REFERENCES ProductImage(Id)
ALTER TABLE Product ADD DEFAULT (1) FOR IsActive 
ALTER TABLE Product ADD DEFAULT (GETDATE()) FOR CreatedAt
ALTER TABLE Product ADD CONSTRAINT  CK_MinStock CHECK (MinStock > 0)
ALTER TABLE Product ADD CONSTRAINT  CK_MaxStock CHECK (MaxStock>=MinStock )
ALTER TABLE Product ADD DEFAULT (0) FOR IsDeleted 

ALTER TABLE ProductAudit ADD CONSTRAINT  FK_ProductAudit_Product FOREIGN KEY (ProductId) REFERENCES Product(Id)
ALTER TABLE ProductAudit ADD CONSTRAINT  FK_ProductAudit_Personnel FOREIGN KEY (ChangeBy) REFERENCES Personnel(PersonnelCod)
ALTER TABLE ProductAudit ADD CONSTRAINT  FK_ProductAudit_Supplier_Old FOREIGN KEY (OldSupplierId) REFERENCES Supplier(Id)
ALTER TABLE ProductAudit ADD CONSTRAINT  FK_ProductAudit_Supplier FOREIGN KEY (NewSupplierId) REFERENCES Supplier(Id)
ALTER TABLE ProductAudit ADD CONSTRAINT  FK_ProductAudit_ProductImage_Old FOREIGN KEY (OldImageId) REFERENCES ProductImage(Id)
ALTER TABLE ProductAudit ADD CONSTRAINT  FK_ProductAudit_ProductImage FOREIGN KEY (NewImageId) REFERENCES ProductImage(Id)
--ALTER TABLE ProductAudit ADD CONSTRAINT  FK_ProductAudit_Product_Old FOREIGN KEY (Oldprice) REFERENCES Product(Currentprice)
--ALTER TABLE ProductAudit ADD CONSTRAINT  FK_ProductAudit_Product FOREIGN KEY (NewPrice) REFERENCES Product(Currentprice)

ALTER TABLE ProductImage ADD CONSTRAINT  FK_ProductImage_Product FOREIGN KEY (ProductId) REFERENCES Product(Id) ON DELETE CASCADE
ALTER TABLE ProductImage ADD DEFAULT (0) FOR IsMainImage 
ALTER TABLE ProductImage ADD DEFAULT (1) FOR SortOrder 
--ALTER TABLE ProductImage ADD DEFAULT (NEWID()) FOR RowGuid
ALTER TABLE ProductImage ADD DEFAULT (SYSDATETIME()) FOR CreatedAt

ALTER TABLE FactorHeader ADD CONSTRAINT FK_FactorHeader_Customer  FOREIGN KEY (CustomerId) REFERENCES  Customer(CustomerCod) ON DELETE CASCADE
ALTER TABLE FactorHeader ADD CONSTRAINT FK_FactorHeader_Personnel  FOREIGN KEY (PersonnelId) REFERENCES  Personnel(PersonnelCod)
ALTER TABLE FactorHeader ADD CONSTRAINT FK_FactorHeader_FactorStatus  FOREIGN KEY (StatusId) REFERENCES  FactorStatus(Id)
ALTER TABLE FactorHeader ADD DEFAULT (GETDATE()) FOR CreatedAt

ALTER TABLE FactorStatusHistory ADD CONSTRAINT FK_FactorStatusHistory_FactorHeader  FOREIGN KEY (FactorHeaderId) REFERENCES  FactorHeader(Id)
ALTER TABLE FactorStatusHistory ADD CONSTRAINT FK_FactorStatusHistory_FactorStatus  FOREIGN KEY (StatusId) REFERENCES  FactorStatus(Id)

ALTER TABLE FactorDetail  ADD CONSTRAINT FK_FactorDetail_FactorHeader  FOREIGN KEY (FactorHeaderId) REFERENCES  FactorHeader (Id)  ON DELETE CASCADE
ALTER TABLE FactorDetail  ADD CONSTRAINT FK_FactorDetail_Product  FOREIGN KEY (ProductId) REFERENCES   Product(Id)
ALTER TABLE FactorDetail  ADD CONSTRAINT CK_DiscountPercent CHECK (DiscountPercent BETWEEN 0 AND 1)
ALTER TABLE FactorDetail  ADD DEFAULT (9) FOR TaxPercent
ALTER TABLE FactorDetail  ADD DEFAULT (0) FOR DiscountPercent 