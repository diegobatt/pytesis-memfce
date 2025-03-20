#import "slides.typ": *

== Datos Sintéticos

#v(2em)

#subtitle_emph()[Conjuntos de datos de la literatura]

#list(
  spacing: 1.5em,
  [Circunferencia Uniforme #h(0.5em) #text(fill: POSITIVE_COLOR)[$+$Ruido $+$Outliers] ],
  [Circunferencia Gaussiana #h(0.5em) #text(fill: POSITIVE_COLOR)[$+$Ruido $+$Outliers]  ],
  [Anteojos #h(0.5em) #text(fill: POSITIVE_COLOR)[$+$Ruido $+$Outliers] ],
)

#v(2em)

#subtitle_emph()[Conjuntos de datos adicionales]

#list(
  spacing: 1.5em,
  [Circunferencia en 3D],
  [Círculo Relleno con densidad variable en función de la distancia al centro],
)



=== Circunferencia

#figure(image("imagenes/datos/circunferencia.png", width: 75%))

=== Circunferencia Gaussiana

#figure(image("imagenes/datos/circunferencia-gaussiana.png", width: 75%))


=== Anteojos

#figure(image("imagenes/datos/anteojos.png", width: 75%))

=== Círculo Relleno

#figure(image("imagenes/datos/circulo-relleno.png", width: 85%))

=== Circunferencia en 3D

#figure(image("imagenes/datos/dummy-dims.png", width: 64%))

== Datos Reales

// Queremos analizar como los métodos estudiados se comportan con datos reales. Utilizamos los conjuntos de datos introducidos en @FootballRobustDataset

// El conjunto de datos consiste en mediciones correspondientes a la posición de jugadores de fútbol dentro de la cancha a lo largo de un partido, en el que se obtiene un punto cada un intervalo de tiempo determinado

// #message(fill: INFORMATIVE_COLOR)[
//   Con el objetivo de obtener agujeros en las zonas donde los jugadores no participan activamente, se agregan artificialmente puntos en los bordes del conjunto de datos, correspondientes a los límites de la cancha @FootballRobustDatasetExplanation
// ]

// Los diferentes jugadores ocupan diferentes espacios en la cancha, en función de la posición que ocupan en el juego, por lo que analizaremos por separado los diferentes jugadores elegidos.

// Se analizarón cuatro jugadores con las siguientes posiciones:
#figure(image("imagenes/datos/paper-football.png", width: 80%))

#subtitle_emph()[Jugadores analizados]

#list(
  spacing: 1.5em,
  [Defensor Central],
  [Mediocampista],
  [Lateral Izquierdo],
  [Mediocampista],
)

=== Jugadores de Futbol

#figure(image("imagenes/datos/futbol.png", width: 78%))
