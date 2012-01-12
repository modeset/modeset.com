require 'rubygems'
require 'bundler'
Bundler.setup
require './app'

if ENV['RACK_ENV'] == 'production'
  require 'rack/rewrite'
  puts 'REWRITES: [ enabled ]' 
  use Rack::Rewrite do
    r301 %r{.*}, 'http://modeset.com$&', :if => lambda { |rack_env| rack_env['SERVER_NAME'] != 'modeset.com' }
  end
else
  puts 'REWRITES: [ disabled ]' 
end

run App::Application
