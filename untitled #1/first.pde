// untitled #1 aka hello world
// matbalez@gmail.com
// 9/7/14

Block[] blocks;
int numBlocks = 6;
int blockOpacity = 50;
int blockWidth = 200;
int maxSpeed = 5;
float rateOfChange = 0.01;

int windowWidth = 500;
int windowHeight = 500;

int numFrames = 300;         
boolean recording = false;

void setup() {
  
  size(windowWidth, windowHeight);

  // Initalize block array with randomly generated blocks

  int randXpos;
  color randColor;
  boolean randDirection;
  int randSpeed;

  blocks = new Block[numBlocks];
  
  for (int i = 0; i < numBlocks; i++) {
    randXpos = (int)random(0, windowWidth);
    randColor = color((int)random(0, 255), (int)random(0, 255), (int)random(0, 255), blockOpacity);
    randDirection = false;
    if (random(0, 100)<50) randDirection = true;
    randSpeed = (int)random(1, maxSpeed);
    blocks[i] = new Block(randXpos, blockWidth, windowHeight, randColor, randDirection, randSpeed);
  }
}

void draw() {
  background(255);
  // move and draw each block
  for (int i = 0; i < numBlocks; i++) {
    blocks[i].move();
    blocks[i].display();
  }
  if (recording) {
    saveFrame("g###.gif");
    if (frameCount==numFrames) {
      exit();
    }
  }
}

// A Block object
class Block {
  // A block knows its color, width and xpos
  int xpos;   // xposition
  int w, h;   // width and height
  color bColor; // block's color
  boolean direction; // indicates direction of block's movement, true = right, false = left
  int speed;  // block's speed of translation
  float angle; //used for internal movement calc

  // Block Constructor
  Block(int tempXPOS, int tempW, int tempH, color tempBColor, boolean tempDirection, int tempSpeed) {
    xpos = tempXPOS;
    w = tempW;
    h = tempH;
    bColor = tempBColor;
    direction = tempDirection;
    speed = tempSpeed;
    angle = (float)random(0, PI);
  } 

  // move block on screen
  void move() {
    if (direction) {
      if (xpos+blockWidth < windowWidth) {
        angle += rateOfChange;
        xpos += (int)map(sin(angle), -1, 1, 1, speed);
      } else {
        direction = false;
      }
    } else {
      if (xpos > 0) {
        angle += rateOfChange;
        xpos -= (int)map(sin(angle), -1, 1, 1, speed);
      } else {
        direction = true;
      }
    }
  }

  void display() {
    noStroke();
    fill(bColor);
    rect(xpos, 0, w, h);
  }
  
}

