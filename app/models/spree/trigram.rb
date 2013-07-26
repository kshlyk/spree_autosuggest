class Spree::Trigram < ActiveRecord::Base
  include Fuzzily::Model
  # don't think these should be accessible
  attr_accessible :score, :trigram, :owner_type
end
