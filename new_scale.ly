
\version "2.24.3"

\header {
  title = "c' violin scale"
}

global = {
  \key c \major
  \time 4/4
}

violin = \absolute  {
  \global
  % En avant la musique.
  c' d' e' f' g' a' b' c'' b' a' g' f' e' d' c' \break c' ees' g' c'' g' ees' c' \break c' e' g' c'' g' e' c' \break c' e' a' c'' a' e' c' \break c' f' a' c'' a' f' c' \break c' f' as' c'' as' f' c' \break c' ees' ges' a' c'' a' ges' ees' c' \break c' e' g' bes' c'' bes' g' e' c' \break c' e' d' f' e' g' f' a' g' b' a' c'' a' b' g' a' f' g' e' f' d' e' c' \break c' des' d' ees' e' f' ges' g' as' a' bes' b' c'' \break c'' d'' e'' f'' g'' a'' b'' c''' b'' a'' g'' f'' e'' d'' c'' \break c'' ees'' g'' c''' g'' ees'' c'' \break c'' e'' g'' c''' g'' e'' c'' \break c'' e'' a'' c''' a'' e'' c'' \break c'' f'' a'' c''' a'' f'' c'' \break c'' f'' as'' c''' as'' f'' c'' \break c'' ees'' ges'' a'' c''' a'' ges'' ees'' c'' \break c'' e'' g'' bes'' c''' bes'' g'' e'' c'' \break c'' e'' d'' f'' e'' g'' f'' a'' g'' b'' a'' c''' a'' b'' g'' a'' f'' g'' e'' f'' d'' e'' c'' \break c'' des'' d'' ees'' e'' f'' ges'' g'' as'' a'' bes'' b'' c''' \break c''' d''' e''' f''' g''' a''' b''' c'''' b''' a''' g''' f''' e''' d''' c''' \break c''' ees''' g''' c'''' g''' ees''' c''' \break c''' e''' g''' c'''' g''' e''' c''' \break c''' e''' a''' c'''' a''' e''' c''' \break c''' f''' a''' c'''' a''' f''' c''' \break c''' f''' as''' c'''' as''' f''' c''' \break c''' ees''' ges''' a''' c'''' a''' ges''' ees''' c''' \break c''' e''' g''' bes''' c'''' bes''' g''' e''' c''' \break c''' e''' d''' f''' e''' g''' f''' a''' g''' b''' a''' c'''' a''' b''' g''' a''' f''' g''' e''' f''' d''' e''' c''' \break c''' des''' d''' ees''' e''' f''' ges''' g''' as''' a''' bes''' b''' c'''' \break 
}
\score {
  \new Staff \with {
    instrumentName = "Violon"
    midiInstrument = "violin"
  } \violin
  \layout { }
  \midi {
    \tempo 4=100
  }
}
