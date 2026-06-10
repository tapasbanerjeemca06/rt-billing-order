-- =====================================================================
-- RTBillingDB - New Features: Recurring Billing, Inter-Branch Report
-- =====================================================================
USE RTBillingDB
GO

-- ===================== tblRecurringBilling ========================
IF OBJECT_ID('tblRecurringBilling') IS NULL
CREATE TABLE tblRecurringBilling (
    RecurID       INT IDENTITY(1,1) PRIMARY KEY,
    CompanyID     INT NOT NULL DEFAULT 1,
    CustID        INT NOT NULL,
    Amount        DECIMAL(18,2) NOT NULL,
    Frequency     NVARCHAR(20) NOT NULL,   -- Monthly, Quarterly, etc.
    NextBillDate  DATE NOT NULL,
    EndDate       DATE NULL,
    ModeID        INT NULL,
    Description   NVARCHAR(300),
    IsActive      BIT NOT NULL DEFAULT 1,
    UserID        INT,
    CreatedOn     DATETIME DEFAULT GETDATE()
)
GO

-- ===================== tblAuditLog ================================
IF OBJECT_ID('tblAuditLog') IS NULL
CREATE TABLE tblAuditLog (
    LogID       INT IDENTITY(1,1) PRIMARY KEY,
    LogTime     DATETIME DEFAULT GETDATE(),
    CompanyID   INT DEFAULT 1,
    UserID      INT,
    Action      NVARCHAR(20),   -- INSERT, UPDATE, DELETE
    TableName   NVARCHAR(50),
    RecordID    INT,
    Description NVARCHAR(500)
)
GO

PRINT 'New features schema applied.'
GO
