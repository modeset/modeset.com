require "rubygems"
require "bundler/setup"
require "action_controller/railtie"
require "sprockets/railtie"

Bundler.require

module Micro
  class Application < Rails::Application
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
  end
end

class ApplicationController < ActionController::Base
  prepend_view_path Rails.application.root.join('app/views')

  def page
    render template: params[:page] || "index"
  end
end

Rails.application.initialize! rescue nil
Rails.application.routes.draw do
  match "/(:page)" => "application#page", via: :get
end

run Micro::Application rescue nil
