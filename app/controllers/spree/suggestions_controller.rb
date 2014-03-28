module Spree
  class SuggestionsController < BaseController
    caches_action :index, cache_path: Proc.new {|c| c.request.url }

    def index
      params['term'] ||= " "
      if Spree::Autosuggest::Config[:search_backend]
        suggestions = Spree::Config[:searcher_class].new(keywords: params['term']).retrieve_products
        suggestions = Spree::Product.search(name_cont: params['term']).result(distinct: true) if suggestions.blank?
        suggestions.collect!{|p| {:keywords => p.name, :url => !p.permalink.blank? ? p.permalink : ""}}
      else
        suggestions = Spree::Suggestion.relevant(params['term'])
        suggestions.collect!{|s| {:keywords => s.keywords, :url => !s.data.blank? && eval(s.data).has_key?(:url) ? eval(s.data)[:url] : ""}}
      end

      if request.xhr?
        render json: suggestions
      else
        render_404
      end
    end
  end
end
