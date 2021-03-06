require "rails_helper"

RSpec.feature "the searching", :type => :feature do
  before :each do
    User.create(:email => "user@example.com", :password => "password")
    visit "/users/sign_in"
    within("#new_user") do
      fill_in "Email", :with => "user@example.com"
      fill_in "Password", :with => "password"
    end
    click_button "Log in"
  end

  scenario "visit search page" do
    click_link("Search")
    expect(page).to have_content "Zapskills Home Search for skills:"
  end

  scenario "go to profile page from search" do
    click_link("Search")
    click_link("Profile")
    expect(page).to have_content "Editing User"
  end

  scenario "sign out from search page" do
    click_link("Search")
    click_link("Sign Out")
    expect(page).to have_content "You need to sign in or sign up before continuing"
  end

  scenario "search show no results" do
    load Rails.root + "db/seeds.rb"
    click_link("Search")
    fill_in "City", :with => "Madison"
    fill_in "State", :with => "WI"
    fill_in "Radius", :with => "1"
    select "Cooking", :from => "skill_id"
    click_button "Search"
    expect(page).to have_no_content "First name"
  end
  
  scenario "search show some result" do
    expect(page).to have_content "Signed in successfully"
    load Rails.root + "db/seeds.rb"
    click_link("Profile")
    fill_in "City", :with => "Madison"
    fill_in "State", :with => "WI"
    click_button "Update User"
    expect(page).to have_content "User was successfully updated"
    click_link("Add skills")
    fill_in "Description", :with => "Learned it"
    fill_in "experience_level", :with => "4"
    select "2010", :from => "experience_start_date_1i"
    select "November", :from => "experience_start_date_2i"
    select "20", :from => "experience_start_date_3i"
    select "Cooking", :from => "experience_skill_id"
    click_button "Create Experience"
    expect(page).to have_content "Skills"
    expect(page).to have_content "Cooking"
    expect(page).to have_content "Description: Learned it"
    expect(page).to have_content "Level: 4"
    click_link("Sign Out")
    visit "/users/sign_in"
    within("#new_user") do
      fill_in "Email", :with => "foo0@bar.com"
      fill_in "Password", :with => "password"
    end
    click_button "Log in" 
    expect(page).to have_content "Signed in successfully"   
    fill_in "City", :with => "Madison"
    fill_in "State", :with => "WI"
    fill_in "Radius", :with => "1"
    select "Cooking", :from => "skill_id"
    click_button "Search"
    expect(page).to have_content "First name"
  end
end
