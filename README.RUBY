This is a ruby port of Adrian Holvaty's python templatemaker:
  http://www.holovaty.com/writing/templatemaker/
which you can get here:
  http://code.google.com/p/templatemaker/

IMPORTANT DEPENDENCY!
You'll need the rake-compiler gem to use the rakefile.
  sudo gem install rake-compiler


Then do:

  $ rake compile
  $ irb -I./lib -rtemplatemaker

  >> t = Templatemaker::Templatemaker.new
  => #<Templatemaker::Templatemaker:0x10115dfb8 @version=0, @tolerance=0, @brain=nil>
  >> t.learn("This and That")
  => nil
  >> t.learn("Jack and Jill")
  => true
  >> t.as_text("!")
  => "! and !"
  >> t.extract("Day and Night")
   and 
  => ["Day", "Night"]
