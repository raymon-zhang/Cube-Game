import java.util.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.MouseInfo;
import java.awt.Point;
import processing.sound.*;
Robot mouseControl;
import java.io.*;
import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;

PShader blockShader;

boolean running;

int cols, rows;
int scl = 1;
int w = 16;
int h = 16;

int WORLDSIZE = 19;
int WATERLEVEL = 100;


SoundFile loading;
SoundFile grass;
SoundFile stone;
SoundFile sand;
SoundFile water;
SoundFile diamond;

World c;

PShape clouds;
PShape clouds2;
PImage cloud;

Player player;


Point pMouse;
Point mouse;


boolean drawingUI;
boolean debug;
boolean drawingInventory;

PImage gui, indicator, inventoryImage, overlay, highlight;

boolean mouseclicked;


PMatrix originalMatrix;



public String loadStatus;

float f;

PFont myFont;


int total_frames;
int time1;

void setup() {
  fullScreen(P3D);
    

  debug = false;
  drawingInventory = false;
  
  ((PGraphicsOpenGL)g).textureSampling(2);

  originalMatrix = (PMatrix) getMatrix();
  
  blockShader = loadShader("/shaders/Frag.glsl", "/shaders/Vert.glsl");


  //filter(POSTERIZE, 200);

  cloud = loadImage("/textures/clouds.png");
  gui = loadImage("/textures/gui/gui.png");
  indicator = loadImage("/textures/gui/indicator.png");
  inventoryImage = loadImage("textures/gui/inventory.png");
  overlay = loadImage("textures/gui/overlay.png");
  highlight = loadImage("textures/gui/highlight.png");
  

  total_frames = 0;

  running = true;
  clouds = createShape();
  clouds.beginShape();
  clouds.noStroke();
  clouds.tint(255, 128);
  clouds.texture(cloud);
  clouds.vertex(0, 0, 0, 0, 0);
  clouds.vertex(0, 0, 3072, 0, 256);
  clouds.vertex(3072, 0, 3072, 256, 256);
  clouds.vertex(3072, 0, 0, 256, 0);
  clouds.endShape(CLOSE);

  //clouds2 = createShape();
  //clouds2.beginShape();
  //clouds2.noStroke();
  //clouds2.tint(255, 128);
  //clouds2.texture(cloud);
  //clouds2.vertex(0, 0, -3072, 0, 0);
  //clouds2.vertex(0, 0, 0, 0, 256);
  //clouds2.vertex(3072, 0, 0, 256, 256);
  //clouds2.vertex(3072, 0, -3072, 256, 0);
  //clouds2.endShape(CLOSE);

  noCursor();
  
  cols = w/scl;
  rows = h/scl;

  try {
    mouseControl = new Robot();
  }
  catch(Exception e)
  {
    println(e);
  }

  
  //colorMode(RGB);
  
  loading = new SoundFile(this, "/sounds/Loading.mp3");
  //loading.play();
  
  //grass = new SoundFile(this, "/sounds/grass.mp3");
  //stone = new SoundFile(this, "/sounds/stone.mp3");
  //sand = new SoundFile(this, "/sounds/sand.mp3");
  //water = new SoundFile(this, "/sounds/water.mp3");
  //diamond = new SoundFile(this, "/sounds/diamond.mp3");

  player = new Player(80, 50, 80);
  

  
  c = new World(WORLDSIZE);

  noStroke();
  noSmooth();
  hint(DISABLE_TEXTURE_MIPMAPS);

  //lights();

  frameRate(150);
  
  myFont = createFont("Arial", 30);
  textFont(myFont);
  textAlign(LEFT);
  
  
  thread("checkChunks");
  thread("checkMouseClicked");
  
  time1 = millis();
}


void draw() {
  
  total_frames += 1;
  background(130, 202, 255);
  
  //if (time1 == 0) time1 = millis();

  //shape(clouds);
  //shape(clouds, -3072, 0);
  //shape(clouds2);

  
  checkKeys();
  checkMouse();
  

  shader(blockShader);
  perspective(radians(70), (float)width/ (float)height, 0.01f, 1000);
  c.drawWorld();
  resetShader();
  perspective(PI/3f, float(width)/float(height), 0.01f, 1000f);
  player.updateCamera();
  
  f = frameRate;
    
   
  
  pMouse.x = mouse.x;
  pMouse.y = mouse.y;
  
}



public void exit() {
  int x = millis()-time1;
  println("Total Frames: " + total_frames);
  println("Total Seconds: " + x/1000);
  println( total_frames /( x/1000));
  running = false;
  //println("hi");
  super.exit();
  
}
