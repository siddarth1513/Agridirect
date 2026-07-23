// appium/config/config.js
// Centralized configuration for Appium E2E Test Suite
module.exports = {
  APP_NAME:        'Farmers App – AgriDirect (Android)',
  APP_VERSION:     '1.0.0',
  PLATFORM:        'Android',
  PLATFORM_NAME:   'Android',
  AUTOMATION_NAME: 'UiAutomator2',
  DEVICE_NAME:     'Android Emulator',
  APP_PACKAGE:     'com.example.farmers_app',
  APP_ACTIVITY:    '.MainActivity',
  ANDROID_VERSION: '13 (API 33)',
  APPIUM_HOST:     'localhost',
  APPIUM_PORT:     4723,
  TIMEOUT:         30000,
  NEW_COMMAND_TIMEOUT: 300,
  RETRY_COUNT:     2,
  REPORT_DIR:      'reports',
  SCREENSHOT_DIR:  'reports/screenshots',
  LOG_DIR:         'logs'
};
