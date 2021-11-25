boolean left_drag, right_drag;
boolean show_text, light, s_ship;
int translate_x, translate_y, translate_z, zoom_factor;
float ang, rot_x, rot_y;
PImage img_sol, img_mercurio, img_venus, img_tierra, img_marte, img_jupiter;
ArrayList star_positions;
PShape sistema, sol, mercurio, venus, tierra, luna, marte, jupiter;

//Cámara
float px, py, pz, vx, vy, vz;

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
  
  //sistema = createShape(GROUP);
  sol = createCelestialBody(100, img_sol);
  mercurio = createCelestialBody(10, img_mercurio);
  venus = createCelestialBody(20, img_venus);
  tierra = createCelestialBody(20, img_tierra);
  luna = createCelestialBody(3, img_mercurio);
  marte = createCelestialBody(13, img_marte);
  jupiter = createCelestialBody(35, img_jupiter);
  
  /*sistema.addChild(mercurio);
  sistema.addChild(venus);
  sistema.addChild(tierra);
  sistema.addChild(luna);
  sistema.addChild(marte);
  sistema.addChild(jupiter);*/
  
  //Inicializa
  ang=0;
  translate_x = width/2;
  translate_y = height/2;
  translate_z = -500;
  zoom_factor = 2;
  show_text = true;
  light = true;
  s_ship = false;
  
  rot_x = 0;
  rot_y = 0;
  
  vx = 135;
  vz = -350;
  //vz = (height/2.0) / tan(PI*30.0 / 180.0);
}


void draw()
{
  background(0);
  //translate(translate_x, translate_y, translate_z);
  camera(0, 0, 1, 0, 0, 0, 0, 1, 0);
  if (s_ship) {
    
    rotateZ(radians(px));
    rotateX(radians(py));
    rotateY(radians(vx));
    translate(-vz, 0, -vz);
    //vz=0;
    //vx=0;
    println("px: " + px);
    println("py: " + py);
    println("pz: " + pz);
    println("vx: " + vx);
    println("vz: " + vz);
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
  addCelestialBody(venus, 1.5, 8.5, 350, -20, 0, "Venus"); //Venus
  popMatrix();
  pushMatrix();
  addCelestialBody(tierra, 2, 3, 450, 15, 0, "Tierra"); //Tierra
  //La Luna rota más lento para que solo muestre una cara a la Tierra
  addCelestialBody(luna, -16, -1, 70, 5, 5, "Luna"); //Luna
  popMatrix();
  pushMatrix();
  addCelestialBody(marte, -3, -0.7, 550, 5, -6, "Marte"); //Marte
  popMatrix();
  pushMatrix();
  addCelestialBody(jupiter, 0.5, -5.4, 650, -10, 0, "Júpiter"); //Júpiter
  popMatrix();
  
  //Resetea tras giro completo
  ang=ang+0.25;
  /*
  if (ang>360)
    ang=0;*/
    
  key();
}

PShape createCelestialBody(float radius, PImage texture){
  PShape cuerpo;
  beginShape();
  cuerpo = createShape(SPHERE, radius);
  cuerpo.setStroke(255);
  cuerpo.setTexture(texture);
  endShape();
  return cuerpo;
}

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

void addCelestialBody(PShape cuerpo, float translation_speed, float rotation_speed, float orbit_radius, float tilt, float orbit_tilt, String name, int name_distance){
  rotateZ(radians(orbit_tilt));
  rotateY(radians(ang * translation_speed));
  
  translate(orbit_radius, 0, 0);
  textAlign(CENTER);
  textSize(40);
  if (!light) text(name, 0, name_distance);
  rotateZ(radians(tilt));
  rotateY(radians(ang*rotation_speed));
  shape(cuerpo);
}

void key() {
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
      } else {
        //Zoom
        if (key == '+'){
          println("P");
          translate_z += zoom_factor;
        }
        if (key == '-'){
          println("P");
          translate_z -= zoom_factor;
        }
      }
      /*if (vx > 1) vx = -1;
      if (vx < -1) vx = 1;
      if (vy > 1) vy = -1;
      if (vy < -1) vy = 1;*/
    }
  }
}

void mouseReleased(){
  left_drag = false;
  right_drag = false;
}

void mouseDragged(){
  if (mousePressed && (mouseButton == LEFT)){
    left_drag = true;
  }
  if (mousePressed && (mouseButton == RIGHT)){
    right_drag = true;
  }
}

void keyPressed() {
  
}

void keyReleased() {
  if (key == CODED) {
    
  } else {
    if (keyCode == 'L') {
      light = !light;
    }
    if (keyCode == ' ') {
      s_ship = !s_ship;
    }
  }
}
