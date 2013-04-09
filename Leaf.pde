class Leaf {
  float a = random(2);

  // the location of just one leaf
  PVector loc;
  // velocity
  PVector vel;
  // acceleration
  PVector acc;
  PVector gravity = new PVector(0.3, 0);
  PVector friction = new PVector(0.85, 0.85);
  color c = color(random(255), random(255), random(255));

  Leaf() {
    loc = new PVector(random(width), random(height));
    acc = new PVector(0, 0);
    vel = new PVector(0, 0);
  }

  void calc(float x, float y) {
    PVector mouse = new PVector(x, y);
    float dist = 100-mouse.dist(loc);
    if (dist <0) {
      dist = 0;
    }
    dist = dist*0.09 ;
    float rot = calcRotation(mouse, loc);

    // println("new rotation:"+rot);
    // this is polar cartesian coordinate system to map the xy points blah blah maths cringe
    float[] xy = polarToCartesian(dist, rot);
    acc.add(xy[0], xy[1], 0);

    // println("new accel:"+acc.x+","+acc.y);
    acc.mult(friction);
    vel.add(acc);
    vel.add(gravity);
    vel.mult(friction);
    loc.add(vel);
    if (loc.y > height) {
      loc.y = 0;
    }
    if (loc.y < 0) {
      loc.y = height;
    }
    if (loc.x > width) {
      loc.x = 0;
    }
    if (loc.x < 0) {
      loc.x = width;
    }
  }

  void render() {

    // begin rotation code headz spin
    a += 0.005;
    if (a > TWO_PI) { 
      a = 0.0;
    }

    pushMatrix();
    translate(loc.x, loc.y);
    float random1 = 0;
    rotateX(a * 3);
    rotateY(a * 4);
    // end rotation code

    image(img, random1, random1, 60, 60);
    popMatrix();
  }

  private float calcRotation(PVector base, PVector angleTo) {
    float angleInRadians = atan2(angleTo.y - base.y, angleTo.x - base.x);
    return angleInRadians;
  }

  // take the radius and angle, and find the X,Y coordinate that matches that point location
  float[] polarToCartesian(float radius, float angle) {
    float[] xy = new float[2];
    xy[0] = radius*cos(angle);
    xy[1] = radius*sin(angle);
    return xy;
  }
}

