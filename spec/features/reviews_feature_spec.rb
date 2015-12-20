require 'rails_helper'
require_relative 'helpers/session'
include SessionHelpers

feature 'reviewing' do
	before {Restaurant.create name: 'KFC'}

	scenario 'allows logged in users to leave a review using a form' do
		sign_in('test@example.com', 'testtest')
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so, so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		expect(current_path).to eq "/restaurants"
		expect(page).to have_content("so, so")
	end

	scenario 'prevents non logged in users from leaving a review' do
		visit '/restaurants'
		click_link 'Review KFC'
		expect(page).to have_content 'Log in'
		expect(page).not_to have_content 'Thoughts'
	end

	scenario 'allows just one review per user per restaurant' do
		sign_in('test@example.com', 'testtest')
		leave_review('so, so', '1')
		leave_review('amazeballs', '5')
		expect(page).to have_content 'You have already reviewed this restaurant'
		expect(page).not_to have_content 'Thoughts'
	end

	scenario 'only creator can delete the review' do
		sign_in('test@example.com', 'testtest')
		leave_review('so, so', '1')
		visit '/restaurants'
		click_link 'Delete review'
		expect(page).not_to have_content 'so, so'
		expect(page).tp have_content 'Review deleted successfully'
	end
end
