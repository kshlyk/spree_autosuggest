require 'spec_helper'

feature "Admin Suggestions" do
  stub_authorization!

  background do
    visit spree.admin_path
  end

  context "listing suggestions" do
    background do
      create(:product, name: "apache baseball cap", sku: "A001")
      create(:product, name: "zomg shirt", sku: "B001")
      create_suggestions
      click_link "Suggestion"
    end

    scenario "list suggestions with correct sorting by Keywords" do
      # display suggestions in desc order
      page.should have_css("table#listing_suggestions tr", count: 3)
      within("table#listing_suggestions") do
        page.should have_content(Spree::Suggestion.all.last.keywords)
        page.should have_content(Spree::Suggestion.all.first.keywords)
      end
    end

    scenario "display a destroy link for each suggestion" do
      page.find_link ("Destroy")["/admin/suggestion/" + (Spree::Suggestion.all.last.id).to_s]
      page.find_link ("Destroy")["/admin/suggestion/" + (Spree::Suggestion.all.first.id).to_s]
    end
  end

  context "as admin user" do
    background do
      create(:product, name: "apache baseball cap", sku: "A001")
      create(:product, name: "zomg shirt", sku: "B001")
      create_suggestions
      click_link "Suggestion"
    end

    scenario "have suggestion Tab in admin pannel" do
      page.should have_content("Suggestions")
    end

    scenario "have a link to suggestions in admin pannel" do
      page.find_link("Suggestion")["/admin/suggestions"]
    end
  end

  context "search Suggestions" do
    background do
      create(:product, name: "apache baseball cap", sku: "A100")
      create(:product, name: "apache baseball cap2", sku: "B100")
      create(:product, name: "zomg shirt")
      create_suggestions
      click_link "Suggestion"
    end

    scenario "search product_suggestion by their properties" do
      fill_in "q_keywords_cont", with: "ca"
      click_button "Search"
      page.should have_content("apache baseball cap")
      page.should have_content("apache baseball cap2")
      page.should_not have_content("zomg shirt")
    end
  end
end
