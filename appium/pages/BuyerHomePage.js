// appium/pages/BuyerHomePage.js
const BasePage = require('./BasePage');

class BuyerHomePage extends BasePage {
  constructor() {
    super('Buyer Home Screen', 'buyer_home_screen');
    this.elements = {
      searchBar:      { id: 'buyer_search_bar',    type: 'EditText'   },
      farmsGrid:      { id: 'farms_grid',          type: 'RecyclerView'},
      filterSlider:   { id: 'distance_filter',     type: 'SeekBar'    },
      categoryFilter: { id: 'category_filter',     type: 'Spinner'    },
      ratingCard:     { id: 'farm_rating_card',    type: 'CardView'   },
      cartIcon:       { id: 'cart_icon',           type: 'ImageView'  },
      cartBadge:      { id: 'cart_badge_count',    type: 'TextView'   },
      wishlistBtn:    { id: 'wishlist_button',     type: 'Button'     },
      sortOptions:    { id: 'buyer_sort_options',  type: 'Spinner'    },
    };
  }
}
module.exports = BuyerHomePage;
