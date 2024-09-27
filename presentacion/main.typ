#import "slides.typ": *


#show: slides.with(
  title: "Tesis De Maestría", // Required
  subtitle:"Test de Hipótesis Sobre Homología Persistente Utilizando la Distancia de Fermat" ,
  university: "Universidad de Buenos Aires - Facultad De Ciencias Exactas y Naturales",
  tutor: "Dr. Pablo Groisman",
  date: none,
  authors: "Diego Javier Battocchio",
  layout: "medium",
  ratio: 4/3,
  title-color: none,
)

#heading(level: 2, outlined: false)[Contenidos]
#outline(title: none, depth: 2, indent: 1em)

#set heading(numbering: "1.")


= Qué buscamos y qué encontramos

#frame(counter: "Buscamos", color: INFORMATIVE_COLOR)[
  - Validar
  -
]

#frame(counter: "Encontramos", color: rgb("#157d17"))[
  #lorem(20)
]

= Conceptos Utilizados

#include("conceptos.typ")

= Técnicas y Algoritmos

// == Intervalos de Confianza

#definition(title: "asdads", color: rgb("#57a778"))[
  #lorem(20)
]

= Conjuntos de datos utilizados

#include("datos.typ")


#bibliography("references.bib", title: "Referencias")
