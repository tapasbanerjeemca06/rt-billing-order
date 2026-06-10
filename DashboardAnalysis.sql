-- Dashboard Analytics Query Tests
-- Run this to verify all dashboard data is populated correctly
-- Database: RTBillingDB | Server: DESKTOP-GA5623V

USE RTBillingDB
GO

PRINT '========================================='
PRINT '    DASHBOARD KPI METRICS'
PRINT '========================================='
PRINT ''

-- 1. Total Sales
PRINT '1. TOTAL SALES (All Time):'
SELECT 
    COUNT(*) AS [Total Bills],
    CAST(SUM(GrandTotal) AS DECIMAL(18,2)) AS [Total Sales Amount],
    CAST(SUM(PaidAmt) AS DECIMAL(18,2)) AS [Total Paid],
    CAST(SUM(DueAmt) AS DECIMAL(18,2)) AS [Total Due]
FROM tblBill
PRINT ''

-- 2. Total Expenses
PRINT '2. TOTAL EXPENSES:'
SELECT 
    COUNT(*) AS [Total Expense Entries],
    CAST(SUM(Amount) AS DECIMAL(18,2)) AS [Total Expense Amount]
FROM tblExpense
PRINT ''

-- 3. Pending Dues
PRINT '3. PENDING DUES DETAILS:'
SELECT 
    c.CustName AS [Customer],
    b.BillNo AS [Bill No],
    b.BillDate AS [Date],
    CAST(b.GrandTotal AS DECIMAL(18,2)) AS [Bill Amount],
    CAST(b.PaidAmt AS DECIMAL(18,2)) AS [Paid],
    CAST(b.DueAmt AS DECIMAL(18,2)) AS [Due Amount]
FROM tblBill b
LEFT JOIN tblCustomer c ON b.CustID = c.CustID
WHERE b.DueAmt > 0
ORDER BY b.DueAmt DESC
PRINT ''

-- 4. Stock Value
PRINT '4. CURRENT STOCK VALUE:'
SELECT 
    i.ItemName,
    ISNULL(SUM(si.Qty), 0) - ISNULL(SUM(so.Qty), 0) AS [Current Stock],
    CAST(i.SalePrice AS DECIMAL(18,2)) AS [Sale Price],
    CAST((ISNULL(SUM(si.Qty), 0) - ISNULL(SUM(so.Qty), 0)) * i.SalePrice AS DECIMAL(18,2)) AS [Stock Value]
FROM tblItem i
LEFT JOIN tblStockIn si ON i.ItemID = si.ItemID
LEFT JOIN tblStockOut so ON i.ItemID = so.ItemID
GROUP BY i.ItemName, i.SalePrice
HAVING ISNULL(SUM(si.Qty), 0) - ISNULL(SUM(so.Qty), 0) > 0
ORDER BY (ISNULL(SUM(si.Qty), 0) - ISNULL(SUM(so.Qty), 0)) * i.SalePrice DESC
PRINT ''

-- Summary totals
SELECT 
    CAST(SUM((ISNULL(si.Qty, 0) - ISNULL(so.Qty, 0)) * i.SalePrice) AS DECIMAL(18,2)) AS [Total Stock Value]
FROM tblItem i
LEFT JOIN (SELECT ItemID, SUM(Qty) AS Qty FROM tblStockIn GROUP BY ItemID) si ON i.ItemID = si.ItemID
LEFT JOIN (SELECT ItemID, SUM(Qty) AS Qty FROM tblStockOut GROUP BY ItemID) so ON i.ItemID = so.ItemID
PRINT ''

PRINT '========================================='
PRINT '    SALES OVERVIEW (MONTHLY)'
PRINT '========================================='
PRINT ''

SELECT 
    CONVERT(VARCHAR(7), BillDate, 120) AS [Month],
    COUNT(*) AS [Bills],
    CAST(SUM(GrandTotal) AS DECIMAL(18,2)) AS [Total Sales]
FROM tblBill
GROUP BY CONVERT(VARCHAR(7), BillDate, 120)
ORDER BY CONVERT(VARCHAR(7), BillDate, 120)
PRINT ''

PRINT '========================================='
PRINT '    TOP 10 ITEMS BY SALES'
PRINT '========================================='
PRINT ''

SELECT TOP 10
    i.ItemName,
    CAST(SUM(bd.Qty) AS DECIMAL(18,2)) AS [Qty Sold],
    CAST(SUM(bd.Amount) AS DECIMAL(18,2)) AS [Revenue]
FROM tblBillDetail bd
INNER JOIN tblItem i ON bd.ItemID = i.ItemID
INNER JOIN tblBill b ON bd.BillID = b.BillID
GROUP BY i.ItemName
ORDER BY SUM(bd.Amount) DESC
PRINT ''

PRINT '========================================='
PRINT '    AGENT PERFORMANCE'
PRINT '========================================='
PRINT ''

SELECT 
    a.AgentName,
    COUNT(b.BillID) AS [Total Bills],
    CAST(ISNULL(SUM(b.GrandTotal), 0) AS DECIMAL(18,2)) AS [Total Sales],
    CAST(ISNULL(a.CommissionPct, 0) AS DECIMAL(5,2)) AS [Commission %],
    CAST(ISNULL(SUM(b.GrandTotal) * a.CommissionPct / 100, 0) AS DECIMAL(18,2)) AS [Commission Amount]
FROM tblAgent a
LEFT JOIN tblBill b ON a.AgentID = b.AgentID
GROUP BY a.AgentName, a.CommissionPct
ORDER BY ISNULL(SUM(b.GrandTotal), 0) DESC
PRINT ''

PRINT '========================================='
PRINT '    FINANCIAL SUMMARY'
PRINT '========================================='
PRINT ''

DECLARE @TotalSales DECIMAL(18,2)
DECLARE @TotalExp DECIMAL(18,2)
DECLARE @Profit DECIMAL(18,2)

SELECT @TotalSales = ISNULL(SUM(GrandTotal), 0) FROM tblBill
SELECT @TotalExp = ISNULL(SUM(Amount), 0) FROM tblExpense
SET @Profit = @TotalSales - @TotalExp

SELECT 
    CAST(@TotalSales AS DECIMAL(18,2)) AS [Total Sales],
    CAST(@TotalExp AS DECIMAL(18,2)) AS [Total Expenses],
    CAST(@Profit AS DECIMAL(18,2)) AS [Net Profit],
    CAST((@Profit / NULLIF(@TotalSales, 0) * 100) AS DECIMAL(5,2)) AS [Profit Margin %]
PRINT ''

PRINT '========================================='
PRINT '    EXPENSE BREAKDOWN'
PRINT '========================================='
PRINT ''

SELECT 
    ExpHead AS [Expense Category],
    COUNT(*) AS [Count],
    CAST(SUM(Amount) AS DECIMAL(18,2)) AS [Total Amount]
FROM tblExpense
GROUP BY ExpHead
ORDER BY SUM(Amount) DESC
PRINT ''

PRINT '========================================='
PRINT '    CUSTOMER SUMMARY'
PRINT '========================================='
PRINT ''

SELECT TOP 10
    c.CustName AS [Customer],
    COUNT(b.BillID) AS [Total Bills],
    CAST(ISNULL(SUM(b.GrandTotal), 0) AS DECIMAL(18,2)) AS [Total Purchase],
    CAST(ISNULL(SUM(b.DueAmt), 0) AS DECIMAL(18,2)) AS [Pending Dues]
FROM tblCustomer c
LEFT JOIN tblBill b ON c.CustID = b.CustID
GROUP BY c.CustName
ORDER BY ISNULL(SUM(b.GrandTotal), 0) DESC
PRINT ''

PRINT '========================================='
PRINT '    INVENTORY STATUS'
PRINT '========================================='
PRINT ''

SELECT 
    i.ItemName,
    ISNULL(SUM(si.Qty), 0) AS [Stock In],
    ISNULL(SUM(so.Qty), 0) AS [Stock Out],
    ISNULL(SUM(si.Qty), 0) - ISNULL(SUM(so.Qty), 0) AS [Current Stock],
    i.ReorderQty AS [Reorder Level],
    CASE 
        WHEN (ISNULL(SUM(si.Qty), 0) - ISNULL(SUM(so.Qty), 0)) <= i.ReorderQty THEN 'LOW STOCK'
        ELSE 'OK'
    END AS [Status]
FROM tblItem i
LEFT JOIN tblStockIn si ON i.ItemID = si.ItemID
LEFT JOIN tblStockOut so ON i.ItemID = so.ItemID
GROUP BY i.ItemName, i.ReorderQty
ORDER BY [Current Stock] ASC
PRINT ''

PRINT '========================================='
PRINT '    RECENT TRANSACTIONS (Last 10)'
PRINT '========================================='
PRINT ''

SELECT TOP 10
    b.BillNo,
    b.BillDate,
    c.CustName AS [Customer],
    CAST(b.GrandTotal AS DECIMAL(18,2)) AS [Amount],
    CASE 
        WHEN b.DueAmt > 0 THEN 'PARTIAL'
        ELSE 'PAID'
    END AS [Status]
FROM tblBill b
LEFT JOIN tblCustomer c ON b.CustID = c.CustID
ORDER BY b.BillDate DESC, b.CreatedOn DESC

PRINT ''
PRINT '========================================='
PRINT 'Dashboard data analysis complete!'
PRINT '========================================='
GO
