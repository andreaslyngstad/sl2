require "spec_helper"

describe User do
  it {should have_many(:logs)}
  it {should have_many(:todos)}
  it {should have_many(:projects)}
  it { should belong_to(:firm) }
  it { should_not allow_value("blah").for(:email) }
  it { should allow_value("a@b.com").for(:email) }
  
  it { should validate_presence_of(:name) }
  it "validates uniqueness of name" do
    FactoryGirl.create(:user, email: 'a@b.com', firm: mock_model(Firm))
    should validate_uniqueness_of(:email)
  end
  it "Can have a valid recovery" do
    user = User.new(:name => "test", :password => "secret", :email => "test@test.com", :loginable_token => "secret")
    user.firm = mock_model(Firm)
    user.save
    User.valid_recover?(user.loginable_token).should == user
  end
  it "Can be valid" do
    user = User.new(:name => "test", :password => "secret", :email => "test@test.com", :loginable_token => "secret")
    user.firm = mock_model(Firm)
    user.save
    params = {:id => user.loginable_token}
    User.valid?(params).should == user
  end
  

end