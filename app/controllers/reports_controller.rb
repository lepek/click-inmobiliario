# encoding: utf-8

class ReportsController < ApplicationController

  before_filter :authenticate_user!
  authorize_resource :class => false
  
  def show
    send "#{params[:id]}_chart"
  #rescue
    #redirect_to root_path and return
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
      @title = 'Comparación de las visitas a los inmuebles'
      option = { width: 600, height: 360, :is3D => true, :colors => ['blue', 'lightblue'] }
      @chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)

    end

    def locations_chart
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'Localidad' )
      data_table.new_column('number', 'Inmuebles')

      locations_count = Property.where('real_estate_id = ?', current_user.real_estate.id).count(:group => 'location_id')
      locations_count.each do |location_id, count|
        data_table.add_row([Location.find(location_id).name, count])
      end
      
      @title = 'Distribución de los inmuebles'
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

      @title = 'Progreso en la publicación de inmuebles'
      opts = { :displayAnnotations => false }
      @chart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table, opts)
    end

    def search_chart
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'Localidad' )
      data_table.new_column('number', 'Búsquedas')
      locations_count = SearchParam.where('name = ?', 'location').count(:group => 'value_str')
      locations_count.each do |location, count|
        data_table.add_row [location, count]
      end
      @title = 'Localidades incluidas en las búsquedas'
      opts = { :dataMode => 'markers', :region => 'AR' }
      @chart = GoogleVisualr::Interactive::GeoMap.new(data_table, opts)
    end

    def price_chart
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'Inmuebles' )
      data_table.new_column('number', 'Precio (en dólares)')

      searches_prices_50000 = Search.joins(:search_params).where('search_params.name = ? AND search_params.value_str = ? AND search_params.value_int <= ?', 'price', 'USD', 50000)
      searches_prices_50000_100000 = Search.joins(:search_params).where('search_params.name = ? AND search_params.value_str = ? AND search_params.value_int BETWEEN ? AND ?', 'price', 'USD', 50000, 100000)
      searches_prices_100000 = Search.joins(:search_params).where('search_params.name = ? AND search_params.value_str = ? AND search_params.value_int >= ?', 'price', 'USD', 100000)

      data_table.add_rows([
        ['Hasta 50.000', searches_prices_50000.count ],
        ['Entre 50.000 y 100.000', searches_prices_50000_100000.count ],
        ['Más de 100.000', searches_prices_100000.count ]
      ])

      @title = 'Precios incluidos en las búsquedas (en dólares)'
      option = { width: 600, height: 360, :is3D => true, :colors => ['blue', 'lightblue', 'darkblue'] }
      @chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)
    end

end
