require 'spec_helper'

describe "Pages" do

	let(:base_title) { "TASC" }

	subject { page }

	describe "Home page" do
		before { visit root_path }

		it { should have_content('TASC') }
		it { should have_title(full_title('')) }
	end

	describe "Help page" do
		before { visit help_path }

		it { should have_content('Help') }
		it { should have_title(full_title('Help')) }
	end

	describe "About page" do
		before { visit about_path }

		it { should have_content('About') }
		it { should have_title(full_title('About')) }
	end

	describe "Members page" do
		before { visit members_path }

		it { should have_content('Members') }
		it { should have_title(full_title("Members")) }
	end

	describe "Sites page" do
		before { visit sites_path}

		it { should have_content('Sites') }
		it { should have_title(full_title("Sites")) }
	end
	
end
