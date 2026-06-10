-- Google Order Integration Tables
-- Run this on your RTBillingDB database

-- Stores Google Sheet configuration
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='tblGoogleOrderConfig' AND xtype='U')
CREATE TABLE tblGoogleOrderConfig (
    ConfigID        INT IDENTITY(1,1) PRIMARY KEY,
    SheetCSVUrl     NVARCHAR(500)   NOT NULL,
    PollIntervalMin INT             NOT NULL DEFAULT 5,
    IsEnabled       BIT             NOT NULL DEFAULT 0,
    DefaultCustID   INT             NULL,       -- fallback customer if phone not found
    LastPolledOn    DATETIME        NULL,
    CreatedOn       DATETIME        DEFAULT GETDATE()
)

-- Tracks each processed/pending row from the sheet
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='tblGoogleOrder' AND xtype='U')
CREATE TABLE tblGoogleOrder (
    GoogleOrderID   INT IDENTITY(1,1) PRIMARY KEY,
    SheetRowKey     NVARCHAR(100)   NOT NULL,   -- Timestamp from Google Form (unique per row)
    CustomerName    NVARCHAR(200)   NULL,
    Phone           NVARCHAR(20)    NULL,
    ItemsRaw        NVARCHAR(2000)  NULL,       -- raw comma list e.g. "Rice x2, Bread x1"
    Notes           NVARCHAR(500)   NULL,
    Status          NVARCHAR(20)    NOT NULL DEFAULT 'Pending',  -- Pending / Processed / Error
    BillID          INT             NULL,       -- linked bill after processing
    ErrorMsg        NVARCHAR(500)   NULL,
    FetchedOn       DATETIME        DEFAULT GETDATE(),
    ProcessedOn     DATETIME        NULL
)

-- Prevent duplicate processing of same sheet row
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='UQ_GoogleOrder_RowKey')
    CREATE UNIQUE INDEX UQ_GoogleOrder_RowKey ON tblGoogleOrder(SheetRowKey)
