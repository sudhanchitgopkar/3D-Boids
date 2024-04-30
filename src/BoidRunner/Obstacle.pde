public class Obstacle {
  PVector pos;
  float r;
  
  public Obstacle(PVector pos, float r) {
    this.pos = pos;
    this.r = r;
  } //Constructor
  
  public void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    fill(255,0,0);
    sphereDetail(4);
    sphere(r/2);
    stroke(255);
    noFill();
    popMatrix();
  } //display
} //Obstacle
