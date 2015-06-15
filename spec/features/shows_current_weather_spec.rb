require 'spec_helper'

feature "View current weather of particular city", %(
  As a user
  I want to enter my location and see the weather
  The weather should include the temperature and percipitation

  Acceptance Criteria:
  [x] I fill out a quick form for zip code
  [x] Then I can see the following:
  [x] The name of the city corresponding to my zip code
  [x] The current temperature
  [x] If there is any precipitation

) do

  scenario "user fills out zip code field" do
    visit '/'
    find_field('zip_code')
    fill_in('zip_code', with: '02129')

    click_button "submit"

    expect(page).to have_content("Charlestown")
  end
end
