require 'spec_helper'

feature "Autosuggest" do
  stub_authorization!

  background do
    visit spree.root_path
  end

  context "listing Suggestions" do
    scenario "should visit spree home page" do
      expect(page).to have_content "No products found"
    end
  end
end
