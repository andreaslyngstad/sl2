require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe InvoicesController do 

  login_user
 	before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
  end

  # describe "GET #index" do
  #   it "should have a current_user" do
  #     subject.current_user.should_not be_nil
  #     subject.current_firm.should_not be_nil
  #   end
  #   it "populates an array of invoices" do
  #     invoices = double
  #     Invoice.should_receive(:order){invoices}
  #     get :index
  #     assigns(:invoices).should be eq(invoices )  
  #   end
  #   it "renders the :index view" do
  #     get :index
  #     response.should render_template("index")
  #   end
  # end 
  
#   describe "GET #show" do
#     it "assigns the requested invoice to @invoice" do
#       invoice = FactoryGirl.create(:invoice, :firm => @user.firm)
#       get :show, :id => invoice
#       assigns(:klass).should eq(invoice) 
#       assigns(:hours).should eq(invoice.logs.sum(:hours)) 
#       assigns(:employees).should eq(invoice.employees)
#       assigns(:projects).should eq(invoice.projects.where(["active = ?", true]))
#     end
#     it "renders the #show view" do
#       @invoice = FactoryGirl.create(:invoice, :firm => @user.firm)
#       get :show, :id => @invoice
#       response.should render_template :show
#     end
#   end
#   describe "GET edit" do 
#     it "should assign invoice to @invoice" do
#       invoice = FactoryGirl.create(:invoice, :firm => @user.firm)
#       get :edit, :id => invoice, :format => 'js'
#       assigns(:invoice).should eq(invoice) 
#     end 
#   end
#   describe "POST create" do
#     context "with valid attributes" do
#       it "creates a new contact" do
#         expect{
#           post :create, invoice: FactoryGirl.attributes_for(:invoice), :format => 'js'
#         }.to change(Invoice,:count).by(1)
#       end
      
#       it "redirects to the new contact" do
#         post :create, invoice: FactoryGirl.attributes_for(:invoice), :format => 'js'
#         flash[:notice].should_not be_nil 
#       end
#     end 
#   end
#   describe 'PUT update' do
#   before :each do
#     @invoice = FactoryGirl.create(:invoice, :firm => @user.firm)
#   end
  
#   context "valid attributes" do
#     it "located the requested @contact" do
#       put :update, id: @invoice, invoice: FactoryGirl.attributes_for(:invoice), :format => 'js'
#       assigns(:klass).should eq(@invoice)      
#     end
  
#     it "changes @invoice's attributes" do
#       put :update, id: @invoice, invoice: FactoryGirl.attributes_for(:invoice, :name => "something else"), :format => 'js'
#       @invoice.reload
#       @invoice.name.should eq("something else")
#     end
#   end
#   context "invalid attributes" do
#     it "locates the requested @invoice" do
#       put :update, id: @invoice, invoice: FactoryGirl.attributes_for(:invoice, :name => nil), :format => 'js'
#       assigns(:klass).should eq(@invoice)      
#     end
    
#     it "does not change @invoice's attributes" do
#       put :update, id: @invoice, 
#         invoice: FactoryGirl.attributes_for(:invoice, :name => nil), :format => 'js'
#       @invoice.reload
#       @invoice.name.should_not eq("something else")
#     end
#   end
  
# end
#   describe 'DELETE destroy' do
#     before :each do
#       @invoice = FactoryGirl.create(:invoice, :firm => @user.firm)
#     end
    
#     it "deletes the contact" do
#       expect{
#         delete :destroy, id: @invoice, :format => 'js'       
#       }.to change(Invoice,:count).by(-1)
#     end
      
#     it "redirects to contacts#index" do
#       delete :destroy, id: @invoice, :format => 'js'
#       flash[:notice].should_not be_nil
#     end
#   end
  # describe "activate_invoices and deactivate_invoices" do
    # it "deactivate_invoices" do 
      # @invoice = FactoryGirl.create(:invoice)
      # expect{
          # get :activate_invoices, :id => @invoice.id
        # }.to change(Invoice.where(:active => true),:count).by(-1)
    # end
    # it "activate_invoices" do 
      # @invoice = FactoryGirl.create(:invoice, :active => false)
      # expect{
          # get :activate_invoices, :id => @invoice.id
        # }.to change(Invoice.where(:active => true),:count).by(1)
    # end
  # end
end