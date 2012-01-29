module Datatables
  module Renderers
    class Json < Datatables::Renderers::Base
      def render(controller, adapter, options = {})
        # Total before filtering
        results = {}
        results[:iTotalRecords] = adapter.total_records
        
        # Total after filtering
        results[:iTotalDisplayRecords] = adapter.total_records
        
        # Unaltered copy of the sEcho variable passed from the client
        # Casted to an integer to avoid potential XSS
        results[:sEcho] = adapter.datatable_echo
        
        # Optional; allows you to re-define the columns being returned
        # Not supporting this until someone has an actual use case for it
        #results[:sColumns] = []
        
        # Actual data as a 2D array
        results[:aaData] = []
        adapter.results.each_with_index do |record, index|
          row_data = []
          adapter.datatable_columns.each do |column|
            row_data << adapter.get_column_value(record, column, options[:missing_value])
          end
          # Add the record to the result set
          results[:aaData] << row_data
        end
        
        controller.render(:text => results.to_json)
      end
    end
  end
end
