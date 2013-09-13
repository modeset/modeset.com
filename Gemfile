source 'https://rubygems.org'

gem 'rails', '~> 3.2.14'
gem 'thin'
gem 'redcarpet'
gem 'postmarkdown'
gem 'html-pipeline', require: 'html/pipeline'
gem 'turbolinks'
gem 'navigasmic'

gem 'newrelic_rpm'

group :assets do
  gem 'haml-rails'
  gem 'sass-rails'
  gem 'bourbon'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'modicon'
  gem 'utensils', github: 'modeset/utensils'
end

group :development, :test do
  gem 'pry'
  gem 'teabag'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'ci_reporter'
end

group :production do
  gem 'charlock_holmes', :git => "git://github.com/brianmario/charlock_holmes.git", :branch => "bundle-icu"
end
