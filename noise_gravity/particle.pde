class Particle {
  PVector position;
  PVector acceleration;
  PVector velocity;
  float mass = 5;
  float radius = 1.5;

  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
  }

  void applyForce(PVector force) {
    force.div(mass);
    acceleration.add(force);
  }

  void border() {
    //teleport borders
    if (position.x > width) {
      position.x = 0;
    } 
    if (position.x < 0) {
      position.x = width;
    } 
    if (position.y > height) {
      position.y = 0;
    }
    if (position.y < 0) {
      position.y = height;
    }

    //bouncy borders
    //if (position.x > width-mass) {
    //  velocity.x *= -1;
    //  position.x = width-mass;
    //} 
    //if (position.x < mass) {
    //  velocity.x *= -1;
    //  position.x = mass;
    //} 
    //if (position.y > height-mass) {
    //  velocity.y *= -1;
    //  position.y = height-mass;
    //}
    //if (position.y < mass) {
    //  velocity.y *= -1;
    //  position.y = mass;
    //}
  }

  void update() {
    velocity.add(acceleration);

    //the velocity must be constrained
    velocity.x = constrain(velocity.x, -2, 2);
    velocity.y = constrain(velocity.y, -2, 2);
    position.add(velocity);
    acceleration.mult(0);
    border();
  }

  void render() {
    fill(255, 255);
    noStroke();
    ellipse(position.x, position.y, radius*2, radius*2);
  }
}
