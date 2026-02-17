
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
  c'8\harmonic a'8\harmonic e'8^\harmonic <c' f'\harmonic> g'8\harmonic e''8harmonic b'8^\harmonic <g' c''\harmonic>  \break d'8\harmonic <as ees'\harmonic> <a e'\harmonic> <bes f'\harmonic> <b fis'\harmonic> c'8\harmonic <as cis'\harmonic> a'8\harmonic <bes ees'\harmonic> e'8^\harmonic <c' f'\harmonic> <cis' fis'\harmonic> g'8\harmonic  \break c'8\harmonic <as cis'\harmonic> a'8\harmonic <bes ees'\harmonic> e'8^\harmonic <c' f'\harmonic> <cis' fis'\harmonic> g'8\harmonic <ees' as'\harmonic> e''8harmonic <f' bes'\harmonic> b'8^\harmonic <g' c''\harmonic>  \break 
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
