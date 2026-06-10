// ============================================================
// RT Billing — Google Apps Script
// Steps to deploy:
//   1. Go to https://script.google.com
//   2. Create new project, paste this entire file
//   3. Deploy → New deployment → Web App
//      Execute as: Me | Who has access: Anyone
//   4. Copy the Web App URL → paste into GoogleOrderForm.html APPS_SCRIPT_URL
//   5. Publish Sheet as CSV:
//      Sheet → File → Share → Publish to web → Sheet1 → CSV
//      Copy that CSV URL → paste into RT Billing Google Order Settings
// ============================================================

const SHEET_NAME = "Orders";

function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    const sheet = getOrCreateSheet();
    sheet.appendRow([
      data.Timestamp    || new Date().toISOString(),
      data.CustomerName || "",
      data.Phone        || "",
      data.Items        || "",
      data.Notes        || "",
      data.OrderRef     || "",
      "Pending"
    ]);
    return ContentService
      .createTextOutput(JSON.stringify({ status: "ok" }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ status: "error", msg: err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function doGet(e) {
  return ContentService
    .createTextOutput("RT Billing Order Endpoint is live.")
    .setMimeType(ContentService.MimeType.TEXT);
}

function getOrCreateSheet() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName(SHEET_NAME);
  if (!sheet) {
    sheet = ss.insertSheet(SHEET_NAME);
    sheet.appendRow(["Timestamp", "Customer Name", "Phone", "Items", "Notes", "Order Ref", "Status"]);
    const header = sheet.getRange(1, 1, 1, 7);
    header.setBackground("#1e1e2f");
    header.setFontColor("#ffffff");
    header.setFontWeight("bold");
  }
  return sheet;
}
