#import "slides.typ": *

== Conclusiones

#subtitle_emph(color: POSITIVE_COLOR)[
- La Distancia de Fermat demuestra ser una métrica robusta y efectiva para inferir la topología subyacente en conjuntos de datos, superando a la distancia euclídea y al método KDE en la detección de agujeros de primer orden.

- El método de Fermat es menos sensible a problemas como la no uniformidad en la densidad de muestreo y el ruido gaussiano, manteniendo resultados consistentes en comparación con otros métodos.

- Fermat muestra una capacidad destacada para detectar componentes conexas adicionales en presencia de datos atípicos, sugiriendo su potencial uso como herramienta de detección de outliers.

- En conjuntos de datos reales, Fermat logra resultados consistentes con la inspección visual, destacándose por su precisión en la detección de agujeros significativos.
]

== Proximos pasos

#subtitle_emph()[

- Investigar el impacto de la varianza del ruido en los resultados, ampliando el análisis de robustez frente a perturbaciones en los datos.

- Explorar el comportamiento de los hiperparámetros, especialmente el rango óptimo para λ en la Distancia de Fermat, y su influencia en la precisión de los resultados.


- Extender el estudio a conjuntos de datos reales más diversos, evaluando la aplicabilidad de Fermat en otros contextos y dimensiones superiores.


- Profundizar en el uso de Fermat como herramienta de detección de datos atípicos, validando su eficacia en diferentes escenarios y conjuntos de datos.
]
