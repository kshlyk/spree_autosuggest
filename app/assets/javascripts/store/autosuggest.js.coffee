class @Autosuggest
  constructor: (selector, options = {}) ->
    @search_field = $(selector)
    return if @search_field.length == 0

    @settings =
      to_display: 5
      strict_cache: false
    @settings = $.extend @settings, options

    @cache = {}

    $.extend true, $.ui.autocomplete::, @extension_methods()
    @search_field.autocomplete(
      @settings,
      source: (request, response) =>
        @finder(request, response)
      select: (event, ui) =>
        if ui.item.store_url is ''
          location.href = ui.item.url
        else
          location.href = ui.item.store_url + ui.item.url
      focus: (event, ui) =>
        ui.item.value = ui.item.product_name
      )

  finder: (request, response) ->
    term = request.term.toLowerCase()
    cached = @from_cache(term)
    return response cached if cached
    $.getJSON "/suggestions", request, (data) =>
      @cache[term] = data
      response @from_cache(term)

  from_cache: (term) ->
    result = false
    $.each @cache, (key, data) =>
      if (if @settings.strict_cache then term is key else term.indexOf(key) is 0)
        result = @filter_terms(data, term).slice(0, @settings.to_display)
    result

  filter_terms: (array, term) ->
      matcher = new RegExp("\\b" + $.ui.autocomplete.escapeRegex(term), "i")
      $.grep array, (value) =>
        source = value.keywords or value.value or value
        return true if matcher.test(source)

  extension_methods: ->
    _renderItem: (ul, item) ->
        if item.url is ""
          item.url = '/search?utf8=✓&keywords='+item.keywords
        item.keywords = item.keywords.replace(new RegExp("(" + $.ui.autocomplete.escapeRegex(@term) + ")", "gi"), "<strong>$1</strong>")

        if item.suggestion_type is "hidden_tags"
          keywords = item.product_name
          css_class = 'suggested'
        else
          keywords = item.keywords
          css_class = ''

        if item.image_url is ''
          thumbnail = ''
        else
          thumbnail = "<div class='store-image " + item.store_name + "'><img src='" + item.image_url + "'></div>"

        if item.store_identifier is ''
          store_identifier = ''
        else
          store_identifier = "<span class='store'>" + item.store_identifier + "</span>"

        if item.store_url is ''
          $("<li class='autosuggest'></li>").addClass(item.store_name).addClass(css_class).data("item.autocomplete", item).append("<a href=" + item.url + ">" + thumbnail + "<span class='title " + item.store_name + "'>" + keywords + "</h5>" + "<span class='price'>" + item.price + "</span>" + store_identifier + "</a>").appendTo ul
        else
          $("<li class='autosuggest'></li>").addClass(item.store_name).addClass(css_class).data("item.autocomplete", item).append("<a href=" + item.store_url + item.url + ">" + thumbnail + "<span class='title " + item.store_name + "'>" + keywords + "</h5>" + "<span class='price'>" + item.price + "</span>" + store_identifier + "</a>").appendTo ul
