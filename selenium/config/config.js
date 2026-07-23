// config/config.js
// Centralized configuration for Selenium E2E Test Suite
module.exports = {
  BASE_URL: process.env.BASE_URL || 'https://siddarth1513.github.io/Agridirect/',
  APP_NAME: 'Farmers App - AgriDirect',
  APP_VERSION: '1.0.0',
  PLATFORM: 'Web',
  BROWSER: 'Headless Chrome',
  TIMEOUT: 30000,
  RETRY_COUNT: 2,
  WORKERS: 4,
  REPORT_DIR: 'reports',
  SCREENSHOT_DIR: 'reports/screenshots',
  LOG_DIR: 'logs'
};
