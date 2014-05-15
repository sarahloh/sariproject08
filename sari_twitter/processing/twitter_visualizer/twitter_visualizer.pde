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

PGraphics canvas;
SyphonServer server;
ArrayList<String> tweets;
ArrayList<String> photos;
ArrayList<String> views;
PFont f; // Global font variable
float x; // Horizontal location
int index = 0;
PImage img;

private WebSocketClient cc;
void setup(){
  
  size(500,400, P3D);
  canvas = createGraphics(500, 400, P3D);
  f = createFont( "Arial" ,16,true);
  x = width;
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
  initialiseArrays();

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
 
    }
  };
  cc.connect();
  } 
  catch(Exception e){
    print(e);
  }
}

void draw() {
  canvas.beginDraw();
  canvas.background(0);
  canvas.fill(110, 220, 240);
  canvas.textFont(f,16);
  canvas.textAlign (LEFT);
  // A specific String from the array is displayed according to the value of the "index" variable.
  canvas.text(tweets.get(index),x,55); 
  canvas.image(img, 0, 150);
  // Change the subtracted value to alter the speed of the scroll
  x = x - 1;
  // If x is less than the negative width, then it is off the screen
  // textWidth() is used to calculate the width of the current String.
  float w = textWidth(tweets.get(index)); 
  if (x < -w) {
    x = width;
    // index is incremented when the current String has left the screen in order to display a new String.
    index = (index + 1) % tweets.size(); 
    img = loadImage(photos.get(index));
    img.resize(256, 256);
  }
  
  canvas.endDraw();
  image(canvas, 0, 0);
  server.sendImage(canvas);
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
