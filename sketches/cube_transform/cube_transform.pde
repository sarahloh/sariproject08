import codeanticode.syphon.*;
PGraphics canvas;
SyphonServer server;
float angle = 0.0;
float speed = 2.0;

void setup() {
  size(640, 360, P3D);
  noStroke();
  canvas = createGraphics(640, 360, P3D);
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
}

void draw() {
  canvas.beginDraw();
  canvas.background(0);
  canvas.translate(width / 2, height / 2);
  
  // Spotlight from the front
  canvas.spotLight(0, 184, 230, // Color
            0, 40, 200, // Position
            0, -0.5, -0.5, // Direction
            PI / 2, 2); // Angle, concentration

  angle = angle += 0.005 % TWO_PI;
  canvas.rotateY(angle * speed);
  canvas.box(150);
  
  canvas.endDraw();
  image(canvas, 0, 0);
  server.sendImage(canvas);
}

void keyPressed()
{
  if(key == '1') {
    // Rotate right
    speed = random(10);
  }
  if(key == '2') {
    // Rotate left
    speed = -random(10);
  }
}
