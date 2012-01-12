require 'rubygems'
require 'bundler'
Bundler.setup
require './app'

if ENV['RACK_ENV'] == 'production'
  require 'rack/rewrite'
  puts 'Enabling rewrites'
  use Rack::Rewrite do
    r301 %r{.*}, 'http://modeset.com$&', :if => lambda { |rack_env| rack_env['SERVER_NAME'] != 'modeset.com' }
  end
end  

run App::Application
