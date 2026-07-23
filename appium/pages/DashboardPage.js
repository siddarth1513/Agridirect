// appium/pages/DashboardPage.js
const BasePage = require('./BasePage');

class DashboardPage extends BasePage {
  constructor() {
    super('Dashboard Screen', 'dashboard_screen');
    this.elements = {
      welcomeText:   { id: 'dashboard_welcome',    type: 'TextView' },
      navHome:       { id: 'nav_home',             type: 'BottomNav' },
      navSearch:     { id: 'nav_search',           type: 'BottomNav' },
      navProfile:    { id: 'nav_profile',          type: 'BottomNav' },
      navOrders:     { id: 'nav_orders',           type: 'BottomNav' },
      listingsGrid:  { id: 'listings_grid',        type: 'RecyclerView' },
      filterButton:  { id: 'filter_button',        type: 'Button' },
      searchBar:     { id: 'dashboard_search_bar', type: 'EditText' },
      sortDropdown:  { id: 'sort_dropdown',        type: 'Spinner' },
      logoutButton:  { id: 'logout_button',        type: 'Button' },
    };
  }
}
module.exports = DashboardPage;
