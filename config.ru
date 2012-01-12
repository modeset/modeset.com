require 'rubygems'
require 'bundler'
Bundler.setup
require './app'

$stdout.sync = true

if ENV['RACK_ENV'].to_s == 'production'
  require 'rack/rewrite'
  puts 'REWRITES: [ enabled ]' 
  use Rack::Rewrite do
    r301 %r{.*}, 'http://modeset.com$&', :if => lambda { |rack_env| rack_env['SERVER_NAME'] != 'modeset.com' }
  end
else
  puts "REWRITES: [ disabled ] (env is #{ENV['RACK_ENV']})"
end

run App::Application
