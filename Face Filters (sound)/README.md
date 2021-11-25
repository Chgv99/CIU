# CIU-Face-Filters-Sound

[CIU-Face-Filters-Sound](https://github.com/Chgv99/CIU-Face-Filters-Sound) es un programa creado en [Processing 3](https://processing.org/) que usa la [detección de rostros](https://github.com/opencv/opencv_3rdparty/tree/contrib_face_alignment_20170818) para la visualización de efectos digitales sobre los mismos. Se han utilizado los conceptos vistos en la asignatura Creando Interfaces de Usuario.

Este programa es una versión mejorada de [CIU-Face-Filters](https://github.com/Chgv99/CIU-Face-Filters). Para información relacionada con la detección de rostros, por favor leer el README de [CIU-Face-Filters](https://github.com/Chgv99/CIU-Face-Filters).

<p align="center">
  Para ejecutar el programa, descomprime el .zip y ejecuta "face_filters/face_filters.pde".
</p>

*Christian García Viguera. [Universidad de Las Palmas de Gran Canaria.](https://www2.ulpgc.es/)*

# Índice
* [Descripción de las mejoras](https://github.com/Chgv99/CIU-Face-Filters-Sound#Descripción-de-las-mejoras)
* [Instrucciones de uso adicionales](https://github.com/Chgv99/CIU-Face-Filters-Sound#Instrucciones-de-uso-adicionales)
* [Errores](https://github.com/Chgv99/CIU-Face-Filters-Sound#Errores)
* [Referencias](https://github.com/Chgv99/CIU-Face-Filters-Sound#Referencias)
---

# Descripción de las mejoras

En esta versión, el programa cuenta con un cluster de osciladores seno, del cual el usuario podrá modificar la frecuencia y el afinamiento, moviendo la cabeza en el eje Y y el eje X respectivamente.

Además, el usuario podrá aumentar el número de osciladores (de 1 a 5) parpadeando.

Información sobre [errores](https://github.com/Chgv99/CIU-Face-Filters-Sound#Errores).

# Instrucciones de uso adicionales

El usuario podrá parpadear para aumentar el número de osciladores.

# Implementación

Para el cluster se ha utilizado código del ejemplo SineCluster de Processing 3.

# Errores

- Debido al titileo de la detección de rostros, resulta complicado mantener un número fijo de osciladores, dado que se detectan más parpadeos de los que se están realizando en realidad, en especial cuando se mueve la cabeza.
- Se recomienda probar el programa en un ambiente bien iluminado y con un fondo homogéneo, para evitar detecciones espurias

# Referencias
* [Processing 3](https://processing.org/)
* [Processing 3 Reference](https://processing.org/reference/)
* [Face detection. Landmark Model](https://github.com/opencv/opencv_3rdparty/tree/contrib_face_alignment_20170818)
* [OpenCV Mat](https://gist.github.com/Spaxe/3543f0005e9f8f3c4dc5)
* [Colors](https://processing.org/reference/red_.html)
