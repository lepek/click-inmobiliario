require 'csv'

##
# Controller Mixin for Datatables support
# 
# @author jhamilton
module Datatables
  autoload :Adapters, 'datatables/adapters'
  autoload :Renderers, 'datatables/renderers'
  
  module ControllerMixin
    ##
    # Inject variables and helper methods into the controller that includes it.
    # 
    # @author jhamilton
    def self.included(base)
      base.send :helper, HelperMethods
      base.class_eval do
        include InstanceMethods
        helper HelperMethods
        helper_method :datatable_response
      end
    end

    module InstanceMethods
      ##
      # Generates a JSON response for consumption by a datatable and stores it in the response_body.
      #
      # @param [Class] model_class Model class being used; either ActiveRecord or ActiveResource
      # @param [Array] columns String representation of database column names to return results for
      # @param [Hash] params The current action's request parameters
      # @param [Hash] options Options for displaying the data
      # @option options [String] :missing_value Value to return in place of empty columns, defaults to an empty string
      # @option options [Symbol] :cookie Optional key of the cookie to store sort data in
      # @option options [Symbol] :format Optional key of the format to return
      # @option options [Integer] :id Optional ID to store in the cookie, defaults to -1.
      # @option options [Array<String>] :select Finder select option. ActiveRecord models only.
      # @option options [Hash, Array, String] :conditions Finder conditions option. ActiveRecord or ActiveResource.
      # @option options [Array<String>] :joins Finder joins option. ActiveRecord models only.
      # @option options [Array<String>] :include Finder include option. ActiveRecord models only.
      # @option options [String] :order Finder order option; if provided, overrides info provided by the datatable
      # @option options [String] :filename The name of the file to be created.
      #   CSV format only. Defaults to "export"
      # @option options [String] :filename_append_timestamp Whether or not to include a timestamp in the filename.
      #   CSV format only. Defaults to true
      # @option options [String] :filename_timestamp_format The format of the timestamp in the filename, if present.
      #   CSV format only. Defaults to "%Y%m%d%H%M%s"
      # @param [Block] block Optional block to modify result rows
      # @author jhamilton
      def datatable_response(model_class, columns, params, options = {}, &block)
        # Pick an adapter based on the model
        adapter = self.choose_adapter(model_class, columns)
        
        # Parse the datagrid params
        adapter.parse_datagrid_params(params)
        
        # Save the sort order if desired
        if options[:cookie].present?
          self.save_sort_order_cookie(adapter, options[:cookie], options[:id])
        end
        
        # Get the results
        adapter.gather_results(options)
        
        # Post-process the results
        yield adapter.results if block_given?
        
        # Render the results based on the requested format
        renderer = self.choose_renderer(options[:format])
        renderer.render(self, adapter, options)
      end
      
    protected
      ##
      # Choose an appropriate adapter based on the model class.
      #  Currently supports ActiveRecord and ActiveModel classes.
      #
      # @param [Class] model_class Model class being used
      # @param [Array] columns String representation of database column names to return results for
      # @return [Datatables::Adapters::Base] Datatable adapter
      # @author jhamilton
      def choose_adapter(model_class, columns)
        if model_class.ancestors.include?(ActiveRecord::Base)
          adapter = Datatables::Adapters::ActiveRecord.new(model_class, columns)
        elsif model_class.ancestors.include?(ActiveResource::Base)
          adapter = Datatables::Adapters::ActiveResource.new(model_class, columns)
        else
          message = "#{model_class.name} is not a valid model."
          raise TypeError.new(message)
        end
      end
      
      ##
      # Choose an appropriate renderer for the requested format.
      #  Currently supports CSV and JSON formats. JSON is the default if
      #  an invalid format is provided.
      #
      # @param [Symbol] format The format to output (:csv, :json, etc.)
      # @return [Datatables::Renderers::Base] Datatable renderer
      # @author jhamilton
      def choose_renderer(format)
        case format
        when :csv
          Datatables::Renderers::Csv.new
        else
          # Default to JSON
          Datatables::Renderers::Json.new
        end
      end
      
      ##
      # Saves the datatable sort order in a cookie
      #
      # @param [Symbol] name The name of the cookie to save to
      # @param [Symbol] datatable_id Unique identifier for the datatable
      #   If none is provided, the ID will be set to -1.
      # @author jhamilton
      def save_sort_order_cookie(adapter, name, datatable_id)
        datatable_id ||= -1
        cookies[name] = {
          :id => datatable_id, 
          :sort => adapter.datatable_sort_order
        }.to_json
      end
    end
    
    module HelperMethods
      ##
      # Produces the HTML required for a datatable.
      #
      # @param [String] id The HTML id property of the datatable
      # @param [Array<String>] column_headers Column headers for the resulting table, in order
      # @param [Hash] options Various options for the datatable
      # @option options [Integer] :cellspacing Cellspacing for the table; default 0
      # @option options [Integer] :cellpadding Cellpadding for the table; default 0
      # @option options [String] :class Class to use for the table
      # @param [Block] block Optional block used to fill in the tbody portion of the table
      # @author jhamilton
      def datatable(id, column_headers, options = {}, &block)
        # Build out the table
        table_options = {
          :id => id,
          :cellspacing => (options[:cellspacing] or 0),
          :cellpadding => (options[:cellpadding] or 0)
        }
        table_options[:class] = options[:class] if options[:class]
        
        table = content_tag :table, table_options do
          thead = content_tag :thead do
            headers = ''
            column_headers.each do |column_header|
              headers << content_tag(:th, column_header, nil, false) << "\n"
            end
            raw(content_tag(:tr, headers, nil, false))
          end
          
          # Use the passed in block to fill the body, if there is one
          tbody = content_tag :tbody do
            if block_given?
              raw(capture(&block))
            else
              # Firefox chokes if there isn't at least one row in an empty table
              raw("<tr></tr>")
            end
          end
          
          thead << "\n" << tbody
        end
        concat(table)
        nil
      end
    end
  end
end
