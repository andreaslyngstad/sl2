require "spec_helper"

describe Invoice do
   it {should belong_to(:firm)}
   it {should belong_to(:customer)}
   it {should belong_to(:project)}
   it {should have_many(:logs)} 
end 