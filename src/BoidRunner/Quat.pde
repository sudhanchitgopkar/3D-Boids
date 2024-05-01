static class Quat {
  public float w, x, y, z;
  
  /* ============= CONSTRUCTORS =============== */
  
  /**
    Constructs a quat with no specified arguments.
  */
  public Quat() {
    w = 1;
    x = 0;
    y = 0;
    z = 0;
  } //Quat()
  
  /**
    Constructs a quat with given floats.
    @param w cos(THETA/2)
    @param x sin(THETA/2)*k.x
    @param y sin(THETA/2)*k.y
    @param z sin(THETA/2)*k.z
  */
  public Quat(float w, float x, float y, float z) {
    this.w = w;
    this.x = x;
    this.y = y;
    this.z = z;
  } //Quat(float, float, float, float)
  
  /**
    Constructs a quat with given float and vector.
    @param w cos(THETA/2)
    @param v sin(THETA/2)*k 
  */
  public Quat(float w, PVector v) {
    this.w = w;
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
    this.normalize();
  } //Quat(float, Pvector)
  /* ============= END CONSTRUCTORS =============== */

  /* ============= INSTANCE METHODS =============== */
  
  /**
    Sets this to passed quat.
    @param q the quat to copy in.
  */
  public void set(Quat q) {
    w = q.w;
    x = q.x;
    y = q.y;
    z = q.z;
  } //set(Quat)
  
  /**
    Sets this to new quat with specified arguments.
    @param w the w value of this quat
    @param v the v value of this quat
  */
  public void set(float w, PVector v) {
    this.w = w;
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
    this.normalize();
  } //set(float, PVector)
  
  /**
    Normalizes the current quat.
  */
  public void normalize() {
    float mag = (float) Math.sqrt(w * w + x * x + y * y + z * z);
    w /= mag;
    x /= mag;
    y /= mag;
    z /= mag;
  } //normalize
  
  /**
    Returns the axis of this quat.
    @return the axis of this quat
  */
  public PVector getAxis() {
    float beta = (float) Math.sqrt(1 - w * w);
    if (beta < 0.0001) {
      return new PVector(1, 0, 0);
    } else {
      return new PVector(x / beta, y / beta, z / beta);
    }
  } //getAxis
  
  /**
    Returns the angle of this quat.
    @return the angle of this quat
  */
  public float getAngle() {
    return (float) Math.acos(w) * 2;
  } //getAngle
  /* ============= END INSTANCE METHODS =============== */
} //Quat

/* ============= STATIC METHODS =============== */

/**
  Multiplies two quats together.
  @param q1 the multiplier
  @param q2 the multiplicand
  @param the product quat
*/
public static Quat mult(Quat q1, Quat q2) {
  return new Quat(
    q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z,
    q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
    q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z,
    q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x
  );
} //mult(Quat, Quat)

/**
  Multiplies a quat with a scalar.
  @param q1 the multiplier
  @param a the scalar
  @param the product quat
*/
public static Quat mult(Quat q, float a) {
  return new Quat(q.w * a, q.x * a, q.y * a, q.z * a);
} //mult(Quat, float)
/* ============= END STATIC METHODS =============== */
