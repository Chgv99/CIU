class FShape{
  
  PImage crop;
  PVector cropSize = new PVector(); //w and h
  float cropRatio = 0;
  
  protected PVector[] contour;
  protected PVector center;
  //protected PShape contourShape;
  protected float camSize;
  
  public FShape(){}
  
  public FShape(PVector[] points){
    contour = points;
    this.camSize = camSize;
  }
  
  public float getCamSize(){
    return camSize;
  }
  
  public PVector getCropSize(){
    return cropSize;
  }
  
  public float getCropRatio(){
    return cropRatio;
  }
  
  public void setPoints(PVector[] contour, PImage img, int cam_x, int cam_y){
    setContour(contour);
    setCenter(Expressions.centerOf(contour/*, w, h*/));
    setCrop(img, cam_x, cam_y);
  }
  
  public void setCrop(PImage img, int cam_x, int cam_y) {
    
    PVector[] corners = Expressions.getCorners(contour);
    cropSize.x = dist(corners[0].x, corners[0].y, corners[1].x, corners[1].y);
    cropSize.y = dist(corners[0].x, corners[0].y, corners[2].x, corners[2].y);
    if (cropSize.x <= 0 && cropSize.y <= 0) {
      cropSize.x = 10;
      cropSize.y = 10;
    }
    cropRatio = cropSize.x / cropSize.y;
    
    //println(crop.width, crop.height);
    
    //println(corners[0].x + ", " + corners[0].y);
    //println(cropSize.x, cropSize.y);
    
    //crop = img.get((int)corners[0].x, (int)corners[0].y, (int)cropSize.x, (int)cropSize.y);
    crop = img.copy();
    //PGraphics maskImage = createGraphics(cam_x, cam_y);  //640, 480
    PGraphics maskImage;
    
       //640, 480
    
    
    //maskImage = createGraphics((int)cropSize.x, (int)cropSize.y);
    maskImage = createGraphics(crop.width, crop.height);
    
    maskImage.beginDraw();
    maskImage.beginShape();
    for(PVector p : contour){
      //println("p: " + p.x, p.y);
      maskImage.vertex(p.x, p.y);
    }
    
    maskImage.endShape(CLOSE);
    maskImage.endDraw();
    // apply mask
    crop.mask(maskImage);
    crop = crop.get((int)corners[0].x, (int)corners[0].y, (int)cropSize.x, (int)cropSize.y);
    
  }
  
  public PImage getCrop(){
    //println("fshape crop: " + crop);
    return crop;
  }
  
  public PVector[] getContour(){
    return contour;
  }
  
  public void setContour(PVector[] contour){
    this.contour = contour;
  }
  
  public PVector getCenter(){
    return center;
  }
  
  public void setCenter(PVector center){
    this.center = center;
  }
  
  public PVector getTop(){
    return new PVector();
  }
  
  //TODO: calculate the top and bottom points
  public float verticalAmplitude(){
    //return Expressions.distance(contour[0], contour[0]);
    PVector[] minMax = Expressions.getMinMax(contour);
    return minMax[1].y - minMax[0].y;
  }
  
  /*
  public PVector[] getShape(){
    return contour;
  }
  
  public void setShape(){
    
  }*/
}
