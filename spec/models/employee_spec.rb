require "spec_helper"

describe Employee do
  it {should have_many(:logs)}
  it { should belong_to(:customer) }
end