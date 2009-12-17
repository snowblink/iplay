require 'lib/snowblink/iplay'

doctor_who_pid = Snowblink::Iplay::Programme.id_for('Doctor Who')

doctor_who = Snowblink::Iplay::Programme.new(doctor_who_pid, Snowblink::Iplay::Strategy::Download.new)
doctor_who.comingup_url = 'comingup.xml'
doctor_who.get_coming_up
doctor_who.update

