# Sistema-Planetario-Nave

[CIU-Sistema-Planetario](https://github.com/Chgv99/CIU-Sistema-Planetario) pero con una cámara añadida a modo de nave espacial.

Este readme contiene la misma información que el de [CIU-Sistema-Planetario](https://github.com/Chgv99/CIU-Sistema-Planetario) pero con información y notas sobre la implementación de la [Cámara](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Funcionamiento-de-la-cámara). Es decir, posiblemente la información que se lea sobre algunos aspectos del programa no concuerde con lo que ocurre en esta versión de Sistema-Planetario. Véase la sección de [errores](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Errores) para conocer todas las funcionalidades afectadas por la implementación de la cámara (nave).

[CIU-Sistema-Planetario](https://github.com/Chgv99/CIU-Sistema-Planetario) es un prototipo de sistema planetario hecho con [Processing 3](https://processing.org/) para la asignatura Creando Interfaces de Usuario.

Para ejecutar el programa, descomprime el .zip y ejecuta "SistemaPlanetarioNave/SistemaPlanetarioNave.pde".

*Christian García Viguera. [Universidad de Las Palmas de Gran Canaria.](https://www2.ulpgc.es/)*

<p align="center">
  <img width="666" height="500" src="https://i.gyazo.com/8bd0bc274cc0332c9875e5829139d061.gif">
</p>

# Índice
* [Descripción](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Descripción)
* [Instrucciones de uso](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Instrucciones-de-uso)
  * [Uso de la cámara](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Uso-de-la-cámara)
* [Funcionamiento](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Funcionamiento)
  * [Funcionamiento de la cámara](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Funcionamiento-de-la-cámara)
* [Errores conocidos](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Errores)
* [Referencias](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Referencias)
---

# Descripción

El sistema planetario está constituido por nuestra estrella, el Sol, los cinco primeros planetas de nuestro sistema solar (Mercurio, Venus, Tierra, Marte y Júpiter), y además nuestra luna.

Se ha intentado respetar la naturaleza de estos planetas un mínimo, en lo que respecta a sus tamaños, orden de sus órbitas y texturas. Por otro lado, dado que la práctica trata del movimiento individual de objetos 3D primitivos y para demostrar estos conceptos, se ha tomado la libertad de escoger el sentido de rotación y traslación de los planetas de manera aleatoria.

Por ello, las órbitas de Marte y de la Luna se han inclinado sobre el eje Z y realizan traslación en sentido contrario a los demás planetas, dando lugar a un sistema más variado.

# Instrucciones de uso

Este programa solo cuenta con la vista del sistema planetario, no existen más pantallas. En esta, es posible visualizar el sistema.

Se ofrece la opción de [rotar la vista en ambos ejes](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Rotacion) con click derecho y de activar y desactivar la iluminación de la escena con la tecla "L".

Desactivar la iluminación permitirá visualizar mejor los planetas que se encuentren en el subespacio comprendido entre el Sol y la cámara, dado que no reflejan la luz del Sol hacia esta. Además, permitirá también visualizar los [nombres de los planetas](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Texto).

<p align="center">
  <img width="666" height="500" src="https://i.gyazo.com/ea6ba1ac8da3580ad5c448e243b80daa.gif">
</p>

## Uso de la cámara

Para acceder a la cámara (nave) debe pulsarse "espacio". En este modo, el usuario es capaz de desplazarse por el sistema planetario con "W", "A", "S" y "D", además de rodar con las flechas "izquierda" y "derecha" y de inclinar el morro con las flechas "arriba" y "abajo". Se puede volver al modo de visualización normal pulsando de nuevo "espacio".

Véase la sección de [errores](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Errores)

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

## Funcionamiento de la cámara

Para los controles de la nave se han añadido las flechas direccionales y las teclas "wasd" para que el usuario pueda escoger por donde moverse y hacia donde mirar.

```processing
if (keyPressed) {
  if (key == CODED) {
    if (s_ship) {
      if (keyCode == UP) {
        py += 1;
      }
      if (keyCode == DOWN) {
        py -= 1;
      }
      if (keyCode == LEFT) {
        px += 1;
      }
      if (keyCode == RIGHT) {
        px -= 1;
      }
    }
  } else {
    if (s_ship) {
      if (key == 'w') {
        vz += 5;
      }
      if (key == 's') {
        vz -= 5;
      }
      if (key == 'a') {
        vx -= 1;
      }
      if (key == 'd') {
        vx += 1;
      }
    } else { ... }
  }
}
```

El movimiento de la nave se logra moviendo el escenario entero mediante las funciones "translate()", "rotateX()", "rotateY()" y "rotateZ()".

```processing
void draw()
{
  background(0);
  camera(0, 0, 1, 0, 0, 0, 0, 1, 0);
  if (s_ship) {
    rotateZ(radians(px));
    rotateX(radians(py));
    rotateY(radians(vx));
    translate(-vz, 0, -vz);
  } else {
    camera(0, 0, -translate_z, 0, 0, 0, 0, 1, 0);
    pushMatrix();
    translate(0, 0, 0);
    textSize(24);
    text("[Right Mouse Drag] Rotate    [L] Enable/disable lights    [+][-] Zoom in/out", 0, height/2 -20, -translate_z);
    fill(255);
    stroke(255);
    popMatrix();
    if (right_drag) {
      rot_y += mouseX - pmouseX;
      rot_x += mouseY - pmouseY;
    }
    rotateY(radians(rot_y));
    rotateX(-radians(rot_x));
  }
  ...
}
```

# Errores

* [Rotación](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Rotación)
* [Texto](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Texto)
* [Cámara](https://github.com/Chgv99/CIU-Sistema-Planetario-Nave#Cámara)

## Rotación

Al rotar la escena en el eje Y, se está rotando consigo el eje X en sí mismo. Esto provoca que si se rota 180º la escena sobre el eje Y, se invierta por completo el sentido de giro sobre el eje X, dado que este también se habrá rotado 180º. Lo mismo pasa rotando sobre el eje X.

Esto resulta en que se pierda el control de la rotación y sea un poco incómodo de usar.

## Texto

El texto que contiene el nombre de cada planeta rota con el mismo. Provocando que a un lado del Sol sean legibles y al otro lado no por estar invertidos.

## Cámara

### Desplazamiento

Al usar la serie de métodos "rotate", no es posible controlar los ejes que se desplazan junto con el sistema planetario, desencadenando una serie de problemas como la imposibilidad de desplazarse hacia delante en otro eje que no sea el que atraviesa la estrella y la cámara al comienzo de la ejecución (eje Z). 

Se intentó implementar una PShape que englobara todo el sistema para trabajar con rotaciones sobre ese objeto sin que afectara a los ejes y poder mover la cámara libremente pero no ha sido posible debido a falta de tiempo.

### HUD

El HUD ha desaparecido. No he sido capaz de colocarlo de nuevo ya que he utilizado el método "camera()" para que ambos modos de visualización (nave y normal) no influyeran el uno sobre el otro a la hora de alternar entre ellos. Aparentemente, mostrar texto usando "camera()" se vuelve más complicado de la manera en la que lo he estado implementando yo.

# Referencias
* [Processing 3](https://processing.org/)
* [Processing 3 Reference](https://processing.org/reference/)
* [Solar System Scope. Texturas](https://www.solarsystemscope.com/textures/)
