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


== Diagramas de Persistencia

=== Circunferencia Uniforme

#align(center, text("Original", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/circulo-base.png", width: 75%))

#align(center, text("Ruido", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/circulo-noise.png", width: 74.2%))

#align(center, text("Datos atípicos", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/circulo-outliers.png", width: 74%))


=== Circunferencia Gaussiana

#align(center, text("Original", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/circulo-gaussiano-base.png", width: 75%))

#align(center, text("Ruido", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/circulo-gaussiano-noise.png", width: 75%))

#align(center, text("Datos atípicos", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/circulo-gaussiano-outliers.png", width: 75%))


=== Anteojos

#align(center, text("Original", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/anteojos-base.png", width: 75%))

#align(center, text("Ruido", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/anteojos-noise.png", width: 75%))

#align(center, text("Datos atípicos", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/anteojos-outliers.png", width: 75%))

=== Círculo Relleno

#figure(image("imagenes/resultados/circulo-relleno.png", width: 75%))

=== Jugadores de Futbol

#align(center, text("Defensor Central (2)", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/jugador-2.png", width: 75%))

#align(center, text("Mediocampista (5)", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/jugador-5.png", width: 75%))

#align(center, text("Lateral Izquierdo (8)", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/jugador-8.png", width: 75%))

#align(center, text("Mediocampista (14)", fill: POSITIVE_COLOR, weight: "bold"))
#figure(image("imagenes/resultados/jugador-14.png", width: 75%))

== Dimensiones Superiores

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
#v(1.5em)

// #frame(counter: "Costo computacional", color: INFORMATIVE_COLOR)[
#message(fill: INFORMATIVE_COLOR)[
  Se observa que los métodos Euclídeo y Fermat tienen un costo computacional similar para las diferentes dimensiones, el tiempo que demora el cómputo de los diagramas de persistencia no varía significativamente. Por su parte, #text(fill: NEGATIVE_COLOR, weight: "bold")[KDE demora exponencialmente más tiempo para dimensiones superiores a $D = 2$].
]

== Potencia

=== Base

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

#message(fill: INFORMATIVE_COLOR)[
  Fermat es el único método que logra identificar correctamente la existencia de un único agujero para el conjunto de datos de anteojos.
]

=== Ruido Agregado

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

#message(fill: INFORMATIVE_COLOR)[
  Similar al caso sin ruido, Fermat logra mayoritariamente detectar un único agujero en los anteojos para el 98% de las corridas
]

=== Datos Atípicos

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

#message(fill: INFORMATIVE_COLOR)[
  Similar al caso sin ruido, Fermat logra mayoritariamente detectar un único agujero en los anteojos para el 98% de las corridas
]


=== Círculo relleno

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

#message(fill: NEGATIVE_COLOR)[
  Similar al caso sin ruido, Fermat logra mayoritariamente detectar un único agujero en los anteojos para el 98% de las corridas
]
