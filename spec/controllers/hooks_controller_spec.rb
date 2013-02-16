require 'spec_helper'

describe HooksController do

  describe "GET 'receiver'" do
    it "returns http success" do
      get 'receiver'
      response.should be_success
    end
  end

end
