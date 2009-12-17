module Snowblink
  module Iplay
    module Strategy
      class Download
        IPLAYER_DOWNLOAD_TO = "~/Movies/iplayer"
        def update(episode)
          `/usr/local/bin/iplayer-dl -d #{IPLAYER_DOWNLOAD_TO} -t 'default' #{episode.pid}`
        end
      end
    end
  end
end
