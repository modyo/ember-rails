require 'ember/handlebars/template'
require 'active_model_serializers'

module Ember
  module Rails
    class Engine < ::Rails::Engine
      config.handlebars = ActiveSupport::OrderedOptions.new

      config.handlebars.precompile = true
      config.handlebars.templates_root = "templates"
      config.handlebars.templates_path_separator = '/'

      initializer "ember_rails.setup", :after => :append_assets_path, :group => :all do |app|
        sprockets = if ::Rails::VERSION::MAJOR == 4
          Sprockets.respond_to?('register_engine') ? Sprockets : app.assets
        else
          app.assets
        end

        app.assets.register_engine '.handlebars', Ember::Handlebars::Template
        app.assets.register_engine '.hbs', Ember::Handlebars::Template
        app.assets.register_engine '.hjs', Ember::Handlebars::Template

        # Add the gem's vendored ember to the end of the asset search path
        variant = app.config.ember.variant

        ember_path = File.expand_path("../../../../vendor/ember/#{variant}", __FILE__)
        app.config.assets.paths.unshift ember_path
      end
    end
  end
end
