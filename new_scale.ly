\version "2.24.3"

\header {
  title = "C violin scale"
}

global = {
  \key c \major
  \time 4/4
}

violin = \absolute {
  \global
   c' d' e' f' g' a' b' c'' \break c' <d' e'> <e' g'> <f' g'> <g' a'> <a' b'> <b' d''> <c'' d''> \break c' <d' fis'> <e' a'> <f' ais'> <g' b'> <a' cis''> <b' e''> <c'' f''> \break c' <d' f'> <e' g'> <f' a'> <g' b'> <a' c''> <b' d''> <c'' e''> \break c' <d' f> <e' g> <f' a> <g' b> <a' c'> <b' d'> <c'' e'> \break c' <d' d''> <e' e''> <f' f''> <g' g''> <a' a''> <b' b''> <c'' c'''> \break c' <cis' f'> <d' fis'> <dis' g'> <e' gis'> <f' a'> <fis' ais'> <g' b'> <gis' c''> <a' cis''> <ais' d''> <b' dis''> <c'' e''> \break c'' d'' e'' f'' g'' a'' b'' c''' \break c'' <d'' e''> <e'' g''> <f'' g''> <g'' a''> <a'' b''> <b'' d'''> <c''' d'''> \break c'' <d'' fis''> <e'' a''> <f'' ais''> <g'' b''> <a'' cis'''> <b'' e'''> <c''' f'''> \break c'' <d'' f''> <e'' g''> <f'' a''> <g'' b''> <a'' c'''> <b'' d'''> <c''' e'''> \break c'' <d'' f'> <e'' g'> <f'' a'> <g'' b'> <a'' c''> <b'' d''> <c''' e''> \break c'' <d'' d'''> <e'' e'''> <f'' f'''> <g'' g'''> <a'' a'''> <b'' b'''> <c''' c''''> \break c'' <cis'' f''> <d'' fis''> <dis'' g''> <e'' gis''> <f'' a''> <fis'' ais''> <g'' b''> <gis'' c'''> <a'' cis'''> <ais'' d'''> <b'' dis'''> <c''' e'''> \break
}

\score {
  \new Staff \with {
    instrumentName = "Violin"
    midiInstrument = "violin"
  } \violin
  \layout { }
  \midi { \tempo 4=100 }
}
