describe FirmMailer do

 
  
  describe 'sign up confirmation' do
    let(:firm)         { FactoryGirl.create(:firm)}
    let(:user)         { FactoryGirl.create(:user, firm:firm)}
    let(:mail) { FirmMailer.sign_up_confirmation(user) }
    it 'sends sign up confirmation' do
      mail.subject.should eq("Squadlink sign up confirmation.")
      mail.to.should eq([user.email])
      mail.from.should eq(["support@squadlink.com"])
    end
  end
  describe "overdue" do
    let(:firm)         { FactoryGirl.create(:firm)}
    let(:user)         { FactoryGirl.create(:user, firm:firm)}
    let(:subscription) { FactoryGirl.create(:subscription, firm: firm, email:user.email) }
    let(:mail) { FirmMailer.overdue(subscription) }
    it "sends overdue mail" do
      mail.subject.should eq("Squadlink payment is overdue.")
      mail.to.should eq([subscription.email])
      mail.from.should eq(["support@squadlink.com"])
     # mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
  describe "two_weeks_overdue" do
    let(:firm)         { FactoryGirl.create(:firm)}
    let(:user)         { FactoryGirl.create(:user, firm:firm)}
    let(:subscription) { FactoryGirl.create(:subscription, firm: firm, email:user.email) }
    let(:mail) { FirmMailer.two_weeks_overdue(subscription) }
    it "sends two_weeks_overdue mail" do
      mail.subject.should eq("Squadlink payment is two weeks overdue.")
      mail.to.should eq([subscription.email])
      mail.from.should eq(["support@squadlink.com"])
     # mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
  describe "reverting_to_free" do
    let(:firm)         { FactoryGirl.create(:firm)}
    let(:user)         { FactoryGirl.create(:user, firm:firm)}
    let(:subscription) { FactoryGirl.create(:subscription, firm: firm, email:user.email) }
    let(:mail) { FirmMailer.reverting_to_free(subscription) }
    it "sends reverting_to_free mail" do
      mail.subject.should eq("Squadlink account revertet to free due to missing payment.")
      mail.to.should eq([subscription.email])
      mail.from.should eq(["support@squadlink.com"])
     # mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
  
    

end