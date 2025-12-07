# Complete Ruby script for LilyPond note mapping with harmonics

note_map = {}

# --- Base pitches (semitone values) ---
base_notes = {
  "c" => 0, "cis" => 1, "des" => 1, "d" => 2, "dis" => 3, "ees" => 3,
  "e" => 4, "f" => 5, "fis" => 6, "ges" => 6, "g" => 7, "gis" => 8,
  "as" => 8, "a" => 9, "ais" => 10, "bes" => 10, "b" => 11
}

# Build octaves up to c'''' (MIDI-style semitone counts)
octaves = ["", "'", "''", "'''", "''''", "'''''", "''''''"]
octaves.each_with_index do |marks, i|
  base_notes.each do |name, val|
    note_map["#{name}#{marks}"] = val + 12 * i
  end
end

# --- Natural harmonics (flageolet circle) ---
["g'", "d''", "a''", "e'''"].each do |open|
  note_map["#{open}2^\\flageolet"] = note_map[open]
end

# --- Artificial harmonics (single notes) ---
# G string
note_map["c''8\\harmonic"] = note_map["g'''"]   # 4th above → 2 octaves higher
note_map["d''8\\harmonic"] = note_map["b'''"]   # 5th above → major tenth

# D string
note_map["a'8\\harmonic"]  = note_map["d''''"]  # 4th above → 2 octaves higher
note_map["b'8\\harmonic"]  = note_map["f''''"]  # 5th above → major tenth

# A string
note_map["d'''8\\harmonic"] = note_map["a''''"] # 4th above → 2 octaves higher
note_map["e'''8\\harmonic"] = note_map["c''''"] # 5th above → major tenth

# E string
note_map["a''''8\\harmonic"] = note_map["e'''''"] # 4th above → 2 octaves higher
note_map["b''''8\\harmonic"] = note_map["g'''''"] # 5th above → major tenth

# --- Chord harmonics ---
note_map["<e'' a''\\harmonic>."] = note_map["e''''"]   # 4th above → 2 octaves higher
note_map["<f' c''\\harmonic>"]   = note_map["c''''"]   # 5th above → major tenth
note_map["<as c'\\harmonic>"]    = note_map["c''"]     # major third above → 2 octaves + M3
# Interval rules in semitones
INTERVAL_RULES = {
  4 => 24,  # perfect fourth → +2 octaves
  7 => 16,  # perfect fifth → +major tenth
  3 => 27   # major third → +2 octaves + M3
}
@reverse_map = {}

def add_chord_harmonic(fundamental, touched, note_map)
  p fundamental, touched
  f_val = note_map[fundamental]
  t_val = note_map[touched]
  interval = t_val - f_val
  if INTERVAL_RULES[interval]
    sounding_val = f_val + INTERVAL_RULES[interval]

    note_map.each { |k,v| @reverse_map[v] ||= k }
    sounding_note = @reverse_map[sounding_val]
    token = "<#{fundamental} #{touched}\\harmonic>"
    note_map[token] = sounding_val
    puts "#{token} => #{sounding_note}"
  else
    puts "No harmonic rule for interval #{interval}"
  end
end

# Example usage
add_chord_harmonic("e''", "a''", note_map)  # 4th above
add_chord_harmonic("f'", "c''", note_map)   # 5th above
add_chord_harmonic("as", "c'", note_map)    # major third
p note_map
@reverse_map = {}
def generate_chord_harmonics(note_map)
  @reverse_map = {}
  note_map.each { |k,v| @reverse_map[v] ||= k }

  fundamentals = note_map.keys #.select { |k| k =~ /^[a-g]/ } # only base notes
  touched_notes = fundamentals.dup

  fundamentals.each do |fund|
    touched_notes.each do |touch|
      f_val = note_map[fund]
      t_val = note_map[touch]
      next unless f_val && t_val
      interval = t_val - f_val
      if INTERVAL_RULES[interval]
        sounding_val = f_val + INTERVAL_RULES[interval]
        sounding_note = @reverse_map[sounding_val]
        token = "<#{fund} #{touch}\\harmonic>"
        note_map[token] = sounding_val
      end
    end
  end
end
generate_chord_harmonics(note_map)


# --- Example usage ---
def transpose_notes(notes, interval, note_map)
  @reverse_map = {}
  note_map.each { |k,v| @reverse_map[v] ||= k }
  notes.map do |note|
    if note_map[note]
      semitone = note_map[note]
      transposed = semitone + interval
      @reverse_map[transposed] || note
    else
      note
    end
  end
end

# Test
#puts transpose_notes(["g'", "c''8\\harmonic", "<e'' a''\\harmonic>."], 2, note_map)

# --- Build reverse map for lookup ---
#@reverse_map = {}
#p note_map
#note_map.each { |k,v| @reverse_map[v] ||= k }
#p @reverse_map

# --- Scale generator ---
def scale(start_note, intervals, note_map, reverse_map)
  result = []
  current = note_map[start_note]
  result << start_note
  intervals.each do |step|
    current += step
    result << (reverse_map[current] || current.to_s)
  end
  result
end

# --- Example: C major scale (whole, whole, half, whole, whole, whole, half) ---
major_pattern = [2,2,1,2,2,2,1]
major_pattern = [1, 1,1, 1,1,1, 1, 1, 1,1, 1,1]

c_major_harmonic = scale("c''", major_pattern, note_map, @reverse_map)

puts "C major scale (harmonic mapping):"
puts c_major_harmonic.inspect
puts c_major_harmonic.join(" ")

# --- Example: G major scale starting from G string harmonic ---
g_major_harmonic = scale("f''", major_pattern, note_map, @reverse_map)
puts g_major_harmonic.join(" ")
g_major_harmonic = scale("f'''", major_pattern, note_map, @reverse_map)
puts g_major_harmonic.join(" ")
g_major_harmonic = scale("f''''", major_pattern, note_map, @reverse_map)
puts g_major_harmonic.join(" ")
g_major_harmonic = scale("f'''''", major_pattern, note_map, @reverse_map)
puts g_major_harmonic.join(" ")
g_major_harmonic = scale("f''''''", major_pattern, note_map, @reverse_map)

puts g_major_harmonic.join(" ")

puts "G major scale (harmonic mapping):"
puts g_major_harmonic.inspect
puts g_major_harmonic.join(" ")

