require 'spec_helper'

describe Spree::SuggestionsController do
  stub_authorization!

  before { controller.stub spree_current_user: nil }

  let(:product) { create(:product, name: "test product1") }
  let(:params) { params = {'term' => 'cap'} }

  before("visiting ") do
    Spree::Autosuggest::Config[:search_backend] = false
  end

  context "#index when prefrence is false" do
    it "respond with a 200" do
     visit "/suggestions"
     response.response_code.should == 200
    end

    it "response to ajax response and render json as response" do
      spree_xhr_get :index
      response.header['Content-Type'].should include 'application/json'
    end
  end
end
