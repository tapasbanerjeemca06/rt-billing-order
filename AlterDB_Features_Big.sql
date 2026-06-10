USE RTBillingDB
GO

-- Price Lists
IF OBJECT_ID('tblPriceList') IS NULL
CREATE TABLE tblPriceList (
    PriceListID  INT IDENTITY(1,1) PRIMARY KEY,
    ListName     NVARCHAR(100) NOT NULL,
    Description  NVARCHAR(200),
    IsDefault    BIT DEFAULT 0,
    IsActive     BIT DEFAULT 1
)
GO
IF OBJECT_ID('tblPriceListDetail') IS NULL
CREATE TABLE tblPriceListDetail (
    DetailID     INT IDENTITY(1,1) PRIMARY KEY,
    PriceListID  INT NOT NULL,
    ItemID       INT NOT NULL,
    SalePrice    DECIMAL(18,2) NOT NULL
)
GO

-- Schemes / Discount Rules
IF OBJECT_ID('tblScheme') IS NULL
CREATE TABLE tblScheme (
    SchemeID     INT IDENTITY(1,1) PRIMARY KEY,
    SchemeName   NVARCHAR(100) NOT NULL,
    SchemeType   NVARCHAR(30),  -- 'PctDisc','FlatDisc','BuyXGetY','MinAmtDisc'
    DiscPct      DECIMAL(5,2) DEFAULT 0,
    DiscAmt      DECIMAL(18,2) DEFAULT 0,
    BuyQty       DECIMAL(18,3) DEFAULT 0,
    FreeQty      DECIMAL(18,3) DEFAULT 0,
    MinAmount    DECIMAL(18,2) DEFAULT 0,
    ItemID       INT,           -- NULL = applies to all items
    CatID        INT,           -- NULL = all categories
    CustID       INT,           -- NULL = all customers
    ValidFrom    DATE,
    ValidTo      DATE,
    IsActive     BIT DEFAULT 1
)
GO

-- Item Variants
IF OBJECT_ID('tblItemVariantGroup') IS NULL
CREATE TABLE tblItemVariantGroup (
    GroupID      INT IDENTITY(1,1) PRIMARY KEY,
    ItemID       INT NOT NULL,
    GroupName    NVARCHAR(50) NOT NULL  -- e.g. 'Size','Color'
)
GO
IF OBJECT_ID('tblItemVariant') IS NULL
CREATE TABLE tblItemVariant (
    VariantID    INT IDENTITY(1,1) PRIMARY KEY,
    ItemID       INT NOT NULL,
    VariantName  NVARCHAR(100) NOT NULL,  -- e.g. 'Red-XL'
    Barcode      NVARCHAR(50),
    ExtraPrice   DECIMAL(18,2) DEFAULT 0,
    IsActive     BIT DEFAULT 1
)
GO

-- Package / Bundle Items
IF OBJECT_ID('tblPackage') IS NULL
CREATE TABLE tblPackage (
    PackageID    INT IDENTITY(1,1) PRIMARY KEY,
    PackageName  NVARCHAR(150) NOT NULL,
    SalePrice    DECIMAL(18,2) NOT NULL,
    TaxGroupID   INT,
    IsActive     BIT DEFAULT 1
)
GO
IF OBJECT_ID('tblPackageDetail') IS NULL
CREATE TABLE tblPackageDetail (
    DetailID     INT IDENTITY(1,1) PRIMARY KEY,
    PackageID    INT NOT NULL,
    ItemID       INT NOT NULL,
    Qty          DECIMAL(18,3) NOT NULL
)
GO

-- Delivery Challan
IF OBJECT_ID('tblDeliveryChallan') IS NULL
CREATE TABLE tblDeliveryChallan (
    ChallanID    INT IDENTITY(1,1) PRIMARY KEY,
    ChallanNo    NVARCHAR(30) NOT NULL,
    ChallanDate  DATE NOT NULL,
    CustID       INT,
    VehicleNo    NVARCHAR(20),
    DriverName   NVARCHAR(100),
    Remarks      NVARCHAR(300),
    Status       NVARCHAR(20) DEFAULT 'Pending',
    BillID       INT,
    UserID       INT,
    CreatedOn    DATETIME DEFAULT GETDATE()
)
GO
IF OBJECT_ID('tblDeliveryChallanDetail') IS NULL
CREATE TABLE tblDeliveryChallanDetail (
    DetailID     INT IDENTITY(1,1) PRIMARY KEY,
    ChallanID    INT NOT NULL,
    ItemID       INT,
    Qty          DECIMAL(18,3),
    Rate         DECIMAL(18,2),
    Amount       DECIMAL(18,2)
)
GO

-- Batch / Expiry Tracking
IF OBJECT_ID('tblBatch') IS NULL
CREATE TABLE tblBatch (
    BatchID      INT IDENTITY(1,1) PRIMARY KEY,
    ItemID       INT NOT NULL,
    BatchNo      NVARCHAR(50) NOT NULL,
    MfgDate      DATE,
    ExpiryDate   DATE,
    Qty          DECIMAL(18,3) DEFAULT 0,
    PurchaseRate DECIMAL(18,2) DEFAULT 0,
    StoreID      INT,
    CreatedOn    DATETIME DEFAULT GETDATE()
)
GO

-- Customer DOB for birthday greetings
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCustomer') AND name='DOB')
    ALTER TABLE tblCustomer ADD DOB DATE NULL
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCustomer') AND name='Anniversary')
    ALTER TABLE tblCustomer ADD Anniversary DATE NULL
GO

-- PriceListID on customer
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCustomer') AND name='PriceListID')
    ALTER TABLE tblCustomer ADD PriceListID INT NULL
GO

-- Auto print setting
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCompany') AND name='AutoPrintAfterSave')
    ALTER TABLE tblCompany ADD AutoPrintAfterSave BIT DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCompany') AND name='AutoPrintThermal')
    ALTER TABLE tblCompany ADD AutoPrintThermal BIT DEFAULT 1
GO

-- Salesman Route
IF OBJECT_ID('tblRoute') IS NULL
CREATE TABLE tblRoute (
    RouteID      INT IDENTITY(1,1) PRIMARY KEY,
    RouteName    NVARCHAR(100) NOT NULL,
    AgentID      INT,
    VisitDay     NVARCHAR(20),  -- 'Monday','Tuesday' etc
    IsActive     BIT DEFAULT 1
)
GO
IF OBJECT_ID('tblRouteCustomer') IS NULL
CREATE TABLE tblRouteCustomer (
    ID           INT IDENTITY(1,1) PRIMARY KEY,
    RouteID      INT NOT NULL,
    CustID       INT NOT NULL,
    SortOrder    INT DEFAULT 0
)
GO

PRINT 'All tables created successfully'
GO
