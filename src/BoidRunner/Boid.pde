class Boid {
  ArrayList<Boid> flock;
  ArrayList<Obstacle> obstacles;
  PVector pos, vel, acc;
  float visibility;
  int BOX_WIDTH;
  float MAX_SPEED, MAX_FORCE;
  float SEP_WEIGHT, ALI_WEIGHT, COH_WEIGHT, OBS_WEIGHT, WALL_WEIGHT;
  float r;

  public Boid(int BOX_WIDTH, ArrayList<Boid> flock, ArrayList<Obstacle> obstacles) {
    this.flock = flock;
    this.obstacles = obstacles;
    
    pos = PVector.random3D().mult(5);
    vel = PVector.random3D().mult(0.2);
    acc = PVector.random3D();
    visibility = 25;
    
    this.BOX_WIDTH = BOX_WIDTH;
    MAX_SPEED = 3;
    MAX_FORCE = .2;
    SEP_WEIGHT = 3.5;
    ALI_WEIGHT = 3.2;
    COH_WEIGHT = 2.8;
    OBS_WEIGHT = 4.0;
    WALL_WEIGHT = 4.0;
    
    r = 2;
    //wallBounce();
    bound();
  } //Boid
  
  public void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    noStroke();
    fill(map(pos.x, -BOX_WIDTH/2, BOX_WIDTH/2, 100, 200), 
         map(pos.y, -BOX_WIDTH/2, BOX_WIDTH/2, 100, 200),
         map(pos.z, -BOX_WIDTH/2, BOX_WIDTH/2, 100, 200));
    sphere(r);    
    noFill();
    stroke(255);
    popMatrix();
  } //display
  
  public void flock() {
    PVector sep = sep(), ali = ali(), coh = coh();
    PVector avo = wallAvoid();
    
    SEP_WEIGHT = cp5.getController("SEPARATION WEIGHT").getValue();
    ALI_WEIGHT = cp5.getController("ALIGNMENT WEIGHT").getValue();
    COH_WEIGHT = cp5.getController("COHESION WEIGHT").getValue();
    OBS_WEIGHT = cp5.getController("WALL AVOIDANCE WEIGHT").getValue();
    WALL_WEIGHT = cp5.getController("OBSTACLE AVOIDANCE WEIGHT").getValue();
    visibility = cp5.getController("VISIBILITY").getValue();
    
    sep.mult(SEP_WEIGHT);
    ali.mult(ALI_WEIGHT);
    coh.mult(COH_WEIGHT);
    avo.mult(WALL_WEIGHT);
        
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
    acc.add(avo);
    
    for (Obstacle o : obstacles) {
      acc.add(avoid(o).mult(OBS_WEIGHT));
    } //for
     
    vel.add(acc);
    vel.limit(MAX_SPEED);
    acc.mult(0);
    
    pos.add(vel);
    //wallBounce();
    bound();
  } //flock
  
  private PVector sep() {
    PVector sep = new PVector(0, 0, 0);
    int numVis = 0;
    for (Boid b : flock) {
        if (isVis(b)) {
          stroke(255,0,0);
          ++numVis;
          sep.add(PVector.sub(this.pos, b.pos)
                    .normalize().div(getDist(b)));
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
  
  private PVector avoid(Obstacle o) {
    PVector avo = new PVector(); 
    if (pos.dist(o.pos) > o.r) return avo;
    avo.set(PVector.sub(pos,o.pos)); 
    avo.mult(1/PVector.dist(pos,o.pos));
    avo.limit(MAX_FORCE); 
    return avo;
  } //avoid
  
  private boolean isVis(Boid b) {
    float dist = pos.dist(b.pos);
    return dist <= visibility && dist > 0;
  } //isVis
  
  private float getDist(Boid b) {
    return pos.dist(b.pos);
  } //getDist
  
  private void bound() {
    pos.x = pos.x <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 - 10: pos.x >= BOX_WIDTH/2 ? -BOX_WIDTH/2 + 10 : pos.x;
    pos.y = pos.y <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 - 10: pos.y >= BOX_WIDTH/2 ? -BOX_WIDTH/2 + 10 : pos.y;
    pos.z = pos.z <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 - 10: pos.z >= BOX_WIDTH/2 ? -BOX_WIDTH/2 + 10 : pos.z;
  } //bound
  
  private void wallBounce() {
    vel.x = pos.x <= -BOX_WIDTH/2  || pos.x >= BOX_WIDTH/2 ? -vel.x : vel.x;
    vel.y = pos.y <= -BOX_WIDTH/2  || pos.y >= BOX_WIDTH/2 ? -vel.y : vel.y;
    vel.z = pos.z <= -BOX_WIDTH/2  || pos.z >= BOX_WIDTH/2 ? -vel.z : vel.z;
  } //bound
  
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
      steer.mult(1/PVector.dist(pos,wall));
      avo.add(steer);
    } //for
    
    avo.div(4);
    avo.limit(MAX_FORCE); 
    return avo;
  } //wallAvoid
   
} //Boid
