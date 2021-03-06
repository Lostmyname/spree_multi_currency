# coding: utf-8

feature 'Order', :js do
  given!(:product) { create(:product) }

  background do
    reset_spree_preferences do |config|
      config.supported_currencies = 'USD,EUR,GBP'
      config.allow_currency_change = true
      config.show_currency_selector = true
    end
    create(:price, variant: product.master, currency: 'EUR', amount: 16.00)
    create(:price, variant: product.master, currency: 'GBP', amount: 23.00)
  end

  context 'when existing in the cart' do
    scenario 'changes its currency, if user switches the currency.' do
      visit spree.product_path(product)
      click_button 'Add To Cart'
      expect(page).to have_content('$19.99')
      select 'EUR', from: 'currency'
      expect(page).to have_content('€16.00')
    end
  end
end
