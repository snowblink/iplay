module Snowblink
  module Iplay
    module Strategy
      class NoOp
        def update(episode)
          puts "Doing nothing with #{episode}"
        end
      end
    end
  end
end
