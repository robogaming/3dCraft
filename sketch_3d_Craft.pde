import java.awt.*;
//import javax.media.opengl.glu.GLU;

float cubeSize = 32;
float chunkSize = 8;

boolean alreadyJumped;

float speed = 5 ; //Player's speed
float jumpHeight = 13; //Player's Jump Height
float playerSize = 100; //Player's height, in blocks
PImage currentBlock;

//Raycasting vars (for block breaking)
float startx,starty,startz,endx,endy,endz;
float len = 0;
boolean hit = false;
//---------------

float xrot = 0;
float yrot = 0;
float zrot = 0;
float x = 0;
float y = -1000;
float z = 0;
float px,py,pz;
float yvel = 0;

// hotbar stuff
float squareSize = 80;
float bottomPadding = 20;

int slot = 1;
PImage items[] = new PImage[10];
int itemNums[] = new int[10];
//----------------

ArrayList<String> keys = new ArrayList<String>();

PImage grass = new PImage();
PImage dirt = new PImage();

chunk c;
Robot rbt;

void setup() { 
  fullScreen(P3D);
  //size(800,800,P3D);
  noCursor();
  dirt = loadImage("/textures/dirt.png");
  grass = loadImage("/textures/grass.png");
  try {
    rbt = new Robot();
  } catch (Exception e) {
    e.printStackTrace();
  }
  c=new chunk(chunkSize*cubeSize*-0.5,0,chunkSize*cubeSize*-0.5);
  perspective(PI/3.0, float(width)/float(height), 0.1,((height/2.0)/tan(PI*60.0/360.0))*10);
  colorMode(RGB, 255);
  //frameRate(-1);
  //beginPGL();
  //GLU.getCurrentGL().getGL2().setSwapInterval(1);
  //endPGL();
  frameRate(20);
}

void draw() {
  
  background(135,206,250,1);
  
  pushMatrix();
  if (dist(mouseX,mouseY,width/2,height/2)>2) {
    xrot += (mouseY-(height/2))*-0.2;
    yrot += (mouseX-(width/2))*-0.2;
  }
  
  //rotateX(radians(xrot));
  //rotateZ(radians(zrot));
  
  if (xrot<1) {
    xrot = 1;
  }
  if (xrot>179) {
    xrot = 179;
  }
  
  float xlookat = 0.01*sin(radians(yrot))*sin(radians(xrot)) + x;
  float ylookat = 0.01*cos(radians(xrot)) + y; // look up / down 
  float zlookat = 0.01*cos(radians(yrot))*sin(radians(xrot)) + z; 
  
  camera (x,y,z,
  xlookat, ylookat, zlookat,
  0.0, 1.0, 0.0
    );
  rbt.mouseMove((width/2+mouseX)/2,(height/2+mouseY)/2);
  
  c.display();
  //stroke(255,0,0);
  //strokeWeight(5);
  //line(startx,starty,startz,endx,endy,endz);
  popMatrix();
  
  pushMatrix();
  hint(DISABLE_DEPTH_TEST);
  noTint();
  strokeWeight(3);
  for (int i = 0; i < 10; i++) {
    if (slot==(10-i)) {
      fill(200,200,200,100);
    } else {
      fill(50,50,50,100);
    }
    stroke(50);
    rect(((width/2)+(5*squareSize))-((i+1)*squareSize),height-(bottomPadding+squareSize),squareSize,squareSize,10);
    fill(255);
    stroke(255);
    int tempI = 9-i;
    if (itemNums[tempI] > 0) {
      image(items[tempI],((width/2)+(5*squareSize))-((i+1)*squareSize)+10,height-(bottomPadding+squareSize)+10,squareSize-20,squareSize-20);
      text(str(itemNums[tempI]),((width/2)+(5*squareSize))-((i+1)*squareSize)+squareSize-(10*ceil(pow(itemNums[tempI],0.1))),height-(bottomPadding+squareSize)+squareSize-5);
    }
  }
  
  stroke(255.0 - red(get(width/2,height/2)), 255.0 - green(get(width/2,height/2)), 255.0 - blue(get(width/2,height/2)));
  line(width/2,height/2-20,width/2,height/2+20);
  line(width/2-20,height/2,width/2+20,height/2);
  
  hint(ENABLE_DEPTH_TEST);
  popMatrix();
  
  
  if (keyPressed) {
    for (String curkey: keys) {
      if (curkey.charAt(0)=='a') {
        z+=speed*cos(radians(yrot+90));
        x+=speed*sin(radians(yrot+90));
        y+=playerSize;
        c.collide();
        y-=playerSize;
        if (hit) {
          z-=speed*cos(radians(yrot+90));
          x-=speed*sin(radians(yrot+90));
        }
      }
      if (curkey.charAt(0)=='d') {
        z+=speed*cos(radians(yrot-90));
        x+=speed*sin(radians(yrot-90));
        y+=playerSize;
        c.collide();
        y-=playerSize;
        if (hit) {
          z-=speed*cos(radians(yrot-90));
          x-=speed*sin(radians(yrot-90));
        }
      }
      if (curkey.charAt(0)=='w') {
        z+=speed*cos(radians(yrot));
        x+=speed*sin(radians(yrot));
        y+=playerSize;
        c.collide();
        y-=playerSize;
        if (hit) {
          z-=speed*cos(radians(yrot));
          x-=speed*sin(radians(yrot));
        }
      }
      if (curkey.charAt(0)=='s') {
        z+=speed*cos(radians(yrot+180));
        x+=speed*sin(radians(yrot+180));
        y+=playerSize;
        c.collide();
        y-=playerSize;
        if (hit) {
          z-=speed*cos(radians(yrot+180));
          x-=speed*sin(radians(yrot+180));
        }
      }
      if (curkey.charAt(0)==' '&& !alreadyJumped) {
        y-= 5;
        yvel=-jumpHeight;
        alreadyJumped = true;
      }
    }
  }
  y+=playerSize;
  c.collide();
  y-=playerSize;
  if (!hit) {
    yvel += 0.89;
    y += yvel;
  }
  y+=playerSize;
  c.collide();
  y-=playerSize;
  if (hit) {
    y-=yvel;
    yvel = 0;
  }
}

void keyPressed() {
  if (int(key)<58 && int(key)>47) {
    if (int(key)==48) {
      slot = 10;
    } else {
      slot = int(key)-48;
    }
  }
  keys.add(str(key));
}

void keyReleased() {
  for (int a = 0; a < keys.size(); a++) {
    if (keys.get(a).charAt(0) == key) {
      keys.remove(a);
    }
  }
  if (key==' ') {
    alreadyJumped = false;
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    startx = x;
    starty = y;
    startz = z;
    hit=false;
    len = 0;
    while(!hit && len<200) {
      endx = len*sin(radians(yrot))*sin(radians(xrot)) + x;
      endy = len*cos(radians(xrot)) + y;
      endz = len*cos(radians(yrot))*sin(radians(xrot)) + z;
      c.rayDetect();
      len+=cubeSize/2;
    }
    c.update();
    if(hit) {
      addHotbar(currentBlock);
    }
  } else if (mouseButton == RIGHT) {
    currentBlock = items[slot-1];
    if (currentBlock != null) {
      startx = x;
      starty = y;
      startz = z;
      hit=false;
      len = 0;
      while(!hit && len<200) {
        endx = len*sin(radians(yrot))*sin(radians(xrot)) + x;
        endy = len*cos(radians(xrot)) + y;
        endz = len*cos(radians(yrot))*sin(radians(xrot)) + z;
        c.placeDetect();
        len+=cubeSize/2;
      }
      if(hit) {
        len-=cubeSize;
        endx = len*sin(radians(yrot))*sin(radians(xrot)) + x;
        endy = len*cos(radians(xrot)) + y;
        endz = len*cos(radians(yrot))*sin(radians(xrot)) + z;
        c.place();
      }
      c.update();
      if (hit) {
        itemNums[slot-1]-=1;
        if (itemNums[slot-1] <= 0)  {
          itemNums[slot-1] = 0;
          items[slot-1] = null;
        }
      }
    }
  }
}

void refreshPos() {
  px = x;
  py = y;
  pz = z;
}

void addHotbar(PImage item) {
  boolean done=false;
  if (itemNums[slot-1] == 0 || items[slot-1] == item) {
    itemNums[slot-1]++;
    items[slot-1] = item;
    done=true;
  } else {
    for (int i = 0; i < 10; i++) {
      if (!done) {
        if (itemNums[i] == 0 || items[i] == item) {
          itemNums[i]++;
          items[i] = item;
          done=true;
        }
      }
    }
  }
}

void getCurrentBlock() {
  currentBlock = items[slot-1];
}