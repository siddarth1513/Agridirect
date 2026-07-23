// appium/pages/RegisterPage.js
const BasePage = require('./BasePage');

class RegisterPage extends BasePage {
  constructor() {
    super('Registration Screen', 'register_screen');
    this.elements = {
      emailInput:     { id: 'reg_email_input',       type: 'EditText' },
      passwordInput:  { id: 'reg_password_input',    type: 'EditText' },
      confirmInput:   { id: 'reg_confirm_input',     type: 'EditText' },
      roleBuyer:      { id: 'role_buyer_radio',      type: 'RadioButton' },
      roleFarmer:     { id: 'role_farmer_radio',     type: 'RadioButton' },
      submitButton:   { id: 'register_submit_button',type: 'Button'   },
      validationText: { id: 'validation_error_text', type: 'TextView' },
      backButton:     { id: 'reg_back_button',       type: 'Button'   },
    };
  }
}
module.exports = RegisterPage;
