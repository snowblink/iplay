require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'parsedate'

module Snowblink
  module Iplay
    class Episode
      IPLAYER_URL = 'http://www.bbc.co.uk/iplayer/episode/'

      attr_accessor :name, :pid, :end_time, :updated
      def initialize(series_name, details)
        @series_name = series_name
        @details = details
        unless details.nil?
          set_end_time
          set_name_and_pid
        end
        @updated = false
      end

      def set_end_time
        # CHANGED as the BBC have changed the layout
        @end_time = @details.at('span.date').inner_text + ' ' + @details.at('span.endtime').inner_text.sub(/^-/, '')
      end

      def set_name_and_pid
        @details.search('div.summary').each do |summary|
          @name = [@series_name, summary.search('span.title').inner_text, summary.search('span.subtitle').inner_text].reject{|a| a =~ /^$/ }.join(' - ')

          
          @pid = summary.at('a.url').get_attribute('href').match(/[^\/]+$/)[0]
        end
      end

      def to_s
        "#{@name} (#{@pid})"
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
          url = "#{IPLAYER_URL}#{@pid}"
          puts "Trying #{url}"
          open(url)
          true
        rescue
          false
        end
      end
      
      # def iplayer_available?
      #   !@details.search('div.availability').empty?
      # end
      
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
