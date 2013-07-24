# Spree Autosuggest

[![Build Status](https://secure.travis-ci.org/futhr/spree_autosuggest.png?branch=2-0-stable)](http://travis-ci.org/futhr/spree_autosuggest)
[![Dependency Status](https://gemnasium.com/futhr/spree_autosuggest.png)](https://gemnasium.com/futhr/spree_autosuggest)
[![Coverage Status](https://coveralls.io/repos/futhr/spree_autosuggest/badge.png?branch=2-0-stable)](https://coveralls.io/r/futhr/spree_autosuggest)

This extension adds suggestions for product search.

## Installation

Add to your app `Gemfile`:
```ruby
gem 'spree_autosuggest', github: 'futhr/spree_autosuggest', branch: '2-0-stable'
```

Run

    rails g spree_autosuggest:install
    rake spree_autosuggest:seed

to add all Taxon & Product names to the autosuggest database.

## Contributing

In the spirit of [free software][1], **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using prerelease versions
* by reporting [bugs][2]
* by suggesting new features
* by writing [translations][4]
* by writing or editing documentation
* by writing specifications
* by writing code (*no patch is too small*: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues][2]
* by reviewing patches

Starting point:

* Fork the repo
* Clone your repo
* Run `bundle install`
* Run `bundle exec rake test_app` to create the test application in `spec/test_app`
* Make your changes and follow this [Style Guide][5]
* Ensure specs pass by running `bundle exec rspec spec`
* Submit your pull request

Copyright (c) 2013 Aleksey Demidov, released under the [New BSD License][3]

[1]: http://www.fsf.org/licensing/essays/free-sw.html
[2]: https://github.com/futhr/spree_autosuggest/issues
[3]: https://github.com/futhr/spree_autosuggest/blob/2-0-stable/LICENSE.md
[4]: http://www.localeapp.com/projects/4933
[5]: https://github.com/thoughtbot/guides
