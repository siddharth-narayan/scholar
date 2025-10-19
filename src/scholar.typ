#let color-math(x, color) = text(fill: color)[$#x$]

#let homework-header(title: none, author-name: none) = {
  align(center, [
    = #title
    #align(left, [
      == #author-name
      == #datetime.today().display("[month]/[day]/[year]")
    ])
  ])

  v(2em)
}

#let homework-question(
  body,
  title: none,
  desc: none,
  show-answers: true
) = {
  box()[
    *#title*

    _#desc _

    #v(1em)
    #set enum(indent: 1em, spacing: 2em)
    
    #if show-answers { body }

    #v(3em)
  ]
}

#let homework-subquestion(
  body,
  desc: none,
) = {
  box()[
    _#desc _
    #v(1em)
    #body
    #v(2em)
  ]
}
