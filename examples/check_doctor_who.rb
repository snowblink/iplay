require 'lib/snowblink/iplay'

doctor_who = Snowblink::Iplay::Programme.new('b006q2x0', Snowblink::Iplay::Strategy::Download.new)
doctor_who.comingup_url = 'comingup.xml'
doctor_who.get_coming_up
doctor_who.update

