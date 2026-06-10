USE RTBillingDB
GO

-- Credit Limit on Customer
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCustomer') AND name='CreditLimit')
    ALTER TABLE tblCustomer ADD CreditLimit DECIMAL(18,2) DEFAULT 0
GO

-- Financial Year Lock table
IF OBJECT_ID('tblFinYearLock') IS NULL
CREATE TABLE tblFinYearLock (
    LockID      INT IDENTITY(1,1) PRIMARY KEY,
    FinYear     NVARCHAR(10) NOT NULL,   -- e.g. 2024-25
    LockFrom    DATE NOT NULL,
    LockTo      DATE NOT NULL,
    IsLocked    BIT DEFAULT 0,
    LockedBy    INT,
    LockedOn    DATETIME,
    Remarks     NVARCHAR(200)
)
GO

-- App Settings table (key-value store)
IF OBJECT_ID('tblAppSettings') IS NULL
CREATE TABLE tblAppSettings (
    SettingKey   NVARCHAR(100) PRIMARY KEY,
    SettingValue NVARCHAR(500)
)
GO

-- Default financial years
IF NOT EXISTS (SELECT 1 FROM tblFinYearLock WHERE FinYear='2023-24')
INSERT INTO tblFinYearLock (FinYear, LockFrom, LockTo, IsLocked)
VALUES
('2023-24','2023-04-01','2024-03-31',0),
('2024-25','2024-04-01','2025-03-31',0),
('2025-26','2025-04-01','2026-03-31',0)
GO

PRINT 'New features schema created successfully.'
GO
