USE RTBillingDB
GO

IF OBJECT_ID('tblQuotation') IS NULL
CREATE TABLE tblQuotation (
    QuotID      INT IDENTITY(1,1) PRIMARY KEY,
    QuotNo      NVARCHAR(30) NOT NULL,
    QuotDate    DATE NOT NULL,
    ValidTill   DATE NOT NULL,
    CustID      INT,
    SubTotal    DECIMAL(18,2) DEFAULT 0,
    DiscountAmt DECIMAL(18,2) DEFAULT 0,
    TaxAmt      DECIMAL(18,2) DEFAULT 0,
    CGSTAmt     DECIMAL(18,2) DEFAULT 0,
    SGSTAmt     DECIMAL(18,2) DEFAULT 0,
    IGSTAmt     DECIMAL(18,2) DEFAULT 0,
    GrandTotal  DECIMAL(18,2) DEFAULT 0,
    Status      NVARCHAR(20) DEFAULT 'Pending', -- Pending, Converted, Cancelled
    ConvertedBillID INT,
    Remarks     NVARCHAR(500),
    UserID      INT,
    CreatedOn   DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblQuotationDetail') IS NULL
CREATE TABLE tblQuotationDetail (
    QuotDetID   INT IDENTITY(1,1) PRIMARY KEY,
    QuotID      INT NOT NULL,
    ItemID      INT,
    HSNCode     NVARCHAR(20),
    Qty         DECIMAL(18,3),
    Rate        DECIMAL(18,2),
    DiscPct     DECIMAL(5,2) DEFAULT 0,
    TaxPct      DECIMAL(5,2) DEFAULT 0,
    CGSTPct     DECIMAL(5,2) DEFAULT 0,
    SGSTPct     DECIMAL(5,2) DEFAULT 0,
    IGSTPct     DECIMAL(5,2) DEFAULT 0,
    TaxAmt      DECIMAL(18,2) DEFAULT 0,
    CGSTAmt     DECIMAL(18,2) DEFAULT 0,
    SGSTAmt     DECIMAL(18,2) DEFAULT 0,
    IGSTAmt     DECIMAL(18,2) DEFAULT 0,
    Amount      DECIMAL(18,2)
)
GO

PRINT 'Quotation tables created successfully.'
GO
