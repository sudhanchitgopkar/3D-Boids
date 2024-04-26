class Quat {
  public double w;
  public Cvec3 v;
  
  public Quat() {
    w = 1;
    v = new Cvec3(0, 0, 0);
  } //Quat()
  
  public Quat(double w, double x, double y, double z) {
    this.w = w;
    this.v = new Cvec3(v.x, v.y, v.z);
  } //Quat(double, double, double, double)

  public Quat(double w, Cvec3 v) {
    this.w = w;
    this.v = v;
  }

public static Quat multiplyQuat(Quat q1, Quat q2) {
    return new Quat(
      q1.w * q2.w - dot(q1.v, q2.v),
      add(add(multiply(q1.v, q2.w), multiply(q2.v, q1.w)), cross(q1.v, q2.v))
    );
  } //multiply
} //Quat
