require 'spec_helper'

feature "Autosuggest" do
  stub_authorization!
  background do
    visit '/'
  end
  context "listing Suggestions" do
    scenario "  it should visit spree home page" do
      page.should have_content('No products found')
    end
  end
end
