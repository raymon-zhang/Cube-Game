import java.util.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.MouseInfo;
import java.awt.Point;
import processing.sound.*;
Robot mouseControl;

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
PImage gui, indicator;


PMatrix originalMatrix;



public String loadStatus;

float f;

PFont myFont;


void setup() {
  fullScreen(P3D);

  debug = false;
  
  ((PGraphicsOpenGL)g).textureSampling(3);

  originalMatrix = (PMatrix) getMatrix();

  cloud = loadImage("clouds.png");
  gui = loadImage("gui.png");
  indicator = loadImage("indicator.png");
  

  

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

  clouds2 = createShape();
  clouds2.beginShape();
  clouds2.noStroke();
  clouds2.tint(255, 128);
  clouds2.texture(cloud);
  clouds2.vertex(0, 0, -3072, 0, 0);
  clouds2.vertex(0, 0, 0, 0, 256);
  clouds2.vertex(3072, 0, 0, 256, 256);
  clouds2.vertex(3072, 0, -3072, 256, 0);
  clouds2.endShape(CLOSE);

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

  
  colorMode(RGB);
  
  loading = new SoundFile(this, "/sounds/Loading.mp3");
  loading.play();
  
  grass = new SoundFile(this, "/sounds/grass.mp3");
  stone = new SoundFile(this, "/sounds/stone.mp3");
  sand = new SoundFile(this, "/sounds/sand.mp3");
  water = new SoundFile(this, "/sounds/water.mp3");
  diamond = new SoundFile(this, "/sounds/diamond.mp3");

  
  player = new Player(80, 50, 80);

  
  c = new World(WORLDSIZE);

  noStroke();
  noSmooth();
  hint(DISABLE_TEXTURE_MIPMAPS);

  //lights();

  frameRate(80);
  
  myFont = createFont("Arial", 30);
  textFont(myFont);
  textAlign(LEFT);
  
  
  thread("checkChunks");
}


void draw() {

  background(130, 202, 255);

  //shape(clouds);
  //shape(clouds, -3072, 0);
  //shape(clouds2);


  checkKeys();
  checkMouse();
  c.drawWorld();

  player.updateCamera();

  if (frameCount %100 == 0)f = frameRate;
  pMouse.x = mouse.x;
  pMouse.y = mouse.y;
}



public void exit() {
  running = false;
  //println("hi");
  super.exit();
}

void mousePressed(){
  if (mouseButton == LEFT){
    breakBlock();
  }else if(mouseButton == RIGHT){
    placeBlock();
  }


}




public void checkChunks() {

  for (;; delay(100)) {
    WORLDSIZE = 19;

    ArrayList<Chunk> regenerate= new ArrayList<Chunk>();
    //println(regenerate);
    int px = floor( player.xPosition/16) ;
    int pz = floor( player.zPosition/16) ;


    ArrayList<Chunk> newVersion = new ArrayList<Chunk>(c.chunkMemory);

    for (Chunk chunk : newVersion) {
      if (abs(chunk.lowestXPos/16 - px) + abs(chunk.lowestZPos/16 - pz) > (WORLDSIZE-1)/2) {
        c.chunkMemory.remove(chunk);
        //chunk  = null;
      }
    }
    if ((player.xPos >= 0.0001) || (player.zPos >= 0.0001)) {
      WORLDSIZE = 7;
    } else WORLDSIZE = 19;

    for (int s = 0; s<(WORLDSIZE+1)/2; s++) {
      for (int x = 0; x<s+1; x++) {
        int y = s-x;
        try {
          Chunk dummy = c.getChunkAt((px) + x, (pz)+y) ;
        }
        catch(ArrayIndexOutOfBoundsException e) {
          Chunk newChunk = new Chunk((px + x)*16, 0, (pz + y)*16, c);
          newChunk.decorate();

          regenerate.add(newChunk);
          c.chunkMemory.add(newChunk);
          //println(regenerate);


          try {
            Chunk chunk = c.getChunkAt(px+x, pz+y-1);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px+x, pz+y+1);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px+x+1, pz+y);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px+x-1, pz+y);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
        }
      }

      for (int x = 0; x<s+1; x++) {
        int y = s-x;
        try {
          Chunk dummy = c.getChunkAt((px) + y, (pz)-x) ;
        }
        catch(ArrayIndexOutOfBoundsException e) {
          Chunk newChunk = new Chunk((px + y)*16, 0, (pz -x)*16, c);
          newChunk.decorate();

          regenerate.add(newChunk);

          c.chunkMemory.add(newChunk);
          //println(regenerate);


          try {
            Chunk chunk = c.getChunkAt(px+y, pz-x-1);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px+y, pz-x+1);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px+y+1, pz-x);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px+y-1, pz-x);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
        }
      }

      for (int x = 0; x<s+1; x++) {
        int y = s-x;

        try {
          Chunk dummy = c.getChunkAt((px) -x, (pz)-y) ;
        }
        catch(ArrayIndexOutOfBoundsException e) {
          Chunk newChunk = new Chunk((px -x)*16, 0, (pz -y)*16, c);
          newChunk.decorate();

          regenerate.add(newChunk);
          c.chunkMemory.add(newChunk);
          //println(regenerate);


          try {
            Chunk chunk = c.getChunkAt(px-x, pz-y-1);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px-x, pz-y+1);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px-x+1, pz-y);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px-x-1, pz-y);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
        }
      }

      for (int x = 0; x<s+1; x++) {
        int y = s-x;
        try {
          Chunk dummy = c.getChunkAt((px) -y, (pz)+x) ;
        }
        catch(ArrayIndexOutOfBoundsException e) {
          Chunk newChunk = new Chunk((px -y)*16, 0, (pz +x)*16, c);
          newChunk.decorate();

          regenerate.add(newChunk);
          c.chunkMemory.add(newChunk);

          //println(regenerate);


          try {
            Chunk chunk = c.getChunkAt(px-y, pz+x-1);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px-y, pz+x+1);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px-y+1, pz+x);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
          try {
            Chunk chunk = c.getChunkAt(px-y-1, pz+x);
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          catch(ArrayIndexOutOfBoundsException exception) {
            //chunk not there
          }
        }
      }
    }

    for (Chunk getRegenerated : regenerate) {
      getRegenerated.betterGenerateMesh();
      //println(getRegenerated);
    }
    //println("-----------");
  }
}
