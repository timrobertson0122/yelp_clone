class RestaurantsController < ApplicationController

	before_action :authenticate_user!, :except => [:index, :show]

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
		@restaurant = Restaurant.new(restaurant_params.merge(user: current_user))
		if @restaurant.save
			redirect_to restaurants_path
		else
			render 'new'
		end
	end

	def show
		@restaurant = Restaurant.find(params[:id])
	end

	def edit
		@restaurant = Restaurant.find(params[:id])
		if @restaurant.user != current_user
			redirect_to restaurants_path, alert: 'You can only edit a restaurant that you have created'
		end
	end

	def update
		@restaurant = Restaurant.find(params[:id])
		@restaurant.update(restaurant_params)
		flash[:notice] = 'Restaurant edited successfully'
		redirect_to '/restaurants'
	end

	def destroy
		@restaurant = Restaurant.find(params[:id])
		if @restaurant.user != current_user
			redirect_to restaurants_path, alert: 'You can only delete a restaurant that you have created'
		else
			@restaurant.destroy
			flash[:notice] = 'Restaurant deleted successfully'
			redirect_to '/restaurants'
		end
	end
end
