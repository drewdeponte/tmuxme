def login(email, password)
  visit(new_session_path)
  fill_in("email", :with => email)
  fill_in("password", :with => password)
  click_button("Log In")
end
