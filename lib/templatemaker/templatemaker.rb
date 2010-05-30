

module Templatemaker

  class Templatemaker
    def initialize tolerance=0, brain=nil
      @tolerance = tolerance
      @brain     = brain
      @version   = 0
    end


    #
    #  Strips any unwanted stuff from the given Sample String, in order to
    #    make templates more streamlined.
    # 
    def clean text
      text.gsub /\r\n/, "\n"
    end

    #
    # Learns the given Sample String.
    #
    # Returns True if this Sample String created more holes in the template.
    # Returns nil if this is the first Sample String in this template.
    # Otherwise, returns False.
    #
    def learn text
      text = clean(text)
      text.gsub!(::Templatemaker::MARKER, '')

      @version += 1

      unless @brain
        @brain = text
        return nil
      end

      old_holes = num_holes
      @brain = ::Templatemaker::FFI::make_template(@brain, text, @tolerance)
      return num_holes > old_holes
    end

    #
    # Returns a display-friendly version of the template, using the
    # given custom_marker to mark template holes.
    #
    def as_text custom_marker = '{{ HOLE }}'
      @brain.gsub(::Templatemaker::MARKER, custom_marker)
    end
    
    #
    #Returns the number of holes in this template.
    #
    def num_holes
      @brain.count(::Templatemaker::MARKER)
    end

    #
    # Given a bunch of text that is marked up using this template, extracts
    # the data.
    #
    # Returns an array of the raw data, in the order in which it appears in
    # the template. If the text doesn't match the template, return nil.
    #
    def extract text
      text = clean(text)
      puts @brain
      re = "^%s$" % Regexp.escape(@brain).gsub(Regexp.escape(::Templatemaker::MARKER), '(.*?)')
      re = Regexp.new(re, Regexp::MULTILINE)
      match_data = re.match(text)
      if match_data
        return match_data.captures
      end
      return nil
    end
    
    #
    # Classmethod that learns all of the files in the given directory name.
    #    Returns the Template object.
    #

    def self.from_directory(dirname, tolerance=0)
      t=self.new(tolerance)
      Dir.entries(dirname).each {|f|
        f = "#{dirname}/#{f}"
        if File.file?(f)
          t.learn(File.read(f))
        end
      }
      t
    end

  end # class

end # module
