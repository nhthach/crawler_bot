source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"
gem "rails", "~> 6.1.3", ">= 6.1.3.2"

gem "bootsnap", ">= 1.4.4", require: false
gem "config"
gem "dotenv-rails", require: "dotenv/rails-now"
gem 'httparty'
gem 'fastimage'
gem "puma", "~> 5.0"
gem "sass-rails", ">= 6"
gem "webpacker", github: "rails/webpacker", ref: 'b6c2180'
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "mysql2"
gem "nokogiri"
gem "ruby-readability", :require => 'readability'
gem "redis"
gem "redis-namespace"
gem "redis-rails"
gem "redis-rack-cache"
gem "slim-rails"
gem 'sidekiq'

# Use Active Storage variant
# gem "image_processing", "~> 1.2"

# Reduces boot times through caching; required in config/boot.rb


group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "factory_bot_rails"
  gem "faker"
  gem "rails-controller-testing"
  gem "rspec"
  gem "rspec-collection_matchers"
  gem "rspec-rails", "~> 4.0.2"
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

group :test do
  gem "brakeman", require: false
  gem "shoulda-matchers", "> 4.0.0"
  gem "simplecov"
  gem "simplecov-json"
  # gem "rspec_junit_formatter"

  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
