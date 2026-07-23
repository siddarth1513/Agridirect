import { defineConfig, devices } from '@playwright/test';
import * as dotenv from 'dotenv';
dotenv.config();

export default defineConfig({
  testDir: './tests',
  timeout: 30_000,
  expect: {
    timeout: 5000,
  },
  retries: Number(process.env.RETRIES) || 2,
  workers: Number(process.env.WORKERS) || 4,
  reporter: [
    ['json', { outputFile: 'reports/latest/json/playwright-report.json' }],
    ['html', { outputFolder: 'reports/latest/html' }]
  ],
  use: {
    baseURL: process.env.BASE_URL || 'https://example.com',
    headless: true,
    screenshot: 'only-on-failure',
    trace: 'on-first-retry',
    video: 'retain-on-failure'
  },
  projects: [
    {
      name: 'Chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    // add more browsers if needed
  ],
});
