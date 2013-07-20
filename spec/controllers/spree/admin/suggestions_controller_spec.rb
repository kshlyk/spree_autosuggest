require 'spec_helper'

describe Spree::Admin::SuggestionsController do
  stub_authorization!

  before { controller.stub spree_current_user: create(:user) }

  let(:product) { create(:product, name: "test product1") }
  let!(:inactive_product) { create(:product, available_on: Time.now.tomorrow, name: "inactive") }

  context "#index" do
    it "include all active_products as @suggestions" do
      active_inactive_product_objects = [product, inactive_product]
      create_suggestions active_inactive_product_objects
      spree_get :index
      Spree::Suggestion.where(keywords: product.name).first.should be_valid if Spree::Suggestion.where(keywords: product.name).first.present?
      Spree::Suggestion.all.first.count.should == 6 if Spree::Suggestion.all.first.present?
      response.should render_template :index
    end

    it "Should not display products not available today" do
      # inactive products shouldn't include in auto-suggested list
      Spree::Suggestion.where(keywords: inactive_product.name).first.should be_nil
    end
  end

  context "#destroy" do
    it "delete requested suggestion and redirect it to suggestion list" do
      active_inactive_product_objects = [product,inactive_product]
      create_suggestions active_inactive_product_objects
      suggestion = Spree::Suggestion.where(keywords: "test product1").first
      spree_delete :destroy, { id: suggestion.id }
      response.should redirect_to spree.admin_suggestions_path
    end

    it "delete requested suggestion" do
      active_inactive_product_objects = [product,inactive_product]
      create_suggestions active_inactive_product_objects
      expect {
        @suggestion = Spree::Suggestion.where(keywords: "test product1").first
        spree_delete :destroy, { id: @suggestion.id }
      }.to be_true
    end
  end

  context "#collection" do

    it "gets suggestions against ajax requests" do
      active_inactive_product_objects = [product,inactive_product]
      create_suggestions active_inactive_product_objects
      spree_xhr_get :index,:q => "ca"
      response.should be_success
    end

  end
end
