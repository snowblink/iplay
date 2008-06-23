require File.dirname(__FILE__) + '/test_helper'
require 'snowblink/iplay'

class ProgrammeTest < Test::Unit::TestCase
  
  def sample_file
    File.dirname(__FILE__) + '/../comingup.xml'
  end
  
  context "a programme" do
    setup do
      @programme = Snowblink::Iplay::Programme.new(
        :name => 'Doctor Who',
        :pid => '1234',
        :strategy => Snowblink::Iplay::Strategy::NoOp.new
        )
      @programme.stubs(:upcoming_url).returns(sample_file)
      @programme.stubs(:programme_url).returns(sample_file)
    end
    
    should "get programme file from programme url" do
      @programme.expects(:programme_doc)
      @programme.stubs(:programme_url).returns(:a_programme_url)
      Hpricot.expects(:open).with(:a_programme_url).returns(sample_file)
      @programme.programme_doc
    end
  end
end