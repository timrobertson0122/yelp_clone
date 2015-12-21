class ReviewsController < ApplicationController

	before_action :authenticate_user!, :except => [:index, :show]

	def review_params
		params.require(:review).permit(:thoughts, :rating)
	end

	def new
		@restaurant = Restaurant.find(params[:restaurant_id])
		@review = Review.new
	end

	def create
		@restaurant = Restaurant.find(params[:restaurant_id])
		@review = @restaurant.reviews.build(review_params.merge(user: current_user))

		if @review.save
			redirect_to restaurants_path
		else
			if @review.errors[:user]
				redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
			else
				render :new
			end
		end
	end

	def destroy
		@review = Review.find(params[:id])
		if @review.user != current_user
			redirect_to restaurants_path, alert: 'You can only delete a review that you have created'
		else
			@review.destroy
			flash[:notice] = 'Review deleted successfully'
			redirect_to '/restaurants'
		end
	end

end
