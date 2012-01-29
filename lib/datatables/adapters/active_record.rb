module Datatables
  module Adapters
    class ActiveRecord < Datatables::Adapters::Base
      def gather_results(options = {})
        options[:additional_where] = self.where_clause
      
        # Get all of the records
        self.results = self.model_class.where(
          options[:additional_where]
        ).all(
          :select => options[:select] || [],
          :conditions => options[:conditions] || {},
          :joins => options[:joins] || [],
          :include => options[:include] || [],
          :order => options[:order] || self.order_clause || '',
          :offset => self.datatable_offset || 0,
          :limit => self.datatable_limit || nil,
          :group => options[:group] || nil
        )
        
        # Calculate the total number of records from the unfiltered set
        self.total_records = self.model_class.where(
          options[:additional_where]
        ).count(
          :conditions => options[:conditions] || [],
          :joins => options[:joins] || []
        )
        
        nil
      end
      
      ##
      # Try to get the value for a particular column in the datatable
      #
      # @param [ActiveRecord::Base] record The record to get a column for
      # @param [String] column The name of the column      
      # @param [String] missing_value The value to use if no value was present in the column
      # @return [Object] The value of the column for the given record
      # @author jhamilton
      def get_column_value(record, column, missing_value)
        if column.present?
          column = column.gsub(self.model_class.table_name + '.', '')
          begin
            value = record.instance_eval(column)
          rescue NameError
            # Try the singular version of the name
            # Need to figure out some other kind of work-around here, since
            # table names won't necessarily equate to relationship names...
            column_parts = column.split '.'
            if column_parts.length > 1
              value = record.instance_eval("#{column_parts[0].singularize}.#{column_parts[1]}")
            else
              raise $!
            end
          end
        else
          # The column doesn't exist, so store a blank
          value = missing_value
        end
        
        # Return the value we found
        value
      end
      
    protected
      ##
      # Generate an order clause based on the datatble's sort order
      #
      # @return [String] A string order clause
      # @author jhamilton
      def order_clause
        clause = ''
        self.datatable_sort_order.each_with_index do |option, i|
          clause << ', ' unless i == 0
          clause << "#{self.datatable_columns[option[:column]]} #{option[:direction]}"
        end
        return nil if clause.empty?
        clause
      end
    
      def where_clause
        # Grab the model's connection for quoting purposes
        connection = self.model_class.connection
      
        # Generate the search condition as one giant OR clause across all searchable columns
        complete_where_clause = []
        if self.datatable_search.present?
          search_string = connection.quote("%#{self.datatable_search}%")
          
          unless self.datatable_searchable_columns.empty?
            clauses = []
            self.datatable_searchable_columns.each do |column|
              column = '"' + self.model_class.table_name + '".' + self.datatable_columns[column]
              clauses << "(#{column} LIKE #{search_string} ESCAPE '!')"
            end
            complete_where_clause << "(#{clauses.join(" OR ")})"
          end
        end
        
        # Generate individual column search/filtering conditions
        # Append each one as an extra condition
        unless self.datatable_filters.empty?
          self.datatable_filters.each do |column, filter|
            filter_string = connection.quote("%#{filter}%")
            clause = "(#{self.datatable_columns[column]} LIKE #{filter_string} ESCAPE '!')"
            complete_where_clause << clause
          end
        end
        
        # Stringify me, cap'n!
        if complete_where_clause.empty?
          complete_where_clause = "1 = 1"
        else
          complete_where_clause = complete_where_clause.join(" AND ")
        end
        
        complete_where_clause
      end
    end
  end
end
