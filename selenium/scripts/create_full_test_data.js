// scripts/create_full_test_data.js
const fs = require('fs');
const path = require('path');

const pages = [
  { page: 'index.html', elements: [
    { id: 'section-1', text: 'Welcome' },
    { id: 'section-2', text: 'Features' },
    { id: 'section-3', text: 'Get Started' }
  ]},
  { page: 'about.html', elements: [
    { id: 'about-section', text: 'About Us' }
  ]},
  { page: 'contact.html', elements: [
    { id: 'contact-section', text: 'Contact Us' }
  ]},
  { page: 'dashboard.html', elements: [
    { id: 'dashboard-section', text: 'Dashboard' }
  ]}
];

const total = 300;
let rows = [];
let counter = 1;
while (rows.length < total) {
  for (const p of pages) {
    for (const el of p.elements) {
      if (rows.length >= total) break;
      const testId = `TC_${String(counter).padStart(3, '0')}`;
      rows.push({ test_id: testId, page: p.page, element_id: el.id, expected_text: el.text });
      counter++;
    }
  }
}

const csvHeader = 'test_id,page,element_id,expected_text\n';
const csvLines = rows.map(r => `${r.test_id},${r.page},${r.element_id},${r.expected_text}`).join('\n');
const csvContent = csvHeader + csvLines + '\n';
const csvPath = path.join(__dirname, '..', 'data', 'test-data.csv');
fs.writeFileSync(csvPath, csvContent, 'utf-8');
console.log(`Generated ${rows.length} test rows to ${csvPath}`);
