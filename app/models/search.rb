class Search < ActiveRecord::Base

  def self.log(params)
    self.log_location(params[:location_id]) unless params[:location_id].blank?
    self.log_type(params[:type_id]) unless params[:type_id].blank?
    self.log_operation(params[:operation_id]) unless params[:operation_id].blank?
    self.log_currency(params[:currency_id]) unless params[:currency_id].blank?
    self.log_price(params[:price]) unless params[:price].blank?
  end

  private

    def self.log_location(id)
      location = Location.find(id)
      search = Search.find_by_name_and_value('location', location.name)
      if search.nil?
        self.create(:name=> 'location', :value => location.name, :count => 1)
      else
        search.increment!(:count)
      end
    end

    def self.log_type(id)
      type = Type.find(id)
      search = Search.find_by_name_and_value('type', type.name)
      if search.nil?
        self.create(:name=> 'type', :value => type.name, :count => 1)
      else
        search.increment!(:count)
      end
    end

    def self.log_operation(id)
      operation = Operation.find(id)
      search = Search.find_by_name_and_value('operation', operation.name)
      if search.nil?
        self.create(:name=> 'operation', :value => operation.name, :count => 1)
      else
        search.increment!(:count)
      end
    end

    def self.log_currency(id)
      currency = Currency.find(id)
      search = Search.find_by_name_and_value('currency', currency.name)
      if search.nil?
        self.create(:name=> 'currency', :value => currency.name, :count => 1)
      else
        search.increment!(:count)
      end
    end

    def self.log_price(price)
      self.create(:name=> 'price', :value => price, :count => 1)
    end

end





