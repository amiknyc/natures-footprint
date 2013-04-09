//BLOB DETECTION LIBRARIES
import hypermedia.video.*;
import java.awt.*;

//original bulge code
float i, j, x, y, r, t;
float q = 500;

// kinect library from the shiffmanarium
import org.openkinect.*;
import org.openkinect.processing.*;

//SimpleOpenNI Library for SceneDepth test
//import SimpleOpenNI.*;
//SimpleOpenNI  context;
//SimpleOpenNI  kinect;
//int smap;

// kinect library object
Kinect kinect;
PImage kinectImg;

// projected image
PImage img;
Leaf[] leaf = new Leaf[500];

Person person;

//from blob detection
OpenCV opencv;

int w = 320;
int h = 240;
int threshold = 80;

boolean find=true;

PFont font;

// this is the end of the blob detection variables


void setup () {
  size(630, 480, P3D);
  img = loadImage("Leaf.png");
  // make a bunch of leaves
  for (int i = 0; i < leaf.length; i++) {
    leaf[i] = new Leaf();
  }

  // make a person ... sort of 
  person = new Person(width/2, height/2);

  // initialize the kinect object & start depth map
  kinect = new Kinect(this);
  kinect.start();

  // open the kinect image
  kinect.enableIR(true);
  kinect.enableDepth(true);

  // all this stuff comes from the blob detection
  opencv = new OpenCV( this );
  opencv.allocate(width, height);

  println( "Drag mouse inside sketch window to change threshold" );
  println( "Press space bar to record background image" );
  // this is the end of the stuff that comes from the blobby detection

    background (0);
  smooth ();
  noStroke ();
}

void draw () {

  // kinect
  kinectImg = kinect.getDepthImage();

  // we have to import the kinect image so we can pass it into opencv
  // to do so we can do blob detection with da kinektz
  // you can then copy this image into OpenCV, like:
  // opencv.copy(depthImage);
  // blamo
  opencv.copy(kinectImg);


  // let's do blob detection
  opencv.read();

  // for testing shit in pretty colors, ooh ahh
  // image( opencv.image(), 10, 10 );	             // RGB image
  // image( opencv.image(OpenCV.GRAY), 20+w, 10 );   // GRAY image not so exciting
  // image( opencv.image(OpenCV.MEMORY), 10, 20+h ); // image in memory

  // blob detection crazy testing codez
  // opencv.absDiff();
  // opencv.threshold(threshold);
  // image( opencv.image(OpenCV.GRAY), 20+w, 20+h ); // absolute difference image

  // PImage vidimg = opencv.image(OpenCV.GRAY);
  // if (vidimg != null) {
  // image( vidimg, 0, 0 ); // absolute difference image
  //  }

  // working with blobs
  Blob[] blobs = opencv.blobs( 100, w*h/3, 1, true );
  noFill();

  // we need to put the "if" statement in bcuz 
  // when we take the images of the background there is no blob detected
  if (blobs.length >0) {
    Rectangle bounding_rect = blobs[0].rectangle;
    Point centroid = blobs[0].centroid;
    fill(255, 0, 0);

    fill(255);
    // plug in the leaves
    ellipse(centroid.x, centroid.y-0.5*bounding_rect.height, 20, 20);
    // call the person class
    person.update(centroid.x, centroid.y-0.5*bounding_rect.height);
  }

  pushMatrix();
  for ( int i=0; i<blobs.length; i++ ) {

    Rectangle bounding_rect = blobs[i].rectangle;
    float area = blobs[i].area;
    float circumference = blobs[i].length;
    Point centroid = blobs[i].centroid;
    Point[] points = blobs[i].points;

    noFill();
    // i have no fucking idea what this is, why its here, or what it does
    stroke( blobs[i].isHole ? 128 : 64 );

    // make the bounding rectangle for blobbies
    rect( bounding_rect.x, bounding_rect.y, bounding_rect.width, bounding_rect.height );

    // centroid
    stroke(0, 0, 255);
    line( centroid.x-5, centroid.y, centroid.x+5, centroid.y );
    line( centroid.x, centroid.y-5, centroid.x, centroid.y+5 );
    noStroke();
    fill(0, 0, 255);
    text( area, centroid.x+5, centroid.y+5 );

    int totalPoints = points.length;
    if (totalPoints > 300) {
      totalPoints = 300;
    }

    noStroke();
    fill(255, 0, 255);
    text( circumference, centroid.x+5, centroid.y+15 );

    // draw ze leaf
    background(0);
    for (int f = 0; f < leaf.length; f++) {
      leaf[f].calc(centroid.x, centroid.y);
      leaf[f].render();
    }
  }
  popMatrix();
  pushMatrix();
  translate(0, 0, 20);
  text (frameRate, 30, 30);
  //END BLOB DETECTION
}

//BLOB DETECTION FUNCTIONS

void keyPressed() {
  if ( key==' ' ) opencv.remember();
}

void mouseDragged() {
  threshold = int( map(mouseX, 0, width, 0, 255) );
}

public void stop() {
  opencv.stop();
  super.stop();
}

