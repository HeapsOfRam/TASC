require 'spec_helper'

describe "Pages" do

	describe "Home page" do
		it "should have the content 'TASC'" do
			visit '/pages/home'
			expect(page).to have_content('TASC')
		end
	end

	describe "Help page" do
		it "should have the content 'Help'" do
			visit '/pages/help'
			expect(page).to have_content('Help')
		end
	end

	describe "About page" do
		it "should have the content 'About'" do
			visit '/pages/about'
			expect(page).to have_content('About')
		end
	end

	describe "Members page" do
		it "should have the content 'Members'" do
			visit '/pages/members'
			expect(page).to have_content('Members')
		end
	end

	describe "Sites page" do
		it "should have the content 'Sites'" do
			visit '/pages/sites'
			expect(page).to have_content('Site')
		end
	end
	
end
