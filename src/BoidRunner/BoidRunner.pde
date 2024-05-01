import controlP5.*; //used for GUI

/* ============ GLOBALS ============ */
//Params
final int BOX_WIDTH = 450;
int NUM_OBSTACLES;
int NUM_BOIDS;

//Objects
ArrayList<Boid> boids;
ArrayList<Obstacle> obstacles;

//Rotation
Arcball arcball;
Quat rotQuat;
float quatAngle;
PVector quatAxis;
boolean [] xyzRotating;
Quat[] xyzQuats;

//GUI
ControlP5 cp5;  
boolean guiHidden;
ControlFont font;
/* ============ END GLOBALS ============ */

void setup() {
  fullScreen(P3D);
  noFill();
  stroke(255);
  
  //GUI Setup
  PFont pfont = createFont("courier",12,true);
  textFont(pfont);
  font = new ControlFont(pfont,12);
  cp5 = new ControlP5(this);
  initGUI();
  
  //Obstacle Setup
  NUM_OBSTACLES = int(random(1, 5));
  obstacles = new ArrayList<Obstacle> ();
  for (int i = 0; i < NUM_OBSTACLES; i++) {
    float r = random(50, 90);
    obstacles.add(new Obstacle(new PVector(random(-BOX_WIDTH/2 + r, BOX_WIDTH/2 - r), 
                                           random(-BOX_WIDTH/2 + r, BOX_WIDTH/2 - r),
                                           random(-BOX_WIDTH/2 + r, BOX_WIDTH/2 - r)), r));
  } //for
  
  //Boid Setup
  NUM_BOIDS = 600;
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
  xyzQuats[0].set((float) Math.cos(radians(0.2)), new PVector(-(float) Math.sin(radians(0.2)), 0, 0));
  xyzQuats[1].set((float) Math.cos(radians(0.2)), new PVector(0, (float) Math.sin(radians(0.2)), 0));
  xyzQuats[2].set((float) Math.cos(radians(0.2)), new PVector(0, 0, (float) -Math.sin(radians(0.2))));
} //setup

void draw() {
  background(0); //black
  if (!guiHidden) writeKeyBinds();
  lights();
  
  pushMatrix();
  translate(width/2, height/2, 0); //screen center = (0,0)
  
  /* ===== ROTATION HANDLING ===== */
  quatAngle = rotQuat.getAngle();
  quatAxis = rotQuat.getAxis();
  rotate(quatAngle, quatAxis.x, quatAxis.y, quatAxis.z); 
  if (mousePressed && (keyPressed || guiHidden)) {
    stopRotating();
    arcball.update();
    rotQuat = mult(arcball.getQuat(), rotQuat);
  } //if
  if (xyzRotating[0]) rotQuat = mult(xyzQuats[0], rotQuat);
  if (xyzRotating[1]) rotQuat = mult(xyzQuats[1], rotQuat);
  if (xyzRotating[2]) rotQuat = mult(xyzQuats[2], rotQuat);
  /* ===== END ROTATION HANDLING ===== */
  
  /* ===== BOX DRAWING ===== */
  strokeWeight(2);
  stroke(255);
  box(BOX_WIDTH);
  strokeWeight(1);
  noFill();
  /* ===== END BOX DRAWING ===== */
  
  /* ===== OBJECT RENDERING ===== */
  for (Obstacle o : obstacles) {
    o.display();  
  } //for
  
  for (Boid b : boids) {
    b.flock();
    b.display();
  } //for
  /* ===== END OBJECT RENDERING ===== */
  popMatrix();
  
  /* ===== UPDATE NUM_BOIDS FROM GUI ===== */
  int numDesired = int(cp5.getController("NUM BOIDS").getValue());
  if (NUM_BOIDS != numDesired) {
    NUM_BOIDS = numDesired;
    boids = new ArrayList<Boid> ();
    for (int i = 0; i < NUM_BOIDS; i++) {
      boids.add(new Boid(BOX_WIDTH, boids, obstacles));
    } //for
  } //if
  /* ===== END UPDATE NUM_BOIDS FROM GUI ===== */
} //draw

/**
  Stops all auto-rotation on Simbox.
*/
void stopRotating() {
  for (int i = 0; i < 3; i++) {
    xyzRotating[i] = false;
  } //for
} //stopRotating

/**
  Handles all key-presses during Sim.
*/
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
     setup();
     break;
    case 'g':
      guiHidden = !guiHidden;
      if (guiHidden) cp5.hide();
      else cp5.show();
      break;
  } //switch
} //keyPressed

/**
  Initializes GUI sliders
*/
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
       .setValue(1.4)
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
  cp5.addSlider("NUM BOIDS")
       .setFont(font)
       .setPosition(40, 220)
       .setSize(100, 20)
       .setRange(100, 800)
       .setValue(300)
       .setColorCaptionLabel(color(255));
} //initGUI

/**
  Displays key-bindings to screen.
*/
void writeKeyBinds() {
  fill(255);
  text("KEYBINDINGS:", 40, 270);
  text("X,Y,Z: AUTO-ROTATE X,Y,Z AXIS", 40, 290);
  text("G: TOGGLE GUI", 40, 310);
  text("R: CREATE NEW SCENE", 40, 330);
  text("MOUSE*: ROTATE SIMBOX", 40, 350);
  text("*HOLD SHIFT IF GUI ON", 40, 370);
  noFill();
} //writeKeyBinds
