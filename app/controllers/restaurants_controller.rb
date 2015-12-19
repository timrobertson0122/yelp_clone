class RestaurantsController < ApplicationController

	def restaurant_params
		params.require(:restaurant).permit(:name)
	end

	def index
		@restaurants = Restaurant.all
	end

	def new
		@restaurant = Restaurant.new
	end

	def create
		Restaurant.create(restaurant_params)
		redirect_to '/restaurants'
	end

	def show
		@restaurant = Restaurant.find(params[:id])
	end

end
