require 'spec_helper'

describe User, type: :model do

	it { should have_many(:restaurants).dependent(:destroy) }
	it { should have_many(:reviews).dependent(:destroy) }
	it { should have_many :reviewed_restaurants }

end
