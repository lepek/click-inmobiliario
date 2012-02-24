class Search < ActiveRecord::Base

  has_many :search_params
  belongs_to :user

  def self.log(params, user)
    @search = Search.new
    @search.user = user
    @search.search_params << SearchParam.create(:name=> 'location', :value_str => Location.find(params[:location_id]).name) unless params[:location_id].blank?
    @search.search_params << SearchParam.create(:name=> 'type', :value_str => Type.find(params[:type_id]).name) unless params[:type_id].blank?
    @search.search_params << SearchParam.create(:name=> 'operation', :value_str => Operation.find(params[:operation_id]).name) unless params[:operation_id].blank?
    @search.search_params << SearchParam.create(:name=> 'price', :value_str => Currency.find(params[:currency_id]).code, :value_int => params[:price].to_i) unless params[:price].blank? || params[:currency_id].blank?
    @search.save
  end

end





