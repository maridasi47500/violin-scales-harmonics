# --- NoteMap for LilyPond with Harmonics ---
class NoteMap
  attr_reader :map, :reverse_map, :key, :scale

  BASE_NOTES = {
    "c"=>0, "cis"=>1, "des"=>1, "d"=>2, "dis"=>3, "ees"=>3,
    "e"=>4, "f"=>5, "fis"=>6, "ges"=>6, "g"=>7, "gis"=>8,
    "as"=>8, "a"=>9, "ais"=>10, "bes"=>10, "b"=>11
  }

  OCTAVES = ["", "'", "''", "'''", "''''", "'''''", "''''''"]

  def initialize
    @map, @reverse_map = {}, {}
    build_base_notes
    build_reverse_map
  end

  def set_key_and_scale(key="c", scale="major")
    @key, @scale = key, scale
  end

  # --- Base notes across octaves ---
  def build_base_notes
    OCTAVES.each_with_index do |marks, i|
      BASE_NOTES.each { |name, val| @map["#{name}#{marks}"] = val + 12*i }
    end
  end

  # --- Reverse map for lookup (support enharmonics) ---
  def build_reverse_map
    @reverse_map = {}
    @map.each { |k,v| (@reverse_map[v] ||= []) << k }
  end

  # --- Transpose notes ---
  def transpose(notes, interval)
    notes.map do |note|
      if @map[note]
        semitone = @map[note] + interval
        (@reverse_map[semitone] || [note]).first
      else
        note
      end
    end
  end

  # --- Scale generator ---
  def scale(start_note, intervals, doublestop=0)
    current = @map[start_note]
    result = [start_note]
    intervals.each.with_index do |step,interval_id|
      current += step
      note = (@reverse_map[current] || ["?"]).first
      if doublestop != 0
        double = build_double_stop(current, intervals, doublestop,interval_id)

        result << "<#{note} #{double}>"
      else
        result << note
      end
    end
    result << "\\break"
    result
  end

  INTERVAL_QUALITIES = {
    1 => {0=>"perfect", 1=>"augmented"}, # unison
    2 => {1=>"minor", 2=>"major", 3=>"augmented"},
    3 => {3=>"minor", 4=>"major", 5=>"augmented"},
    4 => {5=>"perfect", 4=>"diminished", 6=>"augmented"},
    5 => {7=>"perfect", 6=>"diminished", 8=>"augmented"},
    6 => {8=>"minor", 9=>"major", 7=>"diminished", 10=>"augmented"},
    7 => {10=>"minor", 11=>"major", 9=>"diminished", 12=>"augmented"},
    8 => {12=>"perfect", 11=>"diminished", 13=>"augmented"}
  }

  # --- Interval classifier ---
  def interval_class(chord_token)
    # Extract notes inside <...>
    notes = chord_token.gsub(/[<>]/,"").split
    return "Need exactly 2 notes" unless notes.size == 2

    n1, n2 = notes
    v1, v2 = @map[n1], @map[n2]
    return "Unknown notes" unless v1 && v2

    semitones = (v2 - v1).abs

    # Generic interval number (letter distance)
    letter1, letter2 = n1[0], n2[0]
    interval_number = ((letter2.ord - letter1.ord) % 7) + 1

    quality = INTERVAL_QUALITIES[interval_number][semitones] || "unknown"

    "#{quality} #{interval_name(interval_number)} (#{semitones} semitones)"
  end

  def interval_name(num)
    %w[unison second third fourth fifth sixth seventh octave][num-1]
  end


  private

  def build_double_stop(current, intervals, doublestop,interval_id)
    myinterval, mystep = 0, (intervals.length - interval_id - (doublestop.even? ? 0 : 1))
    p "current #{current}"
    while myinterval.abs < doublestop.abs
      if doublestop > 0
      step = intervals[(intervals.length + mystep) % intervals.length]
      else 
      step = intervals[-(intervals.length + mystep) % intervals.length]
      end
      myinterval += doublestop > 0 ? step : -step
      mystep += 1
    end
    x=(@reverse_map[current + myinterval] || ["?"]).first
    x
  end
end

# --- Pattern Library ---
PATTERNS = {
  major: [2,2,1,2,2,2,1],
  natural_minor: [2,1,2,2,1,2,2],
  harmonic_minor: [2,1,2,2,1,3,1],
  melodic_minor: [2,1,2,2,2,2,1],
  chromatic: [1]*12,
  thirds: [3,4,5],
  fourths: [4,3,5],
  fifths: [5,4,3],
  tritone_walk: [4,-2,3,-1,3,-2,4,-2,4,-2,3]
}

# --- LilyPond Score Builder ---
def build_score(title, body)
  <<~LY
  \\version "2.24.3"

  \\header {
    title = "#{title}"
  }

  global = {
    \\key c \\major
    \\time 4/4
  }

  violin = \\absolute {
    \\global
    #{body}
  }

  \\score {
    \\new Staff \\with {
      instrumentName = "Violin"
      midiInstrument = "violin"
    } \\violin
    \\layout { }
    \\midi { \\tempo 4=100 }
  }
  LY

end

# --- Example Usage ---
note_map = NoteMap.new
note_map.set_key_and_scale("c", "major")

hello = ""
["c'", "c''"].each do |note|
  hello << " " + note_map.scale(note, PATTERNS[:major]).join(" ")
  hello << " " + note_map.scale(note, PATTERNS[:major], doublestop=2).join(" ")
  hello << " " + note_map.scale(note, PATTERNS[:major], doublestop=4).join(" ")
  hello << " " + note_map.scale(note, PATTERNS[:major], doublestop=3).join(" ")
  hello << " " + note_map.scale(note, PATTERNS[:major], doublestop=-8).join(" ")
  hello << " " + note_map.scale(note, PATTERNS[:major], doublestop=12).join(" ")
  hello << " " + note_map.scale(note, PATTERNS[:chromatic], doublestop=4).join(" ")
end

score = build_score("C violin scale", hello)
File.write("new_scale.ly", score)

puts "Transpose example:"
puts note_map.transpose(["g'", "c''", "<e'' a''>"], 2).join(" ")

note_map = NoteMap.new

puts note_map.interval_class("<c' a'>")
# => "major sixth (9 semitones)"

puts note_map.interval_class("<c' as'>")
# => "minor sixth (8 semitones)"

puts note_map.interval_class("<c' gis'>")
# => "diminished sixth (7 semitones)"

puts note_map.interval_class("<cis' f'>")
# => "diminished fourth (5 semitones)"

