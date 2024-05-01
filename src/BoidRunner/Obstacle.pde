public class Obstacle {
  PVector pos;
  float r;
  
  /* ============= CONSTRUCTORS =============== */
  
  /**
    Creates a new obstacle at a given position 
    with a given size.
    @param pos the position of the new obstacle
    @param r the radius of the new obstacle
  */
  public Obstacle(PVector pos, float r) {
    this.pos = pos;
    this.r = r;
  } //Constructor
  /* ============= END CONSTRUCTORS =============== */
  
  /* ============= INSTANCE METHODS =============== */
  
  /**
    Displays this obstacle to the screen.
  */
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
  /* ============= END INSTANCE METHODS =============== */
} //Obstacle
