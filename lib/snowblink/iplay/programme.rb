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
      
      def self.id_for(name)
        listing_page = name.scan(/^[^a-z0-9]*([a-z0-9])/i).flatten.first.downcase
        listing_page = '@' if listing_page =~ /[0-9]/ 
        
        a_z = "#{BBC_PROGRAMMES_URL}a-z/by/#{listing_page}"
        doc = Hpricot(open(a_z))
        
        matches = doc.search("ol[@id='brands]//span[@class='title']..//a").select{|element| element.inner_text =~ /#{name}/i}

        case matches.size
        when 0
          return false
        when 1
          return strip_pid(matches.first)
        else
          return matches.collect{|m| strip_pid(m)}
        end
      end

      def initialize(pid, strategy=Strategy::Twitter.new)
        raise "Could not find pid" if pid.nil? || pid == false

        @pid = pid
        
        @programme_url = BBC_PROGRAMMES_URL + @pid    
        @comingup_url = @programme_url # this is no longer consistent, so set it to the same as programme_url for the time being
        @episodes = []
        doc = Hpricot(open(@programme_url))
        @name = doc.at('h1').inner_text
        @strategy = strategy

      end

      def get_episodes(url)
        doc = Hpricot(open(url))
        return if doc.nil?
        # create episodes and push into @episodes

        # for tv shows
        doc.search("a").each do |potential_episode|
          pid_href = potential_episode.get_attribute('href')
          next if pid_href.nil?
          pid = pid_href.match(%r{^http://www.bbc.co.uk/iplayer/episode/([^/]+)$})
          next if pid.nil?
          episode = Episode.new(@name, nil)
          episode.pid = pid[1]
          @episodes << episode unless @episodes.any?{|ep| ep.pid == episode.pid}
        end
        
        # for radio shows
        doc.search("a.aod-link").each do |episode_link|
          pid = episode_link.get_attribute('href').match(/[^\/]+$/)[0]
          episode = Episode.new(@name, nil)
          episode.pid = pid
          @episodes << episode unless @episodes.any?{|ep| ep.pid == episode.pid}
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
          # if !e.updated? && e.iplayer_available?
          if e.iplayer_available?
            puts "Available!"
            @strategy.update(e)
            e.updated=true
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
      
      private
      def self.strip_pid(element)
        element.attributes['href'].gsub('/programmes/', '')
      end
    end
  end
end

