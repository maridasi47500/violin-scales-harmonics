def transpose_notes(notes, interval)
  note_map = {
    "c" => 0, "cis" => 1, "des" => 1, "d" => 2, "dis" => 3, "ees" => 3, "e" => 4, "eis" => 5, "fes" => 4, "f" => 5, "fis" => 6,
    "ges" => 6, "g" => 7, "gis" => 8, "aes" => 8, "a" => 9, "ais" => 10, "bes" => 10, "b" => 11, "bis" => 12, "ces" => 11,
    "c'" => 12, "cis'" => 13, "des'" => 13, "d'" => 14, "dis'" => 15, "ees'" => 15, "e'" => 16, "eis'" => 17, "fes'" => 16, "f'" => 17, "fis'" => 18,
    "ges'" => 18, "g'" => 19, "gis'" => 20, "aes'" => 20, "a'" => 21, "ais'" => 22, "bes'" => 22, "b'" => 23, "bis'" => 24, "ces'" => 23,
    "c''" => 24, "cis''" => 25, "des''" => 25, "d''" => 26, "dis''" => 27, "ees''" => 27, "e''" => 28, "eis''" => 29, "fes''" => 28, "f''" => 29, "fis''" => 30,
    "ges''" => 30, "g''" => 31, "gis''" => 32, "aes''" => 32, "a''" => 33, "ais''" => 34, "bes''" => 34, "b''" => 35, "bis''" => 36, "ces''" => 35,
    "c'''" => 36, "cis'''" => 37, "des'''" => 37, "d'''" => 38, "dis'''" => 39, "ees'''" => 39, "e'''" => 40, "eis'''" => 41, "fes'''" => 40, "f'''" => 41, "fis'''" => 42,
    "ges'''" => 42, "g'''" => 43, "gis'''" => 44, "aes'''" => 44, "a'''" => 45, "ais'''" => 46, "bes'''" => 46, "b'''" => 47, "bis'''" => 48, "ces'''" => 47,
    "c''''" => 48, "cis''''" => 49, "des''''" => 49, "d''''" => 50, "dis''''" => 51, "ees''''" => 51, "e''''" => 52, "eis''''" => 53, "fes''''" => 52, "f''''" => 53, "fis''''" => 54,
    "ges''''" => 54, "g''''" => 55, "gis''''" => 56, "aes''''" => 56, "a''''" => 57, "ais''''" => 58, "bes''''" => 58, "b''''" => 59, "bis''''" => 60, "ces''''" => 59
  }
  note_map["g'2^\flageolet"]=note_map["g'"]
  note_map["a''2^\flageolet"]=note_map["a''"]
  note_map["d''2^\flageolet"]=note_map["d''"]
  note_map["e'''2^\flageolet"]=note_map["e'''"]
  note_map["d''8\harmonic"]=note_map["g'''"]
  note_map["e''8\harmonic"]=note_map["e'''"]
note_map["c'8\\harmonic"] = note_map["g''"]
note_map["d'8\\harmonic"] = note_map["d''"]
note_map["a'8\\harmonic"] = note_map["a''"]
note_map["g'8\\harmonic"] = note_map["g'''"] #4 stringt
note_map["<e'' a''\\harmonic>."] = note_map["e''''"] #2 octave higher for a harmonic a fourth above
note_map["<f' c''\harmonic>"] = note_map["c''"] #2 octave higher for an harmonic fifth above
note_map["<f' c''\harmonic>"] = note_map["c''"] #1 octave higher for an harmonic fifth above
note_map["<as c'\harmonic>"] = note_map["c''"] #1 major third and 2 octave higher for an harmonic a major third above
note_map["<d' f'\harmonic>"] = note_map["c'''"] #3 octave higher minus 1 tone for an harmonic a minor third above



  # Build reverse map (choose one spelling per semitone)
  reverse_map = {}
  note_map.each { |k,v| reverse_map[v] ||= k }

  notes.map do |note|
    if note_map[note]
      semitone = note_map[note]
      transposed = semitone + interval
      reverse_map[transposed] || note # fallback if not found
    else
      note # leave unchanged if not recognized
    end
  end
end

# Example usage:
p transpose_notes(["c", "d", "e"], 2)   # => ["d", "e", "fis"]
p transpose_notes(["g'", "a'", "b'"], 12) # => octave up

