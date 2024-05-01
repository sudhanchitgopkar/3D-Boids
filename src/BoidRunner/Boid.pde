class Boid {
  /* ============ GLOBALS ============ */
  ArrayList<Boid> flock;
  ArrayList<Obstacle> obstacles;
  
  PVector pos, vel, acc;
  float r;

  int BOX_WIDTH;
  float MAX_SPEED, MAX_FORCE;
  float SEP_WEIGHT, ALI_WEIGHT, COH_WEIGHT, OBS_WEIGHT, WALL_WEIGHT, VISIBILITY;
  /* ============ END GLOBALS ============ */
  
  /* ============ CONSTRUCTORS ============ */
  /**
    Creates a new boid with specified params.
    @param BOX_WIDTH width of the simulation box
    @param flock list of all other boids in the simulation
    @param obstacles list of all obstacles in the simulation
  */
  public Boid(int BOX_WIDTH, ArrayList<Boid> flock, ArrayList<Obstacle> obstacles) {
    this.flock = flock;
    this.obstacles = obstacles;
    
    pos = PVector.random3D().mult(5);    //Controls how far boids spawn from ea. other
    vel = new PVector(cos(random(PI/4)), sin(random(PI/4)), cos(random(PI/4)));
    acc = PVector.random3D();
    VISIBILITY = 25;
    
    this.BOX_WIDTH = BOX_WIDTH;
    MAX_SPEED = 2;
    MAX_FORCE = .03;
    SEP_WEIGHT = 3.5;
    ALI_WEIGHT = 3.2;
    COH_WEIGHT = 1.4;
    OBS_WEIGHT = 4.0;
    WALL_WEIGHT = 4.0;
    
    r = 4;
    bound();
  } //Boid
  /* ============ END CONSTRUCTORS ============ */
  
  /**
    Displays a boid to the screen.
  */
  public void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    noStroke();
    colorMode(HSB);
    fill(map(PVector.dist(pos,new PVector(0,0,0)),0, BOX_WIDTH, 0,255),255,255);
    colorMode(RGB);
    PVector tip = PVector.mult(vel.normalize(null), 2*r);
    box(r);
    colorMode(HSB);
    stroke(map(PVector.dist(pos,new PVector(0,0,0)),0, BOX_WIDTH, 0,255),255,255);
    colorMode(RGB);
    line(0,0,0,tip.x,tip.y,tip.z);
    noFill();
    popMatrix();
  } //display
  
  /**
    Moves the boid based on flocking and avoidance forces.
  */
  public void flock() {
    PVector sep = sep(), ali = ali(), coh = coh();  //Standard Boid forces
    PVector avo = wallAvoid();
    
    //Get weights from GUI
    SEP_WEIGHT = cp5.getController("SEPARATION WEIGHT").getValue();
    ALI_WEIGHT = cp5.getController("ALIGNMENT WEIGHT").getValue();
    COH_WEIGHT = cp5.getController("COHESION WEIGHT").getValue();
    OBS_WEIGHT = cp5.getController("WALL AVOIDANCE WEIGHT").getValue();
    WALL_WEIGHT = cp5.getController("OBSTACLE AVOIDANCE WEIGHT").getValue();
    VISIBILITY = cp5.getController("VISIBILITY").getValue();
    
    //Apply weights to each force
    sep.mult(SEP_WEIGHT);
    ali.mult(ALI_WEIGHT);
    coh.mult(COH_WEIGHT);
    avo.mult(WALL_WEIGHT);
    
    //Generate acceleration force
    for (Obstacle o : obstacles) {
      acc.add(avoid(o).mult(OBS_WEIGHT));
    } //for
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
    acc.add(avo);
    
    vel.add(acc);         //Update velocity
    vel.limit(MAX_SPEED);
    acc.mult(0);          //Reset acceleration
    
    pos.add(vel);         //Update position
    bound();              //Handle any OOB
  } //flock
  
  /**
    Generates separation force.
    @return separation vector
  */
  private PVector sep() {
    PVector sep = new PVector(0, 0, 0);
    int numVis = 0;
    
    for (Boid b : flock) {
        if (isVis(b)) {
          ++numVis;
          sep.add(PVector.sub(this.pos, b.pos)
                    .normalize().div(getDist(b)));  //Weight by proximity
        } //if
    } //for
    
    if (numVis > 0) {
      sep.div(numVis);
      sep.setMag(MAX_SPEED);
      sep.sub(vel);
      sep.limit(MAX_FORCE);
    } //if
    
    return sep;
  } //sep
  
  /**
    Generates alignment force.
    @return alignment vector
  */
  private PVector ali() {
    PVector ali = new PVector(0, 0, 0);
    int numVis = 0;
    
    for (Boid b : flock) {
      if (isVis(b)) {
        ++numVis;
        ali.add(b.vel);  
      } //if
    } //for
    
    if (numVis > 0) {
      ali.div(numVis);
      ali.setMag(MAX_SPEED);
      ali.sub(vel);
      ali.limit(MAX_FORCE);
    } //if
    
    return ali;
  } //ali
  
  /**
    Generates cohesion force.
    @return cohesion vector
  */
  private PVector coh() {
    PVector coh = new PVector(0,0,0);
    int numVis = 0;
    
    for (Boid b : flock) {
      if (isVis(b)) {
        ++numVis;
        coh.add(b.pos);
      } //if
    } //for
    
    if (numVis > 0) {
      coh.div(numVis);
      PVector desired = PVector.sub(coh, this.pos);
      desired.setMag(MAX_SPEED);
      desired.sub(vel);
      desired.limit(MAX_FORCE);
      return desired;
    }
    
    return coh;
  } //coh
  
  /**
    Generates force to avoid specified obstacle.
    @param o the obstacle to avoid
    @return force away from obstacle
  */
  private PVector avoid(Obstacle o) {
    PVector avo = new PVector(); 
    if (pos.dist(o.pos) > o.r + VISIBILITY) return avo; //If out of eyesight
    
    avo.set(PVector.sub(pos,o.pos)); 
    avo.mult(1/PVector.dist(pos,o.pos));  //Weight by proximity
    avo.limit(MAX_FORCE); 
    
    return avo;
  } //avoid
  
  /**
    Generates a force pushing away from walls close by.
    @return vector pushing away from walls close by
  */
  private PVector wallAvoid() {
    PVector avo = new PVector(0, 0, 0); 
    PVector walls [] = {new PVector(-BOX_WIDTH/2, pos.y, pos.z),
                        new PVector(BOX_WIDTH/2, pos.y, pos.z),
                        new PVector(pos.x, -BOX_WIDTH/2, pos.z),
                        new PVector(pos.x, BOX_WIDTH/2, pos.z),
                        new PVector(pos.x, pos.y, -BOX_WIDTH/2),
                        new PVector(pos.x, pos.y, BOX_WIDTH/2)};
    
    for (PVector wall : walls) {
      PVector steer = new PVector();
      steer.set(PVector.sub(pos,wall).normalize()); 
      steer.mult(1/PVector.dist(pos,wall));  //Weight by proximity
      avo.add(steer);
    } //for
    
    avo.div(4);
    avo.limit(MAX_FORCE); 
    
    return avo;
  } //wallAvoid
  
  /**
    Allows boids to reappear on the opposite side when
    they fly out of the simulation box.
  */
  private void bound() {
    pos.x = pos.x <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 - 10: pos.x >= BOX_WIDTH/2 ? -BOX_WIDTH/2 + 10 : pos.x;
    pos.y = pos.y <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 - 10: pos.y >= BOX_WIDTH/2 ? -BOX_WIDTH/2 + 10 : pos.y;
    pos.z = pos.z <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 - 10: pos.z >= BOX_WIDTH/2 ? -BOX_WIDTH/2 + 10 : pos.z;
  } //bound
  
  /**
    Determines if a boid is visible to this boid.
    @param b the boid to check visibility of
    @return whether the boid is visible
  */
  private boolean isVis(Boid b) {
    float dist = pos.dist(b.pos);
    return dist <= VISIBILITY && dist > 0;
  } //isVis
  
  /**
    Gets distance from this to a specified boid.
    @param b the boid to get distance to
    @return the distance from this to a specified boid
  */
  private float getDist(Boid b) {
    return pos.dist(b.pos);
  } //getDist
} //Boid
