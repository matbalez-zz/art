
Ball[] balls;
int numBalls = 6;
int[][] positions;

int numFrames = 400;

int windowWidth = 500;
int windowHeight = 500; 
int initialGuideCircleDiam = 450;
int currentGuideCircleDiam;
int initialBallDiam = 50;
int maxBallDiam;  
float initialRotation = 0.0;
float minRotationSpeed = 0.02;
float maxRotationSpeed = 0.04;
int minOpacity = 50;
int maxOpacity = 150;

void setup() {
  color c;
  size(windowWidth, windowHeight);
  balls = new Ball[numBalls];
  currentGuideCircleDiam = initialGuideCircleDiam;
  positions = computePositions(numBalls, currentGuideCircleDiam);
  maxBallDiam = computeMaxBallDiam(numBalls, initialGuideCircleDiam/2);

  for (int i = 0; i < numBalls; i++) {
    c = color(int(random(255)), int(random(255)), int(random(255)));
    balls[i] = new Ball(positions[i][0], positions[i][1], initialBallDiam, c, initialRotation, maxOpacity);
  }
}

int computeMaxBallDiam(int n, int R) {
  float r, a; 
  a = 360/n;
  r = (R/sqrt(2))*sqrt(1-cos(radians(a)));   //computes the critical radius so that all balls just touch when guide circle at its largest
  return int(2*r);
}

int[][] computePositions(int n, int d) {
  int[][] p = new int[n][2];  // 2nd dimension used for x [0] and y [1] coord corresponding to ball i 
  float a = 360 / n; // angle a spreads the balls evenly on the guide circle
  for (int i = 0; i < n; i++) {
    p[i][0] =  int((d/2)*sin(radians(i*a)));      // some simple trig to compute ball center in cartesian coords
    p[i][1] =  int(-1*(d/2)*cos(radians(i*a)));
  }    
  return p;
}

void draw() {

  background(255);

  /*
  // draw the guide circle
  pushMatrix();
  stroke(210);
  noFill();
  translate(windowWidth/2, windowHeight/2);
  ellipse(0, 0, currentGuideCircleDiam, currentGuideCircleDiam);
  popMatrix();
  */

  // draw all balls
  for (int i = 0; i < numBalls; i++) {
    balls[i].display();
  }

  // shrink then expand the guide circle and update ball positions accordingly
  currentGuideCircleDiam = computeGuideCircle();
  positions = computePositions(numBalls, currentGuideCircleDiam);
  for (int i = 0; i < numBalls; i++) {
    balls[i].update(positions[i][0], positions[i][1]);
  }
}

int computeGuideCircle() {
  int newDiam;
  // use sinuisoid to control speed of expansion
  newDiam = initialGuideCircleDiam - int(initialGuideCircleDiam * map(sin(map(frameCount, 0, numFrames/2, -PI/2, PI/2)), -1, 1, 0, 1));
  return newDiam;
}

// A Ball object
class Ball {
  int x, y;   // position of center of each balls
  int diam;   // ball's diameter
  color bColor; // ball's color
  float rotation; //ball's rotation on the guide circle
  int opacity;   // ball's opacity

    // Ball Constructor
  Ball(int tempX, int tempY, int tempDiam, color tempColor, float tempRotation, int tempOpacity) {
    x = tempX;
    y = tempY;
    diam = tempDiam;
    bColor = tempColor;
    rotation = tempRotation;
    opacity = tempOpacity;
  } 

  void display() {
    smooth();
    pushMatrix();
    translate(windowWidth/2, windowHeight/2);
    pushMatrix();
    rotate(rotation);
    pushMatrix();
    noStroke();
    fill(bColor, opacity);
    translate(x, y);        
    ellipse(0, 0, diam, diam);
    popMatrix();
    popMatrix();
    popMatrix();
  }

  // rotate ball along guide circle and update center position, size and opacity
  void update(int _x, int _y) {
    x = _x;
    y = _y;
    // vary diameter linearly based on distance from center
    diam = int(((maxBallDiam - initialBallDiam)/(initialGuideCircleDiam*1.0))*currentGuideCircleDiam) + initialBallDiam;
    
    // vary rotational speed linearly based on distance from center
    rotation += ((maxRotationSpeed - minRotationSpeed)/(initialGuideCircleDiam*1.0))*currentGuideCircleDiam + minRotationSpeed;
    
    // vary opacity linearly based on distance from center
    opacity = maxOpacity + int(((minOpacity - maxOpacity)/(initialGuideCircleDiam*1.0))*currentGuideCircleDiam);
    
  }
}

