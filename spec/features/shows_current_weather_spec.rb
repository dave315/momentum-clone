require 'spec_helper'

feature "View current weather of particular city", %(
  As a user
  I want to enter my location and see the weather
  The weather should include the temperature and percipitation

  Acceptance Criteria:
  [ ] I fill out a quick form for zip code
  [ ] Then I can see the following:
  [ ] The name of the city corresponding to my zip code
  [ ] The current temperature
  [ ] If there is any precipitation

) do

  scenario "user fills out zip code field" do
    visit '/'
    find_field('zip_code')
    fill_in('zip_code', with: 02120)

    click_button "submit"

    expect(page).to have_content("Charlestown")
    expect(page).to have_content("Temp")
  end
end
