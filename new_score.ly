
\version "2.24.3"

\header {
  title = "violin scales"
}

global = {
  \key c \major
  \time 4/4
}

violin = \absolute  {
  \global
  % En avant la musique.
  c'8\harmonic a'8\harmonic e'8^\harmonic <f' c''\harmonic> g'8\harmonic e''8harmonic <b' ges''\harmonic> <c'' g''\harmonic>  \break d'8\harmonic <as dis'\harmonic> <a e'\harmonic> <bes f'\harmonic> b'8^\harmonic c'8\harmonic <cis' gis'\harmonic> a'8\harmonic <ees' ais'\harmonic> e'8^\harmonic <f' c''\harmonic> ges''8^\harmonic g'8\harmonic  \break c'8\harmonic <cis' gis'\harmonic> a'8\harmonic <ees' ais'\harmonic> e'8^\harmonic <f' c''\harmonic> ges''8^\harmonic g'8\harmonic <as' dis''\harmonic> e''8harmonic <bes' f''\harmonic> <b' ges''\harmonic> <c'' g''\harmonic>  \break 
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
