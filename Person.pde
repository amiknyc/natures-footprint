class Person {

  // howz many peeps vary
  float G;
  public PVector location;

  Person (float x, float y) {

    location = new PVector (x, y);
    
    // detect five peeps yo
    G=5;
  }
  
  void update(float x, float y) {
    location.x = x;
    location.y = y;
  }
}
