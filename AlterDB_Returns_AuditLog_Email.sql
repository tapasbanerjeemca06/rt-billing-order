-- Sale Return, Purchase Return, Audit Log, Email Settings
USE RTBillingDB
GO

IF OBJECT_ID('tblSaleReturn') IS NULL
CREATE TABLE tblSaleReturn (
    ReturnID    INT IDENTITY(1,1) PRIMARY KEY,
    ReturnNo    NVARCHAR(30) NOT NULL,
    ReturnDate  DATE NOT NULL,
    BillID      INT,
    CustID      INT,
    SubTotal    DECIMAL(18,2) DEFAULT 0,
    TaxAmt      DECIMAL(18,2) DEFAULT 0,
    CGSTAmt     DECIMAL(18,2) DEFAULT 0,
    SGSTAmt     DECIMAL(18,2) DEFAULT 0,
    GrandTotal  DECIMAL(18,2) DEFAULT 0,
    Reason      NVARCHAR(500),
    UserID      INT,
    CompanyID   INT DEFAULT 1,
    CreatedOn   DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblSaleReturnDetail') IS NULL
CREATE TABLE tblSaleReturnDetail (
    DetailID    INT IDENTITY(1,1) PRIMARY KEY,
    ReturnID    INT NOT NULL,
    ItemID      INT,
    Qty         DECIMAL(18,3),
    Rate        DECIMAL(18,2),
    TaxPct      DECIMAL(5,2) DEFAULT 0,
    TaxAmt      DECIMAL(18,2) DEFAULT 0,
    CGSTPct     DECIMAL(5,2) DEFAULT 0,
    SGSTPct     DECIMAL(5,2) DEFAULT 0,
    CGSTAmt     DECIMAL(18,2) DEFAULT 0,
    SGSTAmt     DECIMAL(18,2) DEFAULT 0,
    Amount      DECIMAL(18,2)
)
GO

IF OBJECT_ID('tblPurchaseReturn') IS NULL
CREATE TABLE tblPurchaseReturn (
    ReturnID    INT IDENTITY(1,1) PRIMARY KEY,
    ReturnNo    NVARCHAR(30) NOT NULL,
    ReturnDate  DATE NOT NULL,
    MatInID     INT,
    VendorID    INT,
    SubTotal    DECIMAL(18,2) DEFAULT 0,
    TaxAmt      DECIMAL(18,2) DEFAULT 0,
    GrandTotal  DECIMAL(18,2) DEFAULT 0,
    Reason      NVARCHAR(500),
    UserID      INT,
    CreatedOn   DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblPurchaseReturnDetail') IS NULL
CREATE TABLE tblPurchaseReturnDetail (
    DetailID    INT IDENTITY(1,1) PRIMARY KEY,
    ReturnID    INT NOT NULL,
    ItemID      INT,
    Qty         DECIMAL(18,3),
    Rate        DECIMAL(18,2),
    TaxPct      DECIMAL(5,2) DEFAULT 0,
    TaxAmt      DECIMAL(18,2) DEFAULT 0,
    Amount      DECIMAL(18,2)
)
GO

IF OBJECT_ID('tblAuditLog') IS NULL
CREATE TABLE tblAuditLog (
    LogID       INT IDENTITY(1,1) PRIMARY KEY,
    LogDate     DATETIME DEFAULT GETDATE(),
    UserID      INT,
    UserName    NVARCHAR(100),
    FormName    NVARCHAR(100),
    Action      NVARCHAR(50),
    RefNo       NVARCHAR(100),
    Description NVARCHAR(1000),
    CompanyID   INT DEFAULT 1
)
GO

IF OBJECT_ID('tblEmailSettings') IS NULL
CREATE TABLE tblEmailSettings (
    SettingID   INT IDENTITY(1,1) PRIMARY KEY,
    SMTPHost    NVARCHAR(100),
    SMTPPort    INT DEFAULT 587,
    UseSSL      BIT DEFAULT 1,
    FromEmail   NVARCHAR(100),
    FromName    NVARCHAR(100),
    Password    NVARCHAR(200),
    CompanyID   INT DEFAULT 1
)
GO
