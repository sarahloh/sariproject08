import codeanticode.syphon.*;

PGraphics canvas;
PGraphics canvasc;
SyphonServer server;
SyphonClient client;

public void setup() {
  size(1000, 800, P3D);
  
  canvas = createGraphics(1000, 800, P3D);
  
  println("Available Syphon servers:");
  println(SyphonClient.listServers());
    
  // Create syhpon client to receive frames 
  // from running server with given name: 
//  client = new SyphonClient(this, "PUT APP NAME HERE");
    client = new SyphonClient(this, "GrandVJ");

  
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "mySyphonServer");
}

public void draw() {    
  canvas.beginDraw();
  canvas.background(0);
  // Receive frames from app
  if (client.available()) {
    canvasc = client.getGraphics(canvasc);
    canvas.image(canvasc, 0, 0);
  }  
  canvas.ellipse(900, 100, 50, 50);
  canvas.endDraw();
  image(canvas, 0, 0);
  server.sendImage(canvas);
}


