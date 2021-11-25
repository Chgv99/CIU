import queasycam.*;

QueasyCam cam;

PImage skybox, skybox_sunset, stone_floor, building_texture;
PShape box, skybox_shape, building, skull;
PShape floor, wall1, wall2, wall3, wall4;

int level;
int posx, posy, posz;

boolean check;

float angle, angle1, des_angle;
float room_width, room_depth, room_height;
float player_height;
float fov;

float spotlight_y;

PShader lightShader;

ArrayList<PShape> cubes;

void setup() {
  size(1280, 720, P3D);
  //lightShader = loadShader("lightfrag.g1s1", "lightvert.g1s1");
  skybox = loadImage("images/skybox.jpg");
  skybox_sunset = loadImage("images/skybox-sunset.jpg");
  stone_floor = loadImage("images/stone.jpg");
  building_texture = loadImage("images/building.jpg");
  skull = loadShape("model/12140_Skull_v3_L2.obj");

  /**  VARS  **/
  angle = 0;
  des_angle = 0;
  fov = PI/2;
  player_height = height/2 - 200;
  room_width = 2000;
  room_depth = 2000;
  room_height = 500;
  posx = 0;
  posy = 0;
  posz = 0;
  level = 1;
  check = false;

  cubes = new ArrayList<PShape>();

  skybox_shape = createShape(SPHERE, 10000);
  beginShape();
  skybox_shape.setTexture(skybox_sunset);
  endShape();
  box = createShape(BOX, new float[]{2000, 10, 2000});
  box.setTexture(loadImage("images/skybox.jpg"));
  endShape();
  building = createShape(BOX, new float[]{500, 2000, 500});
  building.setTexture(loadImage("images/building.jpg"));

  /**  camera settings  **/
  cam = new QueasyCam(this);
  cam.position = new PVector(0, player_height, 0);
  cam.friction = 0.75;
  cam.speed = 5;
  cam.sensitivity = 0.5;
  //cam.setMinimumDistance(100);
  perspective(fov, 
    1280/500, //width/height, 
    (height/2.0) / tan(fov/2.0)/10, 
    (height/2.0) / tan(fov/2.0) * 80);

  spotlight_y = 2000;

  /**  BOXES  **/
  createRoom(room_width, room_depth, room_height, 255, 255, 255);
}

void draw() {
  background(0);
  noFill();
  skybox_shape.setStroke(255);//stroke(255);
  shape(skybox_shape);
  translate(width/2, height/2, 0);
  cam.position.y = player_height;//+ 300;

  if (focused) {
    noCursor();

  }


  //rotateY(angle*10);
  fill(0);
  noStroke();

  PVector forward = cam.getForward();

  switch (level) {
    case 1:
      posx = width/2+100;
      posy = -100;
      posz = 200;
      break;
    case 2:
      posx = width/2-550;
      posy = -100;
      posz = 0;
      break;
    case 3:
      posx = width/2-600;
      posy = -100;
      posz = -870;
      break;
    case 4:
      posx = width/2-800;
      posy = -100;
      posz = -300;
      break;
    case 5:
      posx = width/2+100;
      posy = -100;
      posz = -100;
      break;
    case 6:
      posx = width/2;
      posy = -100;
      posz = -460;
      break;
    case 7:
      posx = 500-width/2;
      posy = 0;
      posz = 500;
      break;
    case 8:
      posx = width/2-250;
      posy = -100;
      posz = 10;
      break;
    case 9:
      posx = width/2-800;
      posy = -100;
      posz = +270;
      break;
    case 10:
      posx = width/2;
      posy = -100;
      posz = 0;
      break;
    default:
      pushMatrix();
      rotateY(radians(angle)*50);
      //skull.scale(1.5);
      showSkull(200, 0, 200, false);
      showSkull(-200, -500, 200, false);
      showSkull(-200, -500, -200, false);
      showSkull(200, -500, -200, false);
      spotLight(255, 0, 0, 200, -500, 1000, -1, 1, -1, PI/2, 10);
      spotLight(255, 255, 0, -1000, -500, 1000, 1, 1, -1, PI/2, 10);
      spotLight(0, 255, 0, -1000, -500, -1000, 1, 1, 1, PI/2, 10);
      spotLight(0, 0, 255, 1000, -500, -1000, -1, 1, 1, PI/2, 10);
      popMatrix();
      sphere(100);
      break;
  }

  if (level < 10) drawCoin(posx, posy, posz);
  else if (level == 10) showSkull(posx,posy,posz);
  
  println(abs(cam.position.x - posx));
  if (abs(cam.position.x - posx - width/2) <= 75 && abs(cam.position.z - posz) <= 75) {
    level++;
  }
  if (level >= 11) level = 11;
  
  
  directionalLight(100, 50, 0, 0.8, 0, 1);

  fill(255);

  pushMatrix();
  translate(0, -400, 0);
  rotateY(radians(-angle)*10);
  fill(255);

  pushMatrix();
  translate(100, 0, 0);
  popMatrix();

  popMatrix();

  fill(255);

  pushMatrix();
  translate(room_width/2, -room_height, room_depth/2);
  rotateY(PI/2);
  shape(wall1);
  popMatrix();
  pushMatrix();
  translate(-room_width/2, -room_height, room_depth/2);
  rotateY(0);
  shape(wall2);
  popMatrix();
  pushMatrix();
  translate(-room_width/2, -room_height, room_depth/2);
  rotateY(PI/2);
  shape(wall3);
  popMatrix();
  pushMatrix();
  translate(-room_width/2, -room_height, -room_depth/2);
  rotateY(0);
  shape(wall4);
  popMatrix();
  pushMatrix();
  translate(-room_width/2, 0, -room_depth/2);
  rotateX(PI/2);
  shape(floor);
  popMatrix();

  /**  BUILDINGS  **/
  building.setStroke(255);
  //building.setTexture(building_texture);
  pushMatrix();
  translate(2500, -750, 1500);
  rotateY(PI/2);
  shape(building);
  popMatrix();

  pushMatrix();
  translate(2600, -500, 900);
  rotateY(PI/2);
  shape(building);
  popMatrix();

  pushMatrix();
  translate(2000, -300, -100);
  rotateY(PI/2);
  shape(building);
  popMatrix();
  
  pushMatrix();
  translate(100, -700, 5500);
  rotateY(PI/2);
  shape(building);
  popMatrix();
  
  pushMatrix();
  translate(700, -900, 4100);
  rotateY(PI/2);
  shape(building);
  popMatrix();

  pushMatrix();
  translate(-500, -700, -4600);
  rotateY(PI/2);
  shape(building);
  popMatrix();
  
  pushMatrix();
  translate(-1000, -700, -2600);
  rotateY(PI/2);
  shape(building);
  popMatrix();
  
  pushMatrix();
  translate(-3500, -700, -1500);
  rotateY(PI/2);
  shape(building);
  popMatrix();
  
  pushMatrix();
  translate(-1100, -900, -2100);
  rotateY(PI/2);
  shape(building);
  popMatrix();

  pushMatrix();
  translate(-500, -700, -4600);
  rotateY(PI/2);
  shape(building);
  popMatrix();
  
  pushMatrix();
  translate(500, -700, -2600);
  rotateY(PI/2);
  shape(building);
  popMatrix();

  /**  update variables  **/
  angle += PI/64;
  angle1 += 1;
  spotlight_y -= 1;


  showTextInHUD("·", width/2, height/2);
  showTextInHUD("No maximizar la ventana", width/2 - 250, -200);
  showTextInHUD("level: " + level, -550, 100);
  showTextInHUD(posz + "", -550, 50);
  showTextInHUD(posy + "", -550, 0);
  showTextInHUD(posx + "", -550, -50);
  showTextInHUD(cam.position.x + "", -550, -100);
  showTextInHUD(cam.position.y + "", -550, -150);
  showTextInHUD(cam.position.z + "", -550, -200);
}

void showSkull(int x, int y, int z, boolean light) {
  pushMatrix();
  translate(x, -300, z);
  rotateY(radians(angle)*80);
  if(light) spotLight(255, 0, 0, 0, 0, 0, 0, 1, 0, PI/2, 10);
  pushMatrix();
  translate(0, sin(angle)*20+200, 0);
  rotateX(PI/2);

  fill(255, 0, 0);
  shape(skull);
  popMatrix();
  pushMatrix();
  translate(0, 0, 0);
  fill(255, 255, 255);
  if(light)spotLight(255, 0, 0, 0, 0, 0, 1, 0.25, 0, PI/2, 50);
  if(light)spotLight(255, 0, 0, 0, 0, 0, -1, 0.25, 0, PI/2, 50);
  popMatrix();
  popMatrix();
}

void showSkull(int x, int y, int z) {
  pushMatrix();
  translate(x, -300, z);
  rotateY(radians(angle)*80);
  spotLight(255, 0, 0, 0, -200, 0, 0, 1, 0, PI/2, 5);
  pushMatrix();
  translate(0, sin(angle)*20+200, 0);
  rotateX(PI/2);

  fill(255, 0, 0);
  shape(skull);
  popMatrix();
  pushMatrix();
  translate(0, 0, 0);
  fill(255, 255, 255);
  spotLight(255, 0, 0, 0, 0, 0, 1, 0.25, 0, PI/2, 50);
  spotLight(255, 0, 0, 0, 0, 0, -1, 0.25, 0, PI/2, 50);
  popMatrix();
  popMatrix();
}

void createRoom(float f_width, float f_depth, float r_height, float r, float g, float b) {
  noStroke();
  fill(r, g, b);
  wall1 = createRect(0, 0, 0, (int)f_depth, (int)r_height);
  wall2 = createRect(0, 0, 0, (int)f_width, (int)r_height);
  wall3 = createRect(0, 0, 0, (int)f_depth, (int)r_height);
  wall4 = createRect(0, 0, 0, (int)f_width, (int)r_height);
  floor = createRect(0, 0, 0, (int)f_width, (int)f_depth);
  //drawFloor(0, 0, 0, f_size, 10, f_size);
}

void drawWall(float x, float y, float z, float w_width, float w_depth, float w_height, boolean rot, float r, float g, float b) {
}

void drawFloor(float pos_x, float pos_y, float pos_z, float size_x, float size_y, float size_z) {
  pushMatrix();
  translate(pos_x, pos_y, pos_z);
  //rotateX(PI/2);
  fill(0);
  //rect(0, 0, size_x, size_y);
  box(size_x, size_y, size_z);

  popMatrix();
}

void drawCoin(float x, float y, float z) {
  pushMatrix();
  translate(x, sin(angle)*20-100, z);
  noStroke();
  fill(#fede00);
  rotateY(angle);
  box(50, 50, 50);
  pushMatrix();
  translate(0, -200, 0);
  spotLight(254, 222, 0, 0, -200, 0, 0, 1, 0, PI/2, 5);
  popMatrix();
  popMatrix();
}

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

void showRects() {  
  fill(255);
  stroke(255);
  for (PShape box : cubes) {
    //println(box);
    shape(box);
  }
}

void showTextInHUD(String str1, float x, float y) {
  // A small 2D HUD for text at
  // free pos.
  // This func may only be called a the very end of draw() afaik.
  camera();
  hint(DISABLE_DEPTH_TEST);
  noLights();
  textMode(MODEL);
  textSize(45);
  if (str1!=null)
    text(str1, x, y);
  hint(ENABLE_DEPTH_TEST);
  //lights();
} // func 
