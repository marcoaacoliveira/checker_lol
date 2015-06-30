require 'spec_helper'
require 'checker.rb' 

describe Checker do
	before :each do
    	@check = Checker.new "e5fa8938-e73e-4d45-9398-0e7d56f202b4"
	end
	it "have a api_key" do
		expect(@checker.get_id("AdrianLion")).to eq 418428 
	end
	it "get a summoner's name by id" do

	end
end