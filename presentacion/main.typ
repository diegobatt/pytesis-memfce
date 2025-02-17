#import "slides.typ": *


#show: slides.with(
  title: "Tesis De Maestría", // Required
  subtitle:"Test de Hipótesis Sobre Homología Persistente Utilizando la Distancia de Fermat" ,
  university: "Universidad de Buenos Aires - Facultad De Ciencias Exactas y Naturales",
  tutor: "Dr. Pablo Groisman",
  date: none,
  authors: "Diego Javier Battocchio",
  layout: "large",
  ratio: 4/3,
  title-color: none,
)

#heading(level: 2, outlined: false)[Contenidos]
#outline(title: none, depth: 2, indent: 1em)

#set text(10pt)
#set heading(numbering: "1.")


= Qué buscamos y qué aprendimos

#include("intro.typ")

= Conceptos Utilizados

#include("conceptos.typ")

= Técnicas y desarrollo

#include("desarrollo.typ")

= Conjuntos de datos utilizados

#include("datos.typ")

= Resultados

#include("resultados.typ")


#bibliography("references.bib", title: "Referencias")
