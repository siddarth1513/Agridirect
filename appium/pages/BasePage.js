// appium/pages/BasePage.js
// Base Page Object Model for Android – all screen pages extend this
class BasePage {
  constructor(screenName, accessibilityId) {
    this.screenName      = screenName;
    this.accessibilityId = accessibilityId;
    this.elements        = {};
  }

  getElement(name)     { return this.elements[name] || null; }
  hasElement(name)     { return !!this.elements[name]; }
  getScreenName()      { return this.screenName; }
  getAllElements()      { return Object.keys(this.elements); }
}

module.exports = BasePage;
