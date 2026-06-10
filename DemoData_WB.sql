USE RTBillingDB
GO

-- ===================== CLEAN DUPLICATES FIRST =====================

-- Remove duplicate departments (keep lowest ID)
DELETE FROM tblDepartment WHERE DepartmentID NOT IN (
    SELECT MIN(DepartmentID) FROM tblDepartment GROUP BY DeptName)
GO

-- Remove duplicate stores (keep lowest ID)
DELETE FROM tblStore WHERE StoreID NOT IN (
    SELECT MIN(StoreID) FROM tblStore GROUP BY StoreName)
GO

-- Remove duplicate staff (keep lowest ID)
DELETE FROM tblStaff WHERE StaffID NOT IN (
    SELECT MIN(StaffID) FROM tblStaff GROUP BY StaffName)
GO

-- Remove duplicate agents (keep lowest ID)
DELETE FROM tblAgent WHERE AgentID NOT IN (
    SELECT MIN(AgentID) FROM tblAgent GROUP BY AgentName)
GO

-- Remove duplicate categories (keep lowest ID)
DELETE FROM tblCategory WHERE CatID NOT IN (
    SELECT MIN(CatID) FROM tblCategory GROUP BY CatName)
GO

-- Remove duplicate tax groups (keep lowest ID per name pattern)
DELETE FROM tblTaxGroupDetail WHERE TaxGroupID NOT IN (
    SELECT MIN(TaxGroupID) FROM tblTaxGroup GROUP BY GroupName)
DELETE FROM tblTaxGroup WHERE TaxGroupID NOT IN (
    SELECT MIN(TaxGroupID) FROM tblTaxGroup GROUP BY GroupName)
GO

-- Remove duplicate taxes (keep lowest ID per name)
DELETE FROM tblTaxGroupDetail WHERE TaxID NOT IN (
    SELECT MIN(TaxID) FROM tblTax GROUP BY TaxName)
DELETE FROM tblTax WHERE TaxID NOT IN (
    SELECT MIN(TaxID) FROM tblTax GROUP BY TaxName)
GO

-- ===================== COMPANY =====================
UPDATE tblCompany SET
    CompanyName='Roytech Traders Pvt Ltd',
    Address='12, Rabindra Sarani, Burrabazar',
    City='Kolkata', State='West Bengal', PinCode='700007',
    Phone='033-22134567', Email='info@roytechtraders.com',
    GSTIN='19AABCR1234F1ZK', PAN='AABCR1234F',
    StateCode='19', StateName='West Bengal'
WHERE CompanyID=1
GO

-- ===================== DEPARTMENTS =====================
IF NOT EXISTS (SELECT 1 FROM tblDepartment WHERE DeptName='Sales')
    INSERT INTO tblDepartment (DeptName) VALUES ('Sales')
IF NOT EXISTS (SELECT 1 FROM tblDepartment WHERE DeptName='Purchase')
    INSERT INTO tblDepartment (DeptName) VALUES ('Purchase')
IF NOT EXISTS (SELECT 1 FROM tblDepartment WHERE DeptName='Accounts')
    INSERT INTO tblDepartment (DeptName) VALUES ('Accounts')
IF NOT EXISTS (SELECT 1 FROM tblDepartment WHERE DeptName='Warehouse')
    INSERT INTO tblDepartment (DeptName) VALUES ('Warehouse')
GO

-- ===================== STORES =====================
IF NOT EXISTS (SELECT 1 FROM tblStore WHERE StoreName='Main Store')
    INSERT INTO tblStore (StoreName, Location) VALUES ('Main Store','Kolkata HQ')
IF NOT EXISTS (SELECT 1 FROM tblStore WHERE StoreName='Branch Store')
    INSERT INTO tblStore (StoreName, Location) VALUES ('Branch Store','Howrah')
GO

-- ===================== STAFF =====================
IF NOT EXISTS (SELECT 1 FROM tblStaff WHERE StaffName='Rajesh Kumar')
    INSERT INTO tblStaff (StaffName, DeptID, Phone, Email, Address, JoinDate, Salary)
    VALUES ('Rajesh Kumar',(SELECT MIN(DepartmentID) FROM tblDepartment WHERE DeptName='Sales'),
            '9831001001','rajesh@roytech.com','45 Park Street, Kolkata','2022-01-10',25000)
IF NOT EXISTS (SELECT 1 FROM tblStaff WHERE StaffName='Priya Ghosh')
    INSERT INTO tblStaff (StaffName, DeptID, Phone, Email, Address, JoinDate, Salary)
    VALUES ('Priya Ghosh',(SELECT MIN(DepartmentID) FROM tblDepartment WHERE DeptName='Purchase'),
            '9831002002','priya@roytech.com','10 Lake Road, Kolkata','2022-03-15',22000)
IF NOT EXISTS (SELECT 1 FROM tblStaff WHERE StaffName='Amit Das')
    INSERT INTO tblStaff (StaffName, DeptID, Phone, Email, Address, JoinDate, Salary)
    VALUES ('Amit Das',(SELECT MIN(DepartmentID) FROM tblDepartment WHERE DeptName='Accounts'),
            '9831003003','amit@roytech.com','22 Gariahat Road, Kolkata','2021-07-01',30000)
IF NOT EXISTS (SELECT 1 FROM tblStaff WHERE StaffName='Sunita Sharma')
    INSERT INTO tblStaff (StaffName, DeptID, Phone, Email, Address, JoinDate, Salary)
    VALUES ('Sunita Sharma',(SELECT MIN(DepartmentID) FROM tblDepartment WHERE DeptName='Warehouse'),
            '9831004004','sunita@roytech.com','5 Salt Lake, Kolkata','2023-01-20',18000)
GO

-- ===================== AGENTS =====================
IF NOT EXISTS (SELECT 1 FROM tblAgent WHERE AgentName='Suresh Agarwal')
    INSERT INTO tblAgent (AgentName, Phone, Email, CommissionPct)
    VALUES ('Suresh Agarwal','9830101010','suresh@agent.com',2.00)
IF NOT EXISTS (SELECT 1 FROM tblAgent WHERE AgentName='Meena Jain')
    INSERT INTO tblAgent (AgentName, Phone, Email, CommissionPct)
    VALUES ('Meena Jain','9830202020','meena@agent.com',1.50)
IF NOT EXISTS (SELECT 1 FROM tblAgent WHERE AgentName='Rahul Biswas')
    INSERT INTO tblAgent (AgentName, Phone, Email, CommissionPct)
    VALUES ('Rahul Biswas','9830303030','rahul@agent.com',2.50)
GO

-- ===================== CATEGORIES & SUBCATEGORIES =====================
IF NOT EXISTS (SELECT 1 FROM tblCategory WHERE CatName='Electronics')
    INSERT INTO tblCategory (CatName) VALUES ('Electronics')
IF NOT EXISTS (SELECT 1 FROM tblCategory WHERE CatName='Stationery')
    INSERT INTO tblCategory (CatName) VALUES ('Stationery')
IF NOT EXISTS (SELECT 1 FROM tblCategory WHERE CatName='Furniture')
    INSERT INTO tblCategory (CatName) VALUES ('Furniture')
IF NOT EXISTS (SELECT 1 FROM tblCategory WHERE CatName='Electrical')
    INSERT INTO tblCategory (CatName) VALUES ('Electrical')
GO

IF NOT EXISTS (SELECT 1 FROM tblSubCategory WHERE SubCatName='Computers')
    INSERT INTO tblSubCategory (CatID, SubCatName)
    VALUES ((SELECT MIN(CatID) FROM tblCategory WHERE CatName='Electronics'), 'Computers')
IF NOT EXISTS (SELECT 1 FROM tblSubCategory WHERE SubCatName='Mobile Phones')
    INSERT INTO tblSubCategory (CatID, SubCatName)
    VALUES ((SELECT MIN(CatID) FROM tblCategory WHERE CatName='Electronics'), 'Mobile Phones')
IF NOT EXISTS (SELECT 1 FROM tblSubCategory WHERE SubCatName='Accessories')
    INSERT INTO tblSubCategory (CatID, SubCatName)
    VALUES ((SELECT MIN(CatID) FROM tblCategory WHERE CatName='Electronics'), 'Accessories')
IF NOT EXISTS (SELECT 1 FROM tblSubCategory WHERE SubCatName='Paper & Files')
    INSERT INTO tblSubCategory (CatID, SubCatName)
    VALUES ((SELECT MIN(CatID) FROM tblCategory WHERE CatName='Stationery'), 'Paper & Files')
GO

-- ===================== TAX & TAX GROUPS =====================
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='CGST 2.5%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('CGST 2.5%', 2.50,'CGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='SGST 2.5%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('SGST 2.5%', 2.50,'SGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='CGST 6%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('CGST 6%',   6.00,'CGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='SGST 6%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('SGST 6%',   6.00,'SGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='CGST 9%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('CGST 9%',   9.00,'CGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='SGST 9%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('SGST 9%',   9.00,'SGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='CGST 14%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('CGST 14%', 14.00,'CGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='SGST 14%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('SGST 14%', 14.00,'SGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='IGST 5%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('IGST 5%',   5.00,'IGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='IGST 12%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('IGST 12%', 12.00,'IGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='IGST 18%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('IGST 18%', 18.00,'IGST')
IF NOT EXISTS (SELECT 1 FROM tblTax WHERE TaxName='IGST 28%')
    INSERT INTO tblTax (TaxName, TaxPct, TaxType) VALUES ('IGST 28%', 28.00,'IGST')
GO

IF NOT EXISTS (SELECT 1 FROM tblTaxGroup WHERE GroupName='GST 5%')
    INSERT INTO tblTaxGroup (GroupName) VALUES ('GST 5%')
IF NOT EXISTS (SELECT 1 FROM tblTaxGroup WHERE GroupName='GST 12%')
    INSERT INTO tblTaxGroup (GroupName) VALUES ('GST 12%')
IF NOT EXISTS (SELECT 1 FROM tblTaxGroup WHERE GroupName='GST 18%')
    INSERT INTO tblTaxGroup (GroupName) VALUES ('GST 18%')
IF NOT EXISTS (SELECT 1 FROM tblTaxGroup WHERE GroupName='GST 28%')
    INSERT INTO tblTaxGroup (GroupName) VALUES ('GST 28%')
GO

-- Link tax group details (only if not already linked)
IF NOT EXISTS (SELECT 1 FROM tblTaxGroupDetail WHERE
    TaxGroupID=(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 5%') AND
    TaxID=(SELECT MIN(TaxID) FROM tblTax WHERE TaxName='CGST 2.5%'))
BEGIN
    INSERT INTO tblTaxGroupDetail (TaxGroupID, TaxID) VALUES
    ((SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 5%'),  (SELECT MIN(TaxID) FROM tblTax WHERE TaxName='CGST 2.5%')),
    ((SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 5%'),  (SELECT MIN(TaxID) FROM tblTax WHERE TaxName='SGST 2.5%')),
    ((SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 12%'), (SELECT MIN(TaxID) FROM tblTax WHERE TaxName='CGST 6%')),
    ((SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 12%'), (SELECT MIN(TaxID) FROM tblTax WHERE TaxName='SGST 6%')),
    ((SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 18%'), (SELECT MIN(TaxID) FROM tblTax WHERE TaxName='CGST 9%')),
    ((SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 18%'), (SELECT MIN(TaxID) FROM tblTax WHERE TaxName='SGST 9%')),
    ((SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 28%'), (SELECT MIN(TaxID) FROM tblTax WHERE TaxName='CGST 14%')),
    ((SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 28%'), (SELECT MIN(TaxID) FROM tblTax WHERE TaxName='SGST 14%'))
END
GO

-- ===================== ITEMS =====================
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='HP Laptop 15')
    INSERT INTO tblItem (ItemName,CatID,SubCatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('HP Laptop 15',
     (SELECT MIN(CatID) FROM tblCategory WHERE CatName='Electronics'),
     (SELECT MIN(SubCatID) FROM tblSubCategory WHERE SubCatName='Computers'),
     'PCS','84713010',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 18%'),38000,45000,5)
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='Dell Monitor 24"')
    INSERT INTO tblItem (ItemName,CatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('Dell Monitor 24"',(SELECT MIN(CatID) FROM tblCategory WHERE CatName='Electronics'),
     'PCS','85285100',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 18%'),12000,15000,3)
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='Wireless Mouse')
    INSERT INTO tblItem (ItemName,CatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('Wireless Mouse',(SELECT MIN(CatID) FROM tblCategory WHERE CatName='Electronics'),
     'PCS','84716060',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 18%'),450,750,10)
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='USB Keyboard')
    INSERT INTO tblItem (ItemName,CatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('USB Keyboard',(SELECT MIN(CatID) FROM tblCategory WHERE CatName='Electronics'),
     'PCS','84716060',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 18%'),600,950,10)
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='HDMI Cable 1.5m')
    INSERT INTO tblItem (ItemName,CatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('HDMI Cable 1.5m',(SELECT MIN(CatID) FROM tblCategory WHERE CatName='Electronics'),
     'PCS','85444900',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 18%'),150,299,20)
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='A4 Paper Ream')
    INSERT INTO tblItem (ItemName,CatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('A4 Paper Ream',(SELECT MIN(CatID) FROM tblCategory WHERE CatName='Stationery'),
     'PKT','48021000',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 12%'),180,250,50)
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='Ballpoint Pen Box')
    INSERT INTO tblItem (ItemName,CatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('Ballpoint Pen Box',(SELECT MIN(CatID) FROM tblCategory WHERE CatName='Stationery'),
     'BOX','96081000',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 12%'),80,130,30)
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='Office Chair')
    INSERT INTO tblItem (ItemName,CatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('Office Chair',(SELECT MIN(CatID) FROM tblCategory WHERE CatName='Furniture'),
     'PCS','94013000',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 18%'),3500,5500,5)
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='Computer Table')
    INSERT INTO tblItem (ItemName,CatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('Computer Table',(SELECT MIN(CatID) FROM tblCategory WHERE CatName='Furniture'),
     'PCS','94033000',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 18%'),4500,7200,3)
IF NOT EXISTS (SELECT 1 FROM tblItem WHERE ItemName='Spiral Notebook')
    INSERT INTO tblItem (ItemName,CatID,Unit,HSNCode,TaxGroupID,PurchasePrice,SalePrice,ReorderQty) VALUES
    ('Spiral Notebook',(SELECT MIN(CatID) FROM tblCategory WHERE CatName='Stationery'),
     'PCS','48201000',(SELECT MIN(TaxGroupID) FROM tblTaxGroup WHERE GroupName='GST 5%'),40,70,100)
GO

-- ===================== CUSTOMERS =====================
IF NOT EXISTS (SELECT 1 FROM tblCustomer WHERE CustName='Biswajit Enterprises')
    INSERT INTO tblCustomer (CustName,Phone,Email,Address,GSTIN,AgentID,StateCode,StateName,OpeningBalance)
    VALUES ('Biswajit Enterprises','9830111111','biswajit@biz.com','34 Strand Road, Kolkata',
            '19AABCB1234A1Z5',(SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Suresh Agarwal'),'19','West Bengal',5000)
IF NOT EXISTS (SELECT 1 FROM tblCustomer WHERE CustName='Subrata Electronics')
    INSERT INTO tblCustomer (CustName,Phone,Email,Address,GSTIN,AgentID,StateCode,StateName,OpeningBalance)
    VALUES ('Subrata Electronics','9830222222','subrata@elec.com','22 Rabindra Sarani, Kolkata',
            '19AABCS5678B1Z2',(SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Meena Jain'),'19','West Bengal',0)
IF NOT EXISTS (SELECT 1 FROM tblCustomer WHERE CustName='Kalyani Traders')
    INSERT INTO tblCustomer (CustName,Phone,Email,Address,GSTIN,AgentID,StateCode,StateName,OpeningBalance)
    VALUES ('Kalyani Traders','9830333333','kalyani@trade.com','15 GT Road, Asansol, WB',
            '19AABCK9012C1Z8',(SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Suresh Agarwal'),'19','West Bengal',2000)
IF NOT EXISTS (SELECT 1 FROM tblCustomer WHERE CustName='Durgapur Steel Works')
    INSERT INTO tblCustomer (CustName,Phone,Email,Address,GSTIN,StateCode,StateName,OpeningBalance)
    VALUES ('Durgapur Steel Works','9830444444','durgapur@steel.com','Block B, Industrial Area, Durgapur',
            '19AABCD3456D1Z1','19','West Bengal',0)
IF NOT EXISTS (SELECT 1 FROM tblCustomer WHERE CustName='Siliguri Distributors')
    INSERT INTO tblCustomer (CustName,Phone,Email,Address,GSTIN,AgentID,StateCode,StateName,OpeningBalance)
    VALUES ('Siliguri Distributors','9830555555','siliguri@dist.com','88 Hill Cart Road, Siliguri, WB',
            '19AABCS7890E1Z4',(SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Rahul Biswas'),'19','West Bengal',10000)
IF NOT EXISTS (SELECT 1 FROM tblCustomer WHERE CustName='Mumbai Imports Pvt Ltd')
    INSERT INTO tblCustomer (CustName,Phone,Email,Address,GSTIN,StateCode,StateName,OpeningBalance)
    VALUES ('Mumbai Imports Pvt Ltd','9820000001','mumbai@imp.com','5 Nariman Point, Mumbai',
            '27AABCM1111F1ZX','27','Maharashtra',0)
GO

-- ===================== VENDORS =====================
IF NOT EXISTS (SELECT 1 FROM tblVendor WHERE VendorName='Techno Suppliers Pvt Ltd')
    INSERT INTO tblVendor (VendorName,Phone,Email,Address,GSTIN,PAN,StateCode,StateName,OpeningBalance)
    VALUES ('Techno Suppliers Pvt Ltd','9831100001','techno@sup.com','45 Burrabazar, Kolkata',
            '19AABCT2222G1ZY','AABCT2222G','19','West Bengal',8000)
IF NOT EXISTS (SELECT 1 FROM tblVendor WHERE VendorName='Kolkata Paper House')
    INSERT INTO tblVendor (VendorName,Phone,Email,Address,GSTIN,PAN,StateCode,StateName,OpeningBalance)
    VALUES ('Kolkata Paper House','9831100002','paper@kol.com','12 Canning Street, Kolkata',
            '19AABCK3333H1ZZ','AABCK3333H','19','West Bengal',0)
IF NOT EXISTS (SELECT 1 FROM tblVendor WHERE VendorName='Delhi Electronics Hub')
    INSERT INTO tblVendor (VendorName,Phone,Email,Address,GSTIN,PAN,StateCode,StateName,OpeningBalance)
    VALUES ('Delhi Electronics Hub','9811000001','delhi@ehub.com','22 Nehru Place, New Delhi',
            '07AABCD4444I1ZW','AABCD4444I','07','Delhi',0)
IF NOT EXISTS (SELECT 1 FROM tblVendor WHERE VendorName='Furniture World WB')
    INSERT INTO tblVendor (VendorName,Phone,Email,Address,GSTIN,PAN,StateCode,StateName,OpeningBalance)
    VALUES ('Furniture World WB','9831100004','furn@wb.com','67 Jadavpur, Kolkata',
            '19AABCF5555J1ZV','AABCF5555J','19','West Bengal',3000)
GO

-- ===================== BILLS (SALES) =====================
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00001')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00001','2025-04-05',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Biswajit Enterprises'),
 (SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Suresh Agarwal'),
 45000,0,8100,4050,4050,0,0,53100,53100,0,'19','B2B',0,'HP Laptop sale',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00002')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00002','2025-04-10',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Subrata Electronics'),
 (SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Meena Jain'),
 15000,500,2610,1305,1305,0,0,17110,10000,7110,'19','B2B',0,'Monitor + Mouse',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00003')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00003','2025-04-18',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Kalyani Traders'),
 (SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Suresh Agarwal'),
 2500,0,300,150,150,0,0,2800,2800,0,'19','B2C',0,'Stationery items',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00004')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00004','2025-05-02',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Durgapur Steel Works'),
 NULL,22000,1000,3780,1890,1890,0,0,24780,24780,0,'19','B2B',0,'Office furniture',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00005')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00005','2025-05-15',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Siliguri Distributors'),
 (SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Rahul Biswas'),
 90000,0,16200,8100,8100,0,0,106200,50000,56200,'19','B2B',0,'Bulk laptop order',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00006')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00006','2025-05-22',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Mumbai Imports Pvt Ltd'),
 NULL,30000,0,5400,0,0,5400,0,35400,35400,0,'27','B2B',0,'Inter-state supply Mumbai',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00007')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00007','2025-06-01',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Biswajit Enterprises'),
 (SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Suresh Agarwal'),
 7500,250,1305,652,652,0,0,8555,8555,0,'19','B2B',0,'Accessories',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00008')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00008','2025-06-10',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Kalyani Traders'),
 (SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Suresh Agarwal'),
 4500,0,810,405,405,0,0,5310,0,5310,'19','B2C',0,'Chair + Notebooks',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00009')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00009','2025-06-20',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Subrata Electronics'),
 (SELECT MIN(AgentID) FROM tblAgent WHERE AgentName='Meena Jain'),
 53000,1000,9360,4680,4680,0,0,61360,61360,0,'19','B2B',0,'Laptop + Monitor',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblBill WHERE BillNo='BILL-00010')
INSERT INTO tblBill (BillNo,BillDate,CustID,AgentID,SubTotal,DiscountAmt,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,CessAmt,GrandTotal,PaidAmt,DueAmt,PlaceOfSupply,InvoiceType,ReverseCharge,Remarks,UserID)
VALUES
('BILL-00010','2025-07-05',
 (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Durgapur Steel Works'),
 NULL,14400,0,2592,1296,1296,0,0,16992,16992,0,'19','B2B',0,'Tables x2',1)
GO

-- ===================== BILL DETAILS =====================
IF NOT EXISTS (SELECT 1 FROM tblBillDetail WHERE BillID=(SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00001'))
INSERT INTO tblBillDetail (BillID,ItemID,HSNCode,Qty,Rate,DiscPct,TaxPct,CGSTPct,SGSTPct,IGSTPct,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,Amount)
VALUES
((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00001'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 '84713010',1,45000,0,18,9,9,0,8100,4050,4050,0,53100),

((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00002'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Dell Monitor 24"'),
 '85285100',1,15000,0,18,9,9,0,2700,1350,1350,0,17700),
((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00002'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Wireless Mouse'),
 '84716060',2,750,0,18,9,9,0,270,135,135,0,1770),

((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00003'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='A4 Paper Ream'),
 '48021000',5,250,0,12,6,6,0,150,75,75,0,1400),
((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00003'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Ballpoint Pen Box'),
 '96081000',5,130,0,12,6,6,0,78,39,39,0,728),
((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00003'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Spiral Notebook'),
 '48201000',10,70,0,5,2.5,2.5,0,35,17.5,17.5,0,735),

((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00004'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Office Chair'),
 '94013000',2,5500,0,18,9,9,0,1980,990,990,0,12980),
((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00004'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Computer Table'),
 '94033000',1,7200,0,18,9,9,0,1296,648,648,0,8496),

((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00005'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 '84713010',2,45000,0,18,9,9,0,16200,8100,8100,0,106200),

((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00006'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 '84713010',1,30000,0,18,0,0,18,5400,0,0,5400,35400),

((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00007'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Wireless Mouse'),
 '84716060',5,750,0,18,9,9,0,675,337.5,337.5,0,4425),
((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00007'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='USB Keyboard'),
 '84716060',4,950,0,18,9,9,0,684,342,342,0,4484),

((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00008'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Office Chair'),
 '94013000',1,5500,0,18,9,9,0,990,495,495,0,6490),
((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00008'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Spiral Notebook'),
 '48201000',10,70,0,5,2.5,2.5,0,35,17.5,17.5,0,735),

((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00009'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 '84713010',1,45000,0,18,9,9,0,8100,4050,4050,0,53100),
((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00009'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Dell Monitor 24"'),
 '85285100',1,15000,0,18,9,9,0,2700,1350,1350,0,17700),

((SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00010'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Computer Table'),
 '94033000',2,7200,0,18,9,9,0,2592,1296,1296,0,16992)
GO

-- ===================== DUE PAYMENTS =====================
IF NOT EXISTS (SELECT 1 FROM tblDuePayment WHERE CustID=(SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Subrata Electronics') AND Amount=5000)
    INSERT INTO tblDuePayment (PayDate,CustID,BillID,Amount,ModeID,Remarks,UserID)
    VALUES ('2025-05-01',
        (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Subrata Electronics'),
        (SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00002'),
        5000,(SELECT MIN(ModeID) FROM tblPaymentMode WHERE ModeName='UPI'),'Partial payment BILL-00002',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblDuePayment WHERE CustID=(SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Siliguri Distributors') AND Amount=30000)
    INSERT INTO tblDuePayment (PayDate,CustID,BillID,Amount,ModeID,Remarks,UserID)
    VALUES ('2025-05-20',
        (SELECT MIN(CustID) FROM tblCustomer WHERE CustName='Siliguri Distributors'),
        (SELECT MIN(BillID) FROM tblBill WHERE BillNo='BILL-00005'),
        30000,(SELECT MIN(ModeID) FROM tblPaymentMode WHERE ModeName='NEFT'),'Partial payment BILL-00005',1)
GO

-- ===================== MATERIAL IN (PURCHASES) =====================
IF NOT EXISTS (SELECT 1 FROM tblMaterialIn WHERE GRNNo='GRN-00001')
    INSERT INTO tblMaterialIn (GRNNo,GRNDate,VendorID,StoreID,InvoiceNo,InvoiceDate,SubTotal,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,GrandTotal,PlaceOfSupply,ReverseCharge,ITCEligible,Remarks,UserID)
    VALUES ('GRN-00001','2025-04-01',
        (SELECT MIN(VendorID) FROM tblVendor WHERE VendorName='Techno Suppliers Pvt Ltd'),
        (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),
        'INV-T-1001','2025-04-01',76000,13680,6840,6840,0,89680,'19',0,1,'Laptop stock purchase',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblMaterialIn WHERE GRNNo='GRN-00002')
    INSERT INTO tblMaterialIn (GRNNo,GRNDate,VendorID,StoreID,InvoiceNo,InvoiceDate,SubTotal,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,GrandTotal,PlaceOfSupply,ReverseCharge,ITCEligible,Remarks,UserID)
    VALUES ('GRN-00002','2025-04-12',
        (SELECT MIN(VendorID) FROM tblVendor WHERE VendorName='Kolkata Paper House'),
        (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),
        'INV-P-2001','2025-04-12',1800,216,108,108,0,2016,'19',0,1,'Paper & stationery',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblMaterialIn WHERE GRNNo='GRN-00003')
    INSERT INTO tblMaterialIn (GRNNo,GRNDate,VendorID,StoreID,InvoiceNo,InvoiceDate,SubTotal,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,GrandTotal,PlaceOfSupply,ReverseCharge,ITCEligible,Remarks,UserID)
    VALUES ('GRN-00003','2025-05-03',
        (SELECT MIN(VendorID) FROM tblVendor WHERE VendorName='Delhi Electronics Hub'),
        (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),
        'INV-D-3001','2025-05-03',24000,4320,0,0,4320,28320,'19',0,1,'Monitors from Delhi (IGST)',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblMaterialIn WHERE GRNNo='GRN-00004')
    INSERT INTO tblMaterialIn (GRNNo,GRNDate,VendorID,StoreID,InvoiceNo,InvoiceDate,SubTotal,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,GrandTotal,PlaceOfSupply,ReverseCharge,ITCEligible,Remarks,UserID)
    VALUES ('GRN-00004','2025-05-20',
        (SELECT MIN(VendorID) FROM tblVendor WHERE VendorName='Furniture World WB'),
        (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),
        'INV-F-4001','2025-05-20',18000,3240,1620,1620,0,21240,'19',0,1,'Chairs & tables',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblMaterialIn WHERE GRNNo='GRN-00005')
    INSERT INTO tblMaterialIn (GRNNo,GRNDate,VendorID,StoreID,InvoiceNo,InvoiceDate,SubTotal,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,GrandTotal,PlaceOfSupply,ReverseCharge,ITCEligible,Remarks,UserID)
    VALUES ('GRN-00005','2025-06-05',
        (SELECT MIN(VendorID) FROM tblVendor WHERE VendorName='Techno Suppliers Pvt Ltd'),
        (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),
        'INV-T-1002','2025-06-05',38000,6840,3420,3420,0,44840,'19',0,1,'More laptops',1)
GO
IF NOT EXISTS (SELECT 1 FROM tblMaterialIn WHERE GRNNo='GRN-00006')
    INSERT INTO tblMaterialIn (GRNNo,GRNDate,VendorID,StoreID,InvoiceNo,InvoiceDate,SubTotal,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,GrandTotal,PlaceOfSupply,ReverseCharge,ITCEligible,Remarks,UserID)
    VALUES ('GRN-00006','2025-07-01',
        (SELECT MIN(VendorID) FROM tblVendor WHERE VendorName='Kolkata Paper House'),
        (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),
        'INV-P-2002','2025-07-01',900,108,54,54,0,1008,'19',0,1,'Notebooks',1)
GO

-- ===================== MATERIAL IN DETAILS =====================
IF NOT EXISTS (SELECT 1 FROM tblMaterialInDetail WHERE MatInID=(SELECT MIN(MatInID) FROM tblMaterialIn WHERE GRNNo='GRN-00001'))
INSERT INTO tblMaterialInDetail (MatInID,ItemID,HSNCode,Qty,Rate,TaxPct,CGSTPct,SGSTPct,IGSTPct,TaxAmt,CGSTAmt,SGSTAmt,IGSTAmt,Amount)
VALUES
((SELECT MIN(MatInID) FROM tblMaterialIn WHERE GRNNo='GRN-00001'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 '84713010',2,38000,18,9,9,0,13680,6840,6840,0,89680),

((SELECT MIN(MatInID) FROM tblMaterialIn WHERE GRNNo='GRN-00002'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='A4 Paper Ream'),
 '48021000',6,180,12,6,6,0,129.6,64.8,64.8,0,1209.6),
((SELECT MIN(MatInID) FROM tblMaterialIn WHERE GRNNo='GRN-00002'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Ballpoint Pen Box'),
 '96081000',5,80,12,6,6,0,48,24,24,0,448),

((SELECT MIN(MatInID) FROM tblMaterialIn WHERE GRNNo='GRN-00003'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Dell Monitor 24"'),
 '85285100',2,12000,18,0,0,18,4320,0,0,4320,28320),

((SELECT MIN(MatInID) FROM tblMaterialIn WHERE GRNNo='GRN-00004'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Office Chair'),
 '94013000',3,3500,18,9,9,0,1890,945,945,0,12390),
((SELECT MIN(MatInID) FROM tblMaterialIn WHERE GRNNo='GRN-00004'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Computer Table'),
 '94033000',2,4500,18,9,9,0,1620,810,810,0,10620),

((SELECT MIN(MatInID) FROM tblMaterialIn WHERE GRNNo='GRN-00005'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 '84713010',1,38000,18,9,9,0,6840,3420,3420,0,44840),

((SELECT MIN(MatInID) FROM tblMaterialIn WHERE GRNNo='GRN-00006'),
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Spiral Notebook'),
 '48201000',15,40,5,2.5,2.5,0,30,15,15,0,630)
GO

-- ===================== STOCK IN =====================
IF NOT EXISTS (SELECT 1 FROM tblStockIn WHERE RefNo='GRN-00001')
INSERT INTO tblStockIn (TxnDate,ItemID,StoreID,Qty,Rate,RefNo,Remarks,UserID)
VALUES
('2025-04-01',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),2,38000,'GRN-00001','Laptops received',1),
('2025-04-12',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='A4 Paper Ream'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),6,180,'GRN-00002','Paper reams',1),
('2025-05-03',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Dell Monitor 24"'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),2,12000,'GRN-00003','Monitors from Delhi',1),
('2025-05-20',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Office Chair'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),3,3500,'GRN-00004','Office chairs',1),
('2025-05-20',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Computer Table'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),2,4500,'GRN-00004','Computer tables',1),
('2025-06-05',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),1,38000,'GRN-00005','Laptop restock',1),
('2025-06-05',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Wireless Mouse'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),10,450,'OPENING','Opening stock mice',1),
('2025-06-05',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='USB Keyboard'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),10,600,'OPENING','Opening stock keyboards',1),
('2025-07-01',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Spiral Notebook'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),15,40,'GRN-00006','Notebooks',1)
GO

-- ===================== STOCK OUT =====================
IF NOT EXISTS (SELECT 1 FROM tblStockOut WHERE RefNo='BILL-00001')
INSERT INTO tblStockOut (TxnDate,ItemID,StoreID,Qty,Rate,RefNo,Remarks,UserID)
VALUES
('2025-04-05',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),1,45000,'BILL-00001','Sale to Biswajit',1),
('2025-04-10',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Dell Monitor 24"'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),1,15000,'BILL-00002','Sale to Subrata',1),
('2025-04-18',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='A4 Paper Ream'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),5,250,'BILL-00003','Sale to Kalyani',1),
('2025-05-02',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Office Chair'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),2,5500,'BILL-00004','Sale to Durgapur',1),
('2025-05-02',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Computer Table'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),1,7200,'BILL-00004','Table sale',1),
('2025-05-15',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),2,45000,'BILL-00005','Bulk sale Siliguri',1),
('2025-05-22',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),1,30000,'BILL-00006','Inter-state sale Mumbai',1),
('2025-06-10',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Office Chair'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),1,5500,'BILL-00008','Chair sale Kalyani',1),
('2025-06-20',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='HP Laptop 15'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),1,45000,'BILL-00009','Laptop to Subrata',1),
('2025-06-20',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Dell Monitor 24"'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),1,15000,'BILL-00009','Monitor to Subrata',1),
('2025-07-05',(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Computer Table'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),2,7200,'BILL-00010','Tables to Durgapur',1)
GO

-- ===================== STOCK WASTAGE =====================
IF NOT EXISTS (SELECT 1 FROM tblStockWastage WHERE ItemID=(SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Wireless Mouse'))
INSERT INTO tblStockWastage (TxnDate,ItemID,StoreID,Qty,Remarks,UserID)
VALUES
('2025-05-10',
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Wireless Mouse'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),1,'Damaged during transit',1),
('2025-06-15',
 (SELECT MIN(ItemID) FROM tblItem WHERE ItemName='Spiral Notebook'),
 (SELECT MIN(StoreID) FROM tblStore WHERE StoreName='Main Store'),2,'Wet damage',1)
GO

-- ===================== EXPENSES =====================
IF NOT EXISTS (SELECT 1 FROM tblExpense WHERE ExpHead='Office Rent - April 2025')
INSERT INTO tblExpense (ExpDate,ExpHead,ExpCategory,Amount,GSTAmt,ITCEligible,Remarks,UserID)
VALUES
('2025-04-01','Office Rent - April 2025',  'Rent',    15000,  0, 0,'Monthly rent',1),
('2025-04-05','Courier Charges - April',    'Transport',  850,153, 1,'Goods delivery',1),
('2025-04-10','Staff Salary - April 2025',  'Salary',  95000,  0, 0,'Monthly payroll',1),
('2025-04-15','Electricity Bill - April',   'Utility',  4200,  0, 0,'Office electricity',1),
('2025-05-01','Office Rent - May 2025',     'Rent',    15000,  0, 0,'Monthly rent',1),
('2025-05-07','Internet & Phone - May',     'Utility',  2500,450, 1,'Broadband + mobile',1),
('2025-05-10','Staff Salary - May 2025',    'Salary',  95000,  0, 0,'Monthly payroll',1),
('2025-05-18','Office Supplies - May',      'Misc',      700,  0, 0,'Cleaning & misc',1),
('2025-06-01','Office Rent - June 2025',    'Rent',    15000,  0, 0,'Monthly rent',1),
('2025-06-10','Staff Salary - June 2025',   'Salary',  95000,  0, 0,'Monthly payroll',1),
('2025-06-20','Vehicle Fuel - June',        'Transport',1800,  0, 0,'Delivery van fuel',1),
('2025-07-01','Office Rent - July 2025',    'Rent',    15000,  0, 0,'Monthly rent',1)
GO

PRINT 'Demo data inserted successfully for all tables.'
GO
