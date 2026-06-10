-- ============================================================
-- RT Billing: Migrate plain-text passwords to SHA-256 hashes
-- Run this ONCE on the database after deploying the new EXE
-- ============================================================
-- SQL Server 2008 does not have a built-in SHA-256 function,
-- so we hash the known default passwords directly here.
-- For any custom passwords you must reset them via the app.

-- Step 1: Hash the default 'admin123' password
--   SHA-256("admin123") = 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
UPDATE tblUsers
SET Password = '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9'
WHERE LoginName = 'admin'
  AND Password = 'admin123';

-- Step 2: For any other users whose passwords are NOT already 64-char hashes,
--         set them to SHA-256("reset123") so they can still log in.
--   SHA-256("reset123") = 2eebf679d102737c877e389ddb099f0abb05514e2a481b2edccb7a50f3845819
UPDATE tblUsers
SET Password = '2eebf679d102737c877e389ddb099f0abb05514e2a481b2edccb7a50f3845819'
WHERE LEN(Password) <> 64;

-- After running this script, any non-admin users must log in with
-- password "reset123" and update it via the Software Users screen.

-- Verify:
SELECT UserID, UserName, LoginName, LEFT(Password,16) AS PassPreview, LEN(Password) AS PassLen
FROM tblUsers
WHERE IsActive = 1;
