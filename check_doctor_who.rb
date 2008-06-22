require 'lib/snowblink/iplay'

doctor_who = Snowblink::Iplay::Programme.new('b006q2x0')
doctor_who.continuous_update

