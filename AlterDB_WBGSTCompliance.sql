-- =====================================================================
-- RTBillingDB - West Bengal GST Compliance Alter Script
-- Run this on existing database to add missing columns
-- =====================================================================
USE RTBillingDB
GO

-- ===================== tblCompany: Add StateCode =====================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCompany') AND name='StateCode')
    ALTER TABLE tblCompany ADD StateCode NVARCHAR(5) DEFAULT '19'  -- WB State Code = 19
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCompany') AND name='StateName')
    ALTER TABLE tblCompany ADD StateName NVARCHAR(100) DEFAULT 'West Bengal'
GO

-- ===================== tblCustomer: Add State info ==================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCustomer') AND name='StateCode')
    ALTER TABLE tblCustomer ADD StateCode NVARCHAR(5) DEFAULT '19'
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCustomer') AND name='StateName')
    ALTER TABLE tblCustomer ADD StateName NVARCHAR(100) DEFAULT 'West Bengal'
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCustomer') AND name='PAN')
    ALTER TABLE tblCustomer ADD PAN NVARCHAR(20)
GO

-- ===================== tblVendor: Add State info ===================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblVendor') AND name='StateCode')
    ALTER TABLE tblVendor ADD StateCode NVARCHAR(5) DEFAULT '19'
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblVendor') AND name='StateName')
    ALTER TABLE tblVendor ADD StateName NVARCHAR(100) DEFAULT 'West Bengal'
GO

-- ===================== tblTax: Add TaxType (CGST/SGST/IGST/CESS) ==
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblTax') AND name='TaxType')
    ALTER TABLE tblTax ADD TaxType NVARCHAR(10) DEFAULT 'CGST'  -- CGST, SGST, IGST, CESS
GO

-- ===================== tblBill: Add GST compliance columns =========
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBill') AND name='PlaceOfSupply')
    ALTER TABLE tblBill ADD PlaceOfSupply NVARCHAR(5) DEFAULT '19'  -- WB=19
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBill') AND name='InvoiceType')
    ALTER TABLE tblBill ADD InvoiceType NVARCHAR(10) DEFAULT 'B2C'  -- B2B, B2C, Export
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBill') AND name='ReverseCharge')
    ALTER TABLE tblBill ADD ReverseCharge BIT DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBill') AND name='CGSTAmt')
    ALTER TABLE tblBill ADD CGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBill') AND name='SGSTAmt')
    ALTER TABLE tblBill ADD SGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBill') AND name='IGSTAmt')
    ALTER TABLE tblBill ADD IGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBill') AND name='CessAmt')
    ALTER TABLE tblBill ADD CessAmt DECIMAL(18,2) DEFAULT 0
GO

-- ===================== tblBillDetail: Add HSN + tax breakup ========
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBillDetail') AND name='HSNCode')
    ALTER TABLE tblBillDetail ADD HSNCode NVARCHAR(20)
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBillDetail') AND name='CGSTPct')
    ALTER TABLE tblBillDetail ADD CGSTPct DECIMAL(5,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBillDetail') AND name='SGSTPct')
    ALTER TABLE tblBillDetail ADD SGSTPct DECIMAL(5,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBillDetail') AND name='IGSTPct')
    ALTER TABLE tblBillDetail ADD IGSTPct DECIMAL(5,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBillDetail') AND name='CGSTAmt')
    ALTER TABLE tblBillDetail ADD CGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBillDetail') AND name='SGSTAmt')
    ALTER TABLE tblBillDetail ADD SGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblBillDetail') AND name='IGSTAmt')
    ALTER TABLE tblBillDetail ADD IGSTAmt DECIMAL(18,2) DEFAULT 0
GO

-- ===================== tblMaterialIn: Add GST compliance ===========
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialIn') AND name='PlaceOfSupply')
    ALTER TABLE tblMaterialIn ADD PlaceOfSupply NVARCHAR(5) DEFAULT '19'
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialIn') AND name='ReverseCharge')
    ALTER TABLE tblMaterialIn ADD ReverseCharge BIT DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialIn') AND name='CGSTAmt')
    ALTER TABLE tblMaterialIn ADD CGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialIn') AND name='SGSTAmt')
    ALTER TABLE tblMaterialIn ADD SGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialIn') AND name='IGSTAmt')
    ALTER TABLE tblMaterialIn ADD IGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialIn') AND name='ITCEligible')
    ALTER TABLE tblMaterialIn ADD ITCEligible BIT DEFAULT 1  -- ITC eligible by default
GO

-- ===================== tblMaterialInDetail: Add HSN + tax breakup ==
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialInDetail') AND name='HSNCode')
    ALTER TABLE tblMaterialInDetail ADD HSNCode NVARCHAR(20)
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialInDetail') AND name='CGSTPct')
    ALTER TABLE tblMaterialInDetail ADD CGSTPct DECIMAL(5,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialInDetail') AND name='SGSTPct')
    ALTER TABLE tblMaterialInDetail ADD SGSTPct DECIMAL(5,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialInDetail') AND name='IGSTPct')
    ALTER TABLE tblMaterialInDetail ADD IGSTPct DECIMAL(5,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialInDetail') AND name='CGSTAmt')
    ALTER TABLE tblMaterialInDetail ADD CGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialInDetail') AND name='SGSTAmt')
    ALTER TABLE tblMaterialInDetail ADD SGSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblMaterialInDetail') AND name='IGSTAmt')
    ALTER TABLE tblMaterialInDetail ADD IGSTAmt DECIMAL(18,2) DEFAULT 0
GO

-- ===================== tblExpense: Add GST on expense ==============
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblExpense') AND name='ExpCategory')
    ALTER TABLE tblExpense ADD ExpCategory NVARCHAR(100)  -- Rent, Salary, Transport, etc.
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblExpense') AND name='GSTAmt')
    ALTER TABLE tblExpense ADD GSTAmt DECIMAL(18,2) DEFAULT 0
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblExpense') AND name='ITCEligible')
    ALTER TABLE tblExpense ADD ITCEligible BIT DEFAULT 0
GO

-- ===================== tblItem: Verify HSNCode exists (already in schema) =
-- tblItem already has HSNCode - no change needed

-- ===================== Default Tax Data for WB (GST) ===============
-- Update existing tax records to set TaxType if empty
UPDATE tblTax SET TaxType='CGST' WHERE TaxName LIKE '%CGST%' OR TaxName LIKE '%C-GST%'
UPDATE tblTax SET TaxType='SGST' WHERE TaxName LIKE '%SGST%' OR TaxName LIKE '%S-GST%' OR TaxName LIKE '%WBGST%'
UPDATE tblTax SET TaxType='IGST' WHERE TaxName LIKE '%IGST%' OR TaxName LIKE '%I-GST%'
UPDATE tblTax SET TaxType='CESS' WHERE TaxName LIKE '%CESS%'
GO

-- Insert standard WB GST tax rates if not present
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='CGST 2.5%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('CGST 2.5%', 2.50, 'CGST'),('SGST 2.5%', 2.50, 'SGST'),('CGST 6%', 6.00, 'CGST'),('SGST 6%', 6.00, 'SGST'),('CGST 9%', 9.00, 'CGST'),('SGST 9%', 9.00, 'SGST'),('CGST 14%', 14.00, 'CGST'),('SGST 14%', 14.00, 'SGST'),('IGST 5%', 5.00, 'IGST'),('IGST 12%', 12.00, 'IGST'),('IGST 18%', 18.00, 'IGST'),('IGST 28%', 28.00, 'IGST')
GO

PRINT 'WB GST Compliance columns added successfully.'
GO
