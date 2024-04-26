static class Quat {
  public float w, x, y, z;
  
  // ============= Constructors ===============
  public Quat() {
    w = 1;
    x = 0;
    y = 0;
    z = 0;
  } //Quat()

  public Quat(float w, float x, float y, float z) {
    this.w = w;
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public Quat(float w, PVector v) {
    this.w = w;
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
    this.normalize();
  } //Quat(float, Pvector)

  // ============= Instance Methods ===============
  public void set(Quat q) {
    w = q.w;
    x = q.x;
    y = q.y;
    z = q.z;
  } //set(Quat)

  public void set(float w, PVector v) {
    this.w = w;
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
    this.normalize();
  } //set(float, PVector)

  public void normalize() {
    float mag = (float) Math.sqrt(w * w + x * x + y * y + z * z);
    w /= mag;
    x /= mag;
    y /= mag;
    z /= mag;
  } //normalize

  public PVector getAxis() {
    float beta = (float) Math.sqrt(1 - w * w);
    if (beta < 0.0001) {
      return new PVector(1, 0, 0);
    } else {
      return new PVector(x / beta, y / beta, z / beta);
    }
  }

  public float getAngle() {
    return (float) Math.acos(w) * 2;
  }

} //Quat

// ============= Static Methods ===============
public static Quat mult(Quat q1, Quat q2) {
  return new Quat(
    q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z,
    q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
    q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z,
    q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x
  );
} //mult(Quat, Quat)

public static Quat mult(Quat q, float a) {
  return new Quat(q.w * a, q.x * a, q.y * a, q.z * a);
} //mult(Quat, float)