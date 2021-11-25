//import java.lang.*;
//import cvimage.*;
//import org.opencv.core.*;
FaceController fc;

void setup() {
  size(640, 480);
  fc = new FaceController(this, "Trust Webcam");
  
  //You can also call process() inside setup();
}

void draw() {  
  background(0);
  fc.process();
  PImage faceImg = fc.getFaceCrop();
  image(faceImg, width/2 - faceImg.width/2, height/2 - faceImg.height/2, faceImg.width, faceImg.height);
}
