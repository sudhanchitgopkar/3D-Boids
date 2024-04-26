static class Quat {
  public double w, x, y, z;
  
  public Quat() {
    w = 1;
    x = 0;
    y = 0;
    z = 0;
  } //Quat()
  
  public Quat(double w, double x, double y, double z) {
    this.w = w;
    this.x = x;
    this.y = y;
    this.z = z;
  } //Quat(double, double, double, double)

  public Quat(double w, PVector v) {
    this.w = w;
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
  } //Quat(double, Pvector)

  public static Quat multiply(Quat q1, Quat q2) {
    return new Quat(
      q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z,
      q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
      q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z,
      q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x
    );
  } //multiply
} //Quat
