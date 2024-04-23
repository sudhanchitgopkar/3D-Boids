/* ============ G L O B A L S ============ */
final int BOX_WIDTH = 500;
final int NUM_BOIDS = 100;

int rotAngle;
boolean isRotating;
ArrayList<Boid> boids; 

void setup() {
  fullScreen(P3D);
  colorMode(HSB);
  noFill();
  stroke(255);
  
  boids = new ArrayList<Boid> ();
  for (int i = 0; i < NUM_BOIDS; i++) {
    boids.add(new Boid(BOX_WIDTH, boids));
  } //for
} //setup

void draw() {
  background(0);
  pushMatrix();
  translate(width/2, height/2);
  rotateY(radians(rotAngle));
  
  stroke(255);
  box(BOX_WIDTH);
  
  for (Boid b : boids) {
    b.flock();
    b.display();
  } //for
  
  if (isRotating) rotAngle = ++rotAngle % 360;
  popMatrix();
} //draw

void keyPressed() {
   if (key == ' ') isRotating = !isRotating;
} //keyPressed
