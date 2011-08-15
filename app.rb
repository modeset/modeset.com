
require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'sass'
require 'dalli'
require 'rack/cache'

module App
  class Application < Sinatra::Base

    set :public,  File.join(File.dirname(__FILE__), 'public')
    set :root, File.dirname(__FILE__)

    configure :development do
      register Sinatra::Reloader
    end

    configure :staging, :production do

      set :cache, Dalli::Client.new

      use Rack::Cache,
        :verbose      => true,
        :metastore    => settings.cache,
        :entitystore  => settings.cache

      before do
        cache_control :public, :max_age => 2 * 60
      end
      
    end

    get '/stylesheets/:name.css' do
      scss :"stylesheets/#{params[:name]}"
    end

    get '/' do
      @page = 'home'
      haml :index, :layout => :"/layouts/layout"
    end

    get '/:name' do
      @page = params[:name]
      haml :"/#{@page}", :layout => :"/layouts/layout"
    end

  end
end

