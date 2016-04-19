require 'rails_helper'
require 'nokogiri'

# Specs in this file have access to a helper object that includes
# the MainHelper. For example:
#
# describe MainHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MainHelper, type: :helper do
  before(:each) do
    @sample = "<xml>
               <FromUserName><![CDATA[fromUser]]></FromUserName>
               <ToUserName><![CDATA[toUser]]></ToUserName>
               <CreateTime>123456789</CreateTime>
               <MsgType><![CDATA[event]]></MsgType>
               <Event><![CDATA[subscribe]]></Event>
               </xml>"
  end


  describe "extract hash from xml" do
    it "turn xml structure into hash" do
      h = helper.extract_hash_from_xml (Nokogiri::Slop @sample).xml
      expect(h.length).to eq 5
      expect(h.key? :from).to be_truthy
      expect(h.key? :to).to be_truthy
      expect(h.key? :type).to be_truthy
      expect(h.key? :event).to be_truthy
      expect(h[:event]).to eq 'subscribe'
    end
  end

end
