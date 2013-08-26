describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = FactoryGirl.create(:user)
    visit root_url
    find("#login_link").click
    click_link "password"
    fill_in "Email", :with => user.email
    click_button "Send instructions"
    current_path.should eq('/users/sign_in')
    page.should have_content("You will receive an email with instructions about how to reset your password in a few minutes.")
    last_email.to.should include(user.email)
  end
 
  it "does not email invalid user when requesting password reset" do
    visit sign_in_url
    first(:link, 'Forgot your password?').click
    fill_in "Email", :with => "nobody@example.com"
    click_button "Send instructions"
    current_path.should eq("/users/password")
    # page.should have_content("not found")
    last_email.should be_nil
  end

  # I added the following specs after recording the episode. It literally
  # took about 10 minutes to add the tests and the implementation because
  # it was easy to follow the testing pattern already established.
  it "updates the user password when confirmation matches" do
    user = FactoryGirl.create(:user, :reset_password_token => "something", :reset_password_sent_at => 1.hour.ago)
    visit edit_password_url(user, :reset_password_token => user.reset_password_token)
    fill_in "user_password", :with => "foobar"
    click_button "Change my password"
    page.should have_content("Password confirmation doesn't match Password")
    fill_in "user_password", :with => "foobar"
    fill_in "Confirm", :with => "foobar"
    click_button "Change my password"
    page.should have_content("Signed in successfully")
  end

  it "reports when password token has expired" do
    user = FactoryGirl.create(:user, :reset_password_token => "something", :reset_password_sent_at => 6.hours.ago)
    visit edit_password_url(user, :reset_password_token => user.reset_password_token)
    fill_in "user_password", :with => "foobar"
    fill_in "Confirm", :with => "foobar"
    click_button "Change my password"
    page.should have_content("Reset password token has expired, please request a new one")
  end

  it "raises record not found when password token is invalid" do
    user = FactoryGirl.create(:user, :reset_password_token => "something", :reset_password_sent_at => 6.hours.ago)
    visit edit_password_url(user, :reset_password_token => "bla")
    fill_in "user_password", :with => "foobar"
    fill_in "Confirm", :with => "foobar"
    click_button "Change my password"
    page.should have_content("Reset password token is invalid")
  end
end