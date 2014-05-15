import org.json.*;
import org.java_websocket.handshake.*;
import org.java_websocket.server.*;
import org.java_websocket.exceptions.*;
import org.java_websocket.*;
import org.java_websocket.client.*;
import org.java_websocket.drafts.*;
import org.java_websocket.framing.*;
import org.java_websocket.util.*;
import java.net.URI;
import java.net.URISyntaxException;
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_10;
import org.java_websocket.framing.Framedata;
import org.java_websocket.handshake.ServerHandshake;
import codeanticode.syphon.*;
import processing.core.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

// syphon
PGraphics canvas;
SyphonServer server;
char currentKey;
// twitter
ArrayList<String> tweets;
ArrayList<String> photos;
ArrayList<String> views;
PFont f; // Global font variable
float x; // Horizontal location
int index = 0;
PImage img;
private WebSocketClient cc;
// particles
float ellipseW = 20;
float ellipseH = 20;
ParticleSystem ps;
// cube
float angle = 0.0;
float speed = 2.0;
// fft
Minim minim;
AudioInput in;
FFT fftLog;
int lastPosition;
int canvasW = 800;
int canvasH = 600;
int baseLine = 300;
int sampleCount = 0;
int sizew = 20;
int sizeh = 15;

void setup(){
  size(1200,800, P3D);
  canvas = createGraphics(1200, 800, P3D);
  f = createFont( "Franklin",20,true);
  x = width/2;
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
  initialiseArrays();
  currentKey = '2';

  // websockets
  try{
  // more about drafts here: http://github.com/TooTallNate/Java-WebSocket/wiki/Drafts
  cc = new WebSocketClient( new URI( "ws://localhost:4000" ), new Draft_10() ) {
    @Override
    public void onMessage( String message ) {
      try {
        org.json.JSONObject obj = new org.json.JSONObject(message);
        tweets.add(obj.getString("tweet"));
        photos.add(obj.getString("photo"));
        views.add("false");
      } catch (JSONException e) {
        e.printStackTrace();
      }
    }
    @Override
    public void onOpen( ServerHandshake handshake ) {
      System.out.println("connection opened ");
    }
    @Override
    public void onClose( int code, String reason, boolean remote ) {
       System.out.println("connection closed");
    }
    @Override
    public void onError( Exception ex ) {
      System.out.println(ex);
    }
  };
  cc.connect();
  } 
  catch(Exception e){
    print(e);
  }
  
  // particles
  ps = new ParticleSystem(new PVector(width/2,50));
  
  // fft
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  minim.debugOn();
  fftLog = new FFT(in.bufferSize(), in.sampleRate());
  fftLog.logAverages(22, 3);
  fftLog.window(FFT.HAMMING);
  colorMode(HSB, 100);
}

void draw() {
  canvas.beginDraw();
  canvas.background(0);
  displayTwitter();
  switch (currentKey) {
   case '1': displayParticles();
             break;
   case '2': displayCube();
             break;
   case '3': displayFFT();
             break;
  }
  canvas.endDraw();
  image(canvas, 0, 0);
  server.sendImage(canvas);
}

void displayTwitter() {
  canvas.noStroke();
  canvas.fill(110, 220, 240);
  canvas.textFont(f,20);
  canvas.textAlign (LEFT);
  // A specific String from the array is displayed according to the value of the "index" variable.
  canvas.text(tweets.get(index),x,55); 
  canvas.image(img, 900, 150);
  // Change the subtracted value to alter the speed of the scroll
  x = x - 1;
  // If x is less than the negative width, then it is off the screen
  // textWidth() is used to calculate the width of the current String.
  float w = textWidth(tweets.get(index)); 
  if (x < -w) {
    x = width/2;
    // index is incremented when the current String has left the screen in order to display a new String.
    index = (index + 1) % tweets.size(); 
    img = loadImage(photos.get(index));
    img.resize(256, 256);
  }
}

void displayParticles() {
  ps.addParticle();
  ps.run();
}

void displayCube() {
  canvas.translate(width / 2, height / 2);
  // Spotlight from the front
  canvas.spotLight(0, 184, 230, // Color
            0, 40, 200, // Position
            0, -0.5, -0.5, // Direction
            PI / 2, 2); // Angle, concentration
  angle = angle += 0.005 % TWO_PI;
  canvas.rotateY(angle * speed);
  canvas.box(150);
}

void displayFFT() {
  fftLog.forward(in.mix);
  canvas.ellipseMode(RIGHT);
  canvas.smooth();
  canvas.noStroke();
//  canvas.colorMode(HSB, 100);
  for (int i = 0; i < fftLog.avgSize(); i++) {         
    if (i < fftLog.avgSize() - 29) {
      canvas.fill(color(0, 0, 0, 20));
      canvas.rect(0, 0, canvasW, canvasH);
    }
    float amp = sqrt(sqrt(fftLog.getAvg(i)))*150;
    float h = i * 100/fftLog.avgSize();
    h -= 10;
    h = 100 - h;
    float s = 70;
    float b = amp/3 * 100;
    float a = 100;
    canvas.fill(color(h, s, b, a));
    float x = i*24 + 150;
    float y = canvasH - amp-50;
    canvas.ellipse(x, y, sizew, sizeh);
  }
}

void initialiseArrays() {
  tweets = new ArrayList<String>();
  photos = new ArrayList<String>();
  views = new ArrayList<String>();
  tweets.add("Tweet #sariwit and see it appear!");
  photos.add("https://pbs.twimg.com/profile_images/444135495300165632/Se-178BE.png");
  views.add("false");
  img = loadImage(photos.get(index));
  img.resize(256, 256);
}

/* 
A simple Particle class
*/
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  int[] colours = {#FF0000, #33CC33, #00CCFF, #FFFF00, #FF9900, #CC66FF, #3333CC};

  Particle(PVector l) {
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(-1,1),random(-2,0));
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
    canvas.ellipse(location.x,location.y,ellipseW,ellipseH);

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
/* ################################# */

/*
A class to describe a group of Particles.
An ArrayList is used to manage the list of Particles.
*/

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
    origin = new PVector(random(0,width-500),random(200,height)).get();
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
/* ################################# */

// fft
void stop()
{
  in.close();
  minim.stop();
  super.stop();
}

void keyPressed()
{
  if(key == '1' || key == '2' || key == '3') {
    currentKey = key;
  }
  if(key == '4') {
    // Alter particle width
    ellipseW = random(10,40);
    // Rotate cube right
    speed = -random(10);
  }
  if(key == '5') {
    // Alter particle height
    ellipseH = random(10,40);
    // Rotate cube left
    speed = -random(10);
  }
}

