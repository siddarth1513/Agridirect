// appium/pages/FarmerHomePage.js
const BasePage = require('./BasePage');

class FarmerHomePage extends BasePage {
  constructor() {
    super('Farmer Home Screen', 'farmer_home_screen');
    this.elements = {
      addListingBtn:  { id: 'add_listing_button',   type: 'FloatingButton' },
      myListingsList: { id: 'my_listings_list',     type: 'RecyclerView'   },
      earningsCard:   { id: 'earnings_card',        type: 'CardView'       },
      analyticsBtn:   { id: 'analytics_button',     type: 'Button'         },
      editProfileBtn: { id: 'edit_profile_button',  type: 'Button'         },
      imageUploader:  { id: 'image_uploader_widget',type: 'ImageView'      },
      locationWidget: { id: 'location_coordinates', type: 'TextView'       },
      reviewsList:    { id: 'farmer_reviews_list',  type: 'RecyclerView'   },
    };
  }
}
module.exports = FarmerHomePage;
