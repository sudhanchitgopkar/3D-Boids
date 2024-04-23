class Boid {
  ArrayList<Boid> flock;
  PVector pos, vel, acc;
  int BOX_WIDTH;
  float visibility;
    
  public Boid(int BOX_WIDTH, ArrayList<Boid> flock) {
    this.BOX_WIDTH = BOX_WIDTH;
    this.flock = flock;
    visibility = 50f;
    
    pos = PVector.random3D().mult(BOX_WIDTH);
    vel = PVector.random3D();
    acc = PVector.random3D();
    bound();
    
  } //Boid
  
  public void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    stroke(map(pos.dist(new PVector(0,0,0)), 0, BOX_WIDTH/2, 0, 255), 255, 255);
    sphere(2);
    popMatrix();
  } //display
  
  public void flock() {
    PVector sep = sep(), ali = ali(), coh = coh();
    
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
        
    acc.limit(4);
    vel.add(acc);
    vel.limit(4);
    
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
    return sep.normalize();
  } //sep
  
  private PVector ali() {
    PVector ali = new PVector(0, 0, 0);
    for (Boid b : flock) {
      if (isVis(b)) {
        ali.add(b.vel);  
      } //if
    } //for
    return ali.normalize();
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
    if (numVis > 0) coh.div(numVis);
    return PVector.sub(coh, this.pos).normalize();
  } //coh
  
  private boolean isVis(Boid b) {
    float dist = pos.dist(b.pos);
    return  dist <= visibility && dist > 0;
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
