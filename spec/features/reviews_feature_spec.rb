require 'rails_helper'
require_relative 'helpers/session'
include SessionHelpers

feature 'reviewing' do

	let!(:restaurant) { FactoryGirl.create(:restaurant) }
	let!(:user) { FactoryGirl.create(:user) }

	before do
		login_as(user, :scope => :user)
	end

	scenario 'allows logged in users to leave a review using a form' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so, so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		expect(current_path).to eq "/restaurants"
		expect(page).to have_content("so, so")
	end

	scenario 'allows just one review per user per restaurant' do
		leave_review('so, so', '1')
		leave_review('amazeballs', '5')
		expect(page).to have_content 'You have already reviewed this restaurant'
		expect(page).not_to have_content 'Thoughts'
	end

	scenario 'creator can delete the review' do
		leave_review('so, so', '1')
		visit '/restaurants'
		click_link 'Delete review'
		expect(page).not_to have_content 'so, so'
		expect(page).to have_content 'Review deleted successfully'
	end

	scenario 'non creator cannot delete the review' do
		leave_review('so, so', '1')
		visit '/restaurants'
		click_link 'Sign out'
		sign_in('test2@example.com', 'testtest')
		visit '/restaurants'
		click_link 'Delete review'
		expect(page).to have_content 'You can only delete a review that you have created'
	end

	scenario 'displays an average rating for all reviews' do
		leave_review('So so', '3')
		leave_review('Great', '5')
		expect(page).to have_content('Average rating: 4')
	end
end
