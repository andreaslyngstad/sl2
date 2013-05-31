describe FirmMailer do
  describe "overdue" do
    let(:subscription) { FactoryGirl.create(:subscription) }
    let(:mail) { FirmMailer.overdue(subscription) }

    it "sends overdue mail" do
      mail.subject.should eq("Overdue")
      mail.to.should eq([subscription.email])
      mail.from.should eq(["info@squadlink.com"])
     # mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
  describe "two_weeks_overdue" do
    let(:subscription) { FactoryGirl.create(:subscription) }
    let(:mail) { FirmMailer.two_weeks_overdue(subscription) }

    it "sends two_weeks_overdue mail" do
      mail.subject.should eq("Two weeks overdue")
      mail.to.should eq([subscription.email])
      mail.from.should eq(["info@squadlink.com"])
     # mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
  describe "reverting_to_free" do
    let(:subscription) { FactoryGirl.create(:subscription) }
    let(:mail) { FirmMailer.reverting_to_free(subscription) }

    it "sends reverting_to_free mail" do
      mail.subject.should eq("Reverting to free")
      mail.to.should eq([subscription.email])
      mail.from.should eq(["info@squadlink.com"])
     # mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
end