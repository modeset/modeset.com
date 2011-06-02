require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'

module App
  class Application < Sinatra::Base

    set :public,  File.join(File.dirname(__FILE__), 'public')
    set :root, File.dirname(__FILE__)

    configure :development do
      register Sinatra::Reloader
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

    get '/sherpa/:name' do
      @page = params[:name]
      haml :"/sherpa/#{@page}", :layout => :"/layouts/layout"
    end

  end
end

