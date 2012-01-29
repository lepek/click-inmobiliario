module Datatables
  module Adapters
    class ActiveResource < Datatables::Adapters::Base
      def gather_results(options = {})
        options[:conditions] ||= {}
      
        if self.datatable_limit.present?
          #options[:conditions][:page] = 1 + (self.datatable_offset || 0)
          #options[:conditions][:page_size] = self.datatable_limit 
        end
        
        # Currently only supports one sort by
        if self.datatable_sort_order.present?
          sort_option = self.datatable_sort_order.first
          if sort_option.present?
            options[:conditions][:sort_by] = self.datatable_columns[sort_option[:column]].to_s
            options[:conditions][:sort_dir] = sort_option[:direction]
          end
        end
        
        # Overriding total records
        begin
          self.results = self.model_class.all(:params => options[:conditions])
          self.total_records = self.results.length
        rescue ::ActiveResource::ConnectionError
          self.results = []
          self.total_records = 0
        end
        
        nil
      end
      
      ##
      # Try to get the value for a particular column in the datatable
      #
      # @param [ActiveResource::Base] record The record to get a column for
      # @param [String] column The name of the column      
      # @param [String] missing_value The value to use if no value was present in the column
      # @return [Object] The value of the column for the given record
      # @author jhamilton
      def get_column_value(record, column, missing_value)
        record.send(column) || missing_value
      rescue
        missing_value
      end
      
    protected
    end
  end
end