module Datatables
  module Adapters
    class Base
      # Model class being represented
      attr_accessor :model_class
      
      # Result set, obtained via #gather_results
      attr_accessor :results
      
      # Total records available, calculated in #gather_results
      attr_accessor :total_records
      
      # Datatable-related attributes
      attr_accessor :datatable_echo
      attr_accessor :datatable_offset
      attr_accessor :datatable_limit
      attr_accessor :datatable_sort_order
      attr_accessor :datatable_columns
      attr_accessor :datatable_headers
      attr_accessor :datatable_search
      attr_accessor :datatable_searchable_columns
      attr_accessor :datatable_filters
      
      ##
      # Create a new instance of the adapter
      # 
      # @author jhamilton
      def self.new(model_class, columns)
        adapter = super
        adapter.model_class = model_class
        adapter.datatable_columns = columns
        adapter
      end
      
      ##
      # Method for gathering all the results and calculating the total records
      # 
      # @author jhamilton
      def gather_results(options = {})
        nil
      end
      
      ##
      # Method for extracting the value of a column from a record
      #
      # @author jhamilton
      def column_value(record, column, missing_value)
        missing_value
      end
      
      ##
      # Process the parameters passed in from the AJAX request.
      #
      # @param [Hash] params Current action's request params; holds datatable specific parameters 
      # @author jhamilton
      def parse_datagrid_params(params)
        # Echo parameter; should always be cast as an int
        if params[:sEcho].present?
          self.datatable_echo = params[:sEcho].to_i
        end
        
        # Start position
        if params[:iDisplayStart].present?
          self.datatable_offset = params[:iDisplayStart].to_i
        end
        
        # Number of records to display
        if params[:iDisplayLength].present?
          self.datatable_limit = params[:iDisplayLength].to_i
        end
        
        # Get the search parameter
        if params[:sSearch].present? && params[:sSearch] != ""
          self.datatable_search = params[:sSearch].strip.gsub("!", "!!").gsub("%", "!%").gsub("_", "!_")
        end
        
        # Get the search parameter for each column
        self.datatable_filters = {}
        self.datatable_searchable_columns = []
        num_columns = params[:iColumns].to_i
        num_columns.times do |i|
          if params["bSearchable_#{i}"].present?
            searchable = (params["bSearchable_#{i}"].downcase == "true")
            if searchable
              # Mark the column as searchable
              self.datatable_searchable_columns << i
              
              # Add the individual column filter, if there is one
              # Expand escaping to include all special characters for LIKE clauses
              column_filter = params["sSearch_#{i}"].strip.gsub("!", "!!").gsub("%", "!%").gsub("_", "!_")
              self.datatable_filters[i] = column_filter if column_filter.present?
            end
          end
        end
        
        # Current sort order
        self.datatable_sort_order = []
        if params[:iSortingCols].present?
          num_columns_to_sort = params[:iSortingCols].to_i
          num_columns_to_sort.times do |i|
            sort_col = params["iSortCol_#{i}".to_sym].to_i
            sort_dir = params["sSortDir_#{i}".to_sym]
            self.datatable_sort_order << {:column => sort_col, :direction => sort_dir}
          end
        end
      end
    end
  end
end