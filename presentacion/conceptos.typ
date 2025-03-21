#import "slides.typ": *


== Distancia de Fermat


#grid(
    columns: (1fr, 1fr),
    align:center,
    [
      #v(5em)
      $ d_F (bold(p), bold(q)) = min_K min_(cal(S)_N^K) sum_(i=1)^(K-1) l(bold(x)^i, bold(x)^(i+1))^lambda $
      $ bold(x)^1 = op("argmin", limits: #true)_(bold(x) in cal(S)_N) l(bold(p), bold(x)) $
      $ bold(x)^K = op("argmin", limits: #true)_(bold(x) in cal(S)_N) l(bold(q), bold(x)) $
    ],
    figure(image("imagenes/intro/fermat-distance-eg.png", width: 100%)),
)

#v(2em)

#message(fill: POSITIVE_COLOR)[
  Incorpora información topológica en la definición de distancia entre puntos
]



== Análisis topológico de datos

// #message(fill: INFORMATIVE_COLOR)[
//   El Análisis de Datos Topológicos o TDA es una área recientemente surgida de la ciencia de datos cuya
// principal motivación es la idea de que la topología y geometría proveen un acercamiento poderoso para
// inferir información robusta, cualitativa y a veces cuantitativa sobre la estructura de los datos
// ]

// #v(2em)

#figure(image("imagenes/intro/TDA.png", width: 75%))

#subtitle_emph("Homología", color: POSITIVE_COLOR)


  La homología es el área de estudio que clasifica espacios topológicos en términos de agujeros de diferentes dimensiones.
  // La homología es el área de estudio que se centra en comprender y clasificar las formas y estructuras espaciales de manera abstracta, permitiendo así la comparación y el análisis de diferentes espacios geométricos. La homología asocia entonces a cada espacio una serie de grupos, llamados grupos de homología, que reflejan características importantes del mismo, como pueden ser componentes conexas y agujeros de diversas dimensiones.

#figure(image("imagenes/intro/ciclostoro.png", width: 40%))

=== Homología Persistente

  ¿Cómo inferir la homología de una variedad $cal(M)$ a partir de una muestra $cal(S)_N$?
  // , obtenida mediante una función de densidad $f$ conocida en $cal(M)$. En general, la homología persistente es una técnica que permite estudiar la evolución de los grupos de homología a medida que se varía un parámetro, en general la escala de observación.

#v(1em)

#grid(
    columns: (1fr, 1fr),
    align:center,
    [
      #v(6em)
      $ B(bold(x)_i, epsilon ) = {bold(x) | d(bold(x_i), bold(x)) < epsilon} $
      $ cal(S)_N^(epsilon) = union_(bold(x) in cal(S)_N) B(bold(x), epsilon ) $
    ],
    figure(image("imagenes/intro/topologia-equivalente-epsilon.png", width: 100%)),
)

#v(1.5em)

#message(fill: NEGATIVE_COLOR)[
  Calcular la homología $H(cal(M))$ directamente a partir de $cal(S)_N^epsilon$ es muy difícil.
]

=== Complejos simpliciales



#let simplex_content = [
  #subtitle_emph()[Complejo de Čech]

  $"Čech"(cal(S)_N , epsilon)$: Conjunto de símplices $sigma$ con vértices $bold(v)_1, dots , bold(v)_k in cal(S)_N$ tales que $ sect.big_(i=1)^k B(bold(v), epsilon) eq.not 0 $

  #subtitle_emph()[Complejo de Vietoris-Rips]

  $V(cal(S)_N , epsilon)$: Símplices con vértices en $cal(S)_N$ de diámetro máximo $2epsilon$.

]

#v(2em)

#grid(
    columns: (1fr, 1fr),
    align:center,
    simplex_content,
    figure(image("imagenes/intro/cech-vs-rips-2.png", width: 100%))
)

#v(3em)


$ "Čech"(cal(S)_N , epsilon) subset V(cal(S)_N , epsilon) subset "Čech"(cal(S)_N , sqrt(2) epsilon) $


=== Diagrama de persistencia

#v(1em)


#message(fill: INFORMATIVE_COLOR)[
// El procedimiento de variar $epsilon$ y evaluar las cualidades topológicas de $cal(S)_N^(epsilon)$ para cada valor da como resultado un tiempo de nacimiento $b_i$ en el que la cualidad topológica $i$ aparece en $cal(S)_N^(epsilon)$ y un valor de muerte $d_i$, en el que esa misma cualidad desaparece.

// Al combinar estos valores de nacimiento y muerte obtenemos un par ordenado $(b_i , d_i)$ para cada cualidad topológica, que si son dispuestos conjuntamente en un plano dan lugar al diagrama de persistencia.
Se obtiene aumentando progresivamente el $epsilon$ y evaluando las cualidades topológicas de $cal(S)_N^(epsilon)$ para cada valor
]

#v(2em)

#figure(image("imagenes/intro/noise-persistence-diagram.png", width: 100%))

#pagebreak()

#subtitle_emph()[Diagramas de persistencia de conjuntos de nivel]

// La unión de bolas $B(bold(x)_i, epsilon)$ puede definirse, alternativamente, como los conjuntos de nivel inferiores de una función $f(x)$, siendo esta el mínimo de la función de distancia entre el punto $bold(x)$ y los datos de la muestra, es decir:

$ cal(S)_N^(epsilon) = union_(bold(x) in cal(S)_N) B(bold(x), epsilon ) = L_epsilon = {bold(x) | min_(bold(x)_i in cal(S)_N) d(bold(x)_i , bold(x)) < epsilon } $

#v(1em)

#figure(image("imagenes/intro/g-persistence-diagram.png", width: 100%))


// === Distancia entre diagramas de persistencia

#pagebreak()

#subtitle_emph()[Distancia entre diagramas de persistencia]



#figure(image("imagenes/intro/bottleneck-distance.png", width: 40%))


#let message_box_bottleneck = [
  #v(7em)
    $
      cal(X), cal(Y) : text("Diagramas de persistencia") \
      eta : cal(X) arrow cal(Y) \
      W_infinity (cal(X), cal(Y)) = inf_(eta : X → Y) sup_(x in cal(X)) ||x - eta (x)||_(infinity)
    $
]

#grid(
    columns: (16em, 1fr),
    align:center,
    message_box_bottleneck,
    figure(image("imagenes/intro/bottleneck-distance.png", width: 100%)),
)


== Distancia de Hausdorff

$
d(bold(x), C) &= inf_(bold(c) in C) d(bold(x), bold(c)) \
d_H (A, B) &= max{sup_(bold(b) in B) d(bold(b), A), sup_(bold(a) in A) d(bold(a), B)} \
d_H (A, B) &= sup_(bold(x) in M) |d(bold(x), A) - d(bold(x), B)|
$


#figure(image("imagenes/intro/hausdorff-distance.png", width: 67%))


== Regiones de Confianza

#subtitle_emph(color: INFORMATIVE_COLOR)[Intervalos de confianza]


// Sea $X$ una muestra aleatoria proveniente de una distribución de probabilidad $p$ de parámetro unidimensional $theta$, siendo $theta$ la cantidad a estimar. Un intervalo de confianza de nivel $1 − alpha$ para el parámetro $theta$ queda determinado por las variables aleatorias $theta_L (X)$ y $theta_U (X)$ tales que

$ bb(P){theta_L (X) lt.eq theta lt.eq theta_U (X)} = 1 − alpha $

#subtitle_emph(color: INFORMATIVE_COLOR)[Regiones de confianza]

$ bb(P){bold(theta) in A(X)} = 1 − alpha $

#subtitle_emph(color: INFORMATIVE_COLOR)[Cálculo de intervalos de confianza]

#message(fill: NEGATIVE_COLOR)[
  El computo analítico de las regiones de confianza es usualmente imposible.
]

#align(center, subtitle_emph(color: POSITIVE_COLOR)[Técnicas de Muestreo])

Analizar la distribución empírica de $hat(theta)^j = T(cal(S)_N^j)$

// A partir de la muestra  $cal(S)_N = { x_1, dots , x_N } $ y el estimador del parámetro de interés $hat(theta) = T(cal(S)_N) $ se obtienen conjuntos $cal(S)_N^j, j = 1, dots, M $ a partir de muestreo sobre $cal(S)_N$.

// La distribución de $hat(theta)$ puede ser inferida analizando la distribución empírica de $hat(theta)^j = T(cal(S)_N^j)$

#let bootstrap_message = frame(counter: "Bootstrap", color: INFORMATIVE_COLOR)[
  $cal(S)_N^j $: muestras de tamaño $N$ *con reposición*
]

#let subsampling_message = frame(counter: "Sub-muestreo", color: INFORMATIVE_COLOR)[
  $cal(S)_N^j, b $: muestras de tamaño $b$ *sin reposición*
]

#grid(
    columns: (1fr, 1em,  1fr),
    align:center,
    bootstrap_message,
    [],
    subsampling_message,
)


=== Regiones de confianza para diagramas de persistencia

// Buscamos obtener una región de confianza de las cualidades topológicas de nuestro diagrama de persistencia.

$
lim_(n arrow infinity ) inf bb(P)(0 lt.eq  W_infinity (cal(P), hat(cal(P))) lt.eq theta_n) gt.eq 1 - alpha
$

// con $cal(P)$ el diagrama de persistencia de la variedad $M$, definido a partir de los conjuntos de nivel

// $ {bold(x) | d_cal(M)(bold(x)) < epsilon} $

// de la función de distancia a la variedad, expresada como:
// $ d_cal(M)(bold(x)) = inf_(bold(y) in cal(M))||bold(x)−bold(y)||  $
// Y siendo $hat(cal(P))$ el diagrama de persistencia construido con el conjunto de datos $cal(S)_N$ que busca estimar $cal(P)$.

// De esta forma, se obtiene la región de confianza para nuestro diagrama de persistencia como:

$ cal(C)_n = {tilde(P) | W_infinity (tilde(P) , hat(P)) < theta_n} $

// El conjunto $cal(C)_n$ tiene la siguiente interpretacion

#subtitle_emph(color: INFORMATIVE_COLOR)[Interpretaciones de $cal(C)_n$]

#grid(
    columns: (1fr, 0.04fr, 1fr),
    align:center,
    message(fill: INFORMATIVE_COLOR)[Caja de lado $2 theta_n$ en cada cualidad topológica $p_i = (b_i, d_i)$],
    [],
    message(fill: POSITIVE_COLOR)[Danda de ancho $sqrt(2) theta_n$ alrededor de la diagonal del diagrama de persistencia],
)

// #message(fill: INFORMATIVE_COLOR)[
//   La región de confianza resultante puede visualizarse centrando una caja de lado $2 theta_n$ en cada punto $p_i = (b_i, d_i)$ del diagrama de persistencia. Todos los diagramas de persistencia $tilde(cal(P))$ dentro del intervalo de confianza de nivel $1 - alpha$ poseen una cualidad topológica dentro de esa caja, formalmente definida como ${ q in bb(R)^2 : ||q - p_i||_infinity lt.eq theta_n}$
// ]

// Si centramos toda nuestra atención en la dicotomía de existencia o no de una cualidad topológica, surge otra interpretación


// #message(fill: POSITIVE_COLOR)[
//  Podemos visualizar la región de confianza como una banda de ancho $sqrt(2) theta_n$ alrededor de la diagonal del diagrama de persistencia. Si una dada cualidad topológica $p_i$ se encuentra dentro de esa banda, significa que $cal(C)_n$ contiene diagramas de persistencia sin esa cualidad, por lo que no puede ser distinguida de ruido bajo el nivel de confianza $1 - alpha$
// ]

// A partir de esta última interpretación, podemos plantear la siguiente prueba de hipótesis para cada una de las cualidades topologicas del diagrama de persistencia.

#subtitle_emph(color: POSITIVE_COLOR)[Test de Hipótesis basado en interpretación Dicotómica]

$
  l_i = d_i - b_i \
  H_0^i : l_i  = 0 \
  H_1^i : l_i > 0
$



#figure(image("imagenes/intro/intervalo-diagrama-persistencia.png", width: 100%))
