# Scholar
Simple formatting for creating homework assignments
<p align="center">
  <img width="400" alt="image" src="https://github.com/user-attachments/assets/af142161-3efa-442c-ae7c-4414d3733e92" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img width="400" height="1010" alt="image" src="https://github.com/user-attachments/assets/77f732d2-4b7f-4c7e-9d34-daf0a6a4cd1d" />
</p>

# Usage
There are three main functions
- ```homework-header```: Set the title and author name. Date will be set automatically
- ```homework-question```: A top level question, set a title and description. If you'd like numbering, do that manually with something like this: ```+ #homework-question(...)```
- ```homework-subquestion```: A sub question, meant to be nested under a top level question, likely numbered with ```+ #homework-subquestion```

### An Example
This example creates the page shown at the top

```typst
#import "@preview/finite:0.5.0": automaton, layout
#set text(size: 14pt)

#homework-header(
  title: "CS 4386 Homework 2",
  author-name: "Siddharth Narayan"
)

#homework-question(
  title: "Question I - FIRST and FOLLOW",
  desc: [
    For the following grammar
    $ 
      &S -> A a \
      &A -> B D \
      &B -> b \
      &B -> epsilon \
      &D -> d \
      &D -> epsilon
    $
  ]
)[
  + #homework-subquestion(desc: "Give the FIRST set for each symbol")[
    $ "FIRST"(a) = { a }$

    $ "FIRST"(b) = { b }$

    $ "FIRST"(c) = { c }$


    $"FIRST"(S) = { b, d, a }$ 

    $"FIRST"(A) = { b, d, epsilon }$ 

    $"FIRST"(B) = { b, epsilon }$ 

    $"FIRST"(D) = { d, epsilon }$ 
  ]
  
  + #homework-subquestion(desc: "Give the FOLLOW set for each of the nonterminals")[
    // #text(red)[Is $"FOLLOW"(S) =  epsilon$ or is it \$ ]

    $"FOLOW"(S) = { \$ }$
    
    $"FOLOW"(A) = { a }$
    
    $"FOLOW"(B) = { d, a }$
    
    $"FOLOW"(D) = { a }$
  ]
]

#pagebreak()
#homework-question(
  title: "Question III - LR Parsing",
  desc: [
    Make an LR(0) automaton for the following CFG

    $
      &S' -> S \
      &S -> A a \
      &S -> B b \
      &S -> a c \
      &A -> a \
      &B -> b
    $

    
  ]
)[
  First compute the closure of $S'$ (And the start state)

  $I_0 = {S' -> .S, S ->.A a, S -> .B b, S -> .a c, A ->.a, B -> .b}$

  Now compute GOTO transitions. Let's color reduce states with blue, to make it clear that we won't include these states in the final DFA. Green is the accepting state
  
  #grid(columns: 2, column-gutter: 3em)[
  $I_1 = "GOTO"(I_0, S) = { #color-math($S' -> S.$, green.darken(30%))}$
  
  $I_2 = "GOTO"(I_0, A) = { S -> A.a}$

  $I_3 = "GOTO"(I_0, B) = { S -> B.b}$

  $I_4 = "GOTO"(I_0, a) = { S -> a.c, #color-math($A-> a.$, blue)}$

  $I_5 = "GOTO"(I_0, b) = { #color-math($B -> b.$, blue)}$
  
  #line()
  // Second level GOTOs
  $I_6 = "GOTO"(I_2, a) = { #color-math($S -> A a.$, blue)}$

  $I_7 = "GOTO"(I_3, b) = { #color-math($S -> B b.$, blue)}$

  $I_8 = "GOTO"(I_4, c) = { #color-math($S -> a c.$, blue)}$
  ][
  #let curve-strength = .3
  #let neg-curve = (curve: -curve-strength, label: (dist: -.5))
  #let straight = (curve: 0)

  #automaton(
    (
      I0:       (I2: "a", I3: "b"),
      I1:       (),
      I2:       (I1: "a, c",),
      I3:       (I1: "b"),
      // I4:       (I1: "c"),
    ),
    initial: "I0",
    final: ("I1",),
    style: (
      state: (fill: luma(250)),
      transition: (curve: curve-strength, label: (angle: 0deg, dist: .5), stroke: luma(80)),
      I0-I3: neg-curve,
      I3-I1: neg-curve,
      // I0-I4: neg-curve,
      // I4-I1: neg-curve,
    ),
    layout: layout.custom.with(positions: (
        I0: (0, 0),
        I1: (0, -8),
        I2: (2, -4),
        I3: (-2, -4),
        I4: (-2, -4),
      ))
  )
  ]

  #v(2em)
  In this case, the grammar is (technically) ambiguous. After a top level '`a`' character is received, while we're at $I_0$, it's unclear whether we've we should reduce to $A$ (GOTO $I_2$) or GOTO $I_4$. With some manual messing around though, it's clear that after we receive an '`a`' at $I_0$, to get to the accept state we can _either_ receive another '`a`' *or* we can receive a '`c`'.
]
```
