# Scene

[CIU-Scene](https://github.com/Chgv99/CIU-Scene) muestra una escena tridimensional en la que se ponen a prueba los conocimientos sobre [Processing 3](https://processing.org/) dados en la asignatura Creando Interfaces de Usuario.

<p align="center">
  No maximizar la ventana del programa. No está pensado para tal funcionamiento.
</p>

<p align="center">
  Para ejecutar el programa, descomprime el .zip y ejecuta "fps/fps.pde".
</p>

*Christian García Viguera. [Universidad de Las Palmas de Gran Canaria.](https://www2.ulpgc.es/)*

<p align="center">
  <img width="1025" height="567" src="https://i.imgur.com/YbO2kI2.png">
</p>

# Índice
* [Descripción](https://github.com/Chgv99/CIU-Scene#Descripción)
* [Iluminación](https://github.com/Chgv99/CIU-Scene#Iluminación)
* [Instrucciones de uso](https://github.com/Chgv99/CIU-Scene#Instrucciones-de-uso)
* [Referencias](https://github.com/Chgv99/CIU-Scene#Referencias)
---

# Descripción

La escena situa al usuario dentro de un recinto cerrado por 4 paredes y una caja luminosa. Además, alrededor del recinto se pueden observar edificios iluminados por la luz del sol.

El HUD muestra información acerca de las coordenadas del usuario y de la caja, además del nivel en que se encuentra.

La escena cuenta con luces focales, luces direccionales, modelos descargados de internet, texturas en figuras sobre las que incide una fuente de luz...

<p align="center">
  <img width="1025" height="567" src="https://i.imgur.com/LyMy9h4.png">
</p>

# Iluminación

En Processing 3, el rebote de la luz sobre superficies curvas o esferas es correcta, pero a la hora de incidir sobre superficies planas se puede notar un efecto extraño, incluso a veces la ausencia de luz. Esto se debe a que en Processing 3, el rebote de la luz es calculado en base a los vértices de la figura sobre la que está incidiendo. 

Esto signficia que, a menos vértices, peor calidad de luz sobre el objeto. Sumado al hecho de que una superficie plana necesita pocos vértices para ser definida, resulta en que las superficies de cubos o rectángulos se comporte de manera anómala ante los efectos de la luz.

Para solucionarlo, creé mis paredes y mi suelo de manera que se usaran muchos vértices a modo de malla (grid). De esta manera, si bien son innecesarios para la geometría, los vértices permiten que la luz sea representada en dicha superficie correctamente.

```processing
PShape createRect(int x, int y, int z, int c_w, int c_d) {
  int detail = 20;
  PShape rect = createShape();
  rect.beginShape(TRIANGLE_STRIP);
  //for (int i = 0; i < 6; i++){
  for (int i = 0; i < c_w/detail; i++) {
    for (int j = 0; j <= c_d/detail; j++) {
      if (j == 0) {
        rect.vertex(x+(detail)*i, y+(detail)*j, z);
      }
      rect.vertex(x+(detail)*i, y+(detail)*j, z);
      rect.vertex(x+detail*(i+1), y+detail*j, z);
      if (j == c_d/detail) {
        rect.vertex(x+(detail)*(i+1), y+(detail)*j, z);
      }
    }
  }
  //}
  rect.endShape(CLOSE);
  return rect;
}
```

# Instrucciones de uso

El usuario podrá desplazarse por la escena usando las teclas "wasd" y mover la cámara moviendo el ratón.

Es posible recoger la caja luminosa pasando por encima. Esto provoca que aparezca otra en el recinto. Recolectar 10 de ellas da acceso a una calavera luminosa. Esta, al ser recolectada, hace que aparezcan 4 focos y 4 calaveras danzando alrededor de una esfera en el centro del habitáculo.

# Referencias
* [Processing 3](https://processing.org/)
* [Processing 3 Reference](https://processing.org/reference/)
* [Queasy](https://github.com/jrc03c/queasycam)
* [Modelo calavera](https://free3d.com/es/modelo-3d/skull-v3--785914.html)
