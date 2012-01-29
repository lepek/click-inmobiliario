module Datatables
  module Renderers
    class Csv < Datatables::Renderers::Base
      def render(controller, adapter, options = {})
        options[:filename] ||= "export"
        
        timestamp = ""
        if options[:filename_append_timestamp].nil? || options[:filename_append_timestamp]
          options[:filename_timestamp_format] ||= "%Y%m%d%H%M%s"
          timestamp = "_#{Time.now.strftime(options[:filename_timestamp_format])}"
        end
        
        filename = "#{options[:filename]}#{timestamp}.csv"
        controller.headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 

        results = CSV::generate do |csv|
          csv << adapter.datatable_headers
          records.each_with_index do |record, index|
            row_data = []
            self.datatable_columns.each do |column|
              row_data << adapter.get_column_value(record, column, options[:missing_value])
            end
            csv << row_data
          end
        end
        
        controller.render(:text => results)
      end
    end
  end
end
