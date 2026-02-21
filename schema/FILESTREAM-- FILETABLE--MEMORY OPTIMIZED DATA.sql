--==================FILESTREAM==================================
	--1-----------تنظیمات
	--1.SQLSERVER CONFIGURATION---PROPERTICE--FILESTREAM---ENABLE ALL
	EXEC sp_configure
	--2
		EXEC sys.sp_configure N'filestream access level', N'2'
		GO
	--2--------------تنظیم فایل استریم در دیتابیس-------------
	CREATE DATABASE Test01
	ON PRIMARY 
	(	NAME = Test01,FILENAME = 'D:\Database\Test01.mdf'),
	FILEGROUP FG_FileStream CONTAINS FILESTREAM---- این بخش اضافه داره فایل استریم
	(	NAME = Test01_FSG,FILENAME ='D:\Database\Test01_FSG')
	LOG ON 
	(	NAME = Test01_Log,FILENAME = 'D:\Database\Test01_Log.ldf')
			--------OR
	ALTER DATABASE Test02 ADD FILEGROUP FG_FileStream CONTAINS FILESTREAM
	ALTER DATABASE Test02 ADD FILE
	(	NAME = Test02_FSG,FILENAME ='D:\Database\Test02_FSG') TO FILEGROUP FG_FileStream

	--3--------------تنظیم فایل استریم جدول  ----------
	Use [FILESTREAM-DB]
	Go
	CREATE TABLE [FileStreamTable_2] (
	[FileId] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,--فیلد ضروری فایل استریم
	[FileName] VARCHAR (25),
	[File] VARBINARY (MAX) FILESTREAM)ON [PRIMARY] FILESTREAM_ON FG_FileStream;--فیلد ضروری فایل استریم
			--------OR
	ALTER TABLE TestTable2 SET(FILESTREAM_ON ='FG_FileStream')
	ALTER TABLE TestTable2 ADD
		FileID  UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL UNIQUE DEFAULT(NEWID()),
		Title	NVARCHAR(255) NOT NULL,
		Pic	VARBINARY(MAX) FILESTREAM NULL
	--4------------افزودن رکورد یک فایل  غیر ساختار یافته داخل جدول
	DECLARE @File varbinary(MAX); 
	SELECT @File = CAST( bulkcolumn as varbinary(max) ) FROM OPENROWSET(BULK 'c:\music\a.mp3', SINGLE_BLOB) as MyData;

	INSERT INTO FileStreamTable_2 
	VALUES ( NEWID(), 'Sample Music', @File) 
--=====================================FILE TABLE========
	CREATE DATABASE MyFileArchive
	ON PRIMARY
	(NAME = MyFileArchive_data,FILENAME = 'C:\Demo\MyFileArchive_data.mdf'),
	FILEGROUP FileStreamGroup CONTAINS FILESTREAM			--بخش ضروری برای فایل تیبل
	(NAME = PhotoFileLibrary_blobs,FILENAME = 'C:\Demo\MyFiles')
	LOG ON
	(NAME = PhotoFileLibrary_log,FILENAME = 'C:\Demo\MyFileArchive_log.ldf')
	WITH FILESTREAM												--بخش ضروری برای فایل تیبل
	(DIRECTORY_NAME='FilesLibrary',NON_TRANSACTED_ACCESS=FULL) 
		------------OR
	ALTER DATABASE NorthPole SET FILESTREAM (NON_TRANSACTED_ACCESS = FULL,DIRECTORY_NAME = 'FilesLibrary')
	-------  ساخت یک FileTable 
	CREATE TABLE PhotoTable AS FileTable
	WITH (FILETABLE_DIRECTORY = 'NorthPole Documents')
	--------درج در جدول
	INSERT INTO PhotoTable ([name], file_stream)
	VALUES ('ReadMe.txt', 0x)
--==================================MEMORY OPTIMIZED DATA============
CREATE DATABASE [JGJGJ]
	ON PRIMARY
	(NAME = MyFileArchive_data,FILENAME = 'C:\DATA\MyFileArchive_data.mdf'),
	FILEGROUP MEMORY_FG CONTAINS MEMORY_OPTIMIZED_DATA ------بخش ضروری برای مموری تیبل
	(NAME = hk_mod,FILENAME = 'C:\DATA\hk_mod')
	LOG ON
	(NAME = MyFileArchive_LOG,FILENAME = 'C:\LOG\MyFileArchive_log.ldf')
	      ------OR
ALTER DATABASE [JGJGJ] ADD FILEGROUP [MEMORY_FG] CONTAINS MEMORY_OPTIMIZED_DATA 
ALTER DATABASE [JGJGJ] ADD FILE ( NAME = N'GJGJG-M', FILENAME = N'E:\GJGJG-M' ) TO FILEGROUP [MEMORY_FG]

