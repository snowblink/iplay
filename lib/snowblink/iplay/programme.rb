require 'rubygems'
require 'hpricot'
require 'open-uri'

require File.dirname(__FILE__) + '/strategy/twitter'
require File.dirname(__FILE__) + '/episode'

module Snowblink
  module Iplay
    class Programme
      BBC_PROGRAMMES_URL = 'http://www.bbc.co.uk/programmes/'
      UPDATE_INTERVAL = 300

      attr_accessor :pid, :episodes, :comingup_url

      def initialize(pid, strategy=Strategy::Twitter.new)
        @pid = pid || 'b006q2x0' # default to Doctor Who!
        @programme_url = BBC_PROGRAMMES_URL + @pid    
        @comingup_url = @programme_url + '/comingup'
        @episodes = []
        doc = Hpricot(open(@programme_url))
        @name = doc.at('h1').inner_text
        @strategy = strategy

        get_coming_up
      end

      def get_episodes(url)
        doc = Hpricot(open(url))
        # create episodes and push into @episodes

        doc.search("ol.episodes").each do |episode_list|
          episode_list.search("li").each do |episode_list_item|
            episode = Episode.new(@name, episode_list_item)
            @episodes << episode unless @episodes.any?{|ep| ep.pid == episode.pid}
          end
        end
      end
      
      def get_coming_up
        get_episodes(@comingup_url)
      end
      
      def get_existing
        get_episodes(@programme_url)
      end
      
      def update
        @episodes.each do |e|
          puts e
          if !e.updated? && e.iplayer_available?
            puts "Available!"
            @strategy.update(e)
            e.updated
          else
            puts "Not available yet!"
          end
        end
      end
      
      def continuous_update
        while !@episodes.all?{|e| e.updated?}
          update
          print "Waiting #{UPDATE_INTERVAL} seconds"
          sleep UPDATE_INTERVAL
          puts '... Done. Trying again'
        end
      end
      
    end
  end
end
