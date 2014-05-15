//http://www.processing.org/tutorials/text/

import codeanticode.syphon.*;
PGraphics canvas;
SyphonServer server;

PFont f1;
PFont f2;
PFont f3;
String message = "press any key to shake it up - press any key to shake it up - press any key to shake it up - press any key to shake it up - press any key to shake it up - press any key to shake it up ";
//String message = "press any key to shake it up";
float x; // Horizontal location
// An array of Letter objects
Letter[] letters;
int[] colours = {#2EB8E6, #33CCFF, #29A3CC, #248FB2, #47D1FF};
PFont[] fonts = {f1, f2, f3};


void setup() {
  size(400, 200, P3D);
  canvas = createGraphics(400, 200, P3D);
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
  // Create the fonts
  fonts[0] = createFont("Ubuntu",20,true);
  fonts[1] = createFont("Ariel",20,true);
  fonts[2] = createFont("Franklin",20,true);
  
  textFont(fonts[0], 20);
  
  // Initialize letters offscreen
  x = width;
  
  // Create the array the same size as the String
  letters = new Letter[message.length()];

  for (int i = 0; i < message.length(); i++) {
    letters[i] = new Letter(x,100,message.charAt(i), random(20,30)); 
    x += textWidth(message.charAt(i)) + 3;
  }
}

void draw() { 
  canvas.beginDraw();
  canvas.background(0);
  for (int i = 0; i < letters.length; i++) {
    // Display all letters
    letters[i].display();
    // Move the letters so they scroll across the screen
    float oldX = letters[i].getX();
    // Increase the subtracted number to speed up scrolling
    float newX = (oldX - 2);
    letters[i].setX(newX);
    // If the mouse is pressed the letters shake
    // If not, they return to their original location
    if (keyPressed) {
      letters[i].shake();
    } 
    else {
      letters[i].home();
    }
  }
  canvas.endDraw();
  image(canvas, 0, 0);
  server.sendImage(canvas);
}

// A class to describe a single Letter
class Letter {
  char letter;
  // The default y position
  float homey;
  // Current location
  float x,y;
  float textSize;

  Letter (float x_, float y_, char letter_, float textSize_) {
    x = x_;
    homey = y = y_;
    letter = letter_; 
    textSize = textSize_;
  }

  // Display the letter
  void display() {
    int colour = colours[(int)random(5)];
    canvas.fill(colour);
    canvas.textFont(fonts[(int)random(3)], textSize);
    canvas.textAlign(LEFT);
    //put letter on screen
    canvas.text(letter,x,y);
  }
  
  float getX() {
   return this.x; 
  }

  void setX(float newX) {
   x = newX; 
  }

  // Move the letter randomly up and down
  void shake() {
    y += random(-2,2);
  }

  // Return the letter to its default y position
  void home() {
    y = homey; 
  }
}
