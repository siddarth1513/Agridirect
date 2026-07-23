// scripts/generate_tests.js
const fs = require('fs');
const path = require('path');
const csvPath = path.join(__dirname, '..', 'data', 'test-data.csv');
const testsDir = path.join(__dirname, '..', 'tests');
if (!fs.existsSync(testsDir)) fs.mkdirSync(testsDir, { recursive: true });
const csv = fs.readFileSync(csvPath, 'utf-8').trim().split('\n');
const header = csv[0].split(',');
for (let i = 1; i < csv.length; i++) {
  const row = csv[i].split(',');
  const record = {};
  header.forEach((h, idx) => record[h] = row[idx]);
  const testFileName = `${record.test_id}.spec.ts`;
  const testFilePath = path.join(testsDir, testFileName);
  const content = `import { test, expect } from '@playwright/test';

test('${record.test_id} - ${record.expected_text}', async ({ page }) => {
  await page.goto(process.env.BASE_URL + '${record.page.startsWith('/') ? '' : '/'}${record.page}');
  const locator = page.locator('#${record.element_id}');
  await expect(locator).toHaveText('${record.expected_text}');
});
`;
  fs.writeFileSync(testFilePath, content, 'utf-8');
}
console.log(`Generated ${csv.length - 1} test files in ${testsDir}`);
