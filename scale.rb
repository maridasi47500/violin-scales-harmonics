# --- NoteMap for LilyPond with Harmonics ---
class NoteMap
  attr_reader :map, :reverse_map

  BASE_NOTES = {
    "c" => 0, "cis" => 1, "des" => 1, "d" => 2, "dis" => 3, "ees" => 3,
    "e" => 4, "f" => 5, "fis" => 6, "ges" => 6, "g" => 7, "gis" => 8,
    "as" => 8, "a" => 9, "ais" => 10, "bes" => 10, "b" => 11
  }

  OCTAVES = ["", "'", "''", "'''", "''''", "'''''", "''''''"]

  INTERVAL_RULES = {
    5 => 23,  # perfect fourth → +2 octaves
    7 => 19,  # perfect fifth → +major tenth
    3 => 32,  # minor third → +3octaves - 1 tone
    4 => 28   # major third → +2 octaves + M3
  }

  def initialize
    @map = {}
    @reverse_map = {}
    build_base_notes



    #add_chord_harmonics
    #add_artificial_harmonics
    #add_natural_harmonics
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
    @map["d''8\harmonic"] = @map["g'''"]
    @map["e''8\harmonic"] = @map["e'''"]
    @map["c'8\\harmonic"] = @map["g''"]
    @map["d'8\\harmonic"] = @map["d''"]
    @map["a'8\\harmonic"] = @map["a''"]
    @map["g'8\\harmonic"] = @map["g'''"] #4 stringt
    @map["a'8\\harmonic"] = @map["a''"]
    @map["b''8\\harmonic"] = @map["b'''"] #4 stringt
    @map["a''8\\harmonic"] = @map["e''''"]

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
      touched_notes.each do |touch|
        f_val = @map[fund]
        t_val = @map[touch]
        next unless f_val && t_val
  
        interval = t_val - f_val
        if INTERVAL_RULES[interval]
          sounding_val = f_val + INTERVAL_RULES[interval]

          sounding_note = @reverse_map[sounding_val]
          token = "<#{fund} #{touch}\\harmonic>"
          p "sounding val #{sounding_val} f_val #{f_val} t_val #{t_val} token #{token} => #{sounding_note}"
          @map[token] = sounding_val
          # Optional: print what was added
          #puts "#{token} => #{sounding_note}"
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
  def scale(start_note, intervals, doublestop=0)

    current = @map[start_note]
    if doublestop != 0
    
    double = @reverse_map[current+doublestop]
    result = ["<#{start_note} #{double}>"]
    else
    result = ["#{start_note}"]
    end

    currentscale={}
    intervals.each.with_index do |step,i|
      current += step
      #p current
      #p step
      #p (@reverse_map[current] || current.to_s)
      currentscale[current]=@reverse_map[current]
      somenote=(@reverse_map[current] || current.to_s)
      double = @reverse_map[current+doublestop]
      result << "<#{(@reverse_map[current] || current.to_s)} #{double}>"
      else
      result << "#{(@reverse_map[current] || current.to_s)}"
      end
    end
    #p result
    result << "\\break "

    #p result
    result
  end
end

# --- Example usage ---
note_map = NoteMap.new
def hi(x, octave=0)
  z=x
  if octave > 0
    z = z * (octave + 1)
    z.reverse.each do |y|
      z << -(y)
    end
  else
    z.reverse[..-1].each do |y|
      z << -(y)
    end
  end
  p z

  z

end
def hey(x, octave=0)
  z=x
  if octave > 0
    z = z * (octave + 1)
    z.reverse.each do |y|
      z << -(y)
    end
  else
    z.reverse.each do |y|
      z << -(y)
    end
  end
  p z

  z

end



chromatic_pattern = [1] * 12

#puts "C major scale:"
hello =""
firstnote="c'"
[firstnote, (firstnote+"'"), (firstnote+"''")].each do |mynote|
major_pattern = hey([2,2,1,2,2,2,1])
hello << note_map.scale(mynote, major_pattern).join(" ")
pattern = hey([3,4, 5])
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([4,3, 5])
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([4,5, 3])
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([5,4, 3])
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([5, 3, 4])
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([3, 3, 3, 3])
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([4, 3, 3, 2])
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([4, -2, 3, -1, 3, -2, 4, -2, 4, -2, 3])
hello << note_map.scale(mynote, pattern).join(" ")

hello << note_map.scale(mynote, hey(chromatic_pattern)).join(" ")
end
mynote=firstnote
chromatic_pattern = [1] * 12

major_pattern = hey([2,2,1,2,2,2,1], 2)
hello << note_map.scale(mynote, major_pattern).join(" ")
pattern = hey([3,4, 5], 2)
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([4,3, 5], 2)
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([4,5, 3], 2)
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([5,4, 3], 2)
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([5, 3, 4], 2)
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([3, 3, 3, 3], 2)
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([4, 3, 3, 2], 2)
hello << note_map.scale(mynote, pattern).join(" ")
pattern = hey([4, -2, 3, -1, 3, -2, 4, -2, 4, -2, 3], 2)
hello << note_map.scale(mynote, pattern).join(" ")

hello << note_map.scale(mynote, hey(chromatic_pattern, 2)).join(" ")
pattern = hey([4, -2, 3, -1, 3, -2, 4, -2, 4, -2, 3, -1, 3, -2, 2], 0)
hello << note_map.scale(mynote, pattern, doublestop=4).join(" ")
pattern = hey([4, -2, 3, -1, 3, -2, 4, -2, 4, -2, 3, -1, 3, -2], 1)
hello << note_map.scale(mynote, pattern, doublestop=4).join(" ")
chromatic_pattern = [1] * 12
pattern = hey(chromatic_pattern)
hello << note_map.scale(mynote, pattern, doublestop=4).join(" ")
chromatic_pattern = [1] * 12
pattern = hey(chromatic_pattern)
hello << note_map.scale(mynote+"'", pattern, doublestop=4).join(" ")
pattern = hey([4, -2, 3, -1, 3, -2, 4, -2, 4, -2, 3, -1, 3, -2, 2], 0)
hello << note_map.scale(mynote, pattern, doublestop=-8).join(" ")
pattern = hey([4, -2, 3, -1, 3, -2, 4, -2, 4, -2, 3, -1, 3, -2], 1)
hello << note_map.scale(mynote, pattern, doublestop=-8).join(" ")
chromatic_pattern = [1] * 12
pattern = hey(chromatic_pattern)
hello << note_map.scale(mynote, pattern, doublestop=-8).join(" ")
chromatic_pattern = [1] * 12
pattern = hey(chromatic_pattern)
hello << note_map.scale(mynote+"'", pattern, doublestop=-8).join(" ")
pattern = hey([4, -2, 3, -1, 3, -2, 4, -2, 4, -2, 3, -1, 3, -2, 2], 0)
hello << note_map.scale(mynote, pattern, doublestop=12).join(" ")
pattern = hey([4, -2, 3, -1, 3, -2, 4, -2, 4, -2, 3, -1, 3, -2], 1)
hello << note_map.scale(mynote, pattern, doublestop=12).join(" ")
chromatic_pattern = [1] * 12
pattern = hey(chromatic_pattern)
hello << note_map.scale(mynote, pattern, doublestop=12).join(" ")
chromatic_pattern = [1] * 12
pattern = hey(chromatic_pattern)
hello << note_map.scale(mynote+"'", pattern, doublestop=12).join(" ")
[12, -8, 4].each do |mydoublestop|
chromatic_pattern = [1] * 12

major_pattern = hey([2,2,1,2,2,2,1], 1)
hello << note_map.scale(mynote, major_pattern, doublestop=mydoublestop).join(" ")
pattern = hey([3,4, 5], 1)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hey([4,3, 5], 1)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hey([4,5, 3], 1)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hey([5,4, 3], 1)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hey([5, 3, 4], 1)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hey([3, 3, 3, 3], 1)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hey([4, 3, 3, 2], 1)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hi([2,2,1,2,2,2,1, 2], 0)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hi([4, 1,2,2,2,1, 2, 2, 1], 0)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hi([7, 2,2,1, 2,2,1, 2, 2], 0)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hi([11, 1, 2,2,1,2,2,2, 1], 0)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hi([9,2,1, 2,2,1,2,2, 2], 0)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hi([7,2,2,1, 2,2,1,2], 0)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hey([5,2,2,2,1, 2,2,1], 0)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
pattern = hey([4,1,2,2,2,1, 2, 2], 0)
hello << note_map.scale(mynote, pattern, doublestop=mydoublestop).join(" ")
end


score="
\\version \"2.24.3\"

\\header {
  title = \"#{firstnote} violin scale\"
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
File.write("new_scale.ly", score)

#puts "Transpose example:"
puts note_map.transpose(["g'", "c''8\\harmonic", "<e'' a''\\harmonic>."], 2).join(" ")

