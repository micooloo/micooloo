//This is my personal take on a coding challenge by the Coding Train of Daniel Shiffman
//All credits to Michele Daffara. Feel free to contact me at micheledaffara@gmail.com for more details about the code

float amplitude = TWO_PI;
float noiseChange = 0.1;
float offsetX = 0;
float offsetY = 0;
float offsetZ = 0;
float fieldDetail = 20;
float[][] forceField;
ArrayList<Particle> particles;

void setup() {
  size(displayWidth, displayHeight);
  colorMode(RGB, 255, 255, 255);
  background(51);

  forceField = new float[int(width/fieldDetail)+1][int(height/fieldDetail)+1];
  particles = new ArrayList<Particle>();

  //create particles
  for (int i = 0; i < 750; i++) 
    particles.add(new Particle(random(width), random(height)));
}

//find color in rgb
color HSBtoRGB(color startingColor) {
  double RED = 255;
  double GREEN = 255;
  double BLUE = 255;
  float HUE = (startingColor >> 16) & 0xFF;
  float SATURATION = 1;
  float VALUE = 1;

  //first step
  double C = VALUE * SATURATION;
  double X = C * (1 - abs((HUE / 60)%2 - 1));
  double m = VALUE - C;

  //second step
  if (HUE >= 0 && HUE < 60) {
    RED = C;
    GREEN = X;
    BLUE = 0;
  } else if (HUE >= 60 && HUE < 120) {
    RED = X;
    GREEN = C;
    BLUE = 0;
  } else if (HUE >= 120 && HUE < 180) {
    RED = 0;
    GREEN = C;
    BLUE = X;
  } else if (HUE >= 180 && HUE < 240) {
    RED = 0;
    GREEN = X;
    BLUE = C;
  } else if (HUE >= 240 && HUE < 300) {
    RED = X;
    GREEN = 0;
    BLUE = C;
  } else if (HUE >= 300 && HUE < 360) {
    RED = C;
    GREEN = 0;
    BLUE = X;
  }

  //third step
  RED += m;
  GREEN += m;
  BLUE += m;

  //fourth step
  RED *= 255;
  GREEN *= 255;
  BLUE *= 255;

  return color((int)RED, (int)GREEN, (int)BLUE);
}

//find force to apply to the particle
PVector nearest(PVector pos) {
  PVector nearestForce = new PVector();
  float minimumDistance = width*height;
  for (int x = 0; x < forceField.length; x++) {
    for (int y = 0; y < forceField[0].length; y++) {
      float distance = dist(pos.x, pos.y, x*fieldDetail, y*fieldDetail);
      if (distance < minimumDistance) {
        nearestForce.x = x;
        nearestForce.y = y;
        minimumDistance = distance;
      }
    }
  }
  return nearestForce;
}

void draw() {
  background(51);

  //compute noise and store in field matrix
  offsetX = 0;
  for (int x = 0; x < (int)(width/fieldDetail)+1; x++) {
    offsetX += noiseChange;
    offsetY = 0;
    for (int y = 0; y < (int)(height/fieldDetail)+1; y++) {
      //the angle is based on 3D perlin noise
      offsetY += noiseChange;
      float theta = amplitude * noise(offsetX, offsetY, offsetZ);
      forceField[x][y] = theta;
      PVector resultant = new PVector(sin(theta), cos(theta));

      //compute color based on the angle
      color startingHSB = color(map(theta, 0, TWO_PI, 0, 360), 1, 1);
      color finalRGB = HSBtoRGB(startingHSB);
      float red = (finalRGB >> 16) & 0xFF;
      float green = (finalRGB >> 8) & 0xFF;
      float blue = finalRGB & 0xFF;
      float alpha = 100;

      //draw the single forces
      push();
      float scale = .75;
      translate(x*fieldDetail, y*fieldDetail);
      stroke(color(red, green, blue, alpha));
      strokeWeight(2);
      line(0, 0, resultant.x*fieldDetail*scale, resultant.y*fieldDetail*scale);
      noStroke();
      fill(color(red, green, blue, alpha));
      circle(0, 0, 4);
      pop();
    }
  }
  offsetZ += noiseChange*.05;

  //compute particles behaviour
  for (Particle p : particles) {
    PVector nearest = nearest(p.position);
    float angle = forceField[(int)nearest.x][(int)nearest.y];
    PVector particleForce = new PVector(10*sin(angle), cos(angle));
    
    //how much should the force effect the particle?
    particleForce.setMag(1);
    p.applyForce(particleForce);
    p.update();
    p.render();
  }
}
