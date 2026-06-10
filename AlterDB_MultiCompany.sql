-- =====================================================================
-- RTBillingDB - Multi-Company & FinYear Lock Alter Script
-- Run once on existing database
-- =====================================================================
USE RTBillingDB
GO

-- ===================== tblCompany: CreditLimit =====================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCompany') AND name='CreditLimit')
    ALTER TABLE tblCompany ADD CreditLimit DECIMAL(18,2) DEFAULT 0
GO

-- ===================== tblBill: CompanyID ==========================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBill') AND name='CompanyID')
    ALTER TABLE tblBill ADD CompanyID INT NOT NULL DEFAULT 1
GO
UPDATE tblBill SET CompanyID=1 WHERE CompanyID IS NULL
GO

-- ===================== tblExpense: CompanyID =======================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblExpense') AND name='CompanyID')
    ALTER TABLE tblExpense ADD CompanyID INT NOT NULL DEFAULT 1
GO
UPDATE tblExpense SET CompanyID=1 WHERE CompanyID IS NULL
GO

-- ===================== tblMaterialIn: CompanyID ====================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialIn') AND name='CompanyID')
    ALTER TABLE tblMaterialIn ADD CompanyID INT NOT NULL DEFAULT 1
GO
UPDATE tblMaterialIn SET CompanyID=1 WHERE CompanyID IS NULL
GO

-- ===================== tblDuePayment: CompanyID ====================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblDuePayment') AND name='CompanyID')
    ALTER TABLE tblDuePayment ADD CompanyID INT NOT NULL DEFAULT 1
GO
UPDATE tblDuePayment SET CompanyID=1 WHERE CompanyID IS NULL
GO

-- ===================== tblCustomer: CompanyID =====================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCustomer') AND name='CompanyID')
    ALTER TABLE tblCustomer ADD CompanyID INT NOT NULL DEFAULT 1
GO
UPDATE tblCustomer SET CompanyID=1 WHERE CompanyID IS NULL
GO

-- ===================== tblVendor: CompanyID =======================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblVendor') AND name='CompanyID')
    ALTER TABLE tblVendor ADD CompanyID INT NOT NULL DEFAULT 1
GO
UPDATE tblVendor SET CompanyID=1 WHERE CompanyID IS NULL
GO

-- ===================== tblItem: CompanyID =========================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblItem') AND name='CompanyID')
    ALTER TABLE tblItem ADD CompanyID INT NOT NULL DEFAULT 1
GO
UPDATE tblItem SET CompanyID=1 WHERE CompanyID IS NULL
GO

-- ===================== tblCustomer: CreditLimit ===================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCustomer') AND name='CreditLimit')
    ALTER TABLE tblCustomer ADD CreditLimit DECIMAL(18,2) DEFAULT 0
GO

-- ===================== tblFinYearLock: create =====================
IF OBJECT_ID('tblFinYearLock') IS NULL
BEGIN
    CREATE TABLE tblFinYearLock (
        LockID    INT IDENTITY(1,1) PRIMARY KEY,
        CompanyID INT NOT NULL DEFAULT 1,
        FinYear   NVARCHAR(10) NOT NULL,
        LockFrom  DATE NOT NULL,
        LockTo    DATE NOT NULL,
        IsLocked  BIT NOT NULL DEFAULT 0,
        LockedOn  DATETIME NULL,
        LockedBy  INT NULL
    )
END
GO

-- ===================== Seed current FY for company 1 ==============
-- Use dynamic SQL so SQL Server does not resolve column names at parse time
DECLARE @sql NVARCHAR(500)
DECLARE @cnt INT
SELECT @cnt = COUNT(1) FROM tblFinYearLock
IF @cnt = 0
BEGIN
    DECLARE @yr INT = CASE WHEN MONTH(GETDATE()) >= 4 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE()) - 1 END
    DECLARE @fy   NVARCHAR(10) = CAST(@yr AS NVARCHAR) + '-' + RIGHT(CAST(@yr + 1 AS NVARCHAR), 2)
    DECLARE @fd   NVARCHAR(20) = CAST(@yr AS NVARCHAR) + '-04-01'
    DECLARE @td   NVARCHAR(20) = CAST(@yr + 1 AS NVARCHAR) + '-03-31'
    SET @sql = N'INSERT INTO tblFinYearLock (CompanyID,FinYear,LockFrom,LockTo,IsLocked) VALUES (1,''' + @fy + ''',''' + @fd + ''',''' + @td + ''',0)'
    EXEC sp_executesql @sql
    PRINT 'Seeded financial year: ' + @fy
END
GO

PRINT 'Multi-company & FinYear Lock schema applied successfully.'
GO
