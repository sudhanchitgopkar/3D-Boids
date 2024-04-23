/* ============ G L O B A L S ============ */
final int BOX_WIDTH = 500;
int rotAngle;
boolean isRotating;

void setup() {
  fullScreen(P3D);
  noFill();
  stroke(255);
} //setup

void draw() {
  background(0);
  pushMatrix();
  translate(width/2, height/2);
  rotateY(radians(rotAngle));
  
  box(BOX_WIDTH);  
  
  if (isRotating) rotAngle = ++rotAngle % 360;
  popMatrix();
} //draw

void keyPressed() {
   if (key == ' ') isRotating = !isRotating;
} //keyPressed
