class chunk {
  float x;
  float y;
  float z;
  float bx;
  float by;
  float bz;
  float cs = cubeSize;
  block[][][] blocks = new block[int(chunkSize)][int(chunkSize)][int(chunkSize)];
  
  chunk(float tx, float ty, float tz) {
    x = tx;
    y = ty;
    z = tz;
    for (int a = 0; a < chunkSize; a++) {
      for (int b = 0; b<chunkSize; b++) {
        for (int c = 0; c < chunkSize; c++) {
          if (y>=0) {
            if (y == 0) {
                blocks[a][b][c] = new block(a*cubeSize+x,b*cubeSize+y,c*cubeSize+z,grass);
            } else {
              blocks[a][b][c] = new block(a*cubeSize+x,b*cubeSize+y,c*cubeSize+z,dirt);
            }
          }
        }
      }
    }
    update();
  }
  
  void update() {
    for (int a = 0; a < chunkSize; a++) {
      for (int b = 0; b < chunkSize; b++) {
        for (int c = 0; c < chunkSize; c++) {
          if (blocks[a][b][c] != null) {//Does it exist?
            //To optimize, don't display what we can't see.
            try {
              blocks[a][b][c].faces[3] = blocks[a][b-1][c] == null;
            } catch (Exception e) {
              blocks[a][b][c].faces[3] = true;
            }
            
            if (blocks[a][b][c] != null) {
              blocks[a][b][c].shadowAmount = int(170+(noise(a*cubeSize+x,c*cubeSize+z)*20));
              try {
                blocks[a][b][c].shadowAmount = int(blocks[a][b-1][c].shadowAmount*0.8);
              } catch (Exception e) {}
            }
          }
        }
      }
    }
  }
  
  void display() {
    for (int a = 0; a < chunkSize; a++) {
      for (int b = 0; b < chunkSize; b++) {
        for (int c = 0; c < chunkSize; c++) {
          if (blocks[a][b][c] != null) {
            blocks[a][b][c].display();
          }
        }
      }
    }
  }
  
  void rayDetect() {
    refreshPos();
    hit = false;
    for (int a = 0; a < chunkSize; a++) {
      for (int b = 0; b < chunkSize; b++) {
        for (int c = 0; c < chunkSize; c++) {
          if (blocks[a][b][c] != null) {// let's make sure what we are trying to break exists
            // Blocks breaking code
            bx = blocks[a][b][c].x;
            by = blocks[a][b][c].y;
            bz = blocks[a][b][c].z;
            if (dist(bx,by,bz,endx,endy,endz) < 400) {
              if(endx>bx && endx<bx+cs && endy>by && endy<by+cs && endz>bz && endz<bz+cs) {
                currentBlock = blocks[a][b][c].texture;
                blocks[a][b][c] = null;
                hit = true;
              }
            }
          }
        }
      }
    }
  }
  
  void placeDetect() {
    refreshPos();
    hit = false;
    for (int a = 0; a < chunkSize; a++) {
      for (int b = 0; b < chunkSize; b++) {
        for (int c = 0; c < chunkSize; c++) {
          if (blocks[a][b][c] != null) {// let's make sure what we are trying to place on exists
            // Blocks breaking code
            bx = blocks[a][b][c].x;
            by = blocks[a][b][c].y;
            bz = blocks[a][b][c].z;
            if (dist(bx,by,bz,endx,endy,endz) < 400) {
              if(endx>bx && endx<bx+cs && endy>by && endy<by+cs && endz>bz && endz<bz+cs) {
                hit = true;
              }
            }
          }
        }
      }
    }
  }
  
  void place() {
    refreshPos();
    hit = false;
    for (int a = 0; a < chunkSize; a++) {
      for (int b = 0; b < chunkSize; b++) {
        for (int c = 0; c < chunkSize; c++) {
          if (!hit) {
            if (blocks[a][b][c] == null) { //lets make sure there is air there that we can build in
              // Blocks breaking code
              bx = a*cubeSize+x;
              by = b*cubeSize+y;
              bz = c*cubeSize+z;
              if (dist(bx,by,bz,endx,endy,endz) < cubeSize*1.5) {
                if(endx>bx && endx<bx+cs && endy>by && endy<by+cs && endz>bz && endz<bz+cs) {
                  blocks[a][b][c] = new block(a*cubeSize+x,b*cubeSize+y,c*cubeSize+z,currentBlock);
                  hit = true;
                }
              }
            }
          }
        }
      }
    }
  }
          
  void collide() {
    refreshPos();
    hit = false;
    for (int a = 0; a < chunkSize; a++) {
      for (int b = 0; b < chunkSize; b++) {
        for (int c = 0; c < chunkSize; c++) {
          if (blocks[a][b][c] != null) {// let's make sure what we are trying to check exists
            // collision detection
            bx = blocks[a][b][c].x;
            by = blocks[a][b][c].y;
            bz = blocks[a][b][c].z;
            if (dist(bx,by,bz,px,py,pz) < cubeSize*1.5) {
              if(px>=bx && px<=bx+cs && py>=by && py<=by+cs && pz>=bz && pz<=bz+cs) {
                hit = true;
              }
            }
          }
        }
      }
    }
  }
}