#import "slides.typ": *
#import "@preview/algo:0.3.4": algo, i, d, comment, code


== Estimación robusta de distancia de Hausdorff

// Si tenemos dos conjuntos de puntos $cal(A)_N$ y $cal(B)_N $, la distancia de Hausdorff puede escribirse como:

#subtitle_emph()[Distancia de Hausdorff para nubes de puntos]

$
d_H (cal(A)_N, cal(B)_N) = max{ max_(bold(a) in cal(A)_N) min_(bold(b) in cal(B)_N) d(bold(a), bold(b)), max_(bold(b) in cal(B)_N) min_(bold(a) in cal(A)_N) d(bold(a), bold(b)) }
$

#subtitle_emph()[Nuestro caso particular $cal(A)_N = cal(S)_N, quad cal(B)_N = cal(S)_N^j$]

// Si tomamos el caso especial en el que $cal(A)_N$ es nuestro conjunto de datos $cal(A)_n = cal(S)_N$ y $cal(B)_N$ es el conjunto de puntos muestreada a partir de $cal(S)_N$, ya sea por sub-muestreo o por _bootstrap_, $cal(B)_N = cal(S)_N^j$, entonces al ser $cal(S)_N^j$ un *subconjunto* de $cal(S)_N$ se tiene que  $min_(bold(a) in cal(S)_N) d(bold(a), bold(b)) = 0$

// Por lo que la distancia de Hausdorff se reduce a

$ d_H (cal(S)_N, cal(S)_N^j) = max_(bold(a) in cal(S)_N) min_(bold(b) in cal(S)^j_N) d(bold(a), bold(b)) $

// #frame(counter: "Estimación robusta de distancia de Hausdorff", color: POSITIVE_COLOR)[
//   Tomar el máximo de una distancia es una operación muy sensible a valores atípicos, por lo que con el objecivo de hacer esta operación más robusta, se reemplaza el máximo por un percentil alto $gamma$ de la distribución de distancias @RobustHausdorffDistance. El valor de $gamma$ obtenido mediante experimentación fue $gamma = 0.97$
// ]

#subtitle_emph(color: POSITIVE_COLOR)[Estimación robusta de distancia de Hausdorff]

$ hat(d)_H (cal(S)_N, cal(S)_N^j) = op("percentil", limits: #true)_(bold(a) in cal(S)_N)(gamma)  min_(bold(b) in cal(S)^j_N) d(bold(a), bold(b)) $

Valor obtenido mediante experimentación:
$ gamma = 0.97 $




== Estimación de regiones de confianza
asd

=== Sub-muestreo con función de distancia

#grid(
  columns: (0.5fr, 1fr),
  align: center,
  $
    theta_j &= d_H (cal(S)_N , cal(S)^j_N) \
    L_b(t) &= 1/M sum_(j=1)^M I(theta_j > t) \
    c_b &= 2 L_b^(-1) (alpha)
  $,
  [
    Se demuestra
    $ bb(P) (W_infinity (hat(cal(P)), cal(P)) gt c_b) lt.eq bb(P)( d_H (cal(S)_N , cal(M)) gt c_b ) = alpha + cal(O)(b/N)^(1/4) $
  ]
)

#align(center, subtitle_emph()[Algoritmo])

#grid(
  columns: (1.1fr, 0.06fr, 1fr),
  align: center,
  algo(title: "Intervalo Sub-muestreo", parameters: ($cal(S)_N$, $b$, $alpha$, $M$))[
    $theta <- "array"(M)$ \
    for $j <- 0$ to $M$: #i\
      $cal(S)^j_N <- "submuestra"(cal(S)_N, b)$ \
      $theta[j] <- d_H (cal(S)_N , cal(S)^j_N)$ #d\
    return $2 "quantile"(theta, 1 - alpha)$
  ],
  [],
  [
    #message(fill: INFORMATIVE_COLOR)[
      La distancia utilizada para calcular $d_H (cal(S)_N , cal(S)^j_N)$ puede ser Fermat o euclídea
    ]
    #message(fill: POSITIVE_COLOR)[
      Eficiente: No es necesario computar el diagrama de persistencia
    ]
  ]
)


=== Bootstrap con estimación por densidad

#let algo_bootstrap = align(center)[
  #scale(x: 100%, y: 100%)[
    #algo(title: "Bootstrap densidad", parameters: ($cal(S)_N$, $h$, $alpha$, $M$))[
      $theta <- "array"(M)$ \
      $hat(f)_h <- $ estimador de densidad de $f$ basado en $cal(S)_N$ \
      $hat(cal(P)) <- $ diagrama de persistencia de $hat(f)_h$ \
      for $j <- 0$ to $M$: #i\
        $cal(S)^j_N <- $ muestra bootstrap de $cal(S)_N$ \
        $hat(f)_h^j <- $ estimador de densidad de $f$ basado en $cal(S)_N^j$ \
        $hat(cal(P))^j <- $ diagrama de persistencia de $hat(f)_h^j$ \
        $theta[j] <- W_infinity (hat(cal(P)), hat(cal(P))^j)$ #d\
      return $"quantile"(theta, 1 - alpha)$
    ]
  ]
]

#grid(
  columns: (1fr, 0.04fr, 1fr),
  align: center,
  [
    #v(1em)
    // $ f_h (x) = integral_cal(M) 1/h^D K(frac(||x - u ||_2, h)) d F(u) $
    $ f_h (x) = sum_(i=1)^N 1/h^D K(frac(||x - x_i ||_2, h)) $
    evaluado en una grilla de puntos para construir el diagrama de persistencia.
    #v(1em)
    #message(fill: NEGATIVE_COLOR)[Computacionalmente muy costoso]
    #message(fill: NEGATIVE_COLOR)[Puede omitir detalles sutiles de la topología del espacio original]
    #message(fill: POSITIVE_COLOR)[Resulta más estable al ruido y datos atípicos]
  ],
  [],
  algo_bootstrap
)

// Sea $cal(S)_N$ un conjunto de muestras i.i.d obtenidas a partir de la medida de probabilidad $F$ con soporte en una variedad $cal(M)$, se define

// $ f_h (x) = integral_cal(M) 1/h^D K(frac(||x - u ||_2, h)) d F(u) $

// $f_h$ representa la densidad de la medida de probabilidad $F_h$ que es una versión suavizada de $F$ con un _kernel_ $K$ y un ancho de banda $h$ @ConfidenceSetsForPersistenceDiagrams.

// #v(0.5em)

// #message(fill: POSITIVE_COLOR)[
//   El diagrama de persistencia de los conjuntos de nivel de $f_h$, denotado como $cal(P)_h$, conserva la información topológica de $cal(M)$ y resulta más estables al costo de omitir detalles sutiles de la topología del espacio original, haciéndolo mas robusto al ruido y datos atípicos.
// ]

// #v(0.5em)

// Dado que $f_h$ es desconocido, utilizaremos su estimador usual:

// $ f_h (x) = sum_(i=1)^N 1/h^D K(frac(||x - x_i ||_2, h)) $

// que será evaluado en una grilla de puntos para construir diagrama de persistencia.

// #message(fill: NEGATIVE_COLOR)[
//   Este método es computacionalmente costoso ya que requiere calcular el diagrama de persistencia $hat(cal(P))^j$ para cada sub-muestra $cal(S)_N^j$
// ]
