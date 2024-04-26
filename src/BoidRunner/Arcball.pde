class Arcball {
  PVector center;
  float radius;

  Quat quat;
  Quat changeQuat;

  // ============= Constructors ==============
  public Arcball() {
    center = new PVector(0, 0, 0);
    radius = 1;
    quat = new Quat();
  } //Arcball()

  public Arcball(PVector center, float radius) {
    this.center = center;
    this.radius = radius;
    quat = new Quat();
  } //Arcball(PVector, float)

  // ============== Instance Methods =============
  public Quat getQuat() {
    return quat;
  } //getQuat()

  private PVector getBallQuat(PVector mouse) {
    PVector v = new PVector();
    v.x = mouse.x - center.x;
    v.y = mouse.y - center.y;

    float mag = v.x * v.x + v.y * v.y;
    v.z = (float) ((mag > radius * radius) ? 0 : Math.sqrt(radius * radius - mag));
    v.normalize();
    return v;
  } //getBallQuat
  
  public void update() {
    PVector start = getBallQuat(new PVector(pmouseX, pmouseY));
    PVector end = getBallQuat(new PVector(mouseX, mouseY));
    quat = mult(new Quat(0, end), mult(new Quat(0, start), -1));
  } //update
} //Arcball