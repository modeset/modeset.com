require "rubygems"
require "bundler/setup"
require "action_controller/railtie"
require "sprockets/railtie"
require "autoprefixer-rails"

Bundler.require

module Micro
  class Application < Rails::Application
    AutoprefixerRails.install(config.assets)
    config.session_store :cookie_store, :key => "_app_session"
    config.secret_token = "30dd9731a121fb4a3425fb528ffed853"
    config.active_support.deprecation = :log
    config.consider_all_requests_local = true
    config.encoding = "utf-8"
    config.eager_load = false
    config.log_level = :debug

    config.assets.enabled = true
    config.assets.version = "1.0"
    config.assets.debug = true
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
  end
end

class ApplicationController < ActionController::Base
  prepend_view_path Rails.application.root.join('app/views')

  def page
    render template: params[:page] || "index"
  end
  rescue_from ActionView::MissingTemplate do |exception|
    render template: "error"
  end
end

Rails.application.initialize! rescue nil
Rails.application.routes.draw do
  match "/(:page)" => "application#page", via: :get
  get "/how-we-work",    to: redirect("/process")
  get "/share-the-love", to: redirect("/find-us")
  get "/who-we-are",     to: redirect("/team")
  get "/what-we-know",   to: redirect("/")
end

run Micro::Application rescue nil
