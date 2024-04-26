/* ============ G L O B A L S ============ */
final int BOX_WIDTH = 500;
final int NUM_BOIDS = 200;

PVector rotAngles;
boolean [] isRotating;
ArrayList<Boid> boids;

void setup() {
  fullScreen(P3D);
  colorMode(HSB);
  noFill();
  stroke(255);
  
  isRotating = new boolean [3];
  rotAngles = new PVector(0, 0, 0);
  boids = new ArrayList<Boid> ();
  for (int i = 0; i < NUM_BOIDS; i++) {
    boids.add(new Boid(BOX_WIDTH, boids));
  } //for
} //setup

void draw() {
  /* ===== ROTATION HANDLING ===== */
  background(0);
  pushMatrix();
  translate(width/2, height/2);
  rotateX(radians(rotAngles.x));
  rotateY(radians(rotAngles.y));
  rotateZ(radians(rotAngles.z));
  
  if (mousePressed) {
    rotAngles.x += map(mouseY - pmouseY, 0, height, 360, 0);
    rotAngles.y += map(mouseX - pmouseX, 0, width, 0, 360);
  } //if
  
  if (isRotating[0]) rotAngles.x++;
  if (isRotating[1]) rotAngles.y++;
  if (isRotating[2]) rotAngles.z++;
  
  rotAngles.x %= 360;
  rotAngles.y %= 360;
  rotAngles.z %= 360;
  
  /* ===== BOX DRAWING ===== */
  stroke(255);
  box(BOX_WIDTH);
  
  /* ===== BOID RENDERING ===== */
  for (Boid b : boids) {
    b.flock();
    b.display();
  } //for
  popMatrix();
} //draw

void stopRotating() {
  for (int i = 0; i < 3; i++) {
    isRotating[i] = false;
  } //for
} //stopRotating

void keyPressed() {
   switch(key) {
     case 'x':
       isRotating[0] = !isRotating[0];
       break;
     case 'y':
       isRotating[1] = !isRotating[1];
       break;
     case 'z':
       isRotating[2] = !isRotating[2];
       break;
     case 'r':
       rotAngles = new PVector(0, 0, 0);
       stopRotating();
   } //switch
} //keyPressed

void mousePressed() {
  stopRotating();
} //mousePressed
