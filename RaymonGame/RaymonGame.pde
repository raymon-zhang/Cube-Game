import java.util.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.MouseInfo;
import java.awt.Point;
import processing.sound.*;
Robot mouseControl;
import java.io.*;
import java.lang.reflect.*;

PShader blockShader;

boolean running;



int WORLDSIZE = 19;
int WATERLEVEL = 96;


SoundFile loading;
SoundFile grass;
SoundFile stone;
SoundFile sand;
SoundFile water;
SoundFile diamond;
SoundFile hurt, die, mob_death;

World c;

PShape clouds;
PShape clouds2;
PImage cloud;

Player player;

Chunk playerChunk;

Point pMouse;
Point mouse;


boolean drawingUI;
boolean debug;
boolean drawingInventory;

PImage gui, indicator, inventoryImage, overlay, highlight, underwater, background;
PImage icons, healthBack, health1, health2, death, buttonTexture, cbuttonTexture, health3;
PImage testImage, panda, arrow;

boolean mouseclicked, bmouseclicked;


PMatrix originalMatrix;

JSONObject sounds;

public String loadStatus;

float f;

PFont myFont;


int total_frames;
int time1;

Entity test, test2;


public Hashtable<Integer, ItemType> ItemTypes=  new Hashtable<Integer, ItemType>();
public Hashtable<Integer, BlockType> BlockTypes=  new Hashtable<Integer, BlockType>();

void setup() {
  fullScreen(P3D);
  
  sounds = loadJSONObject("/sounds/sounds.json");

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
  testImage = loadImage("textures/entity/test.png");
  panda = loadImage("textures/entity/panda.png");
  arrow = loadImage("textures/entity/arrow.png");
  underwater = loadImage("textures/underwater.png");
  background = loadImage("textures/gui/background.png");
  icons = loadImage("textures/gui/icons.png");
  death = loadImage("textures/dead.png");
  healthBack = icons.get(0,0,9,9);
  health1 = icons.get(9,0,9,9);
  health2 = icons.get(9,0,5,9);
  health3 = icons.get(18, 0, 9, 9);
  buttonTexture = icons.get(0, 9, 200, 20);
  cbuttonTexture = icons.get(0, 29, 200, 20);
  total_frames = 0;

  running = true;
  clouds = createShape();
  clouds.beginShape();
  clouds.noStroke();
  clouds.tint(255, 100);
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
  



  try {
    mouseControl = new Robot();
  }
  catch(Exception e)
  {
    println(e);
  }

  
  //colorMode(RGB);
  
  loading = new SoundFile(this, "/sounds/Loading.mp3");
  hurt = new SoundFile(this, sounds.getString("player_hurt"));
  die = new SoundFile(this, sounds.getString("player_die"));
  mob_death = new SoundFile(this, sounds.getString("mob_death"));
  //loading.play();
  
  //grass = new SoundFile(this, "/sounds/grass.mp3");
  //stone = new SoundFile(this, "/sounds/stone.mp3");
  //sand = new SoundFile(this, "/sounds/sand.mp3");
  //water = new SoundFile(this, "/sounds/water.mp3");
  //diamond = new SoundFile(this, "/sounds/diamond.mp3");
  
  player = new Player(88, 50, 88);
  test = new Arrow(88, 50, 80, new PVector(1,0));
  test2 = new Panda(80, 50, 88);
  

  
  c = new World(WORLDSIZE);

  noStroke();
  noSmooth();
  hint(DISABLE_TEXTURE_MIPMAPS);

  lights();

  //frameRate(150);
  
  myFont = createFont("Minecraft.ttf", 200);
  textFont(myFont);
  textAlign(RIGHT);
  
  
  thread("checkChunks");
  thread("checkMouseClicked");
  //thread("checkPlayerChunk");  
  
  time1 = millis();
}


void draw() {
  try{
    total_frames += 1;
    background(130, 202, 255);
    //if (time1 == 0) time1 = millis();
  
    
    //shape(clouds, -3072, 0);
    //shape(clouds2);
  
    
    checkKeys();
    checkMouse();
    
    player.isUnderwater = false;
    player.isUnderlava = false;
    player.headUnderlava = false;
    perspective(radians(player.pov), (float)width/ (float)height, 0.01f, 1000);
    shape(clouds);
    shader(blockShader);
    
    
    updateEntities();
    test.update();
    c.drawWorld();
    
    resetShader();
    drawingUI = true;
    checkSpawnEntities();
   
    perspective(PI/3f, float(width)/float(height), 0.01f, 1000f);
    
    player.updateCamera();
    
    drawingUI = false;
    f = frameRate;
      
     
    
    pMouse.x = mouse.x;
    pMouse.y = mouse.y;
  }catch(Exception e){
    perspective(PI/3f, float(width)/float(height), 0.01f, 1000f);
    pushMatrix();
    hint(DISABLE_DEPTH_TEST);
    resetMatrix();
    applyMatrix(originalMatrix);
    tint(100);
    for(int x = 0; x<width; x+=128){
      for(int y = 0; y<height; y+=128){
        image(background, x, y, 128, 128);
      }
    }
    
    //fill(255, 0,0);
    textSize(50);
    textAlign(CENTER);
    text("There was an error.", width/2, height/2-50);
    text(e.toString(),width/2, height/2 + 50);
    noLoop();
  }
  bmouseclicked = false;
}

void loadThread(){
  
  
  
}
