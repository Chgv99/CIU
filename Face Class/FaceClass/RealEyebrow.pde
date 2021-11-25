class RealEyebrow extends FShape{
  
  RealFace face;
  
  public RealEyebrow(){
    
  }
  
  public RealFace getFace(){
    return face;
  }
  
  public void setFace(RealFace face, float camSize){
    this.face = face;
    this.camSize = camSize;
  }
  
  public PVector getTop(){
    if (contour != null && contour[0] != null) {
      PVector top = contour[0];
      for (PVector point : contour){
        if (face.getCenter().y - point.y > face.getCenter().y - top.y) top = point;
      }
      pushStyle();
      noStroke();
      fill(0,255,255);
      ellipse(top.x, top.y,5,5);
      popStyle();
      return top;
    }
    return null;
  }
  
  public RealEyebrow copy(PImage img, int cam_x, int cam_y){
    PVector[] contour = new PVector[this.contour.length];
    arrayCopy(this.contour, contour);
    
    RealEyebrow newEyebrow = new RealEyebrow();
    newEyebrow.setPoints(contour, img, (int)cam_x, (int)cam_y);
    return newEyebrow;
  }
  
}
