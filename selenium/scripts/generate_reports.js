// selenium/scripts/generate_reports.js
// ============================================================
// Generates Excel + HTML reports from execution-results.json
// Excel: 7 sheets  (All, Passed, Failed, Skipped, Metrics, Defects, PassRate)
// HTML : professional dashboard-style report
// ============================================================
'use strict';

const fs      = require('fs');
const path    = require('path');
const ExcelJS = require('exceljs');

// ── Paths ─────────────────────────────────────────────────
const ROOT        = path.join(__dirname, '..');
const REPORTS_DIR = path.join(ROOT, 'reports');
const JSON_FILE   = path.join(REPORTS_DIR, 'execution-results.json');

if (!fs.existsSync(JSON_FILE)) {
  console.error('ERROR: execution-results.json not found. Run run_selenium_tests.js first.');
  process.exit(1);
}

const { results, summary } = JSON.parse(fs.readFileSync(JSON_FILE, 'utf-8'));
const passRate = ((summary.passed / summary.total) * 100).toFixed(2);
const duration = (summary.duration / 1000).toFixed(2);
const runDate  = new Date().toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' });

// ── Colour palette (Excel) ─────────────────────────────────
const CLR = {
  headerBg:  '0A3D62',
  headerFg:  'FFFFFF',
  passGreen: 'D4EDDA',
  failRed:   'F8D7DA',
  skyBlue:   'D1ECF1',
  yellow:    'FFF3CD',
  white:     'FFFFFF',
  darkGray:  '343A40',
};

// ── Column definitions ─────────────────────────────────────
const COLS = [
  { header: 'Test ID',          key: 'testId',        width: 18 },
  { header: 'Module',           key: 'module',        width: 22 },
  { header: 'Test Name',        key: 'testName',      width: 60 },
  { header: 'Priority',         key: 'priority',      width: 12 },
  { header: 'Status',           key: 'status',        width: 10 },
  { header: 'Execution Time (ms)', key: 'executionTime', width: 20 },
  { header: 'Timestamp',        key: 'timestamp',     width: 25 },
  { header: 'Preconditions',    key: 'preconditions', width: 35 },
  { header: 'Expected Result',  key: 'expectedResult',width: 45 },
  { header: 'Actual Result',    key: 'actualResult',  width: 45 },
  { header: 'Screenshot',       key: 'screenshot',    width: 35 },
];

function styleHeader(sheet) {
  const row = sheet.getRow(1);
  row.eachCell(cell => {
    cell.font      = { bold: true, color: { argb: CLR.headerFg }, size: 11 };
    cell.fill      = { type: 'pattern', pattern: 'solid', fgColor: { argb: CLR.headerBg } };
    cell.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
    cell.border    = {
      top:    { style: 'thin' },
      left:   { style: 'thin' },
      bottom: { style: 'thin' },
      right:  { style: 'thin' },
    };
  });
  row.height = 22;
  sheet.views = [{ state: 'frozen', ySplit: 1 }];
}

function addDataRows(sheet, rows, bgArgb) {
  rows.forEach((r, idx) => {
    const row = sheet.addRow(r);
    const bg  = idx % 2 === 0 ? bgArgb : CLR.white;
    row.eachCell(cell => {
      cell.fill      = { type: 'pattern', pattern: 'solid', fgColor: { argb: bg } };
      cell.alignment = { vertical: 'middle', wrapText: true };
      cell.border    = {
        top:    { style: 'hair' },
        left:   { style: 'hair' },
        bottom: { style: 'hair' },
        right:  { style: 'hair' },
      };
      // Colour the Status cell specifically
      if (cell._column.key === 'status') {
        const val = cell.value;
        cell.font = {
          bold:  true,
          color: { argb: val === 'PASSED' ? '155724' : val === 'FAILED' ? '721C24' : '856404' },
        };
        cell.fill = {
          type: 'pattern', pattern: 'solid',
          fgColor: { argb: val === 'PASSED' ? CLR.passGreen : val === 'FAILED' ? CLR.failRed : CLR.yellow },
        };
      }
    });
    row.height = 18;
  });
}

// ── Build Excel workbook ───────────────────────────────────
async function generateExcel() {
  const wb = new ExcelJS.Workbook();
  wb.creator  = 'Farmers App QA';
  wb.created  = new Date();
  wb.modified = new Date();

  const passed  = results.filter(r => r.status === 'PASSED');
  const failed  = results.filter(r => r.status === 'FAILED');
  const skipped = results.filter(r => r.status === 'SKIPPED');

  // ── Sheet 1: All Executed ──────────────────────────────
  const shAll = wb.addWorksheet('All Test Cases', { tabColor: { argb: CLR.headerBg } });
  shAll.columns = COLS;
  styleHeader(shAll);
  addDataRows(shAll, results, CLR.skyBlue);

  // ── Sheet 2: Passed ───────────────────────────────────
  const shPass = wb.addWorksheet('Passed', { tabColor: { argb: '155724' } });
  shPass.columns = COLS;
  styleHeader(shPass);
  addDataRows(shPass, passed, CLR.passGreen);

  // ── Sheet 3: Failed ───────────────────────────────────
  const shFail = wb.addWorksheet('Failed', { tabColor: { argb: '721C24' } });
  shFail.columns = COLS;
  styleHeader(shFail);
  addDataRows(shFail, failed, CLR.failRed);

  // ── Sheet 4: Skipped ──────────────────────────────────
  const shSkip = wb.addWorksheet('Skipped', { tabColor: { argb: '856404' } });
  shSkip.columns = COLS;
  styleHeader(shSkip);
  addDataRows(shSkip, skipped, CLR.yellow);

  // ── Sheet 5: Metrics ──────────────────────────────────
  const shMet = wb.addWorksheet('Execution Metrics', { tabColor: { argb: '0A3D62' } });
  shMet.columns = [
    { header: 'Metric', key: 'metric', width: 35 },
    { header: 'Value',  key: 'value',  width: 35 },
  ];
  styleHeader(shMet);

  // Group by module
  const moduleCounts = {};
  results.forEach(r => {
    if (!moduleCounts[r.module]) moduleCounts[r.module] = { passed: 0, failed: 0, total: 0 };
    moduleCounts[r.module].total++;
    if (r.status === 'PASSED') moduleCounts[r.module].passed++;
    else moduleCounts[r.module].failed++;
  });

  const avgDuration = (results.reduce((s, r) => s + r.executionTime, 0) / results.length).toFixed(2);
  const minDur      = Math.min(...results.map(r => r.executionTime));
  const maxDur      = Math.max(...results.map(r => r.executionTime));

  const metricRows = [
    { metric: 'Report Generated',         value: runDate },
    { metric: 'Application Name',         value: 'Farmers App – AgriDirect' },
    { metric: 'Base URL',                 value: process.env.BASE_URL || 'https://siddarth1513.github.io/Agridirect/' },
    { metric: 'Total Test Cases',         value: summary.total },
    { metric: 'Executed',                 value: summary.total },
    { metric: 'Passed',                   value: summary.passed },
    { metric: 'Failed',                   value: summary.failed },
    { metric: 'Skipped',                  value: summary.skipped },
    { metric: 'Pass Rate (%)',            value: `${passRate}%` },
    { metric: 'Total Duration (s)',        value: duration },
    { metric: 'Avg Test Duration (ms)',   value: avgDuration },
    { metric: 'Min Test Duration (ms)',   value: minDur },
    { metric: 'Max Test Duration (ms)',   value: maxDur },
    { metric: 'Browser',                  value: 'Chromium (Headless)' },
    { metric: 'Platform',                 value: 'Web – GitHub Pages' },
    { metric: '--- Module Breakdown ---', value: '' },
    ...Object.entries(moduleCounts).map(([mod, c]) => ({
      metric: `  ${mod}`, value: `Total: ${c.total} | Passed: ${c.passed} | Failed: ${c.failed}`,
    })),
  ];
  addDataRows(shMet, metricRows, CLR.skyBlue);

  // ── Sheet 6: Defect Summary ───────────────────────────
  const shDef = wb.addWorksheet('Defect Summary', { tabColor: { argb: 'DC3545' } });
  shDef.columns = [
    { header: 'Test ID',     key: 'testId',     width: 18 },
    { header: 'Module',      key: 'module',     width: 22 },
    { header: 'Test Name',   key: 'testName',   width: 55 },
    { header: 'Error',       key: 'error',      width: 50 },
    { header: 'Screenshot',  key: 'screenshot', width: 35 },
  ];
  styleHeader(shDef);
  if (failed.length === 0) {
    const row = shDef.addRow({ testId: '–', module: '–', testName: 'No defects found – all tests passed!', error: '–', screenshot: '–' });
    row.getCell('testName').font = { bold: true, color: { argb: '155724' } };
    row.getCell('testName').fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: CLR.passGreen } };
  } else {
    addDataRows(shDef, failed.map(r => ({
      testId: r.testId, module: r.module, testName: r.testName, error: r.error || '–', screenshot: r.screenshot,
    })), CLR.failRed);
  }

  // ── Sheet 7: Pass Rate Summary ────────────────────────
  const shPR = wb.addWorksheet('Pass Rate Summary', { tabColor: { argb: '28A745' } });
  shPR.columns = [
    { header: 'Module',        key: 'module',     width: 28 },
    { header: 'Total',         key: 'total',      width: 12 },
    { header: 'Passed',        key: 'passed',     width: 12 },
    { header: 'Failed',        key: 'failed',     width: 12 },
    { header: 'Pass Rate (%)', key: 'passRate',   width: 16 },
  ];
  styleHeader(shPR);
  const prRows = Object.entries(moduleCounts).map(([mod, c]) => ({
    module:   mod,
    total:    c.total,
    passed:   c.passed,
    failed:   c.failed,
    passRate: `${((c.passed / c.total) * 100).toFixed(1)}%`,
  }));
  // Overall row
  prRows.push({ module: 'OVERALL', total: summary.total, passed: summary.passed, failed: summary.failed, passRate: `${passRate}%` });
  addDataRows(shPR, prRows, CLR.skyBlue);

  // ── Save workbook ─────────────────────────────────────
  const xlsxPath = path.join(REPORTS_DIR, 'Automation_Test_Report.xlsx');
  await wb.xlsx.writeFile(xlsxPath);
  console.log(`  ✓ Excel report → ${xlsxPath}`);
}

// ── Build HTML report ──────────────────────────────────────
function generateHtml() {
  // Module breakdown for charts
  const moduleCounts = {};
  results.forEach(r => {
    if (!moduleCounts[r.module]) moduleCounts[r.module] = 0;
    moduleCounts[r.module]++;
  });
  const moduleLabels = JSON.stringify(Object.keys(moduleCounts));
  const moduleData   = JSON.stringify(Object.values(moduleCounts));

  const testRows = results.map((r, i) => `
    <tr class="${r.status === 'PASSED' ? 'pass-row' : r.status === 'FAILED' ? 'fail-row' : 'skip-row'}">
      <td>${i + 1}</td>
      <td><code>${r.testId}</code></td>
      <td>${r.module}</td>
      <td>${r.testName}</td>
      <td>${r.priority}</td>
      <td><span class="badge badge-${r.status === 'PASSED' ? 'pass' : r.status === 'FAILED' ? 'fail' : 'skip'}">${r.status}</span></td>
      <td>${r.executionTime} ms</td>
    </tr>`).join('');

  const html = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Farmers App – Selenium E2E Execution Report</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet"/>
<style>
  *{box-sizing:border-box;margin:0;padding:0}
  body{font-family:'Inter',sans-serif;background:linear-gradient(135deg,#f0f4ff,#d9e5ff);color:#333;min-height:100vh}
  .header{background:linear-gradient(135deg,#0a3d62,#1a5b8c);color:#fff;padding:2rem;text-align:center}
  .header h1{font-size:2rem;font-weight:700}
  .header p{margin-top:.5rem;opacity:.85;font-size:.95rem}
  .cards{display:flex;flex-wrap:wrap;gap:1rem;padding:2rem;justify-content:center}
  .card{background:rgba(255,255,255,.75);backdrop-filter:blur(10px);border-radius:14px;
        padding:1.5rem 2rem;min-width:160px;text-align:center;
        box-shadow:0 4px 16px rgba(0,0,0,.08);transition:transform .2s}
  .card:hover{transform:translateY(-4px)}
  .card .num{font-size:2.5rem;font-weight:700}
  .card .lbl{font-size:.85rem;color:#666;margin-top:.25rem}
  .num-total{color:#0a3d62}
  .num-pass{color:#28a745}
  .num-fail{color:#dc3545}
  .num-skip{color:#ffc107}
  .num-rate{color:#17a2b8}
  .section{padding:0 2rem 2rem}
  .section h2{font-size:1.2rem;font-weight:700;color:#0a3d62;margin-bottom:1rem;
              border-left:4px solid #0a3d62;padding-left:.75rem}
  table{width:100%;border-collapse:collapse;background:#fff;border-radius:10px;
        overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.07);font-size:.85rem}
  thead th{background:#0a3d62;color:#fff;padding:.75rem .6rem;text-align:left;font-weight:600}
  tbody tr:nth-child(even){background:#f8f9ff}
  tbody td{padding:.6rem .6rem;border-bottom:1px solid #eee}
  .pass-row td:first-child{border-left:3px solid #28a745}
  .fail-row td:first-child{border-left:3px solid #dc3545}
  .skip-row td:first-child{border-left:3px solid #ffc107}
  .badge{display:inline-block;padding:.2rem .6rem;border-radius:20px;font-size:.75rem;font-weight:700}
  .badge-pass{background:#d4edda;color:#155724}
  .badge-fail{background:#f8d7da;color:#721c24}
  .badge-skip{background:#fff3cd;color:#856404}
  code{background:#e9ecef;padding:.15rem .4rem;border-radius:4px;font-size:.8rem}
  .chart-wrap{background:rgba(255,255,255,.75);backdrop-filter:blur(10px);
              border-radius:14px;padding:1.5rem;box-shadow:0 4px 16px rgba(0,0,0,.08);max-width:600px}
  .summary-info{background:rgba(255,255,255,.7);backdrop-filter:blur(6px);border-radius:12px;
                padding:1rem 1.5rem;display:inline-block;margin-bottom:1rem;font-size:.9rem}
  footer{text-align:center;padding:2rem;color:#666;font-size:.8rem}
</style>
</head>
<body>
<div class="header">
  <h1>🌾 Farmers App – Selenium E2E Test Report</h1>
  <p>Application: <strong>AgriDirect</strong> &nbsp;|&nbsp; URL: <strong>${process.env.BASE_URL || 'https://siddarth1513.github.io/Agridirect/'}</strong></p>
  <p>Generated: <strong>${runDate}</strong> &nbsp;|&nbsp; Total Duration: <strong>${duration}s</strong></p>
</div>

<!-- Summary Cards -->
<div class="cards">
  <div class="card"><div class="num num-total">${summary.total}</div><div class="lbl">Total Tests</div></div>
  <div class="card"><div class="num num-pass">${summary.passed}</div><div class="lbl">Passed ✓</div></div>
  <div class="card"><div class="num num-fail">${summary.failed}</div><div class="lbl">Failed ✗</div></div>
  <div class="card"><div class="num num-skip">${summary.skipped}</div><div class="lbl">Skipped</div></div>
  <div class="card"><div class="num num-rate">${passRate}%</div><div class="lbl">Pass Rate</div></div>
  <div class="card"><div class="num num-total">${duration}s</div><div class="lbl">Duration</div></div>
</div>

<!-- Module Chart -->
<div class="section">
  <h2>Module Distribution</h2>
  <div class="chart-wrap">
    <canvas id="moduleChart"></canvas>
  </div>
</div>

<!-- Test Results Table -->
<div class="section">
  <h2>All Test Cases (300)</h2>
  <div class="summary-info">
    Browser: Chromium (Headless) &nbsp;|&nbsp; Platform: Web – GitHub Pages &nbsp;|&nbsp; Framework: Node.js Selenium Suite
  </div>
  <table>
    <thead>
      <tr>
        <th>#</th><th>Test ID</th><th>Module</th><th>Test Name</th>
        <th>Priority</th><th>Status</th><th>Time</th>
      </tr>
    </thead>
    <tbody>
      ${testRows}
    </tbody>
  </table>
</div>

<footer>
  Farmers App QA – Selenium E2E Report &copy; ${new Date().getFullYear()}
</footer>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
const ctx = document.getElementById('moduleChart').getContext('2d');
new Chart(ctx, {
  type: 'bar',
  data: {
    labels: ${moduleLabels},
    datasets: [{
      label: 'Test Cases',
      data: ${moduleData},
      backgroundColor: [
        '#0a3d62','#1a5b8c','#28a745','#17a2b8',
        '#ffc107','#fd7e14','#6f42c1','#e83e8c',
        '#20c997','#dc3545'
      ],
      borderRadius: 6,
    }]
  },
  options: {
    responsive: true,
    plugins: { legend: { display: false } },
    scales: { y: { beginAtZero: true, ticks: { stepSize: 10 } } }
  }
});
</script>
</body>
</html>`;

  const htmlPath = path.join(REPORTS_DIR, 'execution-report.html');
  fs.writeFileSync(htmlPath, html);
  console.log(`  ✓ HTML report → ${htmlPath}`);
}

// ── Entry ──────────────────────────────────────────────────
(async () => {
  fs.mkdirSync(REPORTS_DIR, { recursive: true });
  console.log('\n  Generating reports …\n');
  await generateExcel();
  generateHtml();
  console.log('\n  ✅ All reports generated successfully!\n');
})();
