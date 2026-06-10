-- Add UPI ID column to tblCompany
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('tblCompany') AND name='UpiID')
    ALTER TABLE tblCompany ADD UpiID NVARCHAR(100) NULL
GO
