require "spec_helper"

describe Customer do
   it {should have_many(:logs)}
   it {should have_many(:projects)}
   it {should have_many(:employees)}
   it { should belong_to(:firm) }
   it { should validate_presence_of(:name) }
end