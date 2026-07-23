// appium/pages/LoginPage.js
const BasePage = require('./BasePage');

class LoginPage extends BasePage {
  constructor() {
    super('Login Screen', 'login_screen');
    this.elements = {
      emailInput:    { id: 'email_input',      type: 'EditText' },
      passwordInput: { id: 'password_input',   type: 'EditText' },
      loginButton:   { id: 'login_button',     type: 'Button'   },
      registerLink:  { id: 'go_to_register',   type: 'TextView' },
      forgotPassLink:{ id: 'forgot_password',  type: 'TextView' },
      errorLabel:    { id: 'login_error_text', type: 'TextView' },
    };
  }
}
module.exports = LoginPage;
