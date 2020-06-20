import java.util.*;
import java.awt.AWTException;
import java.awt.Robot;
import processing.sound.*;
Robot mouseControl;

boolean running;

int cols, rows;
int scl = 1;
int w = 16;
int h = 16;

int WORLDSIZE = 10;

SoundFile loading;
SoundFile grass;
SoundFile stone;
SoundFile sand;
SoundFile water;
SoundFile diamond;

World c;

PShape clouds;

Player player;

int playerX, playerZ;
//PGraphics graphics;


public String loadStatus;
void setup() {
  fullScreen(P3D);

  
  loading = new SoundFile(this, "load.mp3");
  loading.play();
  //frameRate(100);

  hint(DISABLE_TEXTURE_MIPMAPS);

  //graphics = createGraphics(640, 360, P3D);

  running = true;

  
  
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

  grass = new SoundFile(this, "grass.mp3");
  stone = new SoundFile(this, "stone.mp3");
  sand = new SoundFile(this, "sand.mp3");
  water = new SoundFile(this, "water.mp3");
  diamond = new SoundFile(this, "diamond.mp3");
  
  player = new Player(80, 50, 80);
  
  c = new World(WORLDSIZE);

  noStroke();

  noSmooth();

  //lights();

  frameRate(80);
  
  thread("checkChunks");
}


void draw() {
  
  background(130, 202, 255);

  //println(second());

  //playerX = (int)player.xPosition/16;
  //playerZ = (int)player.zPosition/16;

  //border


  //input, camera
  //println(playerX);  
  

  
  //directionalLight(255, 255, 255, 1, 1, 0);
  
  player.updateCamera();
  checkKeys();
  checkMouse();
  c.drawWorld();
  
  
    
  
  
  
  //b.betterDrawChunk();

  
  
  
  if(frameCount %100 == 0)println("Framerate " + frameRate);
}

public void exit() {
  running = false;
  //println("hi");
  super.exit();
}

//void mousePressed(){
//  if (mouseButton == LEFT){
//    breakBlock();
    
//  }
//  else if (mouseButton == RIGHT){
//    placeBlock();
    
//  }
  
//}


public void checkChunks(){
  
  for(;; delay(100)){
    println("hi");
    int px = (int) player.xPosition/16;
    int pz = (int) player.zPosition/16;
    for(int x = 0;x<WORLDSIZE; x++){
      for(int y = 0; y<WORLDSIZE;y++){
        try{
          Chunk dummy = c.getChunkAt((px) + x, (pz)+y) ;
        }catch(ArrayIndexOutOfBoundsException e){
          Chunk newChunk = new Chunk((px + x)*16, 0, (pz + y)*16, c);
          newChunk.decorate();
          newChunk.betterGenerateMesh();
          
          c.chunkMemory.add(newChunk);
          try{
            c.getChunkAt(px+x,pz+y-1).betterGenerateMesh();
            
           
            
          }
          catch(ArrayIndexOutOfBoundsException f){
            //edge
          }
          try{
            c.getChunkAt(px+x+1,pz+y).betterGenerateMesh();
            
           
            
          }
          catch(ArrayIndexOutOfBoundsException f){
            //edge
          }
          try{
            c.getChunkAt(px+x-1,pz+y).betterGenerateMesh();
            
          }
          catch(ArrayIndexOutOfBoundsException f){
            //edge
          }
          try{
            c.getChunkAt(px+x,pz+y+1).betterGenerateMesh();
            
          }
          catch(ArrayIndexOutOfBoundsException f){
            //edge
          }
          
        }
       
      }
    }
    //for(Chunk chunk: c.chunkMemory){
    //  if (chunk.lowestXPos - player.xPosition < WORLDSIZE || chunk.lowestZPos - player.zPosition < WORLDSIZE){
    //    c.chunkMemory.remove(chunk);
    //  }
    //}
  }
  
}
