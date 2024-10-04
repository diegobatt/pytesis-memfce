#import "slides.typ": *


== Análisis topológico de datos

#frame(counter: "Definición", color: INFORMATIVE_COLOR)[
  El Análisis de Datos Topológicos o TDA es una área recientemente surgida de la ciencia de datos cuya
principal motivación es la idea de que la topología y geometría proveen un acercamiento poderoso para
inferir información robusta, cualitativa y a veces cuantitativa sobre la estructura de los datos
]

#v(2em)

#figure(image("imagenes/intro/TDA.png", width: 100%))

=== Homología

asdsad

== Distancia de Fermat

#frame(counter: "Definción", color: INFORMATIVE_COLOR)[
  Sea una muestra de $N$ puntos
  $ cal(S)_N  = {bold(x)_1, dots.h , bold(x)_N} in cal(M) $
  Donde $cal(M) in bb(R)^D $ es una variedad de dimensión $d >= 1$ y tal que $d << D$.

  Sea además $l(dot, dot)$ una función de distancia defininda en $cal(M) times cal(M)$. Se define entonces la distancia de Fermat para el par de puntos $bold(p)$ y $bold(q)$ como:

  $ d_F (bold(p), bold(q)) = min_K min_(cal(S)_N^K) sum_(i=1)^(K-1) l(bold(x)^i, bold(x)^(i+1))^alpha $

  Donde $cal(S)_N^K, K ≥ 2$, representa todas las secuencias de puntos compuestas por $K$ elementos tomados de $cal(S)_N$ con:

  $ bold(x)^1 = op("argmin", limits: #true)_(bold(x) in cal(S)_N) l(bold(p), bold(x)) $
  $ bold(x)^K = op("argmin", limits: #true)_(bold(x) in cal(S)_N) l(bold(q), bold(x)) $

  La minimización se realiza sobre todos los valores posibles de $K$
]


#figure(image("imagenes/intro/fermat-distance-eg.png", width: 75%))
