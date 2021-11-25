/** TODO
  * REVISAR MÉTODOS DEL README UNO A UNO Y COMPROBAR QUE FUNCIONAN A LA PERFECCIÓN
  * Extraer el concepto de DEBUG de esta clase (se está usando
  * un booleano de la clase superior).
  * Documentar clases nuevas.
  **/

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

//Detectores
CascadeClassifier face;
//Máscara del rostro
Facemark fm;
//Nombres
String faceFile, modelFile;

PShape face_shape;

class FaceController{
  
  private RealFace face;
  PVector[] contour = new PVector[27];
  
  private RealFace naturalFace;
  PVector[] naturalContour = new PVector[27];
  
  private Capture cam;
  private CVImage img;
  private PVector camSize;
  private PVector cropSize;
  
  PGraphics maskImage;
  
  //FACE
  //Point v1, v2, v3, v4;  //Face vertices
  private float face_distance_units, face_distance_cm;
  private float upperOffset;
  private float lowerOffset;
  private float leftOffset;
  private float rightOffset;
  
  //Eyebrows
  private RealEyebrow leftEyebrow;
  private RealEyebrow rightEyebrow;
  private float left_eyebrow_height;
  private float right_eyebrow_height;
  
  //private Point left_eyebrow_n;
  //private Point right_eyebrow_n;
  
  private PVector[] left_eyebrow = new PVector[5];
  private PVector[] right_eyebrow = new PVector[5];
  private int buffer_size;
  
  //EYES
  //CVImage left_eye, right_eye;
  //int left_eye_left_x, left_eye_left_y, right_eye_left_x, right_eye_left_y, eyeb_y;
  private RealEye leftEye;
  private RealEye rightEye;
  private PVector[] left_eye = new PVector[6];
  private PVector[] right_eye = new PVector[6];
  
  //MOUTH
  //float alpha_product;
  private RealMouth mouth;
  private PVector[] mouth_vector = new PVector[12];
  //CVImage mouth;
  private int mouth_x, mouth_y, mouth_min_x, mouth_max_x, mouth_min_y, mouth_max_y;
  private float mouth_amplitude;
  private float mouth_threshold;
  
  private float size;
  
  private float defaultRef = 20;
  
  /**
    * Constructor.
    **/
  public FaceController(PApplet parent, String camera) {
    this(parent, camera, 1, 0.5, 0.2, 0.1, 0.1);
  }
  public FaceController(PApplet parent, String camera, float size) {
    this(parent, camera, size, 0.5, 0.2, 0.1, 0.1);
  }
  public FaceController(PApplet parent, String camera, float size, float upperOffset, float lowerOffset,  float leftOffset, float rightOffset){
    //Camera
    this.size = size;
    camSize = new PVector(640*size, 480*size);
    cropSize = new PVector(640/size, 480/size);
    cam = null;
    while (cam == null) cam = new Capture(parent, (int)camSize.x, (int)camSize.y, camera); //640, 480
    //lookForCameras(parent, camera, 1, (int)camSize.x, (int)camSize.y);
    cam.start();
    //OpenCV
    //Loads OPENCV library
    System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    println(Core.VERSION);
    img = new CVImage(cam.width, cam.height);
    
    //Detectors and mask model
    faceFile = "haarcascade_frontalface_default.xml";
    //faceFile = "new_cascades_cuda/haarcascade_frontalface_alt_tree.xml";
    modelFile = "face_landmark_model.dat";
    fm = org.opencv.face.Face.createFacemarkKazemi();
    fm.loadModel(dataPath(modelFile));
    
    //Face contour shape for cropping.
    /*for (int i = 0; i < 27; i++){
      contour[i] = null;//new PVector(0,0);
    }*/
    
    //Objects
    face = new RealFace();
    //contour = new ArrayList();
    leftEyebrow = new RealEyebrow();
    rightEyebrow = new RealEyebrow();
    leftEye = new RealEye();
    rightEye = new RealEye();
    mouth = new RealMouth();
    
    face.setLeftEyebrow(leftEyebrow, size);
    face.setRightEyebrow(rightEyebrow, size);
    face.setLeftEye(leftEye, size);
    face.setRightEye(rightEye, size);
    face.setMouth(mouth, size);
    
    //Variables
    this.upperOffset = upperOffset;
    this.lowerOffset = lowerOffset;
    this.leftOffset = leftOffset;
    this.rightOffset = rightOffset;
    
    /** Natural variables. (default values) 
      * These are the natural values of a 
      * face at "rest". These will change 
      * after calibrating.**/
    //left_eyebrow_n = new Point(-40,-90);
    //right_eyebrow_n = new Point(40,-90);
    
    //Buffers that help getting rid of
    //spurious pulses.
    
    //left_eyebrow = new ArrayList();
    //right_eyebrow = new ArrayList();
    
    //buffer_size = 1;
  }
  
  /** Updates the values of the points 
      *  and, by extension, the rest of values
      *  needed to work with the class. 
      * (call every frame)**/
  private boolean process() { return process(false); }
  private boolean process(boolean debug){
    //clearAll();
    //println("Process (FaceController)");
    boolean available = cam.available();
    /*while (!available) {
      available = cam.available();
    }*/
    //println("available: " + available);
    if (available) {
      //background(0);
      cam.read();
      //Get image from cam
      img.copy(cam, 0, 0, cam.width, cam.height, 0, 0, img.width, img.height);
      img.copyTo();
      
      
    }
    //Input image
    //println("Cam display");
    /*if (debug) image(img,0,0);*/
    if (debug) image(img,0,0);
    
    
    //Fiducial point detection
    //Facial elements update
    //println("1");
    available = false;
    ArrayList<MatOfPoint2f> shapes = detectFacemarks(img);
    PVector origin = new PVector(0, 0);
    for (MatOfPoint2f sh : shapes) {
      available = true;
      Point [] pts = sh.toArray();
      updateFacialElements(pts, origin, debug);
      //shape(face_shape);
    }
    /*println(contour);
    for(PVector p : contour){
      println(p.x, p.y);
    }*/
    
    return available;
  }
  
  /** Calibration consists of a process in which
    * the program stores multiple values of the
    * desired parts of the face (CalibrateAux())
    * and at the end calculates the mean. **/
  /*public void Calibrate(){
    println("calibrating");
    // If the buffer is full
    if (CalibrateAux()){
      float leb_x = 0;
      float leb_y = 0;
      float reb_x = 0;
      float reb_y = 0;
      for (int i = 0; i < left_eyebrow_buffer.size(); i++){
        //println(left_eyebrow_buffer.get(i) + ", ");
        leb_x += left_eyebrow_buffer.get(i).x;
        leb_y += left_eyebrow_buffer.get(i).y;
        reb_x += right_eyebrow_buffer.get(i).x;
        reb_y += right_eyebrow_buffer.get(i).y;
      }
      leb_x /= cal_buffer_size;
      leb_y /= cal_buffer_size;
      reb_x /= cal_buffer_size;
      reb_y /= cal_buffer_size;
      
      //Points are stored relative to the center of the face
      //and divided by the face distance.
      left_eyebrow_n = new Point((leb_x - getCenter().x) / face_distance_units, (leb_y - getCenter().y) / face_distance_units);
      right_eyebrow_n = new Point((reb_x - getCenter().x) / face_distance_units, (reb_y - getCenter().y) / face_distance_units);
      println("Calibration data: ");
      println("leb: " + leb_x + ", " + leb_y);
      println("reb: " + reb_x + ", " + reb_y);
      println("Natural Left Eyebrow: " + left_eyebrow_n.x + ", " + left_eyebrow_n.y);
      println("Natural Right Eyebrow: " + right_eyebrow_n.x + ", " + right_eyebrow_n.y);
      cal_buffer_size = -1;
    }
  }*/
  
  /** Auxiliar method for Calibrate()
    * that stores multiple values of
    * the desired parts of the face **/
  /*private boolean CalibrateAux(){
    //println(left_eyebrow_buffer.size());
    if (left_eyebrow_buffer.size() < cal_buffer_size) {
      left_eyebrow_buffer.add(GetLeftEyebrow());
      right_eyebrow_buffer.add(GetRightEyebrow());
      return false;
    } else {
      left_eyebrow_buffer.remove(0);
      right_eyebrow_buffer.remove(0);
      left_eyebrow_buffer.add(GetLeftEyebrow());
      right_eyebrow_buffer.add(GetRightEyebrow());
      println("Calibration buffer ready");
      return true;
    }
  }*/
  
  private ArrayList<MatOfPoint2f> detectFacemarks(CVImage i) {
    ArrayList<MatOfPoint2f> shapes = new ArrayList<MatOfPoint2f>();
    CVImage im = new CVImage(i.width, i.height);
    im.copyTo(i);
    MatOfRect faces = new MatOfRect();
    org.opencv.face.Face.getFacesHAAR(im.getBGR(), faces, dataPath(faceFile)); 
    if (!faces.empty()) {
      fm.fit(im.getBGR(), faces, shapes);
    }
    return shapes;
  }
  
  private void updateFacialElements(Point [] p, PVector o, boolean debug) {
    //println("updatefacialelements");
    pushStyle();
    noStroke();
    noFill();
    face_shape = createShape();
    face_shape.beginShape();
    
    for (int i = 0; i < p.length; i++) {
      Point pt = p[i];
      face_shape.vertex((float)pt.x+o.x, (float)pt.y+o.y);
      //ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
      pushStyle();
      switch (i) {
        case 8:
          noStroke();
          fill(127,0,255);
          if (debug) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
          break;
        case 19:  //Left eyebrow
          stroke(0,0,255);
          if (debug) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 5, 5);
          break;
        case 24:  //Right eyebrow
          stroke(0,0,255);
          if (debug) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 5, 5);
          break;
        case 27:
          noStroke();
          fill(127,0,255);
          if (debug) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
          break;
        default:
          if (i >= 42 && i <= 47) { //Right eye
            stroke(255,255,0);
            if (debug) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
            right_eye[i-42] = new PVector((float)(pt.x+o.x), (float)(pt.y+o.y));
          } else if (i >= 36 && i <= 41) {
            stroke(255,0,0);
            if (debug) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
            left_eye[i-36] = new PVector((float)(pt.x+o.x), (float)(pt.y+o.y));
          } else if (i >= 48 && i <= 59) {
            if (debug) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 3, 3);
            mouth_vector[i-48] = new PVector((float)(pt.x+o.x), (float)(pt.y+o.y));
          } else {
            stroke(255);
            if (debug) ellipse((float)pt.x+o.x, (float)pt.y+o.y, 1, 1);
          }
          break;
      }
      popStyle();
    }
    
    for(int i = 0; i < 17; i++){
      contour[i] = new PVector((float)p[i].x+o.x, (float)p[i].y+o.y);
      stroke(255,0,255);
      if (debug) ellipse((float)p[i].x+o.x, (float)p[i].y+o.y, 8, 8);
    }
    
    //int j = 17;
    for (int i = 26; i >= 17; i--){
      float forehead_factor = 0;
      if (getFace().getReference() != -1) {
        //println("no -1");
        //println(getFace().getReference());
        forehead_factor = getFace().getReference() * upperOffset;
      }
      contour[17+26-i] = new PVector((float)p[i].x+o.x, (float)p[i].y+o.y - forehead_factor);
      stroke(0,0,0);
      if (debug) ellipse((float)p[i].x+o.x, (float)p[i].y+o.y - forehead_factor, 5, 5);
      stroke(255,0,0);
      
      if (i <= 26 && i >= 22) {
        stroke(255,0,0);
        right_eyebrow[i-22] = new PVector((float)p[i].x+o.x, (float)p[i].y+o.y);
      }
      if (i <= 21 && i >= 17) {
        stroke(0,255,0);
        left_eyebrow[i-17] = new PVector((float)p[i].x+o.x, (float)p[i].y+o.y);
      }
      if (debug) ellipse((float)p[i].x+o.x, (float)p[i].y+o.y, 8, 8);
    }
    popStyle();
    
    //println("Building face contour");
    //println("FACECONTROLLER");
    //println("Contour: " + contour);
    face.setPoints(contour, img, (int)camSize.x, (int)camSize.y);
    //face.setReference();
    //face.setCrop();
    //println("Face Contour: " + face.getContour());
    face_shape.endShape(CLOSE);
    
    //
    //  FUSIONAR MÉTODOS SETPOINTS Y SETCROP
    //
    
    //println("Building left eyebrow");
    leftEyebrow.setPoints(left_eyebrow, img, (int)camSize.x, (int)camSize.y);
    //leftEyebrow.setCrop(img, (int)camSize.x, (int)camSize.y);
    //println("Building right eyebrow");
    rightEyebrow.setPoints(right_eyebrow, img, (int)camSize.x, (int)camSize.y);
    //rightEyebrow.setCrop(img, (int)camSize.x, (int)camSize.y);
    //println("Building left eye");
    leftEye.setPoints(left_eye, img, (int)camSize.x, (int)camSize.y);
    //leftEye.setCrop(img, (int)camSize.x, (int)camSize.y);
    //println("Building right eye");
    rightEye.setPoints(right_eye, img, (int)camSize.x, (int)camSize.y);
    //rightEye.setCrop(img, (int)camSize.x, (int)camSize.y);
    //println("Building mouth");
    mouth.setPoints(mouth_vector, img, (int)camSize.x, (int)camSize.y);
    //mouth.setCrop(img, (int)camSize.x, (int)camSize.y);
    
    if (debug) {
      pushStyle();
      fill(0,255,0);
      stroke(0,255,0);
      //Draw center
      line(getCenter().x - 8, getCenter().y, getCenter().x + 8, getCenter().y);
      line(getCenter().x, getCenter().y - 8, getCenter().x, getCenter().y + 8);
      //int d = (int) distance((int)max.x, (int)max.y, (int)min.x, (int)min.y);
      ellipse(getCenter().x, getCenter().y, 3, 3);
      popStyle();
    }
  }
  
  public void print(){
    face.printData();
  }
  
  private void lookForCameras(PApplet parent, String cameraName, int cameraIndex, int sizeX, int sizeY){
    boolean found = false;
    println("Looking for cameras");
    String[] cameraList = Capture.list();
    int start = millis();
    int current = millis();
    while (cameraList.length == 0 && (current - start < 10000)){
      cameraList = Capture.list();
      current = millis();
    }
  
    println("Cameras found: " + cameraList.length);
    if (cameraList == null || cameraList.length != 0){
      for (int i = 0; i < cameraList.length; i++){
        println("i: " + i + ", " +
              "name: \"" + cameraList[i] + "\"");
      }
      int index = -1;
      if (cameraName != null){
        for (int i = 0; i < cameraList.length; i++){
          if (cameraList[i].equals(cameraName)){
            index = i;
            found = true;
          }
        }
        if (!found){
          println("WARNING: No camera named \"" + cameraName + "\"");
        }
      }
  
      if (cameraIndex < cameraList.length){
        index = cameraIndex;
      }else{
        println("WARNING: Index bigger than available, using default (0)");
        index = 0;
      }
  
      found = true;
  
      cam = new Capture(parent, sizeX, sizeY, cameraList[index], 15);
      println("Using camera " + "i: " + index + ", " +
              "name: \"" + cameraList[index] + "\"");
      //cam.start();
    }else{
      found = false;
      throw new java.lang.RuntimeException("No camera can be found");
    }
  }
  
  public float getReference() {
    return face.getReference()/defaultRef;
  }
  
  public PImage getFaceCrop(){
    return face.getCrop();
    
    /*maskImage = createGraphics((int)camSize.x, (int)camSize.y);  //640, 480
    maskImage.beginDraw();
    maskImage.beginShape();
    for(PVector p : contour){
      maskImage.vertex(p.x, p.y);
    }
    
    maskImage.endShape(CLOSE);
    maskImage.endDraw();
    // apply mask
    img.mask(maskImage);
    return(img);*/
  }
  
  public PImage getMouthCrop(){
    return mouth.getCrop();
  }
  
  public PImage getLeftEyeCrop(){
    return leftEye.getCrop();
  }
  
  public PImage getRightEyeCrop(){
    return rightEye.getCrop();
  }

  /*public PImage getStaticCrop(){
    PImage staticImg = img.copy();
    maskImage = createGraphics((int)camSize.x, (int)camSize.y);  //640, 480
    maskImage.beginDraw();
    maskImage.beginShape();
    for(PVector p : contour){
      maskImage.vertex(p.x, p.y);
    }
    
    maskImage.endShape(CLOSE);
    maskImage.endDraw();
    // apply mask
    staticImg.mask(maskImage);
    return(staticImg);
  }*/
  
  public float getCamScale() {
    return size;
  }
  
  public PVector getCamSize() {
    return new PVector(cam.width, cam.height);
  }
  
  public RealFace getFace(){
    return face;
  }
  
  public RealFace copyFace(){
    //println("Cropping for copy: " + getCrop());
    //println("copyFace face reference: " + face);
    return face.copy(/*getFaceCrop()*/img, (int)camSize.x, (int)camSize.y);
  }
  
  public RealEyebrow getLeftEyebrow(){
    return leftEyebrow;
  }
  
  public RealEyebrow getRightEyebrow(){
    return rightEyebrow;
  }
  
  public RealEye getLeftEye(){
    return leftEye;
  }
  
  public RealEye getRightEye(){
    return rightEye;
  }
  
  public RealMouth getMouth(){
    return mouth;
  }
  
  public float getDistance(){
    return Expressions.distanceFromCamera(2900, face.getReference());
  }
  
  /*public float getDistanceFromCamera(){
    return Expressions.distanceFromCamera(2900, face.getReference());
  }*/
  
  public PVector getCenter(){
    return face.getCenter();
  }
  
  public float getMouthAmplitude(){
    return Expressions.verticalAmplitude(mouth);
  }
}
