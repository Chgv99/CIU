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

import processing.sound.*;

Capture cam;
CVImage img;

//Detectores
CascadeClassifier face;
//Máscara del rostro
Facemark fm;
//Nombres
String faceFile, modelFile;

PShape face_shape;

//FACE
int face_center_x, face_center_y;

//EYES
PImage left_eye, right_eye;
int leye_x1, leye_x2, leye_y1, leye_y2, leye_center_x, leye_center_y;
int leye_width, leye_height;
int reye_x1, reye_x2, reye_y1, reye_y2, reye_center_x, reye_center_y;
int reye_width, reye_height;
int eyeb_y, face_d;

//MOUTH
float alpha_product;
PImage mouth;
int mouth_x1, mouth_x2, mouth_y1, mouth_y2, mouth_width, mouth_height;
int mouth_amplitude;

// DEBUG
boolean debug, outlines, smooth;
boolean closed;

//FILTER STATE
int filter;

//SOUND
WhiteNoise noise;
BandPass noise_filter;
SinOsc[] sineWaves; 

int numSines = 5; 
float[] sineVolume;

void setup() {
  size(640, 480);
  debug = false;
  outlines = false;
  smooth = true;
  filter = 0;
  
  //Cámara
  cam = null;
  while (cam == null) {
    //cam = new Capture(this, width , height-60, "");
    cam = new Capture(this, width , height);
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
  
  //SOUND
  noise = new WhiteNoise(this);
  noise_filter = new BandPass(this);
  noise.play(0.5);
  noise_filter.process(noise);
  
  sineWaves = new SinOsc[numSines];
  
  createSines(numSines);
}

private void createSines(int numSines){
  if (sineWaves[0] != null) {
    for (int i = 0; i < sineWaves.length; i++) {
      sineWaves[i].stop();
    }
  }
  
  sineVolume = new float[numSines]; 
  for (int i = 0; i < numSines; i++) {

    // The overall amplitude shouldn't exceed 1.0 which is prevented by 1.0/numSines.
    // The ascending waves will get lower in volume the higher the frequency.
    sineVolume[i] = (1.0 / numSines) / (i + 1);

    // Create the Sine Oscillators and start them
    sineWaves[i] = new SinOsc(this);
    sineWaves[i].play();
  }
}

void draw() {  
  if (cam.available()) {
    background(0);
    cam.read();
    
    //Get image from cam
    img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
    img.copyTo();
    
    
    //alpha_product = 25.33/(float)face_d;
    //reye_amplitude = reye_min_y - reye_max_y;
    //reye_amplitude_y = reye_min_y - reye_max_y;
    //leye_amplitude_y = leye_min_y - leye_max_y;
    //leye_amplitude_x = leye_x2 - leye_x;
    //println(mouth_amplitude);
    
    //Sound
    //float bandwidth = map(face_center_y, 0, height, 4000, -200);
    //float bandwidth = map(reye_min_y - reye_max_y, 0, 25, 0, 10000);
    
    /*
    //float frequency = map(abs(mouth_amplitude), 0, 7000, 0.0005, 20000); 
    float frequency = 0;
    if ( face_d > 0 && mouth_amplitude >= 1200) frequency = map(abs(mouth_amplitude), 2000, 4000, 0.000005, 20000);
    float amplitude = 0;
    if ( face_d > 0 && mouth_amplitude >= 1200) amplitude = map(abs(mouth_amplitude), 2000, 4000, 0.0, 10);
    //float amplitude = map(reye_height, 0, 25, 0.0, 1); 
    
    noise.amp(amplitude);
    noise_filter.freq(frequency);
    */
    
    //noise_filter.bw(bandwidth);
    
    //Sound
    float yoffset = (height - face_center_y) / float(height);
    float frequency = pow(1000, yoffset) + 150;
    float detune = float(face_center_x) / width - 0.5;
    // Set the frequencies, detuning and volume
    for (int i = 0; i < numSines; i++) { 
      sineWaves[i].freq(frequency * (i + 1 + i * detune));
      sineWaves[i].amp(sineVolume[i]);
    }
    
    //Imagen de entrada
    image(img,0,0);
    
    //Detección de puntos fiduciales
    ArrayList<MatOfPoint2f> shapes = detectFacemarks(cam);
    PVector origin = new PVector(0, 0);
    
    for (MatOfPoint2f sh : shapes) {
        Point [] pts = sh.toArray();
        drawFacemarks(pts, origin);
        //shape(face_shape);
    }
          
    //Face distance reference (from drawFacemarks())
    //face_d = leye_y1 - eyeb_y;
    face_d = leye_center_y - eyeb_y;
    mouth_height = mouth_y2 - mouth_y1;
    mouth_width = mouth_x2 - mouth_x1;
    mouth_amplitude = mouth_width * mouth_height; 
    
    leye_width = leye_x2 - leye_x1;
    leye_height = leye_y2 - leye_y1;
    leye_center_x = leye_x1 + leye_width/2;
    leye_center_y = leye_y1 + leye_height/2;
    reye_width = reye_x2 - reye_x1;
    reye_height = reye_y2 - reye_y1;
    reye_center_x = reye_x1 + reye_width/2;
    reye_center_y = reye_y1 + reye_height/2;
    
    if ((leye_height <= 6 || reye_height <= 6) && !closed) {
      numSines++;
      if (numSines > 5) numSines = 1;
      createSines(numSines);
      closed = true;
    } else {
      closed = false;
    }
    
    /*println(" leye_y1: " + leye_y1
            + " leye_y2: " + leye_y2
            + " leye_height: " + leye_height);*/
    /*println(" reye_y1: " + reye_y1
            + " reye_y2: " + reye_y2
            + " reye_height: " + reye_height);*/
    
    
    
    pushStyle();
    fill(0,0,0,120);
    rect(10, height-45, width-20, 35);
    rect(width/2 - width/8 - 20, height-85, width/4 + 40, 35);
    popStyle();
    textAlign(CENTER);
    textSize(15);
    text("[Blink] Increase Oscillators        [D] Debug        [O] Outlines        [S] Smoothness", width/2, height-22);
    
    
    if (leye_width > 0 && leye_height > 0 && reye_width > 0 && reye_height > 0) {
      switch (filter){
        case 0:
          sixEyes(smooth);
          textSize(15);
          textAlign(CENTER);
          text("Six Eyes", width/2, height-62);
          text("[<-]                        [->]", width/2, height-62);
          break;
        case 1:
          mouthEyes(smooth);
          textSize(15);
          textAlign(CENTER);
          text("Mouth Eyes", width/2, height-62);
          text("[<-]                        [->]", width/2, height-62);
          break;
        default:
          break;
      }
    }

    if (debug) {
      pushStyle();
      fill(0,0,0,120);
      rect(10, 10, width/3, 140);
      fill(0);
      popStyle();
      textAlign(LEFT);
      textSize(10);
      text("Face Distance Factor: " + face_d, 20, 30);
      //text(" height: " + mouth_height, 20, 40);
      text("Left eye vertical amplitude: " + leye_height, 20, 45);
      text("Right eye vertical amplitude: " + reye_height, 20, 60);
      text("Left eye x: " + leye_center_x + " Left eye y: " + leye_center_y, 20, 75);
      text("Right eye x: " + reye_center_x + " Right eye y: " + reye_center_y, 20, 90);
      text("Mouth vertical amplitude: " + mouth_height, 20, 105);
      text("Mouth area: " + mouth_amplitude, 20, 120);
      text("Number of oscillators: " + numSines + "/5", 20, 135);
    }
  }
}

private void sixEyes(boolean smoothen){
  if (leye_height > 0 && leye_width > 0 && reye_height > 0 && reye_width > 0 && face_d > 0) {
    left_eye = img.get(leye_x1-face_d/4,leye_y1-face_d/4,leye_width+face_d/2,leye_height+face_d);
    right_eye = img.get(reye_x1-face_d/4,reye_y1-face_d/4,reye_width+face_d/2,reye_height+face_d);
    
    if (smoothen) {
      smoothenEdges(left_eye);
      smoothenEdges(right_eye);
    }
    
    image(left_eye, leye_x1, leye_y1 - face_d * 2.5);
    image(right_eye, reye_x1, reye_y1 - face_d * 2.5);
    
    image(left_eye, leye_x1, leye_y1 + face_d * 1.5);
    image(right_eye, reye_x1, reye_y1 + face_d * 1.5);
  }
}

private void mouthEyes(boolean smoothen){
  if (mouth_height > 0 && mouth_width > 0 && face_d > 0) {
    mouth = img.get(mouth_x1-(face_d/4),mouth_y1-(face_d/4),mouth_width+(face_d/2),mouth_height+(face_d/2));
  }
  if (smoothen) {
    smoothenEdges(mouth);
  }
  image(mouth,leye_center_x - mouth_width/2 - (face_d/4), leye_center_y - mouth_height/2 - (face_d/4));
  image(mouth,reye_center_x - mouth_width/2 - (face_d/4), reye_center_y - mouth_height/2 - (face_d/4));
}

private void smoothenEdges(PImage img){
  //Mat mat = toMat(img);
  if (face_d > 0) {
    //Columna
    for (int i = 0; i < img.width; i++){
      //Fila
      for (int j = 0; j < img.height; j++){
        int loc = i + j * img.width;
          if (i <= img.width/2 && j <= img.height/2) {
            //Superior izquierdo
            img.pixels[loc] = color(red(img.get(i,j)),green(img.get(i,j)),blue(img.get(i,j)),i*j*48/face_d);
          } else if (i > img.width/2 && j <= img.height/2) {
            //Superior derecho
            img.pixels[loc] = color(red(img.get(i,j)),green(img.get(i,j)),blue(img.get(i,j)),(img.width-i)*j*48/face_d);
          } else if (i > img.width/2 && j > img.height/2) {
            //Inferior derecho
            img.pixels[loc] = color(red(img.get(i,j)),green(img.get(i,j)),blue(img.get(i,j)),(img.width-i)*(img.height-j)*48/face_d);
          } else if (i <= img.width/2 && j > img.height/2) {
            //Inferior izquierdo
            img.pixels[loc] = color(red(img.get(i,j)),green(img.get(i,j)),blue(img.get(i,j)),i*(img.height-j)*48/face_d);
          }
          
      }
    }
    img.updatePixels();
  }
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
  noFill();
  face_shape = createShape();
  face_shape.beginShape();
  int i = 0;
  
  for (Point pt : p) {
    face_shape.vertex((float)pt.x+o.x, (float)pt.y+o.y);
    stroke(255);
    if (i == 42) {
      //Right eye's leftmost vertex
      stroke(255,0,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 5, 5);
      reye_x1 = (int)(pt.x+o.x);
      //reye_y1 = (int)(pt.y+o.y);
    } else if (i == 45) {
      //Left eye's rightmost vertex
      stroke(255,0,0);
      if (outlines) ellipse((float)pt.x+o.x+1, (float)pt.y+o.y, 5, 5);
      reye_x2 = (int)(pt.x+o.x);
    } else if (i == 44) {
      //Right eye's uppermost vertex
      stroke(255,0,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 5, 5);
      reye_y1 = (int)(pt.y+o.y);
    } else if (i == 46) {
      //Right eye's lowermost vertex
      stroke(255,0,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 5, 5);
      reye_y2 = (int)(pt.y+o.y);
    } else if (i == 36) {
      //Left eye's leftmost vertex
      stroke(0,0,255);
      if (outlines) ellipse((float)pt.x+o.x-1, (float)pt.y+o.y, 5, 5);
      leye_x1 = (int)(pt.x+o.x);
      //leye_y = (int)(pt.y+o.y);
    } else if (i == 39) {
      //Left eye's rightmost vertex
      stroke(0,0,255);
      if (outlines) ellipse((float)pt.x+o.x+1, (float)pt.y+o.y, 5, 5);
      leye_x2 = (int)(pt.x+o.x);
    } else if (i == 38) {
      //Left eye's uppermost vertex
      stroke(0,0,120);
      if (outlines) ellipse((float)pt.x+o.x+1, (float)pt.y+o.y, 5, 5);
      leye_y1 = (int)(pt.y+o.y);
      //println("y1" + leye_y1);
    } else if (i == 40) {
      //Left eye's lowermost vertex
      stroke(0,0,120);
      if (outlines) ellipse((float)pt.x+o.x+1, (float)pt.y+o.y, 5, 5);
      leye_y2 = (int)(pt.y+o.y);
      //println("y2" + leye_y2);
    } else if (i == 18) {
      //Eyebrow vertex (reference)
      stroke(255,0,255);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      eyeb_y = (int)(pt.y+o.y);
    } else if (i == 48) {
      stroke(255,0,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      mouth_x1 = (int)(pt.x+o.x);
      //mouth_y = (int)(pt.y+o.y);
    } else if (i == 54) {
      stroke(0,255,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      mouth_x2 = (int)(pt.x+o.x);
    } else if (i == 50) {
      stroke(255,0,0);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      mouth_y1 = (int)(pt.y+o.y);
    } else if (i == 58) {
      stroke(0,0,255);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      mouth_y2 = (int)(pt.y+o.y);
    } else if (i == 33) {
      stroke(0,0,255);
      if (outlines) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      face_center_x = (int)(pt.x+o.x);
      face_center_y = (int)(pt.y+o.y);
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
