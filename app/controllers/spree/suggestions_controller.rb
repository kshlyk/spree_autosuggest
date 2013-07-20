module Spree
  class SuggestionsController < BaseController
    caches_action :index, cache_path: Proc.new {|c| c.request.url }

    def index
      params['term'] ||= " "
      if Spree::Autosuggest::Config[:search_backend]
        suggestions = Spree::Config[:searcher_class].new(keywords: params['term']).retrieve_products.map(&:name)
        suggestions = Spree::Product.search(name_cont: params['term']).result(distinct: true).map(&:name) if suggestions.blank?
      else
        suggestions = Spree::Suggestion.relevant(params['term']).map(&:keywords)
      end

      if request.xhr?
        render json: suggestions
      else
        render_404
      end
    end
  end
end
