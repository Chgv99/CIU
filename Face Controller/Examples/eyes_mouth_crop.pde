FaceController fc;

PVector facePos;
PImage leyeImg;
PVector leyePos;
PImage reyeImg;
PVector reyePos;
PImage mouthImg;
PVector mouthPos;

void setup() {
  size(640, 480);
  fc = new FaceController(this, "Camera Name");
}

void draw() {  
  background(0);
  fc.process(false);
  facePos = fc.getCenter();
  leyeImg = fc.getLeftEyeCrop();
  leyePos = fc.getLeftEye().getCenter();
  reyeImg = fc.getRightEyeCrop();
  reyePos = fc.getRightEye().getCenter();
  mouthImg = fc.getMouthCrop();
  mouthPos = fc.getMouth().getCenter();
  
  image(leyeImg, leyePos.x - leyeImg.width/2, leyePos.y - leyeImg.height/2, leyeImg.width, leyeImg.height);
  image(reyeImg, reyePos.x - reyeImg.width/2, reyePos.y - reyeImg.height/2, reyeImg.width, reyeImg.height);
  image(mouthImg, mouthPos.x - mouthImg.width/2, mouthPos.y - mouthImg.height/2, mouthImg.width, mouthImg.height);
}
