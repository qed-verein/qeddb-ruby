#let logo = image.with("./logo.svg")
#let tex-par = arguments(leading: 0.65em, spacing: 1.55em, justify: true)
#let default-margins = (
  left: 20mm,
  right: 20mm,
  top: 45mm,
  top-ascent: 10mm,
  bottom-additional: 20mm,
  bottom-descent: 10mm,
)

#let sender-state = state("sender", [])
#let subject-state = state("subject", none)
 
#let letter_header() = block(context {
  let address = sender-state.final()
  let address-height = measure(address).height
  grid(
    columns: (1fr, auto),
    address, logo(height: address-height),
  )
  v(-1em)
  line(length: 100%, stroke: 0.5pt)
})

#let letter_footer() = {
  set text(size: 9pt)
  show grid.cell.where(y: 0): strong
  block(
    grid(
      columns: (1fr, 1fr, 0.7fr, auto),
      // columns: 4,
      column-gutter: 1em,
      row-gutter: 0.55em,
      [Adresse], [Internet], [Vorstand], [Bankverbindung],
      sys.inputs.at("footer.adresse", default: ""),
      sys.inputs.at("footer.internet", default: ""),
      sys.inputs.at("footer.vorstand", default: ""),
      sys.inputs.at("footer.bankverbindung", default: "")
    ),
  )
}
 
#let letter(it, margin: (:)) = {
  set par(..tex-par)
  let header = letter_header()
  let footer = letter_footer()
  margin = default-margins + margin
  context {
    let head-height = measure(
      block(header),
      width: 21cm - margin.left - margin.right,
    ).height
    let foot-height = measure(
      block(footer),
      width: 21cm - margin.left - margin.right,
    ).height
    set page(
      margin: (
        left: margin.left,
        right: margin.right,
        top: margin.top,
        bottom: foot-height + margin.bottom-additional,
      ),
      header: header,
      footer: footer,
      footer-descent: margin.bottom-descent,
      header-ascent: margin.top-ascent,
    )
 
    v(17.7mm + 27.7mm + 8.46mm)
    block(inset: (left: 5mm))[
      #let subject = subject-state.final()
      #if subject != none { strong[#subject]; v(2em) } else { v(4em) }
      #it
    ]
 
    place(top + left, dy: 105mm - margin.top, dx: -margin.left)[#line(length: 5mm, stroke: 0.5pt)]
    place(top + left, dy: 210mm - margin.top, dx: -margin.left)[#line(length: 5mm, stroke: 0.5pt)]
    place(top + left, dy: 148.5mm - margin.top, dx: -margin.left)[#line(length: 7mm, stroke: 0.5pt)]
  }
}

#let sender(it) = {
  sender-state.update(_ => it)
}
 
#let subject(it) = {
  subject-state.update(_ => it)
}