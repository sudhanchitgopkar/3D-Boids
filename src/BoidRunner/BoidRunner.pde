final int BOX_WIDTH = 500;
int rot;
void setup() {
  fullScreen(P3D);
  noFill();
  stroke(255);
} //setup

void draw() {
  background(0);
  pushMatrix();
  translate(width/2, height/2);
  rotateY(radians(rot));
  box(BOX_WIDTH);
  rot = ++rot % 360;
  popMatrix();
} //draw
