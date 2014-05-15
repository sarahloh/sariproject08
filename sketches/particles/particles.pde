//http://processing.org/examples/simpleparticlesystem.html

//Simple Particle System by Daniel Shiffman. 
//Particles are generated each cycle through draw(), fall with gravity and fade out over time A ParticleSystem object manages a variable size (ArrayList) list of particles.

import codeanticode.syphon.*;
PGraphics canvas;
SyphonServer server;
float vel1 = 1;
float vel2 = 0;

ParticleSystem ps;

void setup() {
  size(640,360,P3D);
  canvas = createGraphics(640, 360, P3D);
  ps = new ParticleSystem(new PVector(width/2,50));
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
}

void draw() {
  canvas.beginDraw();
  canvas.background(0);
  ps.addParticle();
  ps.run();
  canvas.endDraw();
  image(canvas, 0, 0);
  server.sendImage(canvas);
}

// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  int[] colours = {#FF0000, #33CC33, #00CCFF, #FFFF00, #FF9900, #CC66FF, #3333CC};

  Particle(PVector l) {
    acceleration = new PVector(0,0.05);
    velocity = new PVector(vel1,vel2);
    location = l.get();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    int i = (int)random(7);
    canvas.stroke(colours[i],lifespan);
    canvas.fill(colours[i],lifespan);
    canvas.ellipse(location.x,location.y,random(40),random(40));

  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    System.out.println(origin);
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    // Replace origin with random location
    origin = new PVector(random(width),random(height)).get();
    particles.add(new Particle(origin));
  }

  void run() {
    Particle p;
    for (int i = particles.size()-1; i >= 0; i--) {
      p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

void keyPressed()
{
  if(key == '1') {
    // Alter particle x velocity
    vel1 = random(-5,5);
  }
  if(key == '2') {
    // Alter perticle y velocity
    vel2 = random(-10,0);
  }
}
