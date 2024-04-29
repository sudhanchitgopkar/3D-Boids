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
    fill(255, 0, 0);
    box(r);
    noFill();
    popMatrix();
  } //display
} //Obstacle
