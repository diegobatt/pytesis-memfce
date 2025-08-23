#import "slides.typ": *
#import "@preview/cetz:0.4.1"


== Distancia de Fermat


#grid(
    columns: (1fr, 1fr),
    align:center,
    [
      #v(5em)
      $ d_F (bold(p), bold(q)) = min_(K >= 2) min_(cal(S)_N^K) sum_(i=1)^(K-1) l(bold(x)^i, bold(x)^(i+1))^lambda $
      $ bold(x)^1 = bold(p), #h(0.3cm) bold(x)^K = bold(q)$
    ],
    figure(image("imagenes/intro/fermat-distance-eg.png", width: 100%)),
)

#v(2em)

#message(fill: POSITIVE_COLOR)[
  Incorpora información topológica en la definición de distancia entre puntos
]



== Análisis topológico de datos


#figure(image("imagenes/intro/TDA.png", width: 75%))

#subtitle_emph("Homología", color: POSITIVE_COLOR)

Área de estudio que clasifica espacios topológicos en términos de agujeros de diferentes dimensiones.

// #figure(image("imagenes/intro/ciclostoro.png", width: 40%))
#align(center, 
  cetz.canvas({
    import cetz.draw: *
    set-style(stroke: (thickness: 1pt))
    group({
      translate(x: -2)
      compound-path({
        hobby(
          (-2.0,  0.2),
          (-1.0,  1.3),
          ( 1.0,  1.3),
          ( 2.0,  0.1),
          ( 1.4, -0.9),
          ( 0.0, -1.3),
          (-1.4, -0.8),
          close: true
        )
        circle((-0.6, 0.25), radius: 0.45)
        circle(( 0.6, 0.25), radius: 0.45)
      }, fill: green, fill-rule: "even-odd")
    })

    group({
      translate(x: 3)
      compound-path({
        hobby(
          (-1.8,  1.2),
          ( 0.8,  1.6),
          ( 2.0,  0.2),
          ( 1.3, -1.0),
          (-0.6, -1.2),
          (-2.0, -0.1),
          close: true
        )
        circle((0.2, 0.2), radius: 0.45)
      }, fill: green, fill-rule: "even-odd")
    })
  })
)

=== Homología Persistente

  ¿Cómo inferir la homología de una variedad $cal(M)$ a partir de una muestra $cal(S)_N$?

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
Se obtiene aumentando progresivamente el $epsilon$ y evaluando las cualidades topológicas de $cal(S)_N^(epsilon)$ para cada valor
]

#v(2em)

#figure(image("imagenes/intro/noise-persistence-diagram.png", width: 100%))

#pagebreak()

#subtitle_emph()[Diagramas de persistencia de conjuntos de nivel]

$ cal(S)_N^(epsilon) = union_(bold(x) in cal(S)_N) B(bold(x), epsilon ) = L_epsilon = {bold(x) | min_(bold(x)_i in cal(S)_N) d(bold(x)_i , bold(x)) < epsilon } $

#v(1em)

#figure(image("imagenes/intro/g-persistence-diagram.png", width: 100%))


#pagebreak()

#subtitle_emph()[Distancia entre diagramas de persistencia]

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

#let equations_hausdoroff = [
  $
  d(bold(x), Y) &= inf_(bold(y) in Y) d(bold(x), bold(y)) \
  d_H (X, Y) &= max{sup_(bold(y) in Y) d(bold(y), X), sup_(bold(x) in X) d(bold(x), Y)} \
  // d_H (A, B) &= sup_(bold(x) in M) |d(bold(x), A) - d(bold(x), B)|
  $
]

#let cota_hausdorff = [
  #v(1.5em)
  $
  W_infinity (cal(P)(X), cal(P)(Y)) <= d_H (X, Y)
  $
]

#grid(
    columns: (1fr, 1fr),
    align:center,
    equations_hausdoroff,
    cota_hausdorff,
)

#v(1em)

#figure(image("imagenes/intro/hausdorff-distance.png", width: 77%))


== Regiones de Confianza

#subtitle_emph(color: INFORMATIVE_COLOR)[Intervalos de confianza]


$ bb(P){theta_L (X) lt.eq theta lt.eq theta_U (X)} = 1 − alpha $

#subtitle_emph(color: INFORMATIVE_COLOR)[Regiones de confianza]

$ bb(P){bold(theta) in A(X)} = 1 − alpha $

#subtitle_emph(color: INFORMATIVE_COLOR)[Cálculo de regiones de confianza]

#message(fill: NEGATIVE_COLOR)[
  El cálculo analítico de las regiones de confianza suele ser imposible.
]

#align(center, subtitle_emph(color: POSITIVE_COLOR)[Técnicas de Muestreo])

Analizar la distribución empírica de $hat(theta)^j = T(cal(S)_N^j)$

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

#v(2em)

$
lim_(n arrow infinity ) inf bb(P)(0 lt.eq  W_infinity (cal(P), hat(cal(P))) lt.eq theta_n) gt.eq 1 - alpha
$


$ cal(C)_n = {tilde(cal(P)) | W_infinity (tilde(cal(P)) , hat(cal(P))) < theta_n} $


#subtitle_emph(color: INFORMATIVE_COLOR)[Interpretaciones de $cal(C)_n$]

#grid(
    columns: (1fr, 0.04fr, 1fr),
    align:center,
    message(fill: INFORMATIVE_COLOR)[Caja de lado $2 theta_n$ en cada cualidad topológica $p_i = (b_i, d_i)$],
    [],
    message(fill: POSITIVE_COLOR)[Banda de ancho $sqrt(2) theta_n$ alrededor de la diagonal del diagrama de persistencia],
)


#subtitle_emph(color: POSITIVE_COLOR)[Test de Hipótesis basado en interpretación Dicotómica]

$
  l_i = d_i - b_i \
  H_0^i : l_i  = 0 \
  H_1^i : l_i > 0
$



#figure(image("imagenes/intro/intervalo-diagrama-persistencia.png", width: 100%))
