class RealEye extends FShape{
  
  RealFace face;
  
  public RealEye(){
    
  }
  
  public void setFace(RealFace face, float camSize){
    this.face = face;
    this.camSize = camSize;
  }
  
  public boolean isOpen(){
    return Expressions.isOpen(this);
  }
  
  public RealEye copy(PImage img, int cam_x, int cam_y){
    PVector[] contour = new PVector[this.contour.length];
    arrayCopy(this.contour, contour);
    
    RealEye newEye = new RealEye();
    newEye.setPoints(contour, img, (int)cam_x, (int)cam_y);
    return newEye;
  }
  
}
