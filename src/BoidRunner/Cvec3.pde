public class Cvec3 {
  public double x, y, z;

  public Cvec3(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

}

public static double dot(Cvec3 a, Cvec3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
  } //dot

  public static Cvec3 cross(Cvec3 a, Cvec3 b) {
    return new Cvec3(
      a.y * b.z - a.z * b.y,
      a.z * b.x - a.x * b.z,
      a.x * b.y - a.y * b.x
    );
  } //cross

  public static Cvec3 add(Cvec3 a, Cvec3 b) {
    return new Cvec3(a.x + b.x, a.y + b.y, a.z + b.z);
  } //add

  public static Cvec3 sub(Cvec3 a, Cvec3 b) {
    return new Cvec3(a.x - b.x, a.y - b.y, a.z - b.z);
  } //sub

  public static Cvec3 multiply(Cvec3 a, double b) {
    return new Cvec3(a.x * b, a.y * b, a.z * b);
  } //multiply