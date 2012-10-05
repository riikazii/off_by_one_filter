// Special glitch filter
// Be careful what your libraries do, kids!!!

import processing.video.*;

Capture cam;

void setup() {
  size(1024, 512);

  cam = new Capture(this, 512, 512);
}


void draw() {
  if (cam.available() == true) {
    cam.read();
    set(0,0, cam);
  }
} 

void keyPressed()
{
  if(key == 'c'){
    PImage filtered;
    filtered = glitchMe(get(0, 0, 512, 512));
    set(512,0,filtered);
  }
}
