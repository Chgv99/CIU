# Sistema-Planetario
Prototipo de sistema planetario hecho con [Processing 3](https://processing.org/) para la asignatura Creando Interfaces de Usuario.

Para ejecutar el programa, descomprime el .zip y ejecuta "SistemaPlanetario/SistemaPlanetario.pde".

*Christian García Viguera. [Universidad de Las Palmas de Gran Canaria.](https://www2.ulpgc.es/)*

<p align="center">
  <img width="666" height="500" src="https://i.gyazo.com/8bd0bc274cc0332c9875e5829139d061.gif">
</p>

# Índice
* [Descripción](https://github.com/Chgv99/CIU-Sistema-Planetario#Descripción)
* [Instrucciones de uso](https://github.com/Chgv99/CIU-Sistema-Planetario#Instrucciones-de-uso)
* [Funcionamiento](https://github.com/Chgv99/CIU-Sistema-Planetario#Funcionamiento)
* [Errores conocidos](https://github.com/Chgv99/CIU-Sistema-Planetario#Errores)
* [Referencias](https://github.com/Chgv99/CIU-Sistema-Planetario#Referencias)
---

# Descripción

El sistema planetario está constituido por nuestra estrella, el Sol, los cinco primeros planetas de nuestro sistema solar (Mercurio, Venus, Tierra, Marte y Júpiter), y además nuestra luna.

Se ha intentado respetar la naturaleza de estos planetas un mínimo, en lo que respecta a sus tamaños, orden de sus órbitas y texturas. Por otro lado, dado que la práctica trata del movimiento individual de objetos 3D primitivos y para demostrar estos conceptos, se ha tomado la libertad de escoger el sentido de rotación y traslación de los planetas de manera aleatoria.

Por ello, las órbitas de Marte y de la Luna se han inclinado sobre el eje Z y realizan traslación en sentido contrario a los demás planetas, dando lugar a un sistema más variado.

# Instrucciones de uso

Este programa solo cuenta con la vista del sistema planetario, no existen más pantallas. En esta, es posible visualizar el sistema.

Se ofrece la opción de [rotar la vista en ambos ejes](https://github.com/Chgv99/CIU-Sistema-Planetario#Rotacion) con click derecho y de activar y desactivar la iluminación de la escena con la tecla "L".

Desactivar la iluminación permitirá visualizar mejor los planetas que se encuentren en el subespacio comprendido entre el Sol y la cámara, dado que no reflejan la luz del Sol hacia esta. Además, permitirá también visualizar los [nombres de los planetas](https://github.com/Chgv99/CIU-Sistema-Planetario#Texto).

<p align="center">
  <img width="666" height="500" src="https://i.gyazo.com/ea6ba1ac8da3580ad5c448e243b80daa.gif">
</p>

# Funcionamiento

El código consiste en un "setup()", un "draw()", los métodos "createCelestialBody()", "addCelestialBody()" y los métodos relacionados con los inputs.

Primeramente se generan los planetas y sus texturas y se inicializan todos los valores.

```processing
void setup()
{
  size(1000,750,P3D);
  stroke(0);
  img_sol = loadImage("images/sun.jpg");
  img_mercurio = loadImage("images/mercury.png");
  img_venus = loadImage("images/venus.jpg");
  img_tierra = loadImage("images/earth.jpeg");
  img_marte = loadImage("images/marte.jpg");
  img_jupiter = loadImage("images/jupiter.jpg");
  
  sol = createCelestialBody(100, img_sol);
  mercurio = createCelestialBody(10, img_mercurio);
  venus = createCelestialBody(20, img_venus);
  tierra = createCelestialBody(20, img_tierra);
  luna = createCelestialBody(3, img_mercurio);
  marte = createCelestialBody(13, img_marte);
  jupiter = createCelestialBody(35, img_jupiter);
  
  //generateStars();
  
  //Inicializa
  ang=0;
  translate_x = width/2;
  translate_y = height/2;
  translate_z = -500;
  zoom_factor = 2;
  show_text = true;
  light = true;
  
  rot_x = 0;
  rot_y = 0;
}
```
```processing
PShape createCelestialBody(float radius, PImage texture){
  PShape cuerpo;
  beginShape();
  cuerpo = createShape(SPHERE, radius);
  cuerpo.setStroke(255);
  cuerpo.setTexture(texture);
  endShape();
  return cuerpo;
}
```

El bucle del programa dibuja el fondo, el texto del HUD, rota la escena según la posición del ratón (si se mantiene click derecho), y dibuja los planetas rotados según el float "ang".

```processing
void draw()
{
  background(0);
  translate(translate_x, translate_y, translate_z);
  textSize(24);
  text("[Right Mouse Drag] Rotate    [L] Enable/disable lights    [+][-] Zoom in/out", 0, height/2 -20, -translate_z);
  fill(255);
  stroke(255);
  //translate(width/2, height/2, -500);
  
  if (right_drag) {
    rot_y += mouseX - pmouseX;
    rot_x += mouseY - pmouseY;
  }
  
  rotateY(radians(rot_y));
  rotateX(-radians(rot_x));
  
  //add planet
  pushMatrix();
  addCelestialBody(sol, 0, 1, 0, -25, 0, "Sol", 150);
  if (light) pointLight(255, 255, 255, 0, 0, 0);
  popMatrix();
  pushMatrix();
  //Mercurio rota más lento para que una de sus caras de siempre al sol
  addCelestialBody(mercurio, -1, -0.25, 250, 10, 0, "Mercurio"); //Mercurio
  popMatrix();
  pushMatrix();
  addCelestialBody(venus, 1.5, 0.5, 350, -20, 0, "Venus"); //Venus
  popMatrix();
  pushMatrix();
  addCelestialBody(tierra, 2, 2, 450, 15, 0, "Tierra"); //Tierra
  //La Luna rota más lento para que solo muestre una cara a la Tierra
  addCelestialBody(luna, -16, -1, 70, 5, 5, "Luna"); //Luna
  popMatrix();
  pushMatrix();
  addCelestialBody(marte, -3, -0.7, 550, 5, -6, "Marte"); //Marte
  popMatrix();
  pushMatrix();
  addCelestialBody(jupiter, 0.5, 0.4, 650, -10, 0, "Júpiter"); //Júpiter
  popMatrix();
  
  //Resetea tras giro completo
  ang=ang+0.25;
  /*
  if (ang>360)
    ang=0;*/
    
  key();
}
```

La riqueza de las rotaciones y traslaciones se consigue usando "pushMatrix()" y "popMatrix()", de manera que rotar la matriz espacial para rotar un planeta no afecte a los demás. Así, conseguimos que la rotación del Sol no haga que los demás planetas se trasladen en conjunto, pudiendo tener planetas cuya traslación va en sentido contrario o estén rotadas en el eje Z.

```processing
void addCelestialBody(PShape cuerpo, float translation_speed, float rotation_speed, float orbit_radius, float tilt, float orbit_tilt, String name){
  rotateZ(radians(orbit_tilt));
  rotateY(radians(ang * translation_speed));
  
  translate(orbit_radius, 0, 0);
  textAlign(CENTER);
  textSize(30);
  if (!light) text(name, 0, 70);
  rotateZ(radians(tilt));
  rotateY(radians(ang*rotation_speed));
  shape(cuerpo);
}
```

# Errores

* [Rotación](https://github.com/Chgv99/CIU-Sistema-Planetario#Rotación)
* [Texto](https://github.com/Chgv99/CIU-Sistema-Planetario#Texto)

## Rotación

Al rotar la escena en el eje Y, se está rotando consigo el eje X en sí mismo. Esto provoca que si se rota 180º la escena sobre el eje Y, se invierta por completo el sentido de giro sobre el eje X, dado que este también se habrá rotado 180º. Lo mismo pasa rotando sobre el eje X.

Esto resulta en que se pierda el control de la rotación y sea un poco incómodo de usar.

## Texto

El texto que contiene el nombre de cada planeta rota con el mismo. Provocando que a un lado del Sol sean legibles y al otro lado no por estar invertidos.

# Referencias
* [Processing 3](https://processing.org/)
* [Processing 3 Reference](https://processing.org/reference/)
* [Solar System Scope. Texturas](https://www.solarsystemscope.com/textures/)
