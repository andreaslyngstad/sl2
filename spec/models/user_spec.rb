require "spec_helper"

describe User do
  it {should have_many(:logs)}
  it {should have_many(:todos)}
  it {should have_many(:projects)}
  it { should belong_to(:firm) }
  it { should_not allow_value("blah").for(:email) }
  it { should allow_value("a@b.com").for(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:name) }

  it "Can have a valid recovery" do
    user = User.create!(:name => "test", :password => "secret", :email => "test@test.com", :loginable_token => "secret")
    User.valid_recover?(user.loginable_token).should == user
  end
  it "Can be valid" do
    user = User.create!(:name => "test", :password => "secret", :email => "test@test.com", :loginable_token => "secret")
    params = {:id => user.loginable_token}
    User.valid?(params).should == user
  end
  

end