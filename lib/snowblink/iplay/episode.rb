require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'parsedate'

module Snowblink
  module Iplay
    class Episode
      IPLAYER_URL = 'http://www.bbc.co.uk/iplayer/page/item/'

      attr_accessor :name, :pid, :end_time, :updated
      def initialize(series_name, details)
        # @end_time specifies when the show is due to finish
        # we should be able to download from iplayer after this time
        @series_name = series_name
        set_end_time(details)
        set_name_and_pid(details)
        @updated = false
      end

      def set_end_time(details)
        @end_time = details.at('abbr.dtend').get_attribute('title')
      end

      def set_name_and_pid(details)
        details.search('div.summary').each do |summary|
          @name = [@series_name, summary.search('span.title').inner_text, summary.search('span.subtitle').inner_text].join(' - ')
          @pid = summary.at('a.url').get_attribute('href').match(/[^\/]+$/)[0]
        end
      end

      def to_s
        "#{@name} (#{@pid}) finishes on telly at #{@end_time}"
      end

      # check with iplayer recent if the show is available yet
      # maybe call this at intervals after the show airs
      def iplayer_available?
        return false unless aired?
        # get the iplayer recent list
        doc = Hpricot(available_list)
        doc.search("entry id").any? do |id|
          id.inner_text =~ /@pid/
        end
      end
      
      def iplayer_available?
        begin
          open("#{IPLAYER_URL}#{@pid}.shtml")
          true
        rescue
          false
        end
      end

      def aired?
        Time.now > Time.local(*ParseDate.parsedate(@end_time))
      end
      
      def updated?
        @updated
      end

      def available_list
        @available_xml ||= open('http://www.bbc.co.uk/iplayer/atom/available.xml')
      end
      
    end
  end
end
