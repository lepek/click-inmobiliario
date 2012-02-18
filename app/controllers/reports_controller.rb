class ReportsController < ApplicationController

  before_filter :authenticate_user!

  def show
    if params[:id] == 'visits'
      visits_chart
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
      option = { width: 600, height: 360, title: 'Visitas a mis inmuebles', :is3D => true }
      @chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)
    end

end
