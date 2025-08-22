#import "slides.typ": *

#set table(stroke: none, inset: 0.4em,)

#let emph_cell(body, good: true) = {
  let color = if good { POSITIVE_COLOR } else { NEGATIVE_COLOR }
  let color = color.lighten(70%)
  table.cell(fill: color, stroke: color)[#body]
}

#let normal_cell(body) = {
  table.cell(fill: gray.lighten(70%))[#body]
}

#v(2em)

#subtitle_emph()[Diagramas de Persistencia]

#list(
  spacing: 1.5em,
  [Sub-muestreo con distancia euclídea #h(0.5em) #text(fill: POSITIVE_COLOR)[$times$ Todos los conjuntos de datos]],
  [Sub-muestreo con distancia de Fermat #h(0.5em) #text(fill: POSITIVE_COLOR)[$times$ Todos los conjuntos de datos]],
  [Bootstrap con estimación por densidad #h(0.5em) #text(fill: POSITIVE_COLOR)[$times$ Todos los conjuntos de datos]]
)

#v(2em)

#subtitle_emph()[Potencia]

- $M = 50$ repeticiones de detección de agujeros #h(0.5em) #text(fill: POSITIVE_COLOR)[$times$ Conjuntos de datos literatura y adicionales]


== Diagramas de Persistencia

=== Circunferencia Uniforme

#subtitle_emph()[Original]
#figure(image("imagenes/resultados/circulo-base.png", width: 75%))

#subtitle_emph()[Ruido]
#figure(image("imagenes/resultados/circulo-noise.png", width: 74.2%))

#subtitle_emph()[Datos Atípicos]
#figure(image("imagenes/resultados/circulo-outliers.png", width: 74%))


=== Circunferencia Gaussiana

#subtitle_emph()[Original]
#figure(image("imagenes/resultados/circulo-gaussiano-base.png", width: 75%))

#subtitle_emph()[Ruido]
#figure(image("imagenes/resultados/circulo-gaussiano-noise.png", width: 75%))

#subtitle_emph()[Datos Atípicos]
#figure(image("imagenes/resultados/circulo-gaussiano-outliers.png", width: 75%))


=== Anteojos

#subtitle_emph()[Original]
#figure(image("imagenes/resultados/anteojos-base.png", width: 75%))

#subtitle_emph()[Ruido]
#figure(image("imagenes/resultados/anteojos-noise.png", width: 75%))

#subtitle_emph()[Datos Atípicos]
#figure(image("imagenes/resultados/anteojos-outliers.png", width: 75%))

=== Círculo Relleno

#figure(image("imagenes/resultados/circulo-relleno.png", width: 75%))

=== Jugadores de Fútbol

#subtitle_emph()[Defensor Central (2)]
#figure(image("imagenes/resultados/jugador-2.png", width: 75%))

#subtitle_emph()[Mediocampista (5)]
#figure(image("imagenes/resultados/jugador-5.png", width: 75%))

#subtitle_emph()[Lateral Izquierdo (8)]
#figure(image("imagenes/resultados/jugador-8.png", width: 75%))

#subtitle_emph()[Mediocampista (14)]
#figure(image("imagenes/resultados/jugador-14.png", width: 75%))

== Dimensiones Superiores

#v(3em)


#align(center)[#table(
  columns: 4,
  align: center,
  table.vline(x: 1, start: 2, stroke: gray),
  table.hline(stroke: gray),
  [],  table.cell(colspan: 3)[*Método*],
  table.hline(stroke: gray),
  [*Dimensiones $D$*],  [*Euclídeo*], [*Fermat*], [*KDE*],
  table.hline(stroke: gray),
  [2], emph_cell[8.99], emph_cell[8.07], emph_cell[2.28],
  [3], emph_cell[8.43], emph_cell[8.00], emph_cell(good: false)[31.65],
  [4], emph_cell[9.06], emph_cell[8.37], emph_cell(good: false)[1501.22],
)]

// #figure(image("imagenes/resultados/tiempos-dimensiones.png", width: 55%))
#v(4em)


#message(fill: NEGATIVE_COLOR)[
  KDE demora exponencialmente más tiempo para dimensiones superiores a $D = 2$
]

== Potencia

=== Base

#v(4em)

// #figure(image("imagenes/resultados/circulo-potencia.png", width: 100%))

#let table_resize = 100%
#scale(x: table_resize, y: table_resize)[#align(center)[#table(
  columns: 5,
  align: center,
  table.vline(x: 1, start: 2, stroke: gray),
  table.vline(x: 2, start: 2, stroke: gray),
  table.hline(stroke: gray),
  [], [],  [*Circunferencia Uniforme*], [*Circunferencia Gaussiana*], [*Anteojos*],
  [*Métodos*], [*Agujeros*],  [], [], [],
  table.hline(stroke: gray),
  table.cell(rowspan: 2)[Euclídeo],
    [1], emph_cell[100%], emph_cell[100%], emph_cell(good: false)[0],
    [2], emph_cell[0], emph_cell[0], emph_cell(good: false)[100%],
  table.cell(rowspan: 2)[Fermat],
    [1], emph_cell[100%], emph_cell[100%], emph_cell[100%],
    [2], emph_cell[0], emph_cell[0], emph_cell[0],
  table.cell(rowspan: 2)[Kde],
    [1], emph_cell[100%], emph_cell[100%], emph_cell(good: false)[0],
    [2], emph_cell[0], emph_cell[0], emph_cell(good: false)[100%],
)]]

// #message(fill: POSITIVE_COLOR)[
//   Fermat es el único método que logra identificar correctamente la existencia de un único agujero para el conjunto de datos de anteojos.
// ]

=== Ruido Agregado

#v(4em)

#scale(x: table_resize, y: table_resize)[#align(center)[#table(
  columns: 5,
  align: center,
  table.vline(x: 1, start: 2, stroke: gray),
  table.vline(x: 2, start: 2, stroke: gray),
  table.hline(stroke: gray),
  [], [],  [*Circunferencia Uniforme*], [*Circunferencia Gaussiana*], [*Anteojos*],
  [*Métodos*], [*Agujeros*],  [], [], [],
  table.hline(stroke: gray),
  table.cell(rowspan: 2)[Euclídeo],
    [1], emph_cell[100%], emph_cell[100%], emph_cell(good: false)[0],
    [2], emph_cell[0], emph_cell[0], emph_cell(good: false)[100%],
  table.cell(rowspan: 2)[Fermat],
    [1], emph_cell[100%], emph_cell[100%], emph_cell[98%],
    [2], emph_cell[0], emph_cell[0], emph_cell(good: false)[2%],
  table.cell(rowspan: 2)[Kde],
    [1], emph_cell[100%], emph_cell[100%], emph_cell(good: false)[0],
    [2], emph_cell[0], emph_cell[0], emph_cell(good: false)[100%],
)]]

// #message(fill: POSITIVE_COLOR)[
//   Similar al caso sin ruido, Fermat logra mayoritariamente detectar un único agujero en los anteojos para el 98% de las corridas
// ]

=== Datos Atípicos

#v(1em)

#let table_resize_outliers = 100%
#scale(x: table_resize_outliers, y: table_resize_outliers)[#align(center)[#table(
  columns: 5,
  align: center,
  inset: 0.3em,
  table.vline(x: 1, start: 2, stroke: gray),
  table.vline(x: 2, start: 2, stroke: gray),
  table.hline(stroke: gray),
  [], [],  [*Circunferencia Uniforme*], [*Circunferencia Gaussiana*], [*Anteojos*],
  [*Métodos*], [*Agujeros*],  [], [], [],
  table.hline(stroke: gray),
  table.cell(rowspan: 4)[Euclídeo],
    [0], emph_cell[0], emph_cell[0], emph_cell(good: false)[8%],
    [1], emph_cell[100%], emph_cell[100%], emph_cell(good: false)[80%],
    [2], emph_cell[0], emph_cell[0], emph_cell(good: false)[12%],
    [3], emph_cell[0], emph_cell[0], emph_cell[0],
  table.cell(rowspan: 4)[Fermat],
    [0], emph_cell[0], emph_cell[0], emph_cell[0],
    [1], emph_cell[98%], emph_cell[100%], emph_cell[84%],
    [2], emph_cell(good: false)[2%], emph_cell[0], emph_cell(good: false)[14%],
    [3], emph_cell[0], emph_cell[0], emph_cell(good: false)[2%],
  table.cell(rowspan: 4)[Kde],
    [0], emph_cell[0], emph_cell[0], emph_cell[0],
    [1], emph_cell[100%], emph_cell[100%], emph_cell[0],
    [2], emph_cell[0], emph_cell[0], emph_cell(good: false)[100%],
    [3], emph_cell[0], emph_cell[0], emph_cell[0],
)]]

// #message(fill: POSITIVE_COLOR)[
//   Similar al caso sin ruido, Fermat logra mayoritariamente detectar un único agujero en los anteojos para el 98% de las corridas
// ]


=== Círculo relleno

#v(2em)

#align(center)[#table(
  columns: 3,
  align: center,
  table.vline(x: 1, start: 2, stroke: gray),
  table.vline(x: 2, start: 2, stroke: gray),
  table.hline(stroke: gray),
  [], [],  [*Detecciones*],
  [*Métodos*], [*Agujeros*],  [],
  table.hline(stroke: gray),
  table.cell(rowspan: 2)[Euclídeo],
    [0], emph_cell[100%],
    [1], emph_cell[0],
  table.cell(rowspan: 2)[Fermat],
    [0], emph_cell[100%],
    [1], emph_cell[0],
  table.cell(rowspan: 2)[Kde],
    [0], emph_cell(good: false)[50%],
    [1], emph_cell(good: false)[50%],
)]

#v(3em)

#message(fill: NEGATIVE_COLOR)[
  El método KDE falla en detectar la ausencia de agujeros para el 50% de las corridas.
]
