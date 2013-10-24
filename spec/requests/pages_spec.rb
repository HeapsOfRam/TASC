require 'spec_helper'

describe "Pages" do

	let(:base_title) { "TASC" }

	describe "Home page" do
		it "should have the content 'TASC'" do
			visit '/pages/home'
			expect(page).to have_content('TASC')
		end

		it "should have the title 'Home'" do
			visit '/pages/home'
			expect(page).to have_title("#{base_title} | Home")
		end
	end

	describe "Help page" do
		it "should have the content 'Help'" do
			visit '/pages/help'
			expect(page).to have_content('Help')
		end

		it "should have the title 'Help'" do
			visit '/pages/help'
			expect(page).to have_title("#{base_title} | Help")
		end
	end

	describe "About page" do
		it "should have the content 'About'" do
			visit '/pages/about'
			expect(page).to have_content('About')
		end

		it "should have the title 'About'" do
			visit '/pages/about'
			expect(page).to have_title("#{base_title} | About")
		end
	end

	describe "Members page" do
		it "should have the content 'Members'" do
			visit '/pages/members'
			expect(page).to have_content('Members')
		end

		it "should have the title 'Members'" do
			visit '/pages/members'
			expect(page).to have_title("#{base_title} | Members")
		end
	end

	describe "Sites page" do
		it "should have the content 'Sites'" do
			visit '/pages/sites'
			expect(page).to have_content('Site')
		end

		it "should have the title 'Sites'" do
			visit '/pages/sites'
			expect(page).to have_title("#{base_title} | Sites")
		end
	end
	
end
