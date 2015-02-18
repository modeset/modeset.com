source 'https://rubygems.org'

ruby '2.1.5' if respond_to?(:ruby)

gem 'rails', '~> 3.2.14'
gem 'puma'
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
  gem 'foreman'
  gem 'pry'
  gem 'teabag'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'ci_reporter'
end

group :production do
  gem 'charlock_holmes', github: 'tooky/charlock_holmes', branch: 'bundle-icu'
end
