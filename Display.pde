class Maple {
  // just a single leaf
  float xpos;
  float ypos;

  float a = random(2);
  float yspeed;

  Maple() {
    xpos = random(width);
    ypos = random(height);
  }

  void changeSpeed(float min, float max) {
    yspeed = random(min, max);
  }

  void display() {

    // begin rotation code
    a += 0.005;
    if (a > TWO_PI) { 
      a = 0.0;
    }

    pushMatrix();
    translate(xpos, ypos);
    float random1 = 0;
    rotateX(a * 3);
    rotateY(a * 4);
    // end rotation code

    image(img, random1, random1, 100, 100);
    popMatrix();
  }

  void move() {
    ypos = ypos + yspeed;
    if (ypos > width) {
      ypos = 0;
    }
  }
}

