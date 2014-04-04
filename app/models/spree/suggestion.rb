class Spree::Suggestion < ActiveRecord::Base
  validates :keywords, presence: true
  belongs_to :product

  scope :has_data, -> { where ["data IS NOT ?", nil] }

  def self.relevant(term)
    config = Spree::Autosuggest::Config
    select('*').
      where("count >= ?", config.min_count).
      where("items_found != 0").
      where("keywords LIKE ? OR keywords LIKE ?", term + '%', term + '%').
      order("(#{config.count_weight}*count + #{config.items_found_weight}*items_found) DESC").
      limit(config.rows_from_db)
  end
end
