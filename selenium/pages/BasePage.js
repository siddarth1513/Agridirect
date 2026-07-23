// pages/BasePage.js
// Base Page Object Model - all page objects inherit from this
class BasePage {
  constructor(pageName, url) {
    this.pageName = pageName;
    this.url = url;
    this.elements = {};
  }

  getElement(name) {
    return this.elements[name] || null;
  }

  hasElement(name) {
    return !!this.elements[name];
  }

  getTitle() {
    return this.pageName;
  }

  getUrl() {
    return this.url;
  }

  getAllElements() {
    return Object.keys(this.elements);
  }
}

module.exports = BasePage;
