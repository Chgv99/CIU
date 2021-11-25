# CIU-Face-Filters

[CIU-Face-Filters](https://github.com/Chgv99/CIU-Face-Filters) es un programa creado en [Processing 3](https://processing.org/) que usa la [detección de rostros](https://github.com/opencv/opencv_3rdparty/tree/contrib_face_alignment_20170818) para la visualización de efectos digitales sobre los mismos. Se han utilizado los conceptos vistos en la asignatura Creando Interfaces de Usuario.

<p align="center">
  Para ejecutar el programa, descomprime el .zip y ejecuta "face_filters/face_filters.pde".
</p>
<p align="center">
  Si no se detecta la cámara es posible que tenga que <a href="https://github.com/Chgv99/CIU-Face-Filters#Modificar-la-cámara">modificar el objeto cam</a>.
</p>

*Christian García Viguera. [Universidad de Las Palmas de Gran Canaria.](https://www2.ulpgc.es/)*

<p align="center">
  <img width="640" height="480" src="https://i.imgur.com/UrghLv9.jpg">
</p>

# Índice
* [Descripción](https://github.com/Chgv99/CIU-Face-Filters#Descripción)
  * [Opciones](https://github.com/Chgv99/CIU-Face-Filters#Opciones)
* [Instrucciones de uso](https://github.com/Chgv99/CIU-Face-Filters#Instrucciones-de-uso)
  * [Error de la cámara](https://github.com/Chgv99/CIU-Face-Filters#Modificar-la-cámara)
* [Implementación](https://github.com/Chgv99/CIU-Face-Filters#Implementación)
* [Filtros](https://github.com/Chgv99/CIU-Face-Filters#Filtros)
  * [Six Eyes](https://github.com/Chgv99/CIU-Face-Filters#Six-Eyes)
  * [Mouth Eyes](https://github.com/Chgv99/CIU-Face-Filters#Mouth-Eyes)

* [Recomendaciones y errores](https://github.com/Chgv99/CIU-Face-Filters#Recomendaciones-y-errores)
* [Referencias](https://github.com/Chgv99/CIU-Face-Filters#Referencias)
---

# Descripción

El programa cuenta con una sola pantalla, en la que se muestra la cámara del usuario y un hud con algunas opciones.

La cámara del usuario ya se verá afectada por el primero de los filtros creados para la práctica.

## Opciones

- Debug: Muestra algunas variables usadas para el cálculo de distancias.
- Outlines: Muestra las "landmarks" generadas por el algoritmo. Las que están marcadas con colores son las que se usaron para todos estos cálculos.
- Smoothness: Desactiva el [suavizado](https://github.com/Chgv99/CIU-Face-Filters#Suavizado).

# Instrucciones de uso

El usuario podrá cambiar el "filtro" de la cámara pulsando las flechas izquierda y derecha. Solo hay dos filtros.

## Modificar la cámara

Si la cámara no funciona nunca o a veces puede ser debido a que el usuario tenga varias cámaras conectadas a su ordenador. Esto es fácilmente solucionable mediante la modificación de las siguientes líneas de código:

```processing
void setup(){
  ...
  //Cámara
  cam = null;
  while (cam == null) {
    //cam = new Capture(this, width , height-60, "");
    cam = new Capture(this, width , height-60);
  }
  ...
}
```

La línea que se encuentra sin comentar serviría para el usuario que solo posee una cámara. Si tiene el problema mencionado anteriormente, puede añadir un parámetro más (como se puede observar en la línea comentada) a la llamada, introduciendo el nombre de la cámara con la que quiere utilizar el programa. Mi cámara principal, por ejemplo, se llama "Trust Webcam", pero a veces uso la del móvil con DroidCam, la cual se llama "DroidCam Source 3" en mi caso.

# Implementación

Para esta práctica se ha usado, como se ha mencionado anteriormente, el [modelo de detección de rostros](https://github.com/opencv/opencv_3rdparty/tree/contrib_face_alignment_20170818) usado en clase como [ejemplo](https://github.com/otsedom/CIU/tree/master/P6/p6_camlandmarks).

El recorte de las zonas de interés se ha llevado a cabo usando los puntos devueltos por el método "detectFaceMarks". Para los ojos se usaron los índices 42 y 36 como referencia (los puntos que están más a la izquierda de cada ojo), el 18 para una de las cejas, el 48 para la referencia de la boca, y por último el 50 y 58 para los labios.

El índice 18 se usa para llevar un control de la escala de la cara proyectada en la cámara. De otra manera, no sería posible saber a qué distancia dibujar las cosas si la persona se encuentra alejada de la pantalla o la cámara. La distancia del ojo izquierdo (derecho en espejo) con la ceja izquierda (en espejo también) se usa como referencia en muchos de los cálculos de las distancias a las que se dibujan los ojos o la boca en los filtros, dando la sensación de que se alejan con el usuario.

Los índices 50 y 58 se usan para el máximo y el mínimo de la boca, para no dibujar más allá de los labios innecesariamente. Cuanto más abierta esté la boca, más se dibujará, y viceversa.

## Suavizado

Al recortar un trozo de la imagen, se realiza con la función "get()", la cual solo nos deja seleccionar un área rectangular:

```processing
private void mouthEyes(){
  //Cropped region of original image
  mouth = img.get(mouth_x-(face_d/4),mouth_y-((mouth_amplitude+20)/2),(int)(face_d*3.75),(int)(abs(mouth_amplitude+20)));
  if (smooth) {
    smoothenEdges(mouth);
  }
  image(mouth,leye_x-(face_d/4)-25,leye_y-(mouth_amplitude+20)/2);
  image(mouth,reye_x-(face_d/4)-25,reye_y-(mouth_amplitude+20)/2);
}
```

Al recortar una imagen rectangular y pegarla en un sitio distinto, se pueden a preciar los bordes, como es lógico, por el cambio de contexto, los colores y contrastes que rodean a la pieza en el lugar nuevo.

Para solventar esto, se han aplicado conocimientos sobre manejo de color y transparencias de píxeles dentro de una imagen.

```processing
private void smoothenEdges(PImage img){
  //Mat mat = toMat(img);
  //Columna
  for (int i = 0; i < img.width; i++){
    //Fila
    for (int j = 0; j < img.height; j++){
      int loc = i + j * img.width;
      /*img.pixels[loc] = color(red(img.get(i,j)),
                              green(img.get(i,j)),
                              blue(img.get(i,j)),
                              //map(min(i,j), 
                              //    0, 
                              //    (face_d*1.75)/3, 
                              //    0, 
                              //    255)
                              i*j
                              );*/
        if (i <= img.width/2 && j <= img.height/2) {
          //Superior izquierdo //1.5
          img.pixels[loc] = color(red(img.get(i,j)),green(img.get(i,j)),blue(img.get(i,j)),i*j*alpha_product);
        } else if (i > img.width/2 && j <= img.height/2) {
          //Superior derecho
          img.pixels[loc] = color(red(img.get(i,j)),green(img.get(i,j)),blue(img.get(i,j)),(img.width-i)*j*alpha_product);
          //img.pixels[loc] = color(255,0,0);
        } else if (i > img.width/2 && j > img.height/2) {
          //Inferior derecho
          img.pixels[loc] = color(red(img.get(i,j)),green(img.get(i,j)),blue(img.get(i,j)),(img.width-i)*(img.height-j)*alpha_product);
        } else if (i <= img.width/2 && j > img.height/2) {
          //Inferior izquierdo
          img.pixels[loc] = color(red(img.get(i,j)),green(img.get(i,j)),blue(img.get(i,j)),i*(img.height-j)*alpha_product);
        }
        
    }
  }
  img.updatePixels();
  //return img;
}
```

Se ha aplicado un método que reduce la opacidad de los píxeles cuanto más cerca estén del borde del trozo que se ha recortado. En realidad, se les aplica una transparencia equivalente al producto de las diferencias de filas y columnas entre el píxel y los bordes más cercanos (multiplicado por un producto que depende de la distancia de la cara con la cámara: la distancia entre una ceja y un ojo).

He aquí el resultado:

<p align="center">
  <img width="1309" height="480" src="https://i.imgur.com/GcxPWhW.jpg">
</p>
<p align="center">
  A la izquierda sin suavizado. A la derecha con suavizado.
</p>

# Filtros

## Six Eyes

Este filtro copia las regiones de la cámara que corresponden a los dos ojos del usuario y los replica por encima y por debajo.

<p align="center">
  <img width="550" height="488" src="https://media.giphy.com/media/Dx9bPtoofVEYa9rQBy/giphy.gif">
</p>

## Mouth Eyes

Este otro filtro copia la región de la boca y la pega en las regiones de los ojos del usuario.

<p align="center">
  <img width="550" height="488" src="https://media.giphy.com/media/LymcESluEU2ZyqjdHP/giphy.gif">
</p>

# Recomendaciones y errores

- Se recomienda probar el programa en un ambiente bien iluminado y sin muchos objetos de fondo.
- La "vibración" o "titileo" de los elementos (ojos, bocas...) es inevitable por parte del alumno, ya que se debe a la detección de rostro landmark, que es muy sensible a la luz y al ruido de la cámara usada.
- Si el usuario inclina su cara hacia los lados, los elementos (ojos, bocas...) no le seguirán la corriente. Esto se ha dejado de esta forma ya que la propia detección de caras fallará si la cara del usuario está muy inclinada. Solventar lo primero resulta una pérdida de tiempo si no se iba a poder aprovechar.
- Lo mismo ocurre si la cara se inclina hacia fuera del plano de la pantalla o hacia dentro

# Referencias
* [Processing 3](https://processing.org/)
* [Processing 3 Reference](https://processing.org/reference/)
* [Face detection. Landmark Model](https://github.com/opencv/opencv_3rdparty/tree/contrib_face_alignment_20170818)
* [OpenCV Mat](https://gist.github.com/Spaxe/3543f0005e9f8f3c4dc5)
* [Colors](https://processing.org/reference/red_.html)
