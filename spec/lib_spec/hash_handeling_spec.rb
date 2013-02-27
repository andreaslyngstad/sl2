require "./lib/hash_handeling.rb"
describe HashHandeling do
  let(:plan) {{users: 10, projects: 50, customers: nil} }
  let(:firm) {{users: 4, projects: 200, customers: 50} }
  
  it "Should find values thats to high" do
    HashHandeling.new.any_values_to_high(firm, plan).should == true 
  end

end
