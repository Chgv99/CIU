# CIU-Pong

<p align="center">
  <a href="https://github.com/Chgv99/CIU-Pong#Español">Español</a>
  <a href="https://github.com/Chgv99/CIU-Pong#English">English</a>
</p>

# Español
CIU-Pong es un miniproyecto para la asignatura **Creando Interfaces de Usuario** que consiste en reconstruir el juego [Pong](https://es.wikipedia.org/wiki/Pong) en [Processing 3](https://processing.org/).

*Christian García Viguera. [Universidad de Las Palmas de Gran Canaria.](https://www2.ulpgc.es/)*

<p align="center">
  <img width="460" height="300" src="https://github.com/Chgv99/Pong/blob/main/preview.gif">
</p>

# Índice
* [Funcionamiento](https://github.com/Chgv99/CIU-Pong#Funcionamiento)
  * [Aleatoriedad](https://github.com/Chgv99/CIU-Pong#Aleatoriedad)
  * [Movimiento](https://github.com/Chgv99/CIU-Pong#Movimiento)
  * [Detección de colisiones](https://github.com/Chgv99/CIU-Pong#Detección-de-colisiones)
  * [Almacenamiento de puntuación](https://github.com/Chgv99/CIU-Pong#Almacenamiento-de-puntuación)
  * [Reproducción de sonido](https://github.com/Chgv99/CIU-Pong#Reproducción-de-sonido)
  * [Detección de entradas por teclado](https://github.com/Chgv99/CIU-Pong#Detección-de-entradas-por-teclado)
* [Diseño](https://github.com/Chgv99/CIU-Pong#Diseño)
* [Referencias](https://github.com/Chgv99/CIU-Pong#Referencias)
---

# Funcionamiento

La práctica explora varios conceptos en Processing:
* [Aleatoriedad](https://github.com/Chgv99/CIU-Pong#Aleatoriedad)
* [Movimiento](https://github.com/Chgv99/CIU-Pong#Movimiento)
* [Detección de colisiones](https://github.com/Chgv99/CIU-Pong#Detección-de-colisiones)
* [Almacenamiento de puntuación](https://github.com/Chgv99/CIU-Pong#Almacenamiento-de-puntuación)
* [Reproducción de sonido](https://github.com/Chgv99/CIU-Pong#Reproducción-de-sonido)
* [Detección de entradas por teclado](https://github.com/Chgv99/CIU-Pong#Detección-de-entradas-por-teclado)

## Aleatoriedad

La partida comienza con un saque aleatorio a la izquierda o a la derecha. Esto da a ambos jugadores la misma probabilidad de comenzar con "*ventaja*".
```processing
//50% de lanzar hacia izquierda, 50% de lanzar hacia derecha
prob = round(random(100));
if (prob > 50){
  //Derecha
  ball_speed_x = global_speed;
  ball_speed_y = 0;
} else {
  ball_speed_x = -global_speed;
  ball_speed_y = 0;
}
```

Además, en cada rebote de la pelota con una pala, se elige al azar de entre *-global_speed* y *global_speed* para la componente vertical de la velocidad de la pelota.
```processing
void bounce(){
  hit.play();
  ball_speed_y = round(random(-global_speed, global_speed));
}
```

## Movimiento

La pelota se inicializa en el centro de la pantalla. En cada loop se le suma a sus componentes una cierta cantidad (*ball_speed_x* y *ball_speed_y*), y tras ello se dibuja en pantalla para generar el movimiento. Lo mismo ocurre con las palas.
```processing
void positionElements() {
  ball_x = ball_x + ball_speed_x;
  ball_y = ball_y + ball_speed_y;
  
  circle(ball_x, ball_y, ball_d);
  rect(paddle_a_x, paddle_a_y - paddle_height/2, paddle_width, paddle_height);
  rect(paddle_b_x, paddle_b_y - paddle_height/2, paddle_width, paddle_height);
}
```

## Detección de colisiones

Las colisiones verticales se resuelven invirtiendo el signo de la componente vertical cuando la pelota toca los bordes.

De las colisiones horizontales, las que incumben a los bordes de la ventana, llevan al reseteo de la posición de la pelota. En cambio, las que tienen que ver con las palas, resultan en la inversión del sentido de la componente horizontal y en otra tirada de los dados para la componente vertical (tal y como se explica en [Aleatoriedad](https://github.com/Chgv99/CIU-Pong#Aleatoriedad)). De esta forma, la partida no es monótona, y obliga a los jugadores a estar más atentos.
```processing
void checkCollisions() {
  checkScoreConditions();
  
  //Colisiones
  //Paredes
  if (ball_y + (ball_d/2) > height || ball_y - (ball_d/2) < 0) {
    ball_speed_y = -ball_speed_y;
  }

  //Palas
  //Pala izquierda
  if ((ball_x - ball_d/2 < paddle_a_x + paddle_width) &&
      (ball_x + ball_d/2 > paddle_a_x) &&
      (ball_y - ball_d/2 < paddle_a_y + paddle_height/2) &&
      (ball_y + ball_d/2 > paddle_a_y - paddle_height/2)) {
    ball_speed_x = abs(global_speed);
    bounce();
  }
  
  //Pala derecha
  if ((ball_x - ball_d/2 < paddle_b_x + paddle_width) &&
      (ball_x + ball_d/2 > paddle_b_x) &&
      (ball_y - ball_d/2 < paddle_b_y + paddle_height/2) &&
      (ball_y + ball_d/2 > paddle_b_y - paddle_height/2)) {
    ball_speed_x = -abs(global_speed);
    bounce();
  }
}
```

## Almacenamiento de puntuación

El almacenamiento de los puntos de cada jugador se realiza en una variable entera que se dibuja mediante *text()* al comienzo del método *draw()*, tras el fondo. Se acumula cada vez que se detecte una colisión de la pelota con el borde izquierdo o derecho de la pantalla.

Si la pelota colisiona con el borde izquierdo, se le suma un punto al jugador de la derecha, y en el siguiente saque, se le dará la pelota al jugador de la izquierda.
```processing
void printBackground() {
  background(0);
  stroke(255);
  strokeWeight(3);
  textSize(100);
  fill(255);
  text(score_b, (width/2) + 75, height/4);
  text(score_a, 
      (width/2) - 140, //200
      height/4);
  for (int i = 0; i < 10; i++){
    line(width/2, i * 50, width/2, i * 50 + 25);
  }
  noStroke();
}
```

## Reproducción de sonido

La reproducción de archivos de sonido se lleva a cabo de la forma en que se explica en el [guión de prácticas](https://github.com/Chgv99/CIU-Pong#Referencias).

Se reproducen dos sonidos distintos: uno para el rebote de la pelota con las palas, y otro para cuando se marca un punto.

Es importante recalcar que la librería no permite el uso de archivos *.mp3*.
```processing
import processing.sound.*;
SoundFile hit;
SoundFile score;

void Setup(){
  hit = new SoundFile(this, "Hit11.wav");
  score = new SoundFile(this, "Hit10.wav");
}

void bounce(){
  hit.play();
  //...
}

void score(){
  score.play();
  //...
}
```

## Detección de entradas por teclado

Las entradas por teclado son la interacción del usuario con el juego. Pulsando 'W' y 'S' se maneja al jugador 1, y pulsando 'UP' y 'DOWN' al jugador 2.

Al pulsar cada tecla, se incrementa o decrementa la componente vertical de la pala correspondiente, generando movimiento.

Debido a alguna particularidad de [Processing 3](https://github.com/Chgv99/CIU-Pong#Referencias), no se admiten varias entradas simultáneas. Esto provoca que un jugador impida que el contrincante participe si está pulsando una tecla, pero se puede jugar en turnos alternos si los reflejos de cada jugador son los suficientes. Para el interesado: sí, se podría solucionar este error de alguna manera.
```processing
void checkKeyPressed(){
  //Teclas
  if (keyPressed) {
    if (key == 'w'){
      paddle_a_y -= paddle_speed;
      print("up\n");
    }
    
    if (key == 's'){
      paddle_a_y += paddle_speed;
      print("down\n");
    }
    
    if (keyCode == UP){
      paddle_b_y -= paddle_speed;
      print("up\n");
    }
    
    if (keyCode == DOWN){
      paddle_b_y += paddle_speed;
      print("down\n");
    }
  }
}
```
---
# Diseño

Dado que Pong es un juego en el que los reflejos son la habilidad requerida al jugador, es importante escoger una distancia adecuada entre las palas, ya que una distancia muy pequeña podría molestar al jugador, y una muy larga provocaría partidas aburridas. En mi caso, escogí para la ventana un tamaño de 750x500px y para las palas uno de 16x100px, dejando un espaciado de 100px con los bordes laterales. Esto nos deja con 518px entre las palas... Poco más que el alto de la ventana.

Las dimensiones de la pelota (15px de diámetro) no las he estudiado demasiado. Simplemente escogí un tamaño que no fuese más grande que el ancho de las palas, para respetar las dimensiones originales del Pong.

En cierto punto se me ocurrió hacer que la velocidad de la pelota aumentase con cada rebote, para que no se jugasen rondas demasiado largas, pero deseché la idea porque creo que corta la tensión que podría surgir del enfrentamiento de dos oponentes dignos el uno del otro. Además, no deja de intentar suplir una carencia de las primeras iteraciones del programa: la velocidad de la pelota no estaba bien ajustada.

En las últimas iteraciones, añadí la detección de la colisión de las palas con los bordes de la ventana.
```processing
void checkPaddleOutOfBounds() {
  if (paddle_a_y <= paddle_height/2){
    paddle_a_y = paddle_height/2;
  }
  if (paddle_a_y > height - paddle_height/2){
    paddle_a_y = height - paddle_height/2;
  }
  if (paddle_b_y <= paddle_height/2){
    paddle_b_y = paddle_height/2;
  }
  if (paddle_b_y > height - paddle_height/2){
    paddle_b_y = height - paddle_height/2;
  }
}
```

Por último, la puntuación del jugador izquierdo está colocada a ojo, dado que el tamaño del texto no coincide con ninguna medida específica en píxeles. Por ello, coloqué primero el contador derecho a 75px del centro (horizontal) y a un cuarto de la altura total de la ventana del borde superior, y luego intenté que el otro contador quedara simétrico. 
No he implementado un contador dinámico, es decir, uno que se desplace según el número de cifras del número de puntos. Esto quiere decir que a partir de 10 puntos, los contadores se solapan o se descolocan.

---
# Referencias
* [Processing 3](https://processing.org/)
* [Processing 3 Reference](https://processing.org/reference/)
* [Gif Animation Exporting](https://github.com/extrapixel/gif-animation)
* [Guión de Prácticas](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)

---

# English
CIU-Pong is a miniproject for the **Creating User Interfaces** subject that consists in the programming of the [Pong](https://es.wikipedia.org/wiki/Pong) game using [Processing 3](https://processing.org/).

*Christian García Viguera. [Universidad de Las Palmas de Gran Canaria.](https://www2.ulpgc.es/)*

<p align="center">
  <img width="460" height="300" src="https://github.com/Chgv99/Pong/blob/main/preview.gif">
</p>

# Index
* [Behaviour](https://github.com/Chgv99/CIU-Pong#Behaviour)
  * [Randomness](https://github.com/Chgv99/CIU-Pong#Randomness)
  * [Movement](https://github.com/Chgv99/CIU-Pong#Movement)
  * [Collision Detection](https://github.com/Chgv99/CIU-Pong#Collision-Detection)
  * [Score Storage](https://github.com/Chgv99/CIU-Pong#Score-Storage)
  * [Sound Playback](https://github.com/Chgv99/CIU-Pong#Sound-Playback)
  * [Input Detection](https://github.com/Chgv99/CIU-Pong#Input-Detection)
* [Design](https://github.com/Chgv99/CIU-Pong#Design)
* [Referencies](https://github.com/Chgv99/CIU-Pong#Referencies)
---

# Behaviour

This project explores multiple concepts in Processing, such as:
* [Randomness](https://github.com/Chgv99/CIU-Pong#Randomness)
* [Movement](https://github.com/Chgv99/CIU-Pong#Movement)
* [Collision Detection](https://github.com/Chgv99/CIU-Pong#Collision-Detection)
* [Score Storage](https://github.com/Chgv99/CIU-Pong#Score-Storage)
* [Sound Playback](https://github.com/Chgv99/CIU-Pong#Sound-Playback)
* [Input Detection](https://github.com/Chgv99/CIU-Pong#Input-Detection)

## Randomness

A match starts with a random service to the left or to the right hand player. This provides both players the same probability of starting with an "*advantage*".
```processing
//50% de lanzar hacia izquierda, 50% de lanzar hacia derecha
prob = round(random(100));
if (prob > 50){
  //Derecha
  ball_speed_x = global_speed;
  ball_speed_y = 0;
} else {
  ball_speed_x = -global_speed;
  ball_speed_y = 0;
}
```
Also, on each bounce of the ball with the paddle, a value between *-global_speed* and *global_speed* is chosen randomly for the vertical speed component of the ball.
```processing
void bounce(){
  hit.play();
  ball_speed_y = round(random(-global_speed, global_speed));
}
```

## Movement

The ball starts at the center of the screen. On each loop, a certain amount (*-global_speed* and *global_speed*) is added to its components, and then it is drawn on the screen to generate a movement effect. The same goes for the paddles.
```processing
void positionElements() {
  ball_x = ball_x + ball_speed_x;
  ball_y = ball_y + ball_speed_y;
  
  circle(ball_x, ball_y, ball_d);
  rect(paddle_a_x, paddle_a_y - paddle_height/2, paddle_width, paddle_height);
  rect(paddle_b_x, paddle_b_y - paddle_height/2, paddle_width, paddle_height);
}
```

## Collision Detection

Vertical collisions are solved by reverting the sign of the vertical component when the ball touches the borders.

Horizontal collisions that involve the window borders lead up to the reset of the ball's position. By the other hand, the ones that involve the paddles, lead up to the reversal of the direction of the horizontal component and to another random vertical component selection (as explained in [Randomness](https://github.com/Chgv99/CIU-Pong#Randomness)). This way, the match is not monotone, and forces players to be more attentive.
```processing
void checkCollisions() {
  checkScoreConditions();
  
  //Colisiones
  //Paredes
  if (ball_y + (ball_d/2) > height || ball_y - (ball_d/2) < 0) {
    ball_speed_y = -ball_speed_y;
  }

  //Palas
  //Pala izquierda
  if ((ball_x - ball_d/2 < paddle_a_x + paddle_width) &&
      (ball_x + ball_d/2 > paddle_a_x) &&
      (ball_y - ball_d/2 < paddle_a_y + paddle_height/2) &&
      (ball_y + ball_d/2 > paddle_a_y - paddle_height/2)) {
    ball_speed_x = abs(global_speed);
    bounce();
  }
  
  //Pala derecha
  if ((ball_x - ball_d/2 < paddle_b_x + paddle_width) &&
      (ball_x + ball_d/2 > paddle_b_x) &&
      (ball_y - ball_d/2 < paddle_b_y + paddle_height/2) &&
      (ball_y + ball_d/2 > paddle_b_y - paddle_height/2)) {
    ball_speed_x = -abs(global_speed);
    bounce();
  }
}
```

## Score Storage

Storage of the score of each player is accomplished with an integer variable that is drawn using *text()* at the beginning of the *draw()* method, after the background. It is increased everytime a collision between the ball and a lateral border is detected.

If the ball collides with the left border, right player's score is increased, and the next service is in favor of the left player.
```processing
void printBackground() {
  background(0);
  stroke(255);
  strokeWeight(3);
  textSize(100);
  fill(255);
  text(score_b, (width/2) + 75, height/4);
  text(score_a, 
      (width/2) - 140, //200
      height/4);
  for (int i = 0; i < 10; i++){
    line(width/2, i * 50, width/2, i * 50 + 25);
  }
  noStroke();
}
```

## Sound Playback

Playback of sound files is accomplished the way it is explained in the [lab guide](https://github.com/Chgv99/CIU-Pong#Referencies).

There are two different sounds that are played: one for the collision between the ball and the paddles, and another for the goals.

It is important to highlight that the sound library does not allow *.mp3* files.
```processing
import processing.sound.*;
SoundFile hit;
SoundFile score;

void Setup(){
  hit = new SoundFile(this, "Hit11.wav");
  score = new SoundFile(this, "Hit10.wav");
}

void bounce(){
  hit.play();
  //...
}

void score(){
  score.play();
  //...
}
```

## Input Detection

Keyboard input are the interaction between the user and the game. Pressing 'W' and 'S' moves player 1, and pressing 'UP' and 'DOWN' moves player 2.

When pressing a key, the vertical component of the correspondent paddle is either increased or decreased, generating the movement effect.

Due to [Processing 3](https://github.com/Chgv99/CIU-Pong#Referencias) particularities, it is not possible to detect concurrent inputs. This results in players being unable to play at the same time. If a player is pressing a key, the other one won't be able to control their paddle. It is possible to play if the players are good enough.

For those interested: yes, it is possible to solve somehow.
```processing
void checkKeyPressed(){
  //Teclas
  if (keyPressed) {
    if (key == 'w'){
      paddle_a_y -= paddle_speed;
      print("up\n");
    }
    
    if (key == 's'){
      paddle_a_y += paddle_speed;
      print("down\n");
    }
    
    if (keyCode == UP){
      paddle_b_y -= paddle_speed;
      print("up\n");
    }
    
    if (keyCode == DOWN){
      paddle_b_y += paddle_speed;
      print("down\n");
    }
  }
}
```
---
# Design

Given that Pong is a game that requires reflexes, it is important to chose the ideal distance between the paddles, as a small distance could annoy the player, and a long one could result in boring matches. In my case, I chose a window size of 750x500px and a paddle size of 16x100px, leaving a spacing of 100px to the side borders. This way, we got 518px between the paddles... A little more than the height of the window.

I didn't study too much the dimensions of the ball (15px diameter). I simply chose a size not bigger than the width of the paddles, in order to maintain the original Pong styling.

At a certain point, I wanted to increase the ball speed with each bounce, so that the matches weren't too long, but I scrapped it because I think that removes the heat of a match between two worthy opponents. Furthermore, it tried to supplement the fact that the ball speed was not balanced enough.

In the last iterations, I added the detection of collisions between the paddles and the window borders.
```processing
void checkPaddleOutOfBounds() {
  if (paddle_a_y <= paddle_height/2){
    paddle_a_y = paddle_height/2;
  }
  if (paddle_a_y > height - paddle_height/2){
    paddle_a_y = height - paddle_height/2;
  }
  if (paddle_b_y <= paddle_height/2){
    paddle_b_y = paddle_height/2;
  }
  if (paddle_b_y > height - paddle_height/2){
    paddle_b_y = height - paddle_height/2;
  }
}
```

Last but not least, left player score is placed by eye, due to the size of the text does not seem to be equivalent to a certain amount of pixels of width nor height. Because of this, I first placed the right counter at 75px from the horizontal center and at a quarter of the total height of the window from the top border, and then I tried to place the other counter symmetrically.
I haven't implemented a dynamic counter. In other words, a counter that repositions itself depending the number of digits. This means that beyond 10 points, the counters overlap or are misplaced.

---
# Referencias
* [Processing 3](https://processing.org/)
* [Processing 3 Reference](https://processing.org/reference/)
* [Gif Animation Exporting](https://github.com/extrapixel/gif-animation)
* [Lab Guide](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/37/CIU_Pr_cticas.pdf)
