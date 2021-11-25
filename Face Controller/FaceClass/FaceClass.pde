/**Terminar barbilla
*  Inclinación de la cabeza
*  Punto superior (relativo a la inclinación)
*  de las cejas (para las expresiones).
*  Hacer que faceController.getFace().getCenter()
*  sea equivalente a hacer faceController.getCenter()????
*  Fix mouth (rebuild)*/

import java.lang.*;
import cvimage.*;
import org.opencv.core.*;
FaceController faceController;
RealFace playerFace;

float calibrationFactor;

Point position;

// DEBUG
boolean debug, outlines, smooth;

Point[] left_points;

float left_eyebrow_x;
float left_eyebrow_y;
float right_eyebrow_x;
float right_eyebrow_y;
int cal_i;

//Copy test
RealEye leftEyeCopy;
RealEye rightEyeCopy;
RealFace faceCopy;

PImage img1;
PVector img1Pos;   

void setup() {
  size(640, 480);
  debug = false;
  outlines = false;
  smooth = true;
  cal_i = 0;
  
  position = new Point(width/2, height/2);
  faceController = new FaceController(this, "Trust Webcam", 0.35);
  //faceController = new FaceController(this, "DroidCam Source 3", 0.35);
}

void draw() {  
  background(0);
  boolean available = faceController.process(debug);
  RealFace face = faceController.copyFace(); //getFace()
  PImage img = face.getCrop();
  float imgRatio = face.getCropRatio(); //== img.width/img.height
  float w = 125;
  float h = w / imgRatio;
  
  image(img, (float)position.x - w/2, (float)position.y - h/2, w, h);
  faceController.print();
  print(faceController.getMouth().verticalAmplitude());
  
  if (faceCopy != null) {
    image(img1, img1Pos.x, img1Pos.y);
  }
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == UP) {
      position.y -= 5;
    }
    if (keyCode == DOWN) {
      position.y += 5;
    }
    if (keyCode == LEFT) {
      position.x -= 5;
    }
    if (keyCode == RIGHT) {
      position.x += 5;
    }
  }
}

void keyReleased(){
  if (key == CODED) {
    
  } else {
    if (keyCode == 'D'){
      debug = !debug;
    }
    if (keyCode == 'O'){
      outlines = !outlines;
    }
    if (keyCode == 'S'){
      //smooth = !smooth;
      noLoop();
    }
    if (keyCode == 'L'){
      //smooth = !smooth;
      loop();
    }
    if (keyCode == ' '){
      faceCopy = faceController.copyFace();
      //println("espacio");
      //println(faceCopy.getCrop());
      img1 = faceCopy.getCrop();
      img1Pos = new PVector(random(0,100),random(0,100));
      //println(faceCopy);
      //leftEyeCopy = faceController.getLeftEye().copy();
      //rightEyeCopy = faceController.getRightEye().copy();
    }
  }
}
