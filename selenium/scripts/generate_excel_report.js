// scripts/generate_excel_report.js
const fs = require('fs');
const path = require('path');
const ExcelJS = require('exceljs');

const reportJsonPath = path.resolve(__dirname, '..', 'reports', 'latest', 'json', 'playwright-report.json');
if (!fs.existsSync(reportJsonPath)) {
  console.error('Playwright JSON report not found at', reportJsonPath);
  process.exit(1);
}

const report = JSON.parse(fs.readFileSync(reportJsonPath, 'utf-8'));
const tests = report.tests || [];

// Helper to count outcomes
const counts = tests.reduce((acc, t) => {
  const outcome = t.outcome;
  acc[outcome] = (acc[outcome] || 0) + 1;
  return acc;
}, {});

const workbook = new ExcelJS.Workbook();

// Sheet: Executed Test Cases
const executedSheet = workbook.addWorksheet('Executed');
executedSheet.columns = [
  { header: 'Test ID', key: 'testId', width: 15 },
  { header: 'Page', key: 'page', width: 20 },
  { header: 'Element ID', key: 'elementId', width: 20 },
  { header: 'Expected Text', key: 'expected', width: 30 },
  { header: 'Status', key: 'status', width: 12 },
  { header: 'Duration (ms)', key: 'duration', width: 15 }
];

tests.forEach(t => {
  const title = t.title || '';
  const testId = title.split(' ')[0]; // assuming first token is test id
  const outcome = t.outcome === 'expected' ? 'Passed' : (t.outcome === 'failed' ? 'Failed' : 'Skipped');
  const duration = t.duration !== undefined ? t.duration : '';
  // Retrieve data from annotations if present (not available in plain JSON). Use placeholder values.
  executedSheet.addRow({
    testId,
    page: t.location?.file ? path.basename(t.location.file) : '',
    elementId: '',
    expected: '',
    status: outcome,
    duration
  });
});

// Sheet: Passed
const passedSheet = workbook.addWorksheet('Passed');
passedSheet.columns = executedSheet.columns;
executedSheet.eachRow((row, rowNumber) => {
  if (row.getCell('status').value === 'Passed') {
    passedSheet.addRow(row.values.slice(1)); // slice removes first empty element
  }
});

// Sheet: Failed
const failedSheet = workbook.addWorksheet('Failed');
failedSheet.columns = executedSheet.columns;
executedSheet.eachRow((row, rowNumber) => {
  if (row.getCell('status').value === 'Failed') {
    failedSheet.addRow(row.values.slice(1));
  }
});

// Sheet: Skipped
const skippedSheet = workbook.addWorksheet('Skipped');
skippedSheet.columns = executedSheet.columns;
executedSheet.eachRow((row, rowNumber) => {
  if (row.getCell('status').value === 'Skipped') {
    skippedSheet.addRow(row.values.slice(1));
  }
});

// Sheet: Metrics
const metricsSheet = workbook.addWorksheet('Metrics');
metricsSheet.addRow(['Total Tests', tests.length]);
metricsSheet.addRow(['Passed', counts['expected'] || 0]);
metricsSheet.addRow(['Failed', counts['failed'] || 0]);
metricsSheet.addRow(['Skipped', counts['skipped'] || 0]);
const passRate = tests.length ? ((counts['expected'] || 0) / tests.length) * 100 : 0;
metricsSheet.addRow(['Pass Rate (%)', passRate.toFixed(2)]);

// Sheet: Defect Summary (placeholder – will be empty if no failures)
const defectSheet = workbook.addWorksheet('Defect Summary');
defectSheet.columns = [
  { header: 'Test ID', key: 'testId', width: 15 },
  { header: 'Error Message', key: 'error', width: 50 }
];
failedSheet.eachRow((row, rowNumber) => {
  // Placeholder error info – real error can be extracted from report.errors if needed
  defectSheet.addRow({ testId: row.getCell('testId').value, error: 'Assertion failed or element not found' });
});

// Sheet: Pass Rate Summary
const passRateSheet = workbook.addWorksheet('Pass Rate Summary');
passRateSheet.addRow(['Pass Rate', `${passRate.toFixed(2)}%`]);

// Write workbook
const outDir = path.resolve(__dirname, '..', 'reports', 'latest', 'excel');
fs.mkdirSync(outDir, { recursive: true });
const outPath = path.join(outDir, 'Automation_Test_Report.xlsx');
workbook.xlsx.writeFile(outPath).then(() => {
  console.log('Excel report generated at', outPath);
}).catch(err => {
  console.error('Failed to write Excel report', err);
  process.exit(1);
});
