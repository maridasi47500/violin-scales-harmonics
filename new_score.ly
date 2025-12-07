
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
  c'' d''2^\flageolet <a e'\harmonic> <bes f'\harmonic> c'8\harmonic a''2^\flageolet <e' b'\harmonic> <f' c''\harmonic> \breakd'' <as ees'\harmonic> <a e'\harmonic> <bes f'\harmonic> <b ges'\harmonic> c'8\harmonic <des' as'\harmonic> a''2^\flageolet <ees' bes'\harmonic> <e' b'\harmonic> <f' c''\harmonic> <ges' des''\harmonic> <g' d''\harmonic> \breakg'' <des' as'\harmonic> a''2^\flageolet <ees' bes'\harmonic> <e' b'\harmonic> <f' c''\harmonic> <ges' des''\harmonic> <g' d''\harmonic> <as' ees''\harmonic> e'''2^\flageolet <bes' f''\harmonic> <b' ges''\harmonic> g'8\harmonic \break
}
\score {
  \new Staff \with {
    instrumentName = "Violon"
    midiInstrument = "violin"
  } \violin
  layout { }
  \midi {
    \tempo 4=100
  }
}
