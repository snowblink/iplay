module Snowblink
  module Iplay
    module Strategy
      class Download
        IPLAYER_DOWNLOAD_TO = "~/Movies/iplayer"
        def update(episode)
          `iplayer-dl -d #{IPLAYER_DOWNLOAD_TO} #{episode.pid}`
        end
      end
    end
  end
end
