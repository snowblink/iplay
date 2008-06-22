require 'rubygems'
require 'hpricot'
require 'open-uri'
gem 'twitter4r'
require 'twitter'
require 'yaml'

module Snowblink
  module Iplay
    module Strategy

      class Twitter
        def initialize
          ::Twitter::Client.configure do |conf|
            conf.application_name     = "BBC Coming Up"
            conf.application_version  = '0.1'
            conf.application_url      = 'http://github.com'
            conf.source               = ''
          end

          twitter_config = YAML::load_file(File.dirname(__FILE__) + '/../../../../twitter_config.yml')
          @twitter = ::Twitter::Client.new(twitter_config)
        end

        def update(episode)
          update = "#{episode.name} available: http://www.bbc.co.uk/iplayer/page/item/#{episode.pid}.shtml"
          @twitter.status(:post, update)
        end
      end
    end
  end
end
