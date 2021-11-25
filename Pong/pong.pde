//import gifAnimation.*;
//GifMaker gifExport;    
import processing.sound.*;
SoundFile hit;
SoundFile score;

//ball
float ball_x, ball_y, ball_d, ball_speed_x, ball_speed_y;

int a_y;
int b_y;

int paddle_spacing = 100;
int paddle_a_x, paddle_a_y, paddle_b_x, paddle_b_y;
int paddle_width, paddle_height;

int prob;

float global_speed = 2; //25
float gspeed;
float inc_speed = 0.25; //Bola
int paddle_speed = 3; //25

int score_a = 0;
int score_b = 0;

void setup() {
  size(750, 500);
  frameRate(200); //12
  //gifExport = new GifMaker(this, "final.gif");
  //gifExport.setRepeat(0);        // make it an "endless" animation
  //gifExport.setTransparent(100,100,100);  // black is transparent
  hit = new SoundFile(this, "Hit11.wav");
  score = new SoundFile(this, "Hit10.wav");

  ball_d = 15; //Diámetro
  ball_x = width/2;
  ball_y = height/2;
  
  paddle_width = 16;
  paddle_height = 100;
  
  paddle_a_x = paddle_spacing; //separación de 100px con el borde
  paddle_b_x = width - paddle_spacing - paddle_width; //separación de 100px con el borde
  paddle_a_y = height/2;
  paddle_b_y = height/2;
  
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
}

void draw() {
  render();
  //gifExport.setDelay(0);
  //gifExport.addFrame();
  
  //if (score_a == 2 || score_b == 2) {
    //gifExport.finish();    
  //}
}

void render(){
  //background(map(mouseX,0,255,0,width),map(mouseY,0,255,0,height), ball_x);
  printBackground();
  
  positionElements();
  
  checkKeyPressed();
  
  checkCollisions();
  
  checkPaddleOutOfBounds();
}

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

void positionElements() {
  ball_x = ball_x + ball_speed_x;
  ball_y = ball_y + ball_speed_y;
  
  circle(ball_x, ball_y, ball_d);
  rect(paddle_a_x, paddle_a_y - paddle_height/2, paddle_width, paddle_height);
  rect(paddle_b_x, paddle_b_y - paddle_height/2, paddle_width, paddle_height);
}

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

void checkScoreConditions(){
  //Condiciones de punto
  //Marca izquierdo
  if (ball_x + ball_d/2 > width) {
    ball_x = width/2;
    ball_y = height/2;
    
    score_a++;
    
    //La bola se saca hacia el derecho
    ball_speed_x = global_speed;
    score();
    paddle_a_y = height/2;
    paddle_b_y = height/2;
  }

  //Marca derecho
  if (ball_x - (ball_d/2) < 0) {
    ball_x = width/2;
    ball_y = height/2;
    
    score_b++;
    
    //La bola se saca hacia el izquierdo
    ball_speed_x = -global_speed;
    score();
    paddle_a_y = height/2;
    paddle_b_y = height/2;
  }
}

void bounce(){
  hit.play();
  ball_speed_y = round(random(-global_speed, global_speed));
}

void score(){
  score.play();
  ball_speed_y = 0;
  a_y = height/2;
  b_y = height/2;
}

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
