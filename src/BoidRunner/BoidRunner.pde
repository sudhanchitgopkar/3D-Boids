/* ============ G L O B A L S ============ */
final int BOX_WIDTH = 500;
final int NUM_BOIDS = 50;

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
    rotateY(map(mouseX, -width/2, width/2, 0, TWO_PI));
    rotateX(map(mouseY, -height/2, height/2, 0, TWO_PI));
  } //if
  
  /* ===== BOX DRAWING ===== */
  stroke(255);
  box(BOX_WIDTH);
  
  /* ===== BOID RENDERING ===== */
  for (Boid b : boids) {
    b.flock();
    b.display();
  } //for
  
  /* ===== ROTATION HANDLING ===== */
  if (isRotating[0]) rotAngles.x = ++rotAngles.x % 360;
  if (isRotating[1]) rotAngles.y = ++rotAngles.y % 360;
  if (isRotating[2]) rotAngles.z = ++rotAngles.z % 360;
  popMatrix();
} //draw

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
       for (int i = 0; i < 3; i++) {
         isRotating[i] = false;
       } //for
   } //switch
} //keyPressed
