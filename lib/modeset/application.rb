 # $LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'bundler/setup'
require 'action_controller/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups(:assets => %w(development test)))

module Modeset
  class Application < Rails::Application
    config.session_store :cookie_store, :key => '_modeset_app_session'
    config.secret_token = '5df96576e3993124e11fa574f45b0704401b333941e356a414eff39cade37040e81988de770e8e580a63903f3a61c96c019c9ca0283a4c19d49e0967ec9ce6cc'

    config.consider_all_requests_local       = true
    config.encoding                          = 'utf-8'
    config.assets.enabled                    = true
    config.assets.version                    = '1.0'
    config.assets.paths                      << 'app/assets'
    config.assets.compile                    = true
    config.assets.digest                     = false
    config.serve_static_assets               = true
    config.assets.prefix                     = 'assets'
    config.active_support.deprecation        = :log

    if !Rails.env.production?
      config.action_controller.perform_caching  = false
      config.cache_classes                      = false
      config.assets.debug                       = true
      config.assets.compress                    = false
    else
      config.action_controller.perform_caching  = true
      config.cache_classes                      = true
      config.assets.compress                    = true
    end

  end
end


Modeset::Application.initialize!

Modeset::Application.routes.draw do
  # Legacy redirects
  match '/careers' => redirect('/')
  match '/community' => redirect('/share-the-love')
  match '/company' => redirect('/who-we-are')
  match '/knowledge' => redirect('/what-we-know')
  match '/process' => redirect('/how-we-work')
  match '/services' => redirect('/how-we-work')
  # Blog
  postmarkdown :as => 'what-we-know'
  # Pages
  match '*page' => 'pages#show'
  root :to => 'pages#show', :page => 'index'
end

Postmarkdown::Config.options[:layout] = 'pages'
Postmarkdown::Config.options[:posts_per_page] = 1000

class PagesController < ActionController::Base
  def show
    @page = params['page']
    @title = (@page == 'index' ? 'Home' : @page)
    render :action => params['page']
  end
end

