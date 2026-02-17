# --- NoteMap for LilyPond with Harmonics ---
class NoteMap
  attr_reader :map, :reverse_map

  BASE_NOTES = {
    "g" => 0, "gis" => 1,
    "as" => 1, "a" => 2, "ais" => 3, "bes" => 3, "b" => 4,
    "c'" => 5, "des'" => 6, "cis'" => 6, "d'" => 7, "dis'" => 8, "ees'" => 8,
    "e'" => 9, "f'" => 10, "ges'" => 11, "fis'" => 11
  }

  OCTAVES = ["", "'", "''", "'''", "''''", "'''''", "''''''"]

  INTERVAL_RULES = {

    5 => 24,  # perfect fourth → +2 octaves
    7 => 19,  # perfect fifth → +major tenth
    4 => 28,   # major third → +2 octaves + M3
    3 => 32  # minor third → +3octaves - 1 tone





  }

  def initialize
    @map = {}
    @reverse_map = {}
    build_base_notes



    add_chord_harmonics
    add_natural_harmonics
    add_artificial_harmonics

    build_reverse_map



  end

  # --- Base notes across octaves ---
  def build_base_notes
    OCTAVES.each_with_index do |marks, i|
      BASE_NOTES.each do |name, val|
        @map["#{name}#{marks}"] = val + 12 * i
      end
    end
  end

  # --- Natural harmonics ---
  def add_natural_harmonics
    ["g'", "d''", "a''", "e'''"].each do |open|
      @map["#{open}2^\\flageolet"] = @map[open]
    end





  end

  # --- Artificial harmonics ---
  def add_artificial_harmonics
    @map["d''8\harmonic"] = @map["a'''"]
    @map["e''8\harmonic"] = @map["e'''"]
    @map["c'8\\harmonic"] = @map["g''"]
    @map["d'8\\harmonic"] = @map["d''"]
    @map["a'8\\harmonic"] = @map["a''"]
    @map["g'8\\harmonic"] = @map["d'''"] #4 stringt
    @map["b''8\\harmonic"] = @map["b'''"] #4 stringt
    @map["a''8\\harmonic"] = @map["e''''"]

    @map["e'8^\\harmonic"] = @map["b''"]
    @map["b'8^\\harmonic"] = @map["fis''"]

    @map["fis''8^\\harmonic"] = @map["des'''"]
    @map["fis''8^\\harmonic"] = @map["cis'''"]
    @map["ges''8^\\harmonic"] = @map["des'''"]
    @map["ges''8^\\harmonic"] = @map["cis'''"]


    @map["cis'''8^\\harmonic"] = @map["gis''''"]
  end

  # --- Chord harmonics ---
  #def add_chord_harmonics
  #  add_chord("e''", "a''")
  #  add_chord("f'", "c''")
  #  add_chord("as", "c'")
  #end
  def add_chord_harmonics
    # Build reverse map for lookup
    @map.each { |k,v| @reverse_map[v] ||= k }
  
    fundamentals = @map.keys
    p "fundamentals", fundamentals
    touched_notes = fundamentals.dup
  
    fundamentals.each do |fund|
      INTERVAL_RULES.keys.reverse.each do |myinterval|
        touched_notes.reverse.each do |touch|

          f_val = @map[fund]
          t_val = @map[touch]
          next unless f_val && t_val
  
          interval = t_val - f_val
          if INTERVAL_RULES[interval] and interval == myinterval
            sounding_val = f_val + INTERVAL_RULES[interval]

            sounding_note = @reverse_map[sounding_val]
            token = "<#{fund} #{touch}\\harmonic>"
            #p "sounding val #{sounding_val} f_val #{f_val} t_val #{t_val} token #{token} => #{sounding_note}"
            @map[token] = sounding_val
            # Optional: print what was added
            #puts "#{token} => #{sounding_note}"
          end
        end
      end
    end
  end


  def add_chord(fundamental, touched)
    f_val = @map[fundamental]
    t_val = @map[touched]
    interval = t_val - f_val
    if INTERVAL_RULES[interval]
      sounding_val = f_val + INTERVAL_RULES[interval]
      build_reverse_map
      sounding_note = @reverse_map[sounding_val]
      token = "<#{fundamental} #{touched}\\harmonic>"
      @map[token] = sounding_val
    end
  end

  # --- Reverse map for lookup ---
  def build_reverse_map
    @reverse_map = {}
    #@map.each { |k,v| @reverse_map[v] ||= k }
    @map.each { |k,v| @reverse_map[v] = k }

    p "@reverse_map"
    p @reverse_map
    
  end

  # --- Transpose notes ---
  def transpose(notes, interval)
    notes.map do |note|
      if @map[note]
        semitone = @map[note]
        transposed = semitone + interval
        @reverse_map[transposed] || note
      else
        note
      end
    end
  end

  # --- Scale generator ---
  def scale(start_note, intervals)

    current = @map[start_note]
    result = [(@reverse_map[current] || current.to_s)]

    intervals.each do |step|
      current += step
      #p current
      #p step
      #p (@reverse_map[current] || current.to_s)
      result << (@reverse_map[current] || current.to_s)
    end
    #p result
    result << " \\break "

    #p result
    result
  end
end

# --- Example usage ---
note_map = NoteMap.new

major_pattern = [2,2,1,2,2,2,1]
chromatic_pattern = [1] * 12

#puts "C major scale:"
hello =""
puts note_map.scale("g''", major_pattern).join(" ")
hello << note_map.scale("g''", major_pattern).join(" ")
puts note_map.scale("d''", chromatic_pattern).join(" ")
hello << note_map.scale("d''", chromatic_pattern).join(" ")


#puts "Chromatic scale from g':"
puts note_map.scale("g''", chromatic_pattern).join(" ")
hello << note_map.scale("g''", chromatic_pattern).join(" ")
score="
\\version \"2.24.3\"

\\header {
  title = \"violin scales\"
}

global = {
  \\key c \\major
  \\time 4/4
}

violin = \\absolute  {
  \\global
  % En avant la musique.
  #{hello}
}
\\score {
  \\new Staff \\with {
    instrumentName = \"Violon\"
    midiInstrument = \"violin\"
  } \\violin
  \\layout { }
  \\midi {
    \\tempo 4=100
  }
}
"
File.write("new_score.ly", score)

#puts "Transpose example:"
puts note_map.transpose(["g'", "c''8\\harmonic", "<e'' a''\\harmonic>."], 2).join(" ")

