# IPlay
Created at Mashed 08 in the 24 hour hacking session. This lets you monitor programmes you like for when they are available on BBC iplayer.

# Usage
See `examples/check_doctor_who.rb` for an example.

You need the brand pid for the show you want.
This can be found by visiting:
<http://bbc.co.uk/programmes>

or alternatively, you can search for a pid in ruby:
`Snowblink::Iplay::Programme.id_for('Doctor Who')`

You can provide a different strategy to execute, by default it will tweet to the twitter account of your choice.

# Future
- Allow multiple strategies

# License
See `LICENSE`