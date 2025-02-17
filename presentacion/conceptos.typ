#import "slides.typ": *


== Análisis topológico de datos

#message(fill: INFORMATIVE_COLOR)[
  El Análisis de Datos Topológicos o TDA es una área recientemente surgida de la ciencia de datos cuya
principal motivación es la idea de que la topología y geometría proveen un acercamiento poderoso para
inferir información robusta, cualitativa y a veces cuantitativa sobre la estructura de los datos
]

#v(2em)

#figure(image("imagenes/intro/TDA.png", width: 100%))

=== Homología

#message(fill: INFORMATIVE_COLOR)[
  La homología es el área de estudio que se centra en comprender y clasificar las formas y estructuras espaciales de manera abstracta, permitiendo así la comparación y el análisis de diferentes espacios geométricos. La homología asocia entonces a cada espacio una serie de grupos, llamados grupos de homología, que reflejan características importantes del mismo, como pueden ser componentes conexas y agujeros de diversas dimensiones.
]

#figure(image("imagenes/intro/ciclostoro.png", width: 58%))

=== Homología Persistente

#message(fill: INFORMATIVE_COLOR)[
  Buscamos inferir la homología de una variedad $cal(M)$ a partir de una muestra $cal(S)_N$ , obtenida mediante una función de densidad $f$ conocida en $cal(M)$. En general, la homología persistente es una técnica que permite estudiar la evolución de los grupos de homología a medida que se varía un parámetro, en general la escala de observación.
]

#v(2em)

#grid(
    columns: (1fr, 1fr),
    align:center,
    [
      #v(6em)
      $ B(bold(x)_i, epsilon ) = {bold(x) | d(bold(x_i), bold(x)) < epsilon} $
      $ cal(S)_N^(epsilon) = union_(bold(x) in cal(S)_N) B(bold(x), epsilon ) $
    ],
    figure(image("imagenes/intro/topologia-equivalente-epsilon.png", width: 90%)),
)


=== Complejos simpliciales

#frame(counter: "Problema", color: NEGATIVE_COLOR)[
 calcular la homología $H(cal(M))$ directamente a partir de $cal(S)_N^epsilon$ resulta una tarea difícil, por lo que esto se realiza mediante la construcción del complejo simplicial a partir de $cal(S)_N$. Un complejo simplicial es un conjunto de símplices, siendo estos generalizaciones de un triángulo en dimensiones arbitrarias, definidos al conectar puntos a menos distancia que $epsilon$
]

#frame(counter: "Complejo de Čech", color: INFORMATIVE_COLOR)[
  El complejo denotado como $"Čech"(cal(S)_N , epsilon)$ representa el conjunto de símplices $sigma$ con vértices $bold(v)_1, · · · , bold(v)_k in cal(S)_N$ tales que

  $ sect.big_(i=1)^k B(bold(v), epsilon) eq.not 0 $
]

#frame(counter: "Complejo de Vietoris-Rips", color: INFORMATIVE_COLOR)[
  $V(cal(S)_N , epsilon)$, que consiste en los símplices con vértices en $cal(S)_N$ de diámetro máximo $2epsilon$. En otras palabras, el símplice $sigma$ es incluido en el complejo si cada par de vértices en $sigma$ está separado como máximo a distancia $2epsilon$
]

#frame(counter: "En que nos ayudan los complejos simpliciales?", color: POSITIVE_COLOR)[
  Teorema del Nervio garantiza que $cal(S)_N^epsilon$ y  $"Čech"(cal(S)_N , epsilon)$ son homotópicamente equivalentes (Fasy et al. 2014; Bauer et al. 2023), es decir, comparten la misma homología. Por su parte, por cuestiones de eficiencia computacional, es común aproximar el complejo de Čech con el complejo de Vietoris-Rips ya que se cunmple la siguiente igualdad

  $ "Čech"(cal(S)_N , epsilon) subset V(cal(S)_N , epsilon) subset "Čech"(cal(S)_N , sqrt(2) epsilon)$
]


#figure(image("imagenes/intro/cech-vs-rips-2.png", width: 55%))


=== Diagrama de persistencia

#message(fill: INFORMATIVE_COLOR)[
El procedimiento de variar $epsilon$ y evaluar las cualidades topológicas de $cal(S)_N^(epsilon)$ para cada valor da como resultado un tiempo de nacimiento $b_i$ en el que la cualidad topológica $i$ aparece en $cal(S)_N^(epsilon)$ y un valor de muerte $d_i$, en el que esa misma cualidad desaparece.

Al combinar estos valores de nacimiento y muerte obtenemos un par ordenado $(b_i , d_i)$ para cada cualidad topológica, que si son dispuestos conjuntamente en un plano dan lugar al diagrama de persistencia.
]

#v(2em)

#figure(image("imagenes/intro/noise-persistence-diagram.png", width: 100%))

#frame(counter: "Diagramas de persistencia de conjuntos de nivel", color: INFORMATIVE_COLOR)[
  La unión de bolas $B(bold(x)_i, epsilon)$ puede definirse, alternativamente, como los conjuntos de nivel inferiores de una función $f(x)$, siendo esta el mínimo de la función de distancia entre el punto $bold(x)$ y los datos de la muestra, es decir:

  $ cal(S)_N^(epsilon) = union_(bold(x) in cal(S)_N) B(bold(x), epsilon ) = L_epsilon = {bold(x) | min_(bold(x)_i in cal(S)_N) d(bold(x)_i , bold(x)) < epsilon } $
]

#figure(image("imagenes/intro/g-persistence-diagram.png", width: 100%))


=== Distancia entre diagramas de persistencia

#frame(counter: "Buscamos", color: INFORMATIVE_COLOR)[
  Sean $cal(X)$ y $cal(Y)$ dos diagramas de persistencia, resulta natural preguntarse cómo estos pueden ser comparados entre sí. Más aún, si los conjuntos de datos que dieron lugar a los diagramas de persistencia $cal(X)$ y $cal(Y)$ son muy distintos, ¿Serán también estos diagramas resultantes muy disimiles?
]

#let message_box_bottleneck = message(fill: POSITIVE_COLOR)[
  Sean entonces $cal(X)$ y $cal(Y)$ dos diagramas de persistencia, se define la distancia *bottleneck* entre estos a partir de la biyección $eta : X → Y$, es decir, una función que le asigna a cada punto $x ∈ cal(X)$ un punto $y ∈ cal(Y)$ y viceversa. guardaremos el supremo de las distancias entre puntos correspondientes a cada diagrama


  $ W_infinity (cal(X), cal(Y)) = inf_(eta : X → Y) sup_(x in cal(X)) ||x - eta (x)||_(infinity) $
]

#grid(
    columns: (1fr, 1fr),
    align:center,
    message_box_bottleneck,
    figure(image("imagenes/intro/bottleneck-distance.png", width: 90%)),
)




== Distancia de Fermat

  Sea una muestra de $N$ puntos
  $ cal(S)_N  = {bold(x)_1, dots.h , bold(x)_N} in cal(M) $
  Donde $cal(M) in bb(R)^D $ es una variedad de dimensión $d >= 1$ y tal que $d << D$.

  Sea además $l(dot, dot)$ una función de distancia defininda en $cal(M) times cal(M)$. Se define entonces la distancia de Fermat para el par de puntos $bold(p)$ y $bold(q)$ como:

  $ d_F (bold(p), bold(q)) = min_K min_(cal(S)_N^K) sum_(i=1)^(K-1) l(bold(x)^i, bold(x)^(i+1))^lambda $

  Donde $cal(S)_N^K, K ≥ 2$, representa todas las secuencias de puntos compuestas por $K$ elementos tomados de $cal(S)_N$ con:

  $ bold(x)^1 = op("argmin", limits: #true)_(bold(x) in cal(S)_N) l(bold(p), bold(x)) $
  $ bold(x)^K = op("argmin", limits: #true)_(bold(x) in cal(S)_N) l(bold(q), bold(x)) $

  La minimización se realiza sobre todos los valores posibles de $K$



#figure(image("imagenes/intro/fermat-distance-eg.png", width: 75%))



== Regiones de Confianza

#frame(counter: "Definición", color: INFORMATIVE_COLOR)[
  sea $X$ una muestra aleatoria proveniente de una distribución de probabilidad $p$ de parámetro unidimensional $theta$, siendo $theta$ la cantidad a estimar. Un intervalo de confianza de nivel $1 − alpha$ para el parámetro $theta$ es el intervalo $(theta_L (X),theta_U (X))$ determinado por las variables aleatorias $theta_L (X)$ y $theta_U (X)$ tales que la siguiente igualdad se cumple para todo $theta$

  $ bb(P){theta_L (X) lt.eq theta lt.eq theta_U (X)} = 1 − alpha $

  Para el caso de parámetros de dimensionalidad mayor, es decir $bold(theta) = [theta_1 , . . . , theta_K ]$, se habla de #text(weight: "bold")["regiones de confianza"], siendo la intuición de estas equivalente a la del caso unidimensional, pero admitiendo regiones $A(X)$ de cualquier forma, es decir $bb(P){bold(theta) in A(X)} = 1 − alpha$.
]

#frame(counter: "Regiones de confianza y pruebas de hipótesis", color: EXTRA_INFO_COLOR)[
  Para verificar que nuestro parámetro es distinto a algún valor $theta_0$, como por ejemplo $theta_0 = 0$, podemos calcular un intervalo de confianza de nivel $1 − alpha$ para este parámetro y verificar si el mismo contiene o no a nuestro valor de interés $theta_0$, en caso de no contenerlo, y recordando que por definición el intervalo de confianza calculado con el estadístico de la muestra tiene una probabilidad de $1 − alpha$ de contener a nuestro parámetro real, podemos descartar la hipótesis $H_0 : theta = theta_0$ con un nivel de confianza $1 − alpha$.
]

=== Cálculo de intervalos de confianza

#frame(counter: "Analítico Vs Computacional", color: EXTRA_INFO_COLOR)[
En algunas situaciones controladas los intervalos de confianza pueden calcularse de forma analítica con fórmula cerrada, como es el típico caso del intervalo de confianza para la media de una distribución gaussiana. En otros casos, estos intervalos resultan de muy difícil o incluso imposible cálculo, al no tener expresión cerrada, es por esto que surgen estrategias computacionales de simulación para calcularlos
]

#v(1em)

A partir de la muestra  $cal(S)_N = { x_1, dots , x_N } $ y el estimador del parámetro de interés $hat(theta) = T(cal(S)_N) $ se obtienen conjuntos $cal(S)_N^j, j = 1, dots, M $ a partir de muestreo sobre $cal(S)_N$.

La distribución de $hat(theta)$ puede ser inferida analizando la distribución empírica de $hat(theta)^j = T(cal(S)_N^j)$

#let bootstrap_message = frame(counter: "Bootstrap", color: INFORMATIVE_COLOR)[
  $cal(S)_N^j $ son muestras de tamaño $N$ y se obtienen a partir de muestreo *con reposición*
]

#let subsampling_message = frame(counter: "Sub-muestreo", color: INFORMATIVE_COLOR)[
  $cal(S)_N^j $ son muestras de tamaño $b$, denotadas como $cal(S)_(N, b)^j$, y se obtienen a partir de muestreo *sin reposición*
]

#grid(
    columns: (1fr, 0em,  1fr),
    align:center,
    bootstrap_message,
    [],
    subsampling_message,
)


=== Regiones de confianza para diagramas de persistencia

Buscamos obtener una región de confianza de las cualidades topológicas de nuestro diagrama de persistencia.

$
lim_(n arrow infinity ) inf bb(P)(0 lt.eq  W_infinity (cal(P), hat(cal(P))) lt.eq theta_n) gt.eq 1 - alpha
$

con $cal(P)$ el diagrama de persistencia de la variedad $M$, definido a partir de los conjuntos de nivel

$ {bold(x) | d_cal(M)(bold(x)) < epsilon} $

de la función de distancia a la variedad, expresada como:
$ d_cal(M)(bold(x)) = inf_(bold(y) in cal(M))||bold(x)−bold(y)||  $
Y siendo $hat(cal(P))$ el diagrama de persistencia construido con el conjunto de datos $cal(S)_N$ que busca estimar $cal(P)$.

De esta forma, se obtiene la región de confianza para nuestro diagrama de persistencia como:

$ cal(C)_n = {tilde(P) | W_infinity (tilde(P) , hat(P)) < theta_n} $

#figure(image("imagenes/intro/intervalo-diagrama-persistencia.png", width: 70%))

#message(fill: POSITIVE_COLOR)[
  La región de confianza resultante puede visualizarse centrando una caja de lado $2 theta_n$ en cada punto $p = (b_i, d_i)$ del diagrama de persistencia
]
