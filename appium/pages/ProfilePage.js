// appium/pages/ProfilePage.js
const BasePage = require('./BasePage');

class ProfilePage extends BasePage {
  constructor() {
    super('Profile Screen', 'profile_screen');
    this.elements = {
      nameField:     { id: 'profile_name_input',    type: 'EditText' },
      phoneField:    { id: 'profile_phone_input',   type: 'EditText' },
      addressField:  { id: 'profile_address_input', type: 'EditText' },
      ratingStars:   { id: 'profile_rating_stars',  type: 'RatingBar' },
      saveButton:    { id: 'profile_save_button',   type: 'Button'   },
      avatarImage:   { id: 'profile_avatar',        type: 'ImageView'},
      editAvatarBtn: { id: 'edit_avatar_button',    type: 'Button'   },
      roleLabel:     { id: 'profile_role_label',    type: 'TextView' },
    };
  }
}
module.exports = ProfilePage;
