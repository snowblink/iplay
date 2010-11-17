#!/usr/bin/ruby

require 'lib/snowblink/iplay'

shows = [ 
  {:name => 'Adam Buxton'},
  {:name => 'Adam and Joe', :pid => 'b00876k2'},
  {:name => 'Age of the Genome', :pid => 'b00ssmcp'},
  {:name => 'Andrew Marr', :pid => 'b00nrrff'},
  {:name => 'David Attenborough', :pid => 'b00vw49d'},
  {:name => 'Genius of Design'},
  {:name => 'Horizon', :pid => 'b006mgxf'},
  {:name => 'How to build'},
  {:name => 'Imagine'},
  {:name => "I'm sorry I"},
  {:name => 'James May'},
  {:name => 'Life', :pid => 'b00lbpcy'},
  {:name => 'Natural World', :pid => 'b006qnnh'},
  {:name => "Nature's Great Events"},
  {:name => 'Museum of Curiosity'},
  {:name => 'Pattern Recgonition'},
  {:name => 'Pirates'},
  {:name => "Richard Hammond's Engineering"},
  {:name => 'QI'},
  {:name => 'Sarah Millican', :pid => 'b00qps8m'},
  {:name => 'Strictly Come Dancing', :pid => 'b006m8dq'},
  {:name => 'Trip'},
  {:name => 'Walk on by'},
  {:name => 'Whites'},
  {:name => 'Wild China'},
  
]
   
for show in shows do
  puts "Getting #{show[:name]}"
  if !show.has_key?(:pid)
    show[:pid] = Snowblink::Iplay::Programme.id_for(show[:name])
  end
  begin
    prog = Snowblink::Iplay::Programme.new(show[:pid], Snowblink::Iplay::Strategy::Download.new)
    # prog = Snowblink::Iplay::Programme.new(show[:pid], Snowblink::Iplay::Strategy::NoOp.new)
    # prog.get_coming_up
    prog.get_existing
    prog.update
  rescue StandardError => e
    puts "Could not get #{show[:name]} because #{e}"
    
  end
  # sleep 60 # so as not to scare iplayer
end
