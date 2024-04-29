/* ============ G L O B A L S ============ */
final int BOX_WIDTH = 500;
final int NUM_BOIDS = 100;

ArrayList<Boid> boids;

Arcball arcball;
Quat rotQuat;
float quatAngle;
PVector quatAxis;
boolean [] xyzRotating;
Quat[] xyzQuats;

void setup() {
  fullScreen(P3D);
  colorMode(HSB);
  noFill();
  stroke(255);
  
  boids = new ArrayList<Boid> ();
  for (int i = 0; i < NUM_BOIDS; i++) {
    boids.add(new Boid(BOX_WIDTH, boids));
  } //for

  arcball = new Arcball(new PVector(width/2, height/2, 0), Math.max(width, height) / 2);
  rotQuat = new Quat();

  xyzRotating = new boolean [3];
  xyzQuats = new Quat[3];
  for (int i = 0; i < 3; i++) {
    xyzQuats[i] = new Quat();
  } //for
  xyzQuats[0].set((float) Math.cos(radians(0.5)), new PVector(-(float) Math.sin(radians(0.5)), 0, 0));
  xyzQuats[1].set((float) Math.cos(radians(0.5)), new PVector(0, (float) Math.sin(radians(0.5)), 0));
  xyzQuats[2].set((float) Math.cos(radians(0.5)), new PVector(0, 0, (float) -Math.sin(radians(0.5))));
} //setup

void draw() {
  /* ===== ROTATION HANDLING ===== */
  background(0);
  pushMatrix();
  translate(width/2, height/2);

  quatAngle = rotQuat.getAngle();
  quatAxis = rotQuat.getAxis();
  rotate(quatAngle, quatAxis.x, quatAxis.y, quatAxis.z); 
  
  strokeWeight(5);
  stroke(75, 255, 255, 50);
  line(-BOX_WIDTH/2, 0, 0, BOX_WIDTH/2, 0, 0);
  
  stroke(150, 255, 255, 50);
  line(0, -BOX_WIDTH/2, 0, 0, BOX_WIDTH/2, 0);
  
  stroke(225, 255, 255, 50);
  line(0, 0, -BOX_WIDTH/2, 0, 0, BOX_WIDTH/2);
  strokeWeight(1);
  
  if (mousePressed) {
    arcball.update();
    rotQuat = mult(arcball.getQuat(), rotQuat);
  } //if
  
  if (xyzRotating[0]) rotQuat = mult(xyzQuats[0], rotQuat);
  if (xyzRotating[1]) rotQuat = mult(xyzQuats[1], rotQuat);
  if (xyzRotating[2]) rotQuat = mult(xyzQuats[2], rotQuat);
  
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
    xyzRotating[i] = false;
  } //for
} //stopRotating

void keyPressed() {
  switch(key) {
    case 'x':
      xyzRotating[0] = !xyzRotating[0];
      break;
    case 'y':
      xyzRotating[1] = !xyzRotating[1];
      break;
    case 'z':
      xyzRotating[2] = !xyzRotating[2];
      break;
    case 'r':
      stopRotating();
  } //switch
} //keyPressed

void mousePressed() {
  stopRotating();
} //mousePressed
