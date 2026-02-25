
--1) Country

----sql
INSERT INTO Country (Name) VALUES
(N'Germany'),
(N'Iran'),
(N'Turkey');
--

-----

--2) City

----sql
INSERT INTO City (CountryId, Name) VALUES
(1, N'Berlin'),
(1, N'Hamburg'),
(2, N'Tehran'),
(2, N'Mashhad'),
(3, N'Istanbul');
--

---


--3) Address

--sql
INSERT INTO Address ( CityId, Street, PostalCode) VALUES
( 1, N'Alexanderplatz 12', '10178'),
( 2, N'Reeperbahn 88', '20359'),
( 3, N'Valiasr St 45', '11369'),
( 4, N'Ahmadabad 22', '91856'),
( 5, N'Taksim Square 5', '34435');
--

---

--4) Supplier

--sql
INSERT INTO Supplier (Name, Phone, 

AddressId) VALUES
(N'Global Electronics GmbH', '03012345678', 1),
(N'Pars Hardware', '02144556677', 3),
(N'Istanbul Trade Co', '09021255543', 5);
--

---

--5) Personnel

--sql
INSERT INTO Personnel (FirstName, LastName, Gender, BirthDay, NationalCode, Phone, AddressId) VALUES
(N'Mahdi', N'Karimi', 1, '1990-05-12', '1234567890', '09121234567', 3),

(N'Sara', N'Ahmadi', 0, '1995-09-20', '0987654321', '09351234567', 4);
--

---

--6) Customer

--sql
INSERT INTO Customer ( [FirstName], [LastName], [Email], [Phone], [AddressId]  )
VALUES
(N'Ali', N'Mousavi','Mousavi@yahoomail.com' ,'09151112233', 4),
(N'Anna', N'Schmidt', 'Schmidt@yahoomail.com','01511223344', 1),
(N'Fatemeh', N'Rostami','Rostami@gmail.com','09356667788', 3);
--

---


--7) ProductCategory

--sql
INSERT INTO ProductCategory (Name, Description) VALUES
(N'Electronics', N'Digital and electronic devices'),
(N'Home Appliances', N'Kitchen and home equipment'),
(N'Office Supplies', N'Office and stationery items');
--

---

--8) ProductUnit

--sql

INSERT INTO ProductUnit (Name) VALUES
(N'Piece'),
(N'Box'),
(N'Pack');
--

---

--9) Product

--sql
INSERT INTO Product (Name, Description, CategoryId, UnitId, SupplierId,Currentprice, MinStock, MaxStock) VALUES
(N'Laptop Lenovo ThinkPad', N'Business laptop', 1, 1, 1,15425.2, 5, 50),
(N'Wireless Mouse Logitech',N'Ergonomic mouse', 1, 1, 1, 28725.2,10, 100),
(N'Coffee Maker Philips', N'Kitchen appliance', 2, 1, 2,45225.2, 3, 30),
(N'A4 Paper 500 Sheets', N'Office paper pack', 3, 3, 3,7225.2, 20, 200);
--

---

--10) ProductStock

--sql
INSERT INTO ProductStock (  [ProductId], [Quantity], [LastUpdate]) VALUES
(1, 20,dateadd(day,10,GETDATE())),
(2, 60,dateadd(MONTH,5,GETDATE())),
(3, 10,dateadd(day,25,GETDATE())),
(4, 150,dateadd(MONTH,10,GETDATE()))
--


---

--11) FactorHeader

--sql
INSERT INTO FactorHeader ([CreatedAt],CustomerId, PersonnelId,[StatusId] ) VALUES
(dateadd(day,1,GETDATE()),1, 1, 1),
(dateadd(day,10,GETDATE()),2, 2, 2);
--

---

--12) FactorDetail

--sql
INSERT INTO FactorDetail 

(FactorHeaderId, ProductId,Quantity, UnitPrice,  DiscountPercent,TaxPercent) VALUES
(1, 1,1, 45000, 0.05,9),
(1, 2,2, 800,  0,9),
(2, 4, 3, 120,  0.10,9);
--
