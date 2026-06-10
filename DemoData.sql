-- Demo Data for RTBilling Software Testing
-- Run this after CreateDB.sql

USE RTBillingDB
GO

-- Company
INSERT INTO tblCompany (CompanyName, Address, City, State, PinCode, Phone, Email, GSTIN, PAN, IsActive)
VALUES ('RoyTech Solutions', 'Plot 123, Industrial Area', 'Mumbai', 'Maharashtra', '400001', '022-12345678', 'info@roytech.com', '27AAACR5055K1Z5', 'AAACR5055K', 1)

-- Departments
INSERT INTO tblDepartment (DeptName, IsActive) VALUES 
('Production', 1), ('Sales', 1), ('Purchase', 1), ('Accounts', 1), ('Maintenance', 1)

-- Staff
INSERT INTO tblStaff (StaffName, DeptID, Phone, Email, Address, JoinDate, Salary, IsActive) VALUES
('Rajesh Kumar', 1, '9876543210', 'rajesh@roytech.com', 'Andheri, Mumbai', '2023-01-15', 35000, 1),
('Priya Sharma', 2, '9876543211', 'priya@roytech.com', 'Bandra, Mumbai', '2023-02-20', 30000, 1),
('Amit Patel', 3, '9876543212', 'amit@roytech.com', 'Thane, Mumbai', '2023-03-10', 32000, 1)

-- Agents
INSERT INTO tblAgent (AgentName, Phone, Email, CommissionPct, IsActive) VALUES
('Suresh Trading', '9988776655', 'suresh@trade.com', 2.5, 1),
('Mahesh Associates', '9988776656', 'mahesh@assoc.com', 3.0, 1)

-- Categories
INSERT INTO tblCategory (CatName, IsActive) VALUES
('Electronics', 1), ('Furniture', 1), ('Stationery', 1), ('Hardware', 1)

-- SubCategories
INSERT INTO tblSubCategory (CatID, SubCatName, IsActive) VALUES
(1, 'Computers', 1), (1, 'Accessories', 1), (2, 'Office Furniture', 1), (3, 'Paper Products', 1), (4, 'Tools', 1)

-- Tax
INSERT INTO tblTax (TaxName, TaxPct, IsActive) VALUES
('CGST-9%', 9.00, 1), ('SGST-9%', 9.00, 1), ('CGST-6%', 6.00, 1), ('SGST-6%', 6.00, 1), ('IGST-18%', 18.00, 1)

-- Tax Groups
INSERT INTO tblTaxGroup (GroupName, IsActive) VALUES ('GST-18%', 1), ('GST-12%', 1), ('GST-5%', 1)

INSERT INTO tblTaxGroupDetail (TaxGroupID, TaxID) VALUES (1, 1), (1, 2), (2, 3), (2, 4)

-- Stores
INSERT INTO tblStore (StoreName, Location, IsActive) VALUES
('Main Store', 'Warehouse A', 1), ('Branch Store', 'Warehouse B', 1)

-- Vendors
INSERT INTO tblVendor (VendorName, Phone, Email, Address, GSTIN, PAN, OpeningBalance, IsActive) VALUES
('Tech Suppliers Ltd', '9123456789', 'tech@suppliers.com', 'Nariman Point, Mumbai', '27AABCT1234L1Z5', 'AABCT1234L', 0, 1),
('Office Mart Pvt Ltd', '9123456790', 'info@officemart.com', 'Worli, Mumbai', '27AABCO5678M1Z5', 'AABCO5678M', 5000, 1),
('Hardware Hub', '9123456791', 'sales@hardwarehub.com', 'Vashi, Navi Mumbai', '27AABHH9012N1Z5', 'AABHH9012N', 0, 1)

-- Customers
INSERT INTO tblCustomer (CustName, Phone, Email, Address, GSTIN, AgentID, OpeningBalance, IsActive) VALUES
('ABC Corporation', '9898989898', 'abc@corp.com', 'BKC, Mumbai', '27AAABC1234C1Z5', 1, 0, 1),
('XYZ Enterprises', '9797979797', 'xyz@ent.com', 'Powai, Mumbai', '27AAXYZ5678D1Z5', 1, 2000, 1),
('PQR Industries', '9696969696', 'pqr@ind.com', 'Goregaon, Mumbai', NULL, 2, 0, 1),
('Walk-in Customer', '9595959595', NULL, NULL, NULL, NULL, 0, 1)

-- Items
INSERT INTO tblItem (ItemName, CatID, SubCatID, Unit, HSNCode, TaxGroupID, PurchasePrice, SalePrice, ReorderQty, IsActive) VALUES
('Dell Laptop i5', 1, 1, 'Nos', '84713010', 1, 35000, 42000, 5, 1),
('Wireless Mouse', 1, 2, 'Nos', '84716060', 1, 250, 350, 20, 1),
('Office Chair', 2, 3, 'Nos', '94013000', 1, 2500, 3500, 10, 1),
('A4 Paper Ream', 3, 4, 'Pack', '48025610', 2, 200, 280, 50, 1),
('Screwdriver Set', 4, 5, 'Set', '82054000', 1, 450, 650, 15, 1)

-- Services
INSERT INTO tblService (ServiceName, TaxGroupID, Rate, IsActive) VALUES
('Installation Service', 1, 1500, 1),
('Annual Maintenance', 1, 5000, 1),
('Repair Service', 1, 800, 1)

-- Bills
INSERT INTO tblBill (BillNo, BillDate, CustID, AgentID, SubTotal, DiscountAmt, TaxAmt, GrandTotal, PaidAmt, DueAmt, ModeID, Remarks, UserID) VALUES
('INV-001', '2024-01-15', 1, 1, 84000, 1000, 14940, 97940, 97940, 0, 1, 'Full payment received', 1),
('INV-002', '2024-01-20', 2, 1, 3500, 0, 630, 4130, 2000, 2130, 5, 'Partial payment', 1),
('INV-003', '2024-01-25', 3, 2, 1300, 0, 234, 1534, 1534, 0, 1, NULL, 1)

-- Bill Details
INSERT INTO tblBillDetail (BillID, ItemID, ServiceID, Qty, Rate, DiscPct, TaxPct, TaxAmt, Amount) VALUES
(1, 1, NULL, 2, 42000, 0, 18, 15120, 84000),
(2, 3, NULL, 1, 3500, 0, 18, 630, 3500),
(3, 2, NULL, 2, 350, 0, 18, 126, 700),
(3, NULL, 3, 1, 800, 0, 18, 144, 800)

-- Due Payments
INSERT INTO tblDuePayment (PayDate, CustID, BillID, Amount, ModeID, Remarks, UserID) VALUES
('2024-02-01', 2, 2, 2130, 1, 'Balance cleared', 1)

-- Expenses
INSERT INTO tblExpense (ExpDate, ExpHead, Amount, ModeID, StaffID, Remarks, UserID) VALUES
('2024-01-10', 'Electricity Bill', 5500, 1, NULL, 'Monthly bill', 1),
('2024-01-15', 'Staff Salary', 35000, 2, 1, 'Rajesh Kumar', 1),
('2024-01-20', 'Office Supplies', 2500, 1, NULL, 'Stationery purchase', 1)

-- Stock In
INSERT INTO tblStockIn (TxnDate, ItemID, StoreID, Qty, Rate, Remarks, RefNo, UserID) VALUES
('2024-01-05', 1, 1, 10, 35000, 'Opening stock', 'PO-001', 1),
('2024-01-05', 2, 1, 50, 250, 'Opening stock', 'PO-001', 1),
('2024-01-08', 3, 1, 20, 2500, 'Opening stock', 'PO-002', 1),
('2024-01-10', 4, 1, 100, 200, 'Opening stock', 'PO-003', 1)

-- Stock Out
INSERT INTO tblStockOut (TxnDate, ItemID, StoreID, Qty, Rate, Remarks, RefNo, UserID) VALUES
('2024-01-15', 1, 1, 2, 35000, 'Sold to customer', 'INV-001', 1),
('2024-01-20', 3, 1, 1, 2500, 'Sold to customer', 'INV-002', 1)

-- Stock Transfer
INSERT INTO tblStockTransfer (TxnDate, ItemID, FromStoreID, ToStoreID, Qty, Remarks, UserID) VALUES
('2024-01-12', 2, 1, 2, 10, 'Transfer to branch', 1)

-- Purchase Orders
INSERT INTO tblPurchaseOrder (PONo, PODate, VendorID, StoreID, Status, Remarks, UserID) VALUES
('PO-001', '2024-01-01', 1, 1, 'Completed', 'Initial stock purchase', 1),
('PO-002', '2024-01-05', 2, 1, 'Completed', 'Furniture order', 1),
('PO-003', '2024-02-01', 3, 1, 'Pending', 'Hardware items', 1)

-- Purchase Order Details
INSERT INTO tblPurchaseOrderDetail (POID, ItemID, Qty, Rate, ReceivedQty) VALUES
(1, 1, 10, 35000, 10), (1, 2, 50, 250, 50), (2, 3, 20, 2500, 20), (3, 5, 30, 450, 0)

-- Material In
INSERT INTO tblMaterialIn (GRNNo, GRNDate, VendorID, StoreID, POID, InvoiceNo, InvoiceDate, SubTotal, TaxAmt, GrandTotal, Remarks, UserID) VALUES
('GRN-001', '2024-01-06', 1, 1, 1, 'TS-INV-001', '2024-01-05', 362500, 65250, 427750, 'Received in good condition', 1),
('GRN-002', '2024-01-08', 2, 1, 2, 'OM-INV-045', '2024-01-07', 50000, 9000, 59000, 'Delivered complete', 1)

-- Material In Details
INSERT INTO tblMaterialInDetail (MatInID, ItemID, Qty, Rate, TaxPct, TaxAmt, Amount) VALUES
(1, 1, 10, 35000, 18, 63000, 350000), (1, 2, 50, 250, 18, 2250, 12500), (2, 3, 20, 2500, 18, 9000, 50000)

-- Requisition Orders
INSERT INTO tblRequisitionOrder (ReqNo, ReqDate, DeptID, StoreID, Status, Remarks, UserID) VALUES
('REQ-001', '2024-01-18', 1, 1, 'Approved', 'Production requirement', 1)

-- Requisition Details
INSERT INTO tblRequisitionDetail (ReqID, ItemID, Qty, IssuedQty) VALUES
(1, 2, 5, 5), (1, 5, 3, 3)

-- Material Out
INSERT INTO tblMaterialOut (IssueNo, IssueDate, DeptID, StoreID, ReqID, Remarks, UserID) VALUES
('ISS-001', '2024-01-19', 1, 1, 1, 'Issued for production', 1)

-- Material Out Details
INSERT INTO tblMaterialOutDetail (MatOutID, ItemID, Qty) VALUES
(1, 2, 5), (1, 5, 3)

GO
PRINT 'Demo data inserted successfully!'
