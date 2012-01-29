require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # Bundler.require(*Rails.groups(:assets => %w(development test)))
  Bundler.require(:default, Rails.env)
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module ClickInmobiliario
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths << File.join(config.root, "lib")

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    #config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :es

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = false

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    # Generate extensions for all JavaScript files
    js_directory = 'admin/javascripts'
    js_extension = '.js'
    Dir["public/#{js_directory}/**/*#{js_extension}"].each do |filename|
      filename = filename.gsub("public/#{js_directory}/", "").gsub(js_extension, "")
      js_symbol = filename.gsub("/", "_").gsub("\\", "_").to_sym
      config.action_view.javascript_expansions[js_symbol] =
        ["../#{js_directory}/#{filename}#{js_extension}"]
    end

    # Generate extensions for all stylesheets
    css_directory = 'admin/stylesheets'
    css_extension = '.css'
    Dir["public/#{css_directory}/**/*#{css_extension}"].each do |filename|
      filename = filename.gsub("public/#{css_directory}/", "").gsub(css_extension, "")
      css_symbol = filename.gsub("/", "_").gsub("\\", "_").to_sym
      config.action_view.stylesheet_expansions[css_symbol] =
        ["../#{css_directory}/#{filename}#{css_extension}"]
    end

    config.action_view.stylesheet_expansions[:defaults] = [
      'jquery-ui-1.8.7.custom.css',
      'superfish.css',
      'bootstrap.css',
      'application.css',
      'icons.css',
      'layout.css']

    config.action_view.stylesheet_expansions[:datatables] = [
      'jquery-datatables.css']

    config.action_view.stylesheet_expansions[:fancybox] = [
      '../javascripts/jquery-fancybox/style.css']

    config.action_view.stylesheet_expansions[:multiselect] = [
      '../javascripts/jquery-multiselect/css/ui.multiselect.css',
      'jquery-multiselect.css']

    config.action_view.stylesheet_expansions[:combobox] = [
      'jquery-ui-combobox.css']

    config.action_view.stylesheet_expansions[:toggle_box] = [
      'toggle_box.css']

    config.action_view.stylesheet_expansions[:droid_sans_mono_font] = [
      'https://fonts.googleapis.com/css?family=Droid+Sans+Mono']

    config.action_view.stylesheet_expansions[:autosuggest] = [
      'autoSuggest.css']

    config.action_view.stylesheet_expansions[:treeview] = [
      '../javascripts/jquery-treeview/jquery.treeview.css']

    config.action_view.stylesheet_expansions[:formtastic] = [
      'formtastic.css',
      'formtastic-portal.css']

    config.action_view.stylesheet_expansions[:ie6] = [
      'ie6.css']

    config.action_view.stylesheet_expansions[:chosen] = [
      '../javascripts/chosen/chosen/chosen.css']

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = [
      'https://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js',
      'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.7/jquery-ui.min.js',
      'jquery-cookie/jquery.cookie.js',
      'rails.js',
      'superfish.js',
      'application.js']

    config.action_view.javascript_expansions[:dragdrop] = [
      'dragdrop.js',
      'screenshot.js']

    config.action_view.javascript_expansions[:ie_html5] = [
      'https://html5shim.googlecode.com/svn/trunk/html5.js']

    config.action_view.javascript_expansions[:ie_opacity] = [
      'jquery-supersleight.min.js']

    config.action_view.javascript_expansions[:datatables] = [
      'jquery-datatables/media/js/jquery.dataTables.js',
      'jquery-datatables/media/js/jquery.dataTables.fnSetFilteringDelay.js',
      'jquery-datatables/media/js/jquery.dataTables.fnReloadAjax.js']

    config.action_view.javascript_expansions[:fancybox] = [
      'jquery-fancybox/fancybox/jquery.fancybox-1.3.4.pack.js']

    config.action_view.javascript_expansions[:multiselect] = [
      'jquery-tmpl/jquery.tmpl.min.js',
      'jquery-blockui/jquery.blockUI.js',
      'jquery-localisation/jquery.localisation.min.js',
      'jquery-multiselect/js/ui.multiselect.js']

    config.action_view.javascript_expansions[:combobox] = [
      'jquery-ui-combobox.js']

    config.action_view.javascript_expansions[:numberformat] = [
      'jshashtable/hashtable.js',
      'jquery-numberformatter/src/jquery.numberformatter.js']

    config.action_view.javascript_expansions[:date] = [
      'datejs/build/date.js']

    config.action_view.javascript_expansions[:datepicker] = [
      'jquery-ui-datepicker.js']

    config.action_view.javascript_expansions[:google_jsapi] = [
      'https://www.google.com/jsapi']

    config.action_view.javascript_expansions[:dygraphs] = [
      'dygraphs/dygraph-combined.js']

    config.action_view.javascript_expansions[:validation] = [
      'jquery-validation/jquery.validate.min.js']

    config.action_view.javascript_expansions[:rails_validation] = [
      'rails.validations.js']

    config.action_view.javascript_expansions[:qtip] = [
      'jquery-qtip/jquery.qtip-1.0.0-rc3.min.js']

    config.action_view.javascript_expansions[:toggle_box] = [
      'toggle_box.js']

    config.action_view.javascript_expansions[:autosuggest] = [
      'jquery-autosuggest.js']

    config.action_view.javascript_expansions[:treeview] = [
      'jquery-treeview/jquery.treeview.js']

    config.action_view.javascript_expansions[:selectchain] = [
      'jquery-selectchain.js']
      
    config.action_view.javascript_expansions[:protovis] = [
      'protovis-3.2/protovis-r3.2.js']
      
    config.action_view.javascript_expansions[:history] = [
      'history-js/history.js',
      'history-js/history.adapter.jquery.js',
      'history-js/amplify.store.js',
      'history-js/json2.js',
      'jquery.address-1.4.js']

    config.action_view.javascript_expansions[:nicedit] = [
      'nicedit/nicedit.js']
    
    config.action_view.javascript_expansions[:chosen] = [
      'chosen/chosen/chosen.jquery.min.js']
    
  end
end
