require File.dirname(__FILE__) + '/test_helper'
require 'snowblink/iplay'
require 'ruby-debug'

class ProgrammeTest < Test::Unit::TestCase
  
  def sample_file
    File.dirname(__FILE__) + '/comingup.xml'
  end

  context "looking for a programme" do
    setup do
      listing = File.dirname(__FILE__) + '/lib/t_listing.html'
      
      Snowblink::Iplay::Programme.stubs(:open).returns(File.open(listing).read)
    end
    
    should "be able to provide a programme id for a given title" do
      titles = {  'Top Gear' => 'b006mj59', 
                  'Test Match Special' => ['b00c67t1', 'b00fr0n5'], 
                  'The show where Horne & Corden are put on a spike' => false }
      
      titles.each do |title, pid|
        assert_equal pid, Snowblink::Iplay::Programme.id_for(title)
      end
    end
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