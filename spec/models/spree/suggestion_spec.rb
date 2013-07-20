require 'spec_helper'

describe Spree::Suggestion do
  it { should validate_presence_of :keywords }

  context "relevant" do

    it "search product_suggestion by their properties" do
      create(:product, name: "apache baseball cap")
      create(:product, name: "apache baseball cap2")
      create(:product, name: "zomg shirt")
      create_suggestions
      Spree::Suggestion.relevant('cap').should == []
end
end
end
