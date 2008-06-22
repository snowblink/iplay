require File.dirname(__FILE__) + '/../morph/lib/morph.rb'
require 'rubygems'
require 'hpricot'
require 'open-uri'

# 2 functions
# 1. notify me when the show is available for download
# 2. show me a list of all the shows available for watching

class Programme
  BBC_PROGRAMMES_URL = 'http://www.bbc.co.uk/programmes/'
  
  attr_accessor :pid, :episodes
  
  def initialize(pid)
    @pid = pid || 'b006q2x0' # default to Doctor Who!
    @programme_url = BBC_PROGRAMMES_URL + @pid    
    @comingup_url = @programme_url + '/comingup'
    @episodes = []
    doc = Hpricot(open(@programme_url))
    @name = doc.at('h1').inner_text
  end
  
  def get_coming_up
    doc = Hpricot(open(@comingup_url))
    # create episodes and push into @episodes
    
    doc.search("ol.episodes").each do |episode_list|
      episode_list.search("li").each do |episode_list_item|
        @episodes << Episode.new(@name, episode_list_item)
      end
    end
  end
  
end

class Episode
  # include Morph
  IPLAYER_URL = 'http://www.bbc.co.uk/iplayer/page/item/'

  def initialize(series_name, details)
    # @end_time specifies when the show is due to finish
    # we should be able to download from iplayer after this time
    @end_time = details.at('abbr.dtend').get_attribute('title')
    
    details.search('div.summary').each do |summary|
      @name = [series_name, summary.search('span.title').inner_text, summary.search('span.subtitle').inner_text].join(' - ')
      @pid = summary.at('a.url').get_attribute('href').match(/[^\/]+$/)
    end
  end

  def to_s
    "#{@name} (#{@pid}) finishes on telly at #{@end_time}"
  end
  
  # check with iplayer recent if the show is available yet
  # maybe call this at intervals after the show airs
  def iplayer_available?
    # get the iplayer recent list
    doc = Hpricot(open('http://www.bbc.co.uk/iplayer/atom/available.xml'))
    doc.search("entry").each do |entry|
      entry
    end
    # serach for the pid
  end
end

doctor_who = Programme.new('b006q2x0')
doctor_who.get_coming_up

doctor_who.episodes.each {|e| puts e}


__END__

# doc = Hpricot(open('http://www.bbc.co.uk/programmes/b006q2x0/comingup'))

programme_urls = doc.search("li.vevent div.summary a.url").map{|a| a.get_attribute('href')}


pids = programme_urls.map{|programme_url| programme_url.match(/[^\/]+$/)}




programmes = doc.search("li.vevent")
# scrape the programmes page to get all iplayer links for show

