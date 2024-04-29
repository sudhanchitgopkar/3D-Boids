class Boid {
  ArrayList<Boid> flock;
  PVector pos, vel, acc;
  float visibility;
  int BOX_WIDTH;
  float MAX_SPEED, MAX_FORCE;
  float SEP_WEIGHT, ALI_WEIGHT, COH_WEIGHT;
  float r;

  public Boid(int BOX_WIDTH, ArrayList<Boid> flock) {
    this.flock = flock;
    
    pos = PVector.random3D().mult(5);
    vel = PVector.random3D();
    acc = PVector.random3D();
    visibility = 85;
    
    this.BOX_WIDTH = BOX_WIDTH;
    MAX_SPEED = 3;
    MAX_FORCE = .02;
    SEP_WEIGHT = 1.8;
    ALI_WEIGHT = 2.0;
    COH_WEIGHT = 1.8;
    
    r = 5;
    wallBounce();
  } //Boid
  
  public void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(vel.x);
    rotateY(vel.y);
    box(5);    
    popMatrix();
  } //display
  
  public void flock() {
    PVector sep = sep(), ali = ali(), coh = coh();
    
    sep.mult(SEP_WEIGHT);
    ali.mult(ALI_WEIGHT);
    coh.mult(COH_WEIGHT);
    
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
     
    vel.add(acc);
    vel.limit(MAX_SPEED);
    acc.mult(0);
    
    pos.add(vel);
    wallBounce();
  } //flock
  
  private PVector sep() {
    PVector sep = new PVector(0, 0, 0);
    int numVis = 0;
    for (Boid b : flock) {
        if (isVis(b)) {
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
  
  private boolean isVis(Boid b) {
    float dist = pos.dist(b.pos);
    return dist <= visibility && dist > 0;
  } //isVis
  
  private boolean isVis(PVector p) {
    float dist = pos.dist(p);
    return dist <= 8 * visibility && dist > 0;
  } //isVis
  
  private float getDist(Boid b) {
    return pos.dist(b.pos);
  } //getDist
  
  private float getDist(PVector p) {
    return pos.dist(p);
  } //getDist
  
  private void bound() {
    pos.x = pos.x <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 : pos.x >= BOX_WIDTH/2 ? -BOX_WIDTH/2 : pos.x;
    pos.y = pos.y <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 : pos.y >= BOX_WIDTH/2 ? -BOX_WIDTH/2 : pos.y;
    pos.z = pos.z <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 : pos.z >= BOX_WIDTH/2 ? -BOX_WIDTH/2 : pos.z;
  } //bound
  
  private void wallBounce() {
    vel.x = pos.x <= -BOX_WIDTH/2  || pos.x >= BOX_WIDTH/2 ? -vel.x : vel.x;
    vel.y = pos.y <= -BOX_WIDTH/2  || pos.y >= BOX_WIDTH/2 ? -vel.y : vel.y;
    vel.z = pos.z <= -BOX_WIDTH/2  || pos.z >= BOX_WIDTH/2 ? -vel.z : vel.z;
  } //bound
   
} //Boid
