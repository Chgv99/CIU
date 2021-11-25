static class Expressions{
  
  public static float verticalAmplitude(FShape shape){
    if (shape != null) {
      int size = shape.getContour().length;
      PVector a = null;
      PVector b = null;
      int aux;
      if((size/4)%1 != 0) aux = (int)Math.ceil(size/4);  
      else aux = (int)Math.ceil((size/4)+1);
      a = shape.getContour()[aux];
      b = shape.getContour()[aux + (size/2)];

      return dist(a.x, a.y, b.x, b.y);
    }
    return -1;
  }
  
  public static boolean isOpen(FShape shape){
    //println(verticalAmplitude(shape) / shape.getCamSize());
    if (verticalAmplitude(shape) / shape.getCamSize() > 25) return true;
    return false;
  }
  
  /**
    * Checks if the eyebrow is lifted
    * side = 0: left eyebrow
    * side = 1: right eyebrow
    */
  public static boolean eyebrowIsLifted(RealEyebrow eyebrow){
    if (eyebrow != null) {
      //println("distancia centro-ceja = " + (eyebrow.getFace().getCenter().y - eyebrow.getTop().y));
      if (eyebrow.getFace().getCenter().y - eyebrow.getTop().y > 50) return true;
    }
    return false;
  }
  
  public static PVector[] getMinMax(PVector[] contour/*, float w, float h*/){
    //println("Contour: "+ (Object[])contour);
    PVector max = new PVector(0, 0);
    PVector min = new PVector(10000, 10000);
    for (PVector point : contour){
      //println("Point: " + point);
      if (point.x > max.x) max.x = point.x;
      if (point.y > max.y) max.y = point.y;
      if (point.x < min.x) min.x = point.x;
      if (point.y < min.y) min.y = point.y;
    }
    
    return new PVector[]{min, max};
  }
  
  public static PVector[] getCorners(PVector[] contour/*, float w, float h*/){
    //println("Contour: "+ (Object[])contour);
    PVector topLeft = new PVector(Integer.MAX_VALUE, Integer.MAX_VALUE);
    PVector topRight = new PVector(0, Integer.MAX_VALUE);
    PVector bottomLeft = new PVector(Integer.MAX_VALUE, 0);
    PVector bottomRight = new PVector(0, 0);
    
    for (PVector point : contour){
      //println("Point: " + point);
      if (point.x < topLeft.x) topLeft.x = point.x;
      if (point.y < topLeft.y) topLeft.y = point.y;
      
      if (point.x > topRight.x) topRight.x = point.x;
      if (point.y < topRight.y) topRight.y = point.y;
      
      if (point.x < bottomLeft.x) bottomLeft.x = point.x;
      if (point.y > bottomLeft.y) bottomLeft.y = point.y;
      
      if (point.x > bottomRight.x) bottomRight.x = point.x;
      if (point.y > bottomRight.y) bottomRight.y = point.y;
    }
    
    return new PVector[]{topLeft, topRight, bottomLeft, bottomRight};
  }
  
  public static PVector centerOf(PVector[] contour/*, float w, float h*/){
    if (contour != null){
      /**PVector max = contour[0];
      PVector min = contour[0];**/
      PVector[] minMax = getMinMax(contour/*, w, h*/);
      return new PVector(minMax[0].x + ((minMax[1].x - minMax[0].x) / 2), minMax[0].y + ((minMax[1].y - minMax[0].y) / 2));//new Point(min.x + d/2, min.y + d/2);
    }
    return null;
  }
  
  public static float distance(FShape a, FShape b){
    //println("FShape a = " + a.getCenter());
    //println("FShape b = " + b.getCenter());
    //println(dist(a.getCenter().x, a.getCenter().y, b.getCenter().x, b.getCenter().y));
    return dist(a.getCenter().x, a.getCenter().y, b.getCenter().x, b.getCenter().y);
  }
  
  public static float distance(PVector a, PVector b){
    return dist(a.x, a.y, b.x, b.y);
  }
  
  /**
    * Distance in centimeters from the camera
    */
  //calibrationFactor = 2900 en las pruebas
  public static float distanceFromCamera(int calibrationFactor, float reference){
    return calibrationFactor / reference;
  }
  
  /*public static float rotationOf(RealFace face){
    PVector line = PVector.sub(face.getCenter(),face.getChin());
    return PVector.angleBetween(line, new PVector(10,0));
  }*/
  
  public static PVector makeRelative(PVector v, PVector center){
    return PVector.sub(v, center);
  }
  
  public static float makeProportional(float distance, float reference){
    return distance / reference;
  }
}
