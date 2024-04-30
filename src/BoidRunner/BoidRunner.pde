import controlP5.*;

/* ============ G L O B A L S ============ */
final int BOX_WIDTH = 450;
final int NUM_BOIDS = 300;
final int NUM_OBSTACLES = int(random(2,6));

ArrayList<Boid> boids;
ArrayList<Obstacle> obstacles;

Arcball arcball;
Quat rotQuat;
float quatAngle;
PVector quatAxis;
boolean [] xyzRotating;
Quat[] xyzQuats;

ControlP5 cp5;  
boolean guiHidden;
ControlFont font;

void setup() {
  fullScreen(P3D);
  noFill();
  stroke(255);
  
  //GUI Setup
  PFont pfont = createFont("courier",12,true);
  font = new ControlFont(pfont,12);
  cp5 = new ControlP5(this);
  initGUI();
  
  //Random Obstacle Setup
  obstacles = new ArrayList<Obstacle> ();
  for (int i = 0; i < NUM_OBSTACLES; i++) {
    float r = random(30, 50);
    obstacles.add(new Obstacle(new PVector(random(-BOX_WIDTH/2 + r, BOX_WIDTH/2 - r), 
                                           random(-BOX_WIDTH/2 + r, BOX_WIDTH/2 - r),
                                           random(-BOX_WIDTH/2 + r, BOX_WIDTH/2 - r)), r));
  } //for
  
  //Boid Flock Setup
  boids = new ArrayList<Boid> ();
  for (int i = 0; i < NUM_BOIDS; i++) {
    boids.add(new Boid(BOX_WIDTH, boids, obstacles));
  } //for


  //Cube Rotation Setup
  arcball = new Arcball(new PVector(width/2, height/2, 0), Math.max(width, height) / 2);
  rotQuat = new Quat();
  xyzRotating = new boolean [] {false, true, false};
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
  translate(width/2, height/2, 0);

  quatAngle = rotQuat.getAngle();
  quatAxis = rotQuat.getAxis();
  rotate(quatAngle, quatAxis.x, quatAxis.y, quatAxis.z); 
  if (mousePressed && keyPressed) {
    stopRotating();
    arcball.update();
    rotQuat = mult(arcball.getQuat(), rotQuat);
  } //if
  if (xyzRotating[0]) rotQuat = mult(xyzQuats[0], rotQuat);
  if (xyzRotating[1]) rotQuat = mult(xyzQuats[1], rotQuat);
  if (xyzRotating[2]) rotQuat = mult(xyzQuats[2], rotQuat);
  
  /* ===== BOX DRAWING ===== */
  stroke(255);
  box(BOX_WIDTH);
  noFill();
  
  /* ===== BOID RENDERING ===== */
  for (Obstacle o : obstacles) {
    o.display();  
  } //for
  
  for (Boid b : boids) {
    b.flock();
    b.display();
  } //for
  
  /* === AXES  DRAWING ===
  strokeWeight(5);
  stroke(75, 255, 255, 50);
  line(-BOX_WIDTH/2, 0, 0, BOX_WIDTH/2, 0, 0);
  
  stroke(150, 255, 255, 50);
  line(0, -BOX_WIDTH/2, 0, 0, BOX_WIDTH/2, 0);
  
  stroke(225, 255, 255, 50);
  line(0, 0, -BOX_WIDTH/2, 0, 0, BOX_WIDTH/2);
  strokeWeight(1);
  ======================== */
  
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
      xyzRotating = new boolean [] {false, true, false};
      xyzQuats[0].set((float) Math.cos(radians(0.5)), new PVector(-(float) Math.sin(radians(0.5)), 0, 0));
      xyzQuats[1].set((float) Math.cos(radians(0.5)), new PVector(0, (float) Math.sin(radians(0.5)), 0));
      xyzQuats[2].set((float) Math.cos(radians(0.5)), new PVector(0, 0, (float) -Math.sin(radians(0.5))));
      break;
    case 'g':
      guiHidden = !guiHidden;
      if (guiHidden) cp5.hide();
      else cp5.show();
  } //switch
} //keyPressed

void initGUI() {
  cp5.addSlider("SEPARATION WEIGHT")
       .setFont(font)
       .setPosition(40, 40)
       .setSize(100, 20)
       .setRange(0, 10)
       .setValue(3.5)
       .setColorCaptionLabel(color(255));
  cp5.addSlider("ALIGNMENT WEIGHT")
       .setFont(font)
       .setPosition(40, 70)
       .setSize(100, 20)
       .setRange(0, 10)
       .setValue(3.2)
       .setColorCaptionLabel(color(255));
  cp5.addSlider("COHESION WEIGHT")
       .setFont(font)
       .setPosition(40, 100)
       .setSize(100, 20)
       .setRange(0, 10)
       .setValue(2.8)
       .setColorCaptionLabel(color(255));
  cp5.addSlider("WALL AVOIDANCE WEIGHT")
       .setFont(font)
       .setPosition(40, 130)
       .setSize(100, 20)
       .setRange(0, 10)
       .setValue(4)
       .setColorCaptionLabel(color(255));
  cp5.addSlider("OBSTACLE AVOIDANCE WEIGHT")
       .setFont(font)
       .setPosition(40, 160)
       .setSize(100, 20)
       .setRange(0, 10)
       .setValue(4)
       .setColorCaptionLabel(color(255));
  cp5.addSlider("VISIBILITY")
       .setFont(font)
       .setPosition(40, 190)
       .setSize(100, 20)
       .setRange(10, 200)
       .setValue(25)
       .setColorCaptionLabel(color(255));
} //initGUI
