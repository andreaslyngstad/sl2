require "spec_helper"

describe Project do
  it {should have_many(:logs)}
  it {should have_many(:todos)}
  it {should have_many(:milestones)}
  it {should have_many(:users)}
  it {should belong_to(:customer) }
  it {should belong_to(:firm) }
  it { should validate_presence_of(:name) }
end
