Spree::BaseController.class_eval do
  after_filter :save_search

  def save_search
    keywords = @searcher.try :keywords

    if @products.present? and keywords.present?
      query = Spree::Suggestion.find_or_initialize_by_keywords(keywords.downcase)

      query.items_found = @products.size
      if query.count
        query.increment(:count)
      else
        query.count = 1
      end
      query.save
      session[:keywords] = keywords
    end
  end
end