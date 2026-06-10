-- RTBillingDB Setup Script for SQL Server 2008
-- Run this script on DESKTOP-GA5623V using sa / abc@123

USE master
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name='RTBillingDB')
    CREATE DATABASE RTBillingDB
GO
USE RTBillingDB
GO

-- ===================== MASTERS =====================

CREATE TABLE IF_NOT_EXISTS_Company (dummy INT)
IF OBJECT_ID('tblCompany') IS NULL
CREATE TABLE tblCompany (
    CompanyID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName NVARCHAR(200) NOT NULL,
    Address NVARCHAR(500),
    City NVARCHAR(100),
    State NVARCHAR(100),
    PinCode NVARCHAR(10),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    GSTIN NVARCHAR(20),
    PAN NVARCHAR(20),
    Logo NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblUsers') IS NULL
CREATE TABLE tblUsers (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(100) NOT NULL,
    LoginName NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50) DEFAULT 'User',
    IsActive BIT DEFAULT 1,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblDepartment') IS NULL
CREATE TABLE tblDepartment (
    DeptID INT IDENTITY(1,1) PRIMARY KEY,
    DeptName NVARCHAR(100) NOT NULL,
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblStaff') IS NULL
CREATE TABLE tblStaff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    StaffName NVARCHAR(100) NOT NULL,
    DeptID INT,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(300),
    JoinDate DATE,
    Salary DECIMAL(18,2),
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblAgent') IS NULL
CREATE TABLE tblAgent (
    AgentID INT IDENTITY(1,1) PRIMARY KEY,
    AgentName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CommissionPct DECIMAL(5,2),
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblCategory') IS NULL
CREATE TABLE tblCategory (
    CatID INT IDENTITY(1,1) PRIMARY KEY,
    CatName NVARCHAR(100) NOT NULL,
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblSubCategory') IS NULL
CREATE TABLE tblSubCategory (
    SubCatID INT IDENTITY(1,1) PRIMARY KEY,
    CatID INT NOT NULL,
    SubCatName NVARCHAR(100) NOT NULL,
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblTax') IS NULL
CREATE TABLE tblTax (
    TaxID INT IDENTITY(1,1) PRIMARY KEY,
    TaxName NVARCHAR(100) NOT NULL,
    TaxPct DECIMAL(5,2) NOT NULL,
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblTaxGroup') IS NULL
CREATE TABLE tblTaxGroup (
    TaxGroupID INT IDENTITY(1,1) PRIMARY KEY,
    GroupName NVARCHAR(100) NOT NULL,
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblTaxGroupDetail') IS NULL
CREATE TABLE tblTaxGroupDetail (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    TaxGroupID INT NOT NULL,
    TaxID INT NOT NULL
)
GO

IF OBJECT_ID('tblPaymentMode') IS NULL
CREATE TABLE tblPaymentMode (
    ModeID INT IDENTITY(1,1) PRIMARY KEY,
    ModeName NVARCHAR(50) NOT NULL,
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblStore') IS NULL
CREATE TABLE tblStore (
    StoreID INT IDENTITY(1,1) PRIMARY KEY,
    StoreName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(200),
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblVendor') IS NULL
CREATE TABLE tblVendor (
    VendorID INT IDENTITY(1,1) PRIMARY KEY,
    VendorName NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(300),
    GSTIN NVARCHAR(20),
    PAN NVARCHAR(20),
    OpeningBalance DECIMAL(18,2) DEFAULT 0,
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblCustomer') IS NULL
CREATE TABLE tblCustomer (
    CustID INT IDENTITY(1,1) PRIMARY KEY,
    CustName NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(300),
    GSTIN NVARCHAR(20),
    AgentID INT,
    OpeningBalance DECIMAL(18,2) DEFAULT 0,
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblItem') IS NULL
CREATE TABLE tblItem (
    ItemID INT IDENTITY(1,1) PRIMARY KEY,
    ItemName NVARCHAR(150) NOT NULL,
    CatID INT,
    SubCatID INT,
    Unit NVARCHAR(20),
    HSNCode NVARCHAR(20),
    TaxGroupID INT,
    PurchasePrice DECIMAL(18,2),
    SalePrice DECIMAL(18,2),
    ReorderQty DECIMAL(18,3) DEFAULT 0,
    IsActive BIT DEFAULT 1
)
GO

IF OBJECT_ID('tblService') IS NULL
CREATE TABLE tblService (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(150) NOT NULL,
    TaxGroupID INT,
    Rate DECIMAL(18,2),
    IsActive BIT DEFAULT 1
)
GO

-- ===================== ENTRIES =====================

IF OBJECT_ID('tblBill') IS NULL
CREATE TABLE tblBill (
    BillID INT IDENTITY(1,1) PRIMARY KEY,
    BillNo NVARCHAR(30) NOT NULL,
    BillDate DATE NOT NULL,
    CustID INT,
    AgentID INT,
    SubTotal DECIMAL(18,2),
    DiscountAmt DECIMAL(18,2) DEFAULT 0,
    TaxAmt DECIMAL(18,2) DEFAULT 0,
    GrandTotal DECIMAL(18,2),
    PaidAmt DECIMAL(18,2) DEFAULT 0,
    DueAmt DECIMAL(18,2) DEFAULT 0,
    ModeID INT,
    Remarks NVARCHAR(500),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblBillDetail') IS NULL
CREATE TABLE tblBillDetail (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    BillID INT NOT NULL,
    ItemID INT,
    ServiceID INT,
    Qty DECIMAL(18,3),
    Rate DECIMAL(18,2),
    DiscPct DECIMAL(5,2) DEFAULT 0,
    TaxPct DECIMAL(5,2) DEFAULT 0,
    TaxAmt DECIMAL(18,2) DEFAULT 0,
    Amount DECIMAL(18,2)
)
GO

IF OBJECT_ID('tblDuePayment') IS NULL
CREATE TABLE tblDuePayment (
    PayID INT IDENTITY(1,1) PRIMARY KEY,
    PayDate DATE NOT NULL,
    CustID INT,
    BillID INT,
    Amount DECIMAL(18,2),
    ModeID INT,
    Remarks NVARCHAR(300),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblExpense') IS NULL
CREATE TABLE tblExpense (
    ExpID INT IDENTITY(1,1) PRIMARY KEY,
    ExpDate DATE NOT NULL,
    ExpHead NVARCHAR(100),
    Amount DECIMAL(18,2),
    ModeID INT,
    StaffID INT,
    Remarks NVARCHAR(300),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblServiceEntry') IS NULL
CREATE TABLE tblServiceEntry (
    SvcEntID INT IDENTITY(1,1) PRIMARY KEY,
    EntryDate DATE NOT NULL,
    CustID INT,
    ServiceID INT,
    Qty DECIMAL(18,3),
    Rate DECIMAL(18,2),
    TaxAmt DECIMAL(18,2),
    TotalAmt DECIMAL(18,2),
    Remarks NVARCHAR(300),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

-- ===================== INVENTORY =====================

IF OBJECT_ID('tblStockIn') IS NULL
CREATE TABLE tblStockIn (
    StockInID INT IDENTITY(1,1) PRIMARY KEY,
    TxnDate DATE NOT NULL,
    ItemID INT,
    StoreID INT,
    Qty DECIMAL(18,3),
    Rate DECIMAL(18,2),
    Remarks NVARCHAR(300),
    RefNo NVARCHAR(50),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblStockOut') IS NULL
CREATE TABLE tblStockOut (
    StockOutID INT IDENTITY(1,1) PRIMARY KEY,
    TxnDate DATE NOT NULL,
    ItemID INT,
    StoreID INT,
    Qty DECIMAL(18,3),
    Rate DECIMAL(18,2),
    Remarks NVARCHAR(300),
    RefNo NVARCHAR(50),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblStockWastage') IS NULL
CREATE TABLE tblStockWastage (
    WastageID INT IDENTITY(1,1) PRIMARY KEY,
    TxnDate DATE NOT NULL,
    ItemID INT,
    StoreID INT,
    Qty DECIMAL(18,3),
    Remarks NVARCHAR(300),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblStockTransfer') IS NULL
CREATE TABLE tblStockTransfer (
    TransferID INT IDENTITY(1,1) PRIMARY KEY,
    TxnDate DATE NOT NULL,
    ItemID INT,
    FromStoreID INT,
    ToStoreID INT,
    Qty DECIMAL(18,3),
    Remarks NVARCHAR(300),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblRequisitionOrder') IS NULL
CREATE TABLE tblRequisitionOrder (
    ReqID INT IDENTITY(1,1) PRIMARY KEY,
    ReqNo NVARCHAR(30),
    ReqDate DATE NOT NULL,
    DeptID INT,
    StoreID INT,
    Status NVARCHAR(20) DEFAULT 'Pending',
    Remarks NVARCHAR(300),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblRequisitionDetail') IS NULL
CREATE TABLE tblRequisitionDetail (
    ReqDetID INT IDENTITY(1,1) PRIMARY KEY,
    ReqID INT,
    ItemID INT,
    Qty DECIMAL(18,3),
    IssuedQty DECIMAL(18,3) DEFAULT 0
)
GO

IF OBJECT_ID('tblPurchaseOrder') IS NULL
CREATE TABLE tblPurchaseOrder (
    POID INT IDENTITY(1,1) PRIMARY KEY,
    PONo NVARCHAR(30),
    PODate DATE NOT NULL,
    VendorID INT,
    StoreID INT,
    Status NVARCHAR(20) DEFAULT 'Pending',
    Remarks NVARCHAR(300),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblPurchaseOrderDetail') IS NULL
CREATE TABLE tblPurchaseOrderDetail (
    PODetID INT IDENTITY(1,1) PRIMARY KEY,
    POID INT,
    ItemID INT,
    Qty DECIMAL(18,3),
    Rate DECIMAL(18,2),
    ReceivedQty DECIMAL(18,3) DEFAULT 0
)
GO

IF OBJECT_ID('tblMaterialIn') IS NULL
CREATE TABLE tblMaterialIn (
    MatInID INT IDENTITY(1,1) PRIMARY KEY,
    GRNNo NVARCHAR(30),
    GRNDate DATE NOT NULL,
    VendorID INT,
    StoreID INT,
    POID INT,
    InvoiceNo NVARCHAR(50),
    InvoiceDate DATE,
    SubTotal DECIMAL(18,2),
    TaxAmt DECIMAL(18,2),
    GrandTotal DECIMAL(18,2),
    Remarks NVARCHAR(300),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblMaterialInDetail') IS NULL
CREATE TABLE tblMaterialInDetail (
    MatInDetID INT IDENTITY(1,1) PRIMARY KEY,
    MatInID INT,
    ItemID INT,
    Qty DECIMAL(18,3),
    Rate DECIMAL(18,2),
    TaxPct DECIMAL(5,2),
    TaxAmt DECIMAL(18,2),
    Amount DECIMAL(18,2)
)
GO

IF OBJECT_ID('tblMaterialOut') IS NULL
CREATE TABLE tblMaterialOut (
    MatOutID INT IDENTITY(1,1) PRIMARY KEY,
    IssueNo NVARCHAR(30),
    IssueDate DATE NOT NULL,
    DeptID INT,
    StoreID INT,
    ReqID INT,
    Remarks NVARCHAR(300),
    UserID INT,
    CreatedOn DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('tblMaterialOutDetail') IS NULL
CREATE TABLE tblMaterialOutDetail (
    MatOutDetID INT IDENTITY(1,1) PRIMARY KEY,
    MatOutID INT,
    ItemID INT,
    Qty DECIMAL(18,3)
)
GO

-- ===================== DEFAULT DATA =====================
IF NOT EXISTS (SELECT 1 FROM tblUsers WHERE LoginName='admin')
INSERT INTO tblUsers (UserName, LoginName, Password, Role) VALUES ('Administrator', 'admin', 'admin123', 'Admin')

IF NOT EXISTS (SELECT 1 FROM tblPaymentMode WHERE ModeName='Cash')
INSERT INTO tblPaymentMode (ModeName) VALUES ('Cash'),('Cheque'),('NEFT'),('RTGS'),('UPI'),('Credit Card'),('Debit Card')
GO
