class Arcball {
  PVector center;
  float radius;

  Quat quat;
  Quat changeQuat;

  /* ============= CONSTRUCTORS ============== */
  
  /**
    Constructs a new Arcball with defaults.
  */
  public Arcball() {
    center = new PVector(0, 0, 0);
    radius = 1;
    quat = new Quat();
  } //Arcball()
  
  /**
    Constructs a new Arcball with specified location and size.
    @param center the center of the arcball
    @param radius the radius of the arcball
  */
  public Arcball(PVector center, float radius) {
    this.center = center;
    this.radius = radius;
    quat = new Quat();
  } //Arcball(PVector, float)
  /* ============= END CONSTRUCTORS ============== */


  /* ============= INSTANCE METHODS ============== */
  
  /**
    Returns the arcball's quaternion.
    @return the arcball's quaternion
  */
  public Quat getQuat() {
    return quat;
  } //getQuat()
  
  /**
    Returns a vector from the center of the arcball to mouse click location.
    @param mouse the click location
    @return a vector from the center of the arcball to mouse click location
  */
  private PVector getBallQuat(PVector mouse) {
    PVector v = new PVector();
    v.x = mouse.x - center.x;
    v.y = mouse.y - center.y;

    float mag = v.x * v.x + v.y * v.y;
    v.z = (float) ((mag > radius * radius) ? 0 : Math.sqrt(radius * radius - mag));
    v.normalize();
    return v;
  } //getBallQuat
  
  /**
    Calculates the change in rotation of the arcball.
  */
  public void update() {
    PVector start = getBallQuat(new PVector(pmouseX, pmouseY));
    PVector end = getBallQuat(new PVector(mouseX, mouseY));
    quat = mult(new Quat(0, end), mult(new Quat(0, start), -1));
  } //update
   /* ============= END INSTANCE METHODS ============== */
} //Arcball
