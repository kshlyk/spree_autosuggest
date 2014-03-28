namespace :spree_autosuggest do
  task seed: :environment do
    # all taxons with more than two words
    Spree::Taxon.find(:all, conditions: ["parent_id IS NOT ? AND parent_id <> ?", nil, 1]).each do |taxon|
      searcher = Spree::Config.searcher_class.new({:taxon => taxon.id})
      query = Spree::Suggestion.find_or_initialize_by_keywords(taxon.name)
      query.keywords = taxon.name # keep the case of keywords same with current
      query.items_found = searcher.retrieve_products.size
      query.count = Spree::Autosuggest::Config[:min_count] + 1
      query.data = {url: "/t/#{taxon.permalink}"}.to_s
      query.save
    end

    # all active and available product names
    Spree::Product.active.available.each do |product|
      query = Spree::Suggestion.find_or_initialize_by_keywords(product.name)
      query.keywords = product.name # keep the case of keywords same with current
      query.items_found = 1
      query.count = Spree::Autosuggest::Config[:min_count] + 1
      query.data = {url: "/products/#{product.permalink}"}.to_s
      query.save
    end

    require 'net/http'
    require 'uri'

    Spree::Suggestion.all.each do |s|
      if !s.data.blank? && eval(s.data).has_key?(:url)
        url = URI.parse("http://" + Spree::Config[:site_url] + eval(s.data)[:url])
        full_path = (url.query.blank?) ? url.path : "#{url.path}?#{url.query}"
        puts url
        req = Net::HTTP::Get.new(full_path)

        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
        puts res.code
        s.destroy if res.code != '200'
      end
    end
  end
end
