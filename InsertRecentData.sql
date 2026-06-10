-- Insert Recent Demo Data for Dashboard Testing
-- This will insert bills with TODAY's date so dashboard shows data immediately

USE RTBillingDB
GO

-- Get today's date
DECLARE @Today DATE = CAST(GETDATE() AS DATE)
DECLARE @Yesterday DATE = DATEADD(DAY, -1, @Today)
DECLARE @WeekAgo DATE = DATEADD(DAY, -7, @Today)

-- Insert recent bills (last 7 days)
INSERT INTO tblBill (BillNo, BillDate, CustID, AgentID, SubTotal, DiscountAmt, TaxAmt, GrandTotal, PaidAmt, DueAmt, ModeID, Remarks, UserID) 
VALUES
-- Today's bills
('DEMO-TODAY-001', @Today, 1, 1, 5000, 100, 882, 5782, 5782, 0, 1, 'Demo - Today', 1),
('DEMO-TODAY-002', @Today, 2, 1, 3500, 0, 630, 4130, 4130, 0, 5, 'Demo - Today', 1),
('DEMO-TODAY-003', @Today, 3, 2, 2500, 0, 450, 2950, 2950, 0, 2, 'Demo - Today', 1),
('DEMO-TODAY-004', @Today, 1, 1, 8000, 200, 1404, 9204, 9204, 0, 6, 'Demo - Today', 1),

-- Yesterday's bills
('DEMO-YEST-001', @Yesterday, 2, 1, 4200, 0, 756, 4956, 4956, 0, 1, 'Demo - Yesterday', 1),
('DEMO-YEST-002', @Yesterday, 3, 2, 3800, 100, 666, 4366, 4000, 366, 5, 'Demo - Yesterday', 1),

-- Last week bills
('DEMO-WEEK-001', @WeekAgo, 1, 1, 12000, 500, 2070, 13570, 13570, 0, 1, 'Demo - Last Week', 1),
('DEMO-WEEK-002', @WeekAgo, 2, 1, 6500, 0, 1170, 7670, 7670, 0, 2, 'Demo - Last Week', 1)
GO

-- Get the last inserted BillIDs
DECLARE @Bill1 INT = (SELECT BillID FROM tblBill WHERE BillNo = 'DEMO-TODAY-001')
DECLARE @Bill2 INT = (SELECT BillID FROM tblBill WHERE BillNo = 'DEMO-TODAY-002')
DECLARE @Bill3 INT = (SELECT BillID FROM tblBill WHERE BillNo = 'DEMO-TODAY-003')
DECLARE @Bill4 INT = (SELECT BillID FROM tblBill WHERE BillNo = 'DEMO-TODAY-004')
DECLARE @Bill5 INT = (SELECT BillID FROM tblBill WHERE BillNo = 'DEMO-YEST-001')
DECLARE @Bill6 INT = (SELECT BillID FROM tblBill WHERE BillNo = 'DEMO-YEST-002')
DECLARE @Bill7 INT = (SELECT BillID FROM tblBill WHERE BillNo = 'DEMO-WEEK-001')
DECLARE @Bill8 INT = (SELECT BillID FROM tblBill WHERE BillNo = 'DEMO-WEEK-002')

-- Insert bill details
INSERT INTO tblBillDetail (BillID, ItemID, Qty, Rate, DiscPct, TaxPct, TaxAmt, Amount) VALUES
-- Today's bill details
(@Bill1, 1, 1, 42000, 0, 18, 7560, 42000),
(@Bill1, 2, 3, 350, 0, 18, 189, 1050),
(@Bill2, 3, 1, 3500, 0, 18, 630, 3500),
(@Bill3, 4, 5, 280, 0, 18, 252, 1400),
(@Bill3, 5, 1, 650, 0, 18, 117, 650),
(@Bill4, 1, 2, 42000, 0, 18, 15120, 84000),

-- Yesterday's details
(@Bill5, 3, 1, 3500, 0, 18, 630, 3500),
(@Bill5, 2, 2, 350, 0, 18, 126, 700),
(@Bill6, 4, 10, 280, 0, 18, 504, 2800),
(@Bill6, 5, 1, 650, 0, 18, 117, 650),

-- Last week details  
(@Bill7, 1, 3, 42000, 0, 18, 22680, 126000),
(@Bill8, 3, 2, 3500, 0, 18, 1260, 7000)
GO

-- Insert some expenses for the last 7 days
DECLARE @Today2 DATE = CAST(GETDATE() AS DATE)
DECLARE @TwoDaysAgo DATE = DATEADD(DAY, -2, @Today2)
DECLARE @FiveDaysAgo DATE = DATEADD(DAY, -5, @Today2)

INSERT INTO tblExpense (ExpDate, ExpHead, Amount, ModeID, Remarks, UserID) VALUES
(@Today2, 'Electricity', 3500, 1, 'Monthly bill - Demo', 1),
(@Today2, 'Internet', 1200, 2, 'Broadband - Demo', 1),
(@TwoDaysAgo, 'Office Supplies', 2500, 1, 'Stationery - Demo', 1),
(@FiveDaysAgo, 'Transport', 1800, 1, 'Fuel - Demo', 1),
(@FiveDaysAgo, 'Maintenance', 4500, 1, 'AC Repair - Demo', 1)
GO

PRINT '✅ Recent demo data inserted successfully!'
PRINT 'Dashboard should now show data for the last 7 days'
GO
