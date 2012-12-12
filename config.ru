# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../lib/modeset/application',  __FILE__)
run Modeset::Application

