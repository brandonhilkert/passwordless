module LoginHelpers
  def login(email = "test@aol.com")
    visit "/login"
    fill_in "login_session_email", with: email
    click_button "Login"
  end
end
