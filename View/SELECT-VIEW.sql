-- Views جهت گزارشات مدیریتی
USE [Store]
SELECT * FROM Vw_ProductSaleAndStock
--میزان فروش و موجودی انبار کالا
SELECT * FROM Vw_OrderDeliveryPerformance
--میزان تاخیر یا تحویل به موقع سفارشات
SELECT * FROM Vw_All_Info 
--اطلاعات کل محصولات ,فروشنده و تامین کننده  مشتریان  مربوط به فروش هر دسته از کالا فروش
SELECT * FROM Vw_Sale_Info
--اطلاعات مربوط به کالاهای فروخته شده
SELECT * FROM Vw_Category_MonthSale
--میزان فروش ماهانه محصولات بر اساس دسته بندی
SELECT * FROM Vw_SalePercent_Per_Category_Per_Product
--مجموع فروش و درصد فروش به ازای هر دسته بندی و هر محصول
SELECT * FROM VW_SumSale_per_supliers
--مجموع فروش به ازای هر تامین کننده و نمایش اطلاعات تامین کننده
SELECT * FROM Vw_Topspent_Customer
--رتبه بندی مشتریان بر اساس بالاترین میزان خرید
SELECT * FROM Vw_Monthly_sale
--میزان فروش ماهانه
SELECT * FROM Vw_Product_State
--وضعیت انبار و محصولات????????/
SELECT * FROM Vw_Top10_Sale
--گزارش محصولات با بیشترین تعداد فروش
