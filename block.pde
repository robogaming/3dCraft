 class block {
  float x;
  float y;
  float z;
  float size = cubeSize;
  PImage texture;
  boolean show = true;
  boolean[] faces = new boolean[6];
  int shadowAmount;
  
  block(float tx, float ty,float tz, PImage img) {
    x = tx;
    y = ty;
    z = tz;
    texture = img;
    for (int a = 0; a < 6; a++) {
      faces[a] = true;
    }
  }
  
  void display() {
    noStroke();
    tint(shadowAmount);
    if (faces[0]) { // z-
        beginShape();
        textureMode(NORMAL);
        texture(texture);
        vertex(x,y,z,0,0);
        vertex(x+size,y,z,1,0);
        vertex(x+size,y+size,z,1,1);
        vertex(x,y+size,z,0,1);
        endShape(CLOSE);
      }
      if (faces[1]) { // y-
        beginShape();
        textureMode(NORMAL);
        texture(texture);
        vertex(x,y,z,0,0);
        vertex(x+size,y,z,1,0);
        vertex(x+size,y,z+size,1,1);
        vertex(x,y,z+size,0,1);
        endShape(CLOSE);
      }
      if (faces[2]) { // z+
        beginShape();
        textureMode(NORMAL);
        texture(texture);
        vertex(x,y,z+size,0,0);
        vertex(x+size,y,z+size,1,0);
        vertex(x+size,y+size,z+size,1,1);
        vertex(x,y+size,z+size,0,1);
        endShape(CLOSE);
      }
      if (faces[3]) { // y+
        beginShape();
        textureMode(NORMAL);
        texture(texture);
        vertex(x,y+size,z,0,0);
        vertex(x+size,y+size,z,1,0);
        vertex(x+size,y+size,z+size,1,1);
        vertex(x,y+size,z+size,0,1);
        endShape(CLOSE);
      }
      if (faces[4]) { // x-
        beginShape();
        textureMode(NORMAL);
        texture(texture);
        vertex(x,y,z,0,0);
        vertex(x,y+size,z,1,0);
        vertex(x,y+size,z+size,1,1);
        vertex(x,y,z+size,0,1);
        endShape(CLOSE);
      }
      if (faces[5]) { // x+
        beginShape();
        textureMode(NORMAL);
        texture(texture);
        vertex(x+size,y,z,0,0);
        vertex(x+size,y+size,z,1,0);
        vertex(x+size,y+size,z+size,1,1);
        vertex(x+size,y,z+size,0,1);
        endShape(CLOSE);
      }
    }
  }