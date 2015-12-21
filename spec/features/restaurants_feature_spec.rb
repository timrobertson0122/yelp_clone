require 'rails_helper'
require_relative 'helpers/session'
include SessionHelpers

feature 'restaurants' do

	let(:user) { FactoryGirl.create(:user) }

	context 'no restaurants have been added' do
		scenario 'should display a prompt to add a restaurant' do
			visit '/restaurants'
			expect(page).to have_content 'No restaurants yet'
			expect(page).to have_link 'Add a restaurant'
		end
	end

	context 'restaurants have been added' do
		before { Restaurant.create(name: 'Tortilla') }

		scenario 'display restaurants' do
			visit '/restaurants'
			expect(page).to have_content 'Tortilla'
			expect(page).not_to have_content 'No restaurants yet'
		end
	end

	context 'creating restaurants' do

		scenario 'prevents a non logged in user from creating restaurants' do
			visit '/restaurants'
			click_link 'Add a restaurant'
			expect(page).to have_content 'Log in'
			expect(page).not_to have_content 'Create Restaurant'
		end

		scenario 'prompts a logged in user to fill out a form, then displays a new restaurant' do
			login_as(user, :scope => :user)
			visit '/restaurants'
			click_link 'Add a restaurant'
			fill_in 'Name', with: 'KFC'
			click_button 'Create Restaurant'
			expect(page).to have_content 'KFC'
			expect(current_path).to eq '/restaurants'
		end

		context 'an invalid restaurant' do
			it 'does not let you submit a name that is too short' do
				login_as(user, :scope => :user)
				visit '/restaurants'
				click_link 'Add a restaurant'
				fill_in 'Name', with: 'Kf'
				click_button 'Create Restaurant'
				expect(page).not_to have_css 'h2', text: 'kf'
				expect(page).to have_content 'error'
			end
		end
	end

	context 'viewing restaurants' do

		let(:kfc){ FactoryGirl.create(:restaurant) }
		before { kfc }

		scenario 'lets a user view a restaurant' do
			visit '/restaurants'
			click_link 'KFC'
			expect(page).to have_content 'KFC'
			expect(current_path).to eq "/restaurants/#{kfc.id}"
		end
	end

	context 'user making changes to restaurants' do

		before do
      user = FactoryGirl.create(:user)
			FactoryGirl.create(:restaurant)
		end

		scenario 'prevents a non logged in user from editing restaurants' do
			visit '/restaurants'
			click_link 'Edit KFC'
			expect(page).to have_content 'Log in'
			expect(page).not_to have_content 'Update Restaurant'
		end

		scenario 'prevents non-creator from editing a restaurant' do
			another_user = FactoryGirl.create(:user)
			login_as(another_user, :scope => :user)
			visit '/restaurants'
			click_link 'Edit KFC'
			expect(page).to have_content 'KFC'
			expect(page).to have_content 'You can only edit a restaurant that you have created'
		end

		scenario 'lets creator edit a restaurant' do
			login_as(user, :scope => :user)
			create_restaurant('Trade')
			visit '/restaurants'
			click_link 'Edit Trade'
			fill_in 'Name', with: 'Trade Made'
			click_button 'Update Restaurant'
			expect(page).to have_content 'Trade Made'
			expect(page).to have_content 'Restaurant edited successfully'
			expect(current_path).to eq '/restaurants'
		end

		scenario 'prevents a non logged in user from deleting restaurants' do
			visit '/restaurants'
			click_link 'Delete KFC'
			expect(page).to have_content 'Log in'
			expect(page).not_to have_content 'Restaurant deleted successfully'
		end

		scenario 'prevents non-creator from deleting a restaurant' do
			another_user = FactoryGirl.create(:user)
			login_as(another_user, :scope => :user)
			visit '/restaurants'
			click_link 'Delete KFC'
			expect(page).to have_content 'KFC'
			expect(page).to have_content 'You can only delete a restaurant that you have created'
		end

		scenario 'removes a restaurant when creator clicks a delete link' do
			login_as(user, :scope => :user)
			create_restaurant('Trade')
			visit '/restaurants'
			click_link 'Delete Trade'
			expect(page).not_to have_content 'Trade'
			expect(page).to have_content 'Restaurant deleted successfully'
		end
	end
end
