#!/usr/bin/ruby

require 'lib/snowblink/iplay'

shows = [ 
  {:name => 'Miranda'},
  {:name => 'Adam and Joe', :pid => 'b00876k2'},
  {:name => "Life", :pid => 'b00lbpcy'},
  {:name => "Natural World", :pid => 'b006qnnh'},
  {:name => 'Andrew Marr', :pid => 'b00nrrff'},
  {:name => 'Spooks', :pid => 'b006mf4b'},
  {:name => 'Art Deco', :pid => 'b00nj89c'},
  {:name => 'Ray Mears', :pid => 'b00nqhwl'},
  {:name => 'James May', :pid => 'b00nqmlb'},
  {:name => 'Mark Steel', :pid => 'b00d4b8b'},
  {:name => 'Horizon', :pid => 'b006mgxf'},
  {:name => 'Games Britannia'},
  {:name => 'Hamlet'}
]
   
for show in shows do
  puts "Getting #{show[:name]}"
  if !show.has_key?(:pid)
    show[:pid] = Snowblink::Iplay::Programme.id_for(show[:name])
  end
  prog = Snowblink::Iplay::Programme.new(show[:pid], Snowblink::Iplay::Strategy::Download.new)
  # prog = Snowblink::Iplay::Programme.new(show[:pid], Snowblink::Iplay::Strategy::NoOp.new)
  # prog.get_coming_up
  prog.get_existing
  prog.update
  # sleep 60 # so as not to scare iplayer
end
