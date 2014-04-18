require 'spec_helper'


describe CurrencyHelper do
	it 'returns kr 12 001.50' do
		helper.currency_converter("12001.50", "NOK").should eq "kr 12 001,50"
	end
end      