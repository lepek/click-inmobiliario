class ReportsController < ApplicationController

  before_filter :authenticate_user!

  def show
    if params[:id] == 'visits'
      visits_chart
    elsif params[:id] == 'locations'
      locations_chart
    elsif params[:id] == 'publish'
      publish_chart
    end
  end

  private

    def visits_chart
      my_visits = Property.find_all_by_real_estate_id(current_user.real_estate.id).map(&:impressionist_count).sum
      other_visits = Property.all.map(&:impressionist_count).sum - my_visits
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'Inmuebles' )
      data_table.new_column('number', 'Visitas')

      # Add Rows and Values
      data_table.add_rows([
        [current_user.real_estate.name, my_visits ],
        ['Otros', other_visits ]
      ])
      option = { width: 600, height: 360, title: 'Visitas a mis inmuebles', :is3D => true, :colors => ['blue', 'lightblue'] }
      @chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)

      ## TODO: grafico de visitas por mes a mis inmuebles
    end

    def locations_chart
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'Localidad' )
      data_table.new_column('number', 'Inmuebles')

      locations_count = Property.count(:all, :group => 'location_id')
      locations_count.each do |location_id, count|
        data_table.add_row([Location.find(location_id).name, count])
      end

      opts = { :dataMode => 'markers', :region => 'AR' }
      @chart = GoogleVisualr::Interactive::GeoMap.new(data_table, opts)
    end

    def publish_chart
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('date', 'Fecha' )
      data_table.new_column('number', 'Inmuebles')
      data_table.new_column('string', 'title1')
      data_table.new_column('string', 'text1' )
      data_table.new_column('number', 'Inmuebles acumulados' )
      data_table.new_column('string', 'title2')
      data_table.new_column('string', 'text2' )

      properties = Property.count_by("created_at", :group_by => "day").where('real_estate_id = ?', current_user.real_estate.id)
      properties.each do |property|
        properties_acum = Property.where('created_at <= ? AND real_estate_id = ?', property.day, current_user.real_estate.id).count
        data_table.add_row([Date.parse(property.day), property.count_all, '', '', properties_acum, '', ''])
      end

      opts = { :displayAnnotations => false }
      @chart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table, opts)
    end

end
