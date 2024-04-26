class Boid {
  ArrayList<Boid> flock;
  PVector pos, vel, acc;
  float visibility;
  int BOX_WIDTH;
  float MAX_SPEED, MAX_FORCE;

  public Boid(int BOX_WIDTH, ArrayList<Boid> flock) {
    this.BOX_WIDTH = BOX_WIDTH;
    MAX_SPEED = 2;
    MAX_FORCE = .03;
    
    this.flock = flock;
    visibility = 75;
    
    pos = PVector.random3D().mult(BOX_WIDTH);
    vel = PVector.random3D();
    acc = PVector.random3D();
    bound();
    
  } //Boid
  
  public void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    stroke(map(pos.z, -BOX_WIDTH/2, BOX_WIDTH/2, 0, 255), 255, 255);
    sphere(4);
    popMatrix();
  } //display
  
  public void flock() {
    PVector sep = sep(), ali = ali(), coh = coh();
    
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
        
    vel.add(acc);
    vel.limit(MAX_SPEED);
    acc.mult(0);
    
    pos.add(vel);
    bound();
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
  
  private float getDist(Boid b) {
    return pos.dist(b.pos);
  } //getDist
  
  private void bound() {
    pos.x = pos.x <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 : pos.x >= BOX_WIDTH/2 ? -BOX_WIDTH/2 : pos.x;
    pos.y = pos.y <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 : pos.y >= BOX_WIDTH/2 ? -BOX_WIDTH/2 : pos.y;
    pos.z = pos.z <= -BOX_WIDTH/2 ?  BOX_WIDTH/2 : pos.z >= BOX_WIDTH/2 ? -BOX_WIDTH/2 : pos.z;
  } //bound
} //Boid
