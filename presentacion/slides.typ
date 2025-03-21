#let POSITIVE_COLOR = rgb("#157d17")
#let NEGATIVE_COLOR = rgb("#ff2e2e")
#let INFORMATIVE_COLOR = rgb("#4865f6")
#let EXTRA_INFO_COLOR = rgb("#bac00c")


#let default-color = blue.darken(40%)
#let header-color = default-color.lighten(75%)
#let body-color = default-color.lighten(85%)

#let layouts = (
  "small": ("height": 9cm, "space": 1.4cm),
  "medium": ("height": 10.5cm, "space": 1.6cm),
  "large": ("height": 12cm, "space": 1.8cm),
)

#let slides(
  content,
  title: none,
  subtitle: none,
  date: none,
  authors: (),
  layout: "medium",
  ratio: 4/3,
  title-color: none,
  university: none,
  tutor: none,
) = {

  // Parsing
  if layout not in layouts {
      panic("Unknown layout " + layout)
  }
  let (height, space) = layouts.at(layout)
  let width = ratio * height

  // Colors
  if title-color == none {
      title-color = default-color
  }

  // Setup
  set document(
    title: title,
    author: authors,
  )
  set page(
    width: width,
    height: height,
    margin: (x: 0.5 * space, top: space * 1.2, bottom: 0.6 * space),
    header: context {
      let page = here().page()
      let headings = query(selector(heading))
      let heading = headings.rev().find(x => x.location().page() <= page)
      if heading != none {
        set align(top)
        v(space / 2.5)
        let offset_numbering = if heading.depth > 1 {1} else {2}
        let starting_numbering = if heading.depth > 1 {1} else {0}
        let head_numbering = if heading.location().page() <= (page - offset_numbering) {
          " " + numbering("(I)", page - heading.location().page() + starting_numbering)
        }
        if heading.depth == 3 {
          let filtered_headings = headings.filter(x => x.depth == 2 or x.location().page() == heading.location().page())
          let body_ix = filtered_headings.position(x => x == heading)
          let prev_body = filtered_headings.at(body_ix - 1).body
          // let prev_body = headings.rev().find(
          //   x => x.depth <= 2 and x.location().page() < heading.location().page()
          // ).body
          let prev_heading_text = text(1.3em, weight: "bold", fill: title-color, prev_body)
          let heading_text = text(1.1em, weight: "bold", fill: title-color, heading.body + head_numbering)
          let header_block = grid(
            columns: (1.5fr, 1fr),
            align(left, prev_heading_text),
            align(right, heading_text)
          )
          block(header_block , below: 0.6em)
        } else {
          let heading_text = text(1.3em, weight: "bold", fill: title-color, heading.body + head_numbering)
          block(heading_text, below: 0.6em)
        }
        line(length: 100%, stroke: title-color)
      }
    },
    header-ascent: 0%,
    footer: context {
      set text(0.8em)
      set align(right)
      counter(page).display("1/1", both: true)
    },
    footer-descent: space / 3,
  )

  // set bibliography(
  //   title: none
  // )

  // Rules
  show heading.where(level: 1): x => {
    set page(header: none, footer: none)
    set align(center + horizon)
    set text(1.2em, weight: "bold", fill: title-color)
    v(- space / 2)
    x.body
  }
  show heading.where(level: 2): pagebreak(weak: true)
  show heading.where(level: 3): pagebreak(weak: true)
  show heading: set text(1.1em, fill: title-color)

  // Title
  if (title == none) {
    panic("A title is required")
  }
  else {
    if (type(authors) != array) {
      authors = (authors,)
    }
    set page(footer: none)
    set align(center)
    v(- space / 1.3)
    block(
      text(1.6em, weight: "bold", fill: title-color, title) +
      v(1.4em, weak: true) +
      if subtitle != none { text(1.1em, weight: "bold", fill: title-color, subtitle) } +
      if subtitle != none and date != none { text(1.1em)[ \- ] } +
      v(1em, weak: true) +
      figure(image("imagenes/logo.png", width: 40%)) +
      if date != none {text(1.1em, date)} +
      v(1em, weak: true) +
      if university != none {text(0.9em, weight: "bold", university)} +
      v(1em, weak: true) +
      text(0.8em, authors.join(", ", last: " and ")) +
      v(0.8em, weak: true) +
      if tutor != none {text(0.8em, "Director: " + tutor)}
    )
  }

  // Content
  content
}

#let frame(content, counter: none, title: none, color: none) = {

  let color = if color != none {color} else {body-color}
  let header = none
  if counter == none and title != none {
    header = [*#title.*]
  }
  else if counter != none and title == none {
    header = [*#counter*]
  }
  else {
    header = [*#counter:* #title.]
  }

  show stack: set block(breakable: false, above: 0.8em, below: 0.8em)

  stack(
    block(
      width: 100%,
      fill: color.lighten(20%),
      radius: (top: 0.3em),
      inset: (x: 0.6em, top: 0.40em, bottom: 0.40em),
      header
    ),
    block(
      width: 100%,
      fill: color.lighten(55%),
      radius: (bottom: 0.3em),
      inset: (x: 0.6em, top: 0.40em, bottom: 0.40em),
      content
    ),
  )
}


#let message(body, fill: red) = {
  set text(white, size: 0.95em)
  set block(width: 100%, breakable: false, above: 0.5em, below: 0.5em)

  block(
    fill: fill.lighten(10%),
    inset: 0.9em,
    radius: 4pt,
    above: 1em,
    below: 1em,
    [*#body*],
  )
}

#let subtitle_emph(body, color: none, alignment: none) = {
  let fill = if color != none {color} else {INFORMATIVE_COLOR}
  set text(1.1em, weight: "bold", fill: fill)
  if alignment != none {
    set align(alignment)
  }

  block(body, inset: 0em, above: 1.5em, below: 1.5em)
}
