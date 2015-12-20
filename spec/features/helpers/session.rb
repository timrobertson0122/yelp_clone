module SessionHelpers

	def sign_in(email, password)
		User.create(email: email, password: password)
		visit '/users/sign_in'
		fill_in 'Email', with: email
		fill_in 'Password', with: password
		click_button 'Log in'
	end

end
