import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
//Detectores
import org.opencv.objdetect.CascadeClassifier;
//Máscara del rostro
import org.opencv.face.Face;
import org.opencv.face.Facemark;

import java.nio.*;
import org.opencv.core.Mat;
import org.opencv.core.CvType;

Capture cam;
CVImage img;

//Detectores
CascadeClassifier face;
//Máscara del rostro
Facemark fm;
//Nombres
String faceFile, modelFile;

PShape face_shape;

//EYES
PImage left_eye, right_eye;
int leye_x, leye_y, reye_x, reye_y, eyeb_y, face_d;

//MOUTH
float alpha_product;
PImage mouth;
int mouth_x, mouth_y, mouth_amplitude, mouth_min_y, mouth_max_y;

// DEBUG
boolean debug, outlines, smooth;

//FILTER STATE
int filter;

void setup() {
  size(640, 540);
  debug = false;
  outlines = false;
  smooth = true;
  filter = 0;
  
  //Cámara
  cam = null;
  while (cam == null) {
    //cam = new Capture(this, width , height-60, "");
    cam = new Capture(this, width , height-60);
  }
  
  cam.start(); 
  
  //OpenCV
  //Carga biblioteca core de OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  img = new CVImage(cam.width, cam.height);
  
  //Detectores
  faceFile = "haarcascade_frontalface_default.xml";
  //Modelo de máscara
  modelFile = "face_landmark_model.dat";
  fm = Face.createFacemarkKazemi();
  fm.loadModel(dataPath(modelFile));
}

void draw() {  
  if (cam.available()) {
    background(0);
    cam.read();
    
    //Get image from cam
    img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
    img.copyTo();
    
    //Face distance reference (from drawFacemarks())
    face_d = leye_y - eyeb_y;
    mouth_amplitude = mouth_min_y - mouth_max_y;
    alpha_product = 25.33/(float)face_d;
    
    //Imagen de entrada
    image(img,0,0);
    
    switch (filter){
      case 0:
        sixEyes();
        break;
      case 1:
        mouthEyes();
        break;
      default:
        break;
    }
    
    
    pushStyle();
    fill(0);
    rect(0, height-40, width, 40);
    popStyle();
    textAlign(CENTER);
    textSize(15);
    text("[<-] Previous Filter    [D] Debug  [O] Outlines  [S] Smoothness    Next Filter [->]", width/2, height-20);
    
    if (debug) {
      pushStyle();
      fill(0);
      rect(0, 0, width, 30);
      popStyle();
      textAlign(LEFT);
      textSize(15);
      text("Face Distance Factor: " + face_d + "    Alpha Distance: " + alpha_product, 15, 22);
      println("face_d: " + face_d);
      println("alpha_product: " + alpha_product);
    }
    //Detección de puntos fiduciales
    ArrayList<MatOfPoint2f> shapes = detectFacemarks(cam);
    PVector origin = new PVector(0, 0);
    
    for (MatOfPoint2f sh : shapes) {
        Point [] pts = sh.toArray();
        drawFacemarks(pts, origin);
        //shape(face_shape);
    }
   
  }
}

private void mouthEyes(){
  //Cropped region of original image
  mouth = img.get(mouth_x-(face_d/4),mouth_y-((mouth_amplitude+20)/2),(int)(face_d*3.75),(int)(abs(mouth_amplitude+20)));
  if (smooth) {
    smoothenEdges(mouth);
  }
  image(mouth,leye_x-(face_d/4)-25,leye_y-(mouth_amplitude+20)/2);
  image(mouth,reye_x-(face_d/4)-25,reye_y-(mouth_amplitude+20)/2);
}

private void sixEyes(){
  //Cropped region of original image
  left_eye = img.get(leye_x-face_d/4,leye_y-face_d/2,(int)(face_d*1.75),(int)(face_d));
  right_eye = img.get(reye_x-face_d/4,reye_y-face_d/2,(int)(face_d*1.75),(int)(face_d));
  if (smooth) {
    smoothenEdges(left_eye);
    smoothenEdges(right_eye);
  }
  image(left_eye,leye_x-face_d/4,leye_y - face_d * 2.25);
  image(right_eye,reye_x-face_d/4, reye_y - face_d * 2.25);
  image(left_eye,leye_x-face_d/4, (int)(reye_y + face_d * 0.5));
  image(right_eye,reye_x-face_d/4, (int)(reye_y + face_d * 0.5));
}

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

private ArrayList<MatOfPoint2f> detectFacemarks(PImage i) {
  ArrayList<MatOfPoint2f> shapes = new ArrayList<MatOfPoint2f>();
  CVImage im = new CVImage(i.width, i.height);
  im.copyTo(i);
  MatOfRect faces = new MatOfRect();
  Face.getFacesHAAR(im.getBGR(), faces, dataPath(faceFile)); 
  if (!faces.empty()) {
    fm.fit(im.getBGR(), faces, shapes);
  }
  return shapes;
}

private void drawFacemarks(Point [] p, PVector o) {
  pushStyle();
  noStroke();
  //fill(255,0,0);
  noFill();
  face_shape = createShape();
  face_shape.beginShape();
  int i = 0;
  for (Point pt : p) {
    face_shape.vertex((float)pt.x+o.x, (float)pt.y+o.y);
    //ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
    if (i == 42) {
      //Right eye's leftmost vertex
      stroke(255,0,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 5, 5);
      reye_x = (int)(pt.x+o.x);
      reye_y = (int)(pt.y+o.y);
    } else if (i == 36) {
      stroke(255,0,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 5, 5);
      leye_x = (int)(pt.x+o.x);
      leye_y = (int)(pt.y+o.y);
    } else if (i == 18) {
      stroke(0,255,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      eyeb_y = (int)(pt.y+o.y);
    } else if (i == 48) {
      stroke(255,255,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      mouth_x = (int)(pt.x+o.x);
      mouth_y = (int)(pt.y+o.y);
    } else if (i == 50) {
      stroke(255,255,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      mouth_max_y = (int)(pt.y+o.y);
    } else if (i == 58) {
      stroke(255,255,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      mouth_min_y = (int)(pt.y+o.y);
    } else {
      stroke(255);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 1, 1);
    }
    i++;
  }
  face_shape.endShape(CLOSE);
  popStyle();
}

void keyReleased(){
  if (key == CODED) {
    if (keyCode == LEFT) {
      filter--;
      if (filter < 0){
        filter = 1;
      }
    }
    if (keyCode == RIGHT) {
      filter++;
      if (filter > 1){
        filter = 0;
      }
    }
  } else {
    if (keyCode == 'D'){
      debug = !debug;
    }
    if (keyCode == 'O'){
      outlines = !outlines;
    }
    if (keyCode == 'S'){
      smooth = !smooth;
    }
  }
  
}
