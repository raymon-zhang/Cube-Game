import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.awt.AWTException; 
import java.awt.Robot; 
import java.awt.MouseInfo; 
import java.awt.Point; 
import processing.sound.*; 
import java.io.*; 
import java.lang.reflect.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RaymonGame extends PApplet {







Robot mouseControl;




PShader blockShader;

boolean running;

float MONSTER_SPAWN_RATE = 0.5f;

int WORLDSIZE = 19;
int WATERLEVEL = 96;


SoundFile loading;
SoundFile grass;
SoundFile stone;
SoundFile sand;
SoundFile water;
SoundFile diamond;
SoundFile hurt, die, mob_death, bowSound, arrowSound;

World c;

PShape clouds;
PShape clouds2;
PImage cloud;

Player player;

Chunk playerChunk;

Point pMouse;
Point mouse;

String[] funny;

String toast;

boolean drawingUI;
boolean debug;
boolean drawingInventory;

PImage gui, indicator, inventoryImage, overlay, highlight, underwater, background, logo;
PImage icons, healthBack, health1, health2, death, buttonTexture, cbuttonTexture, health3, bk;
PImage testImage, panda, arrow, monster;

boolean mouseclicked, bmouseclicked;


PMatrix originalMatrix;

JSONObject sounds;

public String loadStatus;

float f;

PFont myFont;

PShape bowShape;
int total_frames;
int time1;

Entity test, test2;



public Hashtable<Integer, ItemType> ItemTypes=  new Hashtable<Integer, ItemType>();
public Hashtable<Integer, BlockType> BlockTypes=  new Hashtable<Integer, BlockType>();

public void setup() {
  
  
  

  bowShape = loadShape("/textures/bow_model2.obj");
  
  sounds = loadJSONObject("/sounds/sounds.json");

  debug = false;
  drawingInventory = false;
  
  ((PGraphicsOpenGL)g).textureSampling(2);

  originalMatrix = (PMatrix) getMatrix();
  
  blockShader = loadShader("/shaders/Frag.glsl", "/shaders/Vert.glsl");

  if(hour() >= 18){
    MONSTER_SPAWN_RATE = 1;
  }
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
  monster = loadImage("textures/entity/skeleton.png");
  underwater = loadImage("textures/underwater.png");
  background = loadImage("textures/gui/background.png");
  icons = loadImage("textures/gui/icons.png");
  death = loadImage("textures/dead.png");
  logo = loadImage("textures/logo.png");
  bk = loadImage("textures/bk.png");
  bk.resize(width, height);
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
  
  funny = loadStrings("/texts/funny.txt");
  int rand = (int)random(funny.length);
  toast = funny[rand];
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
  bowSound = new SoundFile(this, sounds.getString("bow_shot"));
  arrowSound = new SoundFile(this, sounds.getString("bow_hit"));
  //loading.play();
  
  //grass = new SoundFile(this, "/sounds/grass.mp3");
  //stone = new SoundFile(this, "/sounds/stone.mp3");
  //sand = new SoundFile(this, "/sounds/sand.mp3");
  //water = new SoundFile(this, "/sounds/water.mp3");
  //diamond = new SoundFile(this, "/sounds/diamond.mp3");
  player = new Player(88, 50, 88);

  noStroke();
  
  hint(DISABLE_TEXTURE_MIPMAPS);

  lights();

  //frameRate(150);
  
  myFont = createFont("Minecraft.ttf", 200);
  textFont(myFont);
  textAlign(RIGHT);
  
  entities.add(new Monster(80, 50, 80));
  //thread("checkPlayerChunk");  
  
  time1 = millis();
}


public void draw() {
  //try{
  //  background(130, 202, 255);
  //  //if (time1 == 0) time1 = millis();
  
    
  //  //shape(clouds, -3072, 0);
  //  //shape(clouds2);
  
    
  //  checkKeys();
  //  checkMouse();
    
  //  player.isUnderwater = false;
  //  player.isUnderlava = false;
  //  player.headUnderlava = false;
  //  perspective(radians(player.pov), (float)width/ (float)height, 0.01f, 1000);
  //  shape(clouds);
  //  shader(blockShader);
    
    
  //  updateEntities();
  //  test.update();
  //  c.drawWorld();
    
  //  resetShader();
  //  drawingUI = true;
  //  checkSpawnEntities();
   
  //  perspective(PI/3f, float(width)/float(height), 0.01f, 1000f);
    
  //  player.updateCamera();
    
  //  drawingUI = false;
  //  f = frameRate;
      
     
    
  //  pMouse.x = mouse.x;
  //  pMouse.y = mouse.y;
  //}catch(Exception e){
  //  perspective(PI/3f, float(width)/float(height), 0.01f, 1000f);
  //  pushMatrix();
  //  hint(DISABLE_DEPTH_TEST);
  //  resetMatrix();
  //  applyMatrix(originalMatrix);
  //  tint(100);
  //  for(int x = 0; x<width; x+=128){
  //    for(int y = 0; y<height; y+=128){
  //      image(background, x, y, 128, 128);
  //    }
  //  }
    
  //  //fill(255, 0,0);
  //  textSize(50);
  //  textAlign(CENTER);
  //  text("There was an error.", width/2, height/2-50);
  //  text(e.toString(),width/2, height/2 + 50);
  //  noLoop();
  //}
  //bmouseclicked = false;
  drawGameFrame();
}
public class Arrow extends Entity{
  
  PVector vel;
  Boolean onGround = false;
  float pVDeg;
  public Arrow(float xPos, float yPos, float zPos, PVector vel){
    super(xPos, yPos, zPos);
    bowSound.play();
    this.vel = vel.setMag(0.45f);
    
    this.hDeg = player.hDeg ;
    this.vDeg = 0;
    this.xPos = vel.x;
    this.zPos = vel.z;
    this.yPos = vel.y;
    
    this.shape = createShape();
    this.shape.beginShape(TRIANGLE);
    this.shape.noStroke();
    this.shape.noTint();
    this.shape.noFill();
    this.shape.texture(arrow);
    
    this.shape.vertex(2.5f/16.0f, 0, 0, 0, 0);
    this.shape.vertex(2.5f/16.0f, 0, 16/16.0f, 16, 0);
    this.shape.vertex(2.5f/16.0f, 5/16.0f, 16/16.0f, 16, 5);
    this.shape.vertex(2.5f/16.0f, 5/16.0f, 0, 0, 5);
    this.shape.vertex(2.5f/16.0f, 0, 0, 0, 0);
    this.shape.vertex(2.5f/16.0f, 5/16.0f, 16/16.0f, 16, 5);
    
    this.shape.vertex(0, 2.5f/16.0f, 0, 0, 0);
    this.shape.vertex(5/16.0f, 2.5f/16.0f, 0, 0, 5);
    this.shape.vertex(5/16.0f, 2.5f/16.0f, 16/16.0f, 16, 5);
    this.shape.vertex(0, 2.5f/16.0f, 16/16.0f, 16, 0);
    this.shape.vertex(0, 2.5f/16.0f, 0, 0, 0);
    this.shape.vertex(5/16.0f, 2.5f/16.0f, 16/16.0f, 16, 5);
    
    this.shape.vertex(0, 0, 1/16.0f, 0, 5);
    this.shape.vertex(5/16.0f, 0, 1/16.0f, 5, 5);
    this.shape.vertex(5/16.0f, 5/16.0f, 1/16.0f, 5, 10);
    this.shape.vertex(0, 5/16.0f, 1/16.0f, 0, 10);
    this.shape.vertex(0, 0, 1/16.0f, 0, 5);
    this.shape.vertex(5/16.0f, 5/16.0f, 1/16.0f, 5, 10);
    
    if(degrees(this.hDeg)%180 > 45 && degrees(this.hDeg)%180 <135){
      this.shape.translate(5.5f/16.0f, -1/16.0f, -5.5f/16.0f);
      this.hitboxWidth = 1;
      this.hitboxHeight = 3/16.0f;
      this.hitboxLength = 1/16.0f;
      
    }else{
      this.hitboxWidth = 1/16.0f;
      this.hitboxHeight = 3/16.0f;
      this.hitboxLength = 16/16.0f;
      this.shape.translate(-2/16.0f, -1/16.0f, 0);
    }
    
    
    
    

    this.shape.endShape();
  }
  
  public void update(){
    if (! debug){
      if(! this.onGround){
        
        this.yPosition += this.yPos;
        
        this.xPosition += this.xPos;
      
        this.zPosition += this.zPos;
        float d = new PVector(this.xPos, this.zPos).mag();
        this.vDeg = atan(this.yPos/d);
        this.checkCollisions(new PVector(this.xPos, this.yPos, this.zPos));
        Entity tentity = getEntityAt(new PVector(this.xPosition, this.yPosition, this.zPosition));
        if(tentity != null)tentity.die();
        
        this.yPos += gravity*(1f/260);
      }
      if(! this.onGround){
        
        this.yPosition += this.yPos;
        
        this.xPosition += this.xPos;
      
        this.zPosition += this.zPos;
        float d = new PVector(this.xPos, this.zPos).mag();
        this.vDeg = atan(this.yPos/d);
        this.checkCollisions(new PVector(this.xPos, this.yPos, this.zPos));
        Entity tentity = getEntityAt(new PVector(this.xPosition, this.yPosition, this.zPosition));
        if(tentity != null)tentity.die();
        
        this.yPos += gravity*(1f/260);
      }
      this.drawShape();
      
      
    }
    
  }
  
  public void checkCollisions(PVector vel){
    //beginShape();
    //stroke(255);
    float xPosition = this.xPosition;
    float yPosition = this.yPosition;
    float zPosition = this.zPosition;
    for(int x = floor(this.xPosition - this.hitboxWidth/2); x < xPosition + this.hitboxWidth/2; x++){
      //println(x);
      for(int y = floor(this.yPosition); y < yPosition +this.hitboxHeight; y++){
        for(int z = floor(this.zPosition - this.hitboxLength/2); z < zPosition + this.hitboxLength/2; z++){
          
          //vertex(x,y,z);
          
          Block block = c.getBlockAt(x, y, z);
          if(block != null && !block.isTransparent()){
            
            
            if (vel.y < 0){
              //this.yPosition = y +1+0.01;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            if(vel.x >0){
              //this.xPosition = x-(this.hitboxWidth/2 + 0.0001);
              this.onGround = true;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            
            else if(vel.x <0){
              //this.xPosition = x+1 + (this.hitboxWidth/2 + 0.0001);
              this.onGround = true;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            if(vel.z >0){
              //this.zPosition = z-(this.hitboxLength/2 + 0.0001);
              this.onGround = true;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            
            else if(vel.z <0){
              //this.zPosition = z+1 + (this.hitboxLength/2 + 0.0001);
              this.jumping = true;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            
            if(vel.y>0){
              this.onGround = true;
              //this.yPosition =y  - this.hitboxHeight;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
              
            }
            
            
            arrowSound.play();
            
          }
          
        }
      }
    }
    
    //endShape(CLOSE);
    
  }
  
  
  
}
//Class for storing and drawing blocks to chunk meshes
public class Block{
  
  
  public int blockType;
  
  
  
  
  public Block(int type){
    
    
    this.blockType = type;
    
    
  }
  
  
  
  
  
  
  //better
  public void drawTop(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(255);
    
    
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex(x, y, (z+1), texture.x + 16, texture.y);   
    shape.vertex((x+1), y, (z+1), texture.x + 16, texture.y + 16);  
    shape.vertex((x+1), y, z, texture.x, texture.y + 16);
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex((x+1), y, (z+1), texture.x + 16, texture.y + 16);  

    
    
  }
  public void drawBottom(PShape shape,  int x, int y, int z, PVector texture){
    
    shape.tint(102);
    
    shape.vertex(x, y+1, z, texture.x, texture.y);
    shape.vertex(x, y+1, (z+1), texture.x + 16, texture.y);   
    shape.vertex((x+1), y+1, (z+1), texture.x + 16, texture.y + 16);  
    shape.vertex((x+1), y+1, z, texture.x, texture.y + 16);
    shape.vertex(x, y+1, z, texture.x, texture.y);
    shape.vertex((x+1), y+1, (z+1), texture.x + 16, texture.y + 16);  

    
  }
  
  
  
  public void drawSide4(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(204);
    
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex(x, y, (z+1), texture.x + 16, texture.y);   
    shape.vertex((x), y+1, (z+1), texture.x + 16, texture.y + 16);  
    shape.vertex((x), y+1, z, texture.x, texture.y + 16);
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex((x), y+1, (z+1), texture.x + 16, texture.y + 16);  
    
  }
  public void drawSide3(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(153);
    
    shape.vertex(x+1, y, z, texture.x, texture.y);
    shape.vertex(x, y, (z), texture.x + 16, texture.y);   
    shape.vertex((x), y+1, (z), texture.x + 16, texture.y + 16);  
    shape.vertex((x+1), y+1, z, texture.x, texture.y+ 16);
    shape.vertex(x+1, y, z, texture.x, texture.y);
    shape.vertex((x), y+1, (z), texture.x + 16, texture.y + 16);  

    
    
  }
  
  public void drawSide2(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(204);
    
    shape.vertex(x+1, y, z+1, texture.x, texture.y);
    shape.vertex(x+1, y, (z), texture.x + 16, texture.y);   
    shape.vertex((x+1), y+1, (z), texture.x + 16, texture.y + 16);  
    shape.vertex((x+1), y+1, z+1, texture.x, texture.y + 16);
    shape.vertex(x+1, y, z+1, texture.x, texture.y);
    shape.vertex((x+1), y+1, (z), texture.x + 16, texture.y + 16);  

    
    
  }
  
  public void drawSide1(PShape shape, int x, int y, int z, PVector texture){
    
    
    shape.tint(153);
    
    shape.vertex(x, y, z+1, texture.x, texture.y);
    shape.vertex(x+1, y, (z+1), texture.x + 16, texture.y);   
    shape.vertex((x+1), y+1, (z+1), texture.x + 16, texture.y + 16);  
    shape.vertex((x), y+1, z+1, texture.x, texture.y + 16);
    shape.vertex(x, y, z+1, texture.x, texture.y);
    shape.vertex((x+1), y+1, (z+1),  texture.x + 16, texture.y + 16);  

    
    
  }
  
  public void drawNature(PShape shape, int x, int y, int z, PVector texture){
    shape.tint(204);
    
    shape.vertex(x + 0.1464466f, y, z + 0.1464466f, texture.x , texture.y );
    shape.vertex(x + 0.8535533f, y, z + 0.8535533f, texture.x + 16, texture.y );
    shape.vertex(x + 0.8535533f, y+1, z + 0.8535533f, texture.x + 16, texture.y + 16);
    shape.vertex(x + 0.1464466f, y+1, z + 0.1464466f, texture.x, texture.y + 16);
    shape.vertex(x + 0.1464466f, y, z + 0.1464466f, texture.x , texture.y );
    shape.vertex(x + 0.8535533f, y+1, z + 0.8535533f, texture.x + 16, texture.y + 16);
    
    shape.vertex(x + 0.8535533f, y, z + 0.1464466f, texture.x , texture.y );
    shape.vertex(x + 0.1464466f, y, z + 0.8535533f, texture.x + 16, texture.y );
    shape.vertex(x + 0.1464466f, y+1, z + 0.8535533f, texture.x + 16, texture.y + 16);
    shape.vertex(x + 0.8535533f, y+1, z + 0.1464466f, texture.x , texture.y + 16);
    shape.vertex(x + 0.8535533f, y, z + 0.1464466f, texture.x , texture.y);
    shape.vertex(x + 0.1464466f, y+1, z + 0.8535533f, texture.x + 16, texture.y + 16);
    
    
  }
  
  public void drawShape(PShape shape, int x, int y, int z, PVector[] texture, boolean one, boolean two, boolean three, boolean four, boolean top, boolean bottom){
    if(this.blockType != 12){
      if(one)this.drawSide1(shape, x, y, z, texture[1]);
      if(two)this.drawSide2(shape, x, y, z, texture[1]);
      if(three)this.drawSide3(shape, x, y, z, texture[1]);
      if(four)this.drawSide4(shape, x, y, z, texture[1]);
      if(top)this.drawTop(shape, x, y, z, texture[0]);
      if(bottom)this.drawBottom(shape, x, y, z, texture[2]);
    }else this.drawNature(shape, x, y, z, texture[1]);
  }
  
  
  
  public boolean isTransparent(){
    return (this.blockType == 4 || this.blockType == 12 || this.blockType == 13 || this.blockType == 14 || this.blockType == 9 || this.blockType == 19 || this.blockType == 20);
  }
  public boolean isNature(){
    return (this.blockType == 12 || this.blockType == 13 || this.blockType == 14 || this.blockType == 19 || this.blockType == 20);
  }
  public boolean isLiquid(){
    return (this.blockType == 4 || this.blockType == 9);
  }
  
  
  
}
//Class that reads blocktypes from file and determines features of thos blocks
public class BlockType{
  public int type, dropped;
  
  public Method functionLeft, functionRight;
  public BlockType(String filepath){
    String file = "/blocks/" + filepath;
    String[] lines = loadStrings(file);
    this.type = Integer.parseInt(lines[0]);
    this.dropped = Integer.parseInt(lines[1]);
    
  }
  public void put(){
    BlockTypes.put(this.type,this);
  }
  
  
}
//Class for all chunk functionality
public class Chunk{
  public int lowestXPos, lowestYPos, lowestZPos;

  
  public final int cWidth = 16, cLength = 16, cHeight = 128;
  
  
  
  public PShape mesh;
  public World world;
  
  
  Block[][][] blocks;
  
  public Chunk(int lowestXPos, int lowestYPos, int lowestZPos, World world){
    this.lowestXPos = lowestXPos;
    this.lowestYPos = lowestYPos;
    this.lowestZPos = lowestZPos;
    
    this.blocks = new Block[cWidth][cHeight][cLength];
    this.mesh = createShape();
    
    this.world = world;
    
    
  }
  
  public void removeBlock(int x, int y, int z, boolean byUser){
    blocks[x][y][z] = null;
    if (byUser){
      this.betterGenerateMesh();
      try{
      
        if(x == 0){
          //println("Checking chunk: " + ((lowestXPos)/16 -1) + ", " + lowestZPos/16);
          this.world.getChunkAt(lowestXPos/16-1, lowestZPos/16).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(x == 15){
          //println("Checking chunk: " + ((lowestXPos)/16 + 1) + ", " + lowestZPos/16);
          this.world.getChunkAt(lowestXPos/16+1,lowestZPos/16).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(z == 0){
          //println("Checking chunk: ", + (lowestXPos/16) + ", " + ((lowestZPos)/16 -1) );
          this.world.getChunkAt(lowestXPos/16, lowestZPos/16-1).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(z == 15){
          //println("Checking chunk: " +(lowestXPos/16) + ", " + ((lowestZPos)/16 + 1)  );
          this.world.getChunkAt(lowestXPos/16, lowestZPos/16+1).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
    }
  }
  public void setBlock(int blockId, int x, int y, int z, boolean byUser){
    blocks[x][y][z] = new Block(blockId);
    if (byUser){
      this.betterGenerateMesh();
      try{
      
        if(x == 0){
          //println("Checking chunk: " + ((lowestXPos)/16 -1) + ", " + lowestZPos/16);
          this.world.getChunkAt(lowestXPos/16-1, lowestZPos/16).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(x == 15){
          //println("Checking chunk: " + ((lowestXPos)/16 + 1) + ", " + lowestZPos/16);
          this.world.getChunkAt(lowestXPos/16+1,lowestZPos/16).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(z == 0){
          //println("Checking chunk: ", + (lowestXPos/16) + ", " + ((lowestZPos)/16 -1) );
          this.world.getChunkAt(lowestXPos/16, lowestZPos/16-1).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(z == 15){
          //println("Checking chunk: " +(lowestXPos/16) + ", " + ((lowestZPos)/16 + 1)  );
          this.world.getChunkAt(lowestXPos/16, lowestZPos/16+1).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
    }
    
  }
  

  
  
  
  public void betterDrawChunk(){
    shape(this.mesh);
    
  }
  public void betterGenerateMesh(){
    
    
    //int timeStamp1 = millis();
    while(drawingUI == true) delay(1);
    PShape newMesh = createShape();
    newMesh.beginShape(TRIANGLE);
    newMesh.noStroke();
    newMesh.texture(this.world.getTexture());
    //this.mesh = createShape(); //reset coords
    //this.mesh.beginShape(TRIANGLE);
    //this.mesh.noStroke();
    //this.mesh.texture(this.world.getTexture());
    
    
    
    for (int x = 0; x < blocks.length;x++){ //add face vertices to coords
      for (int y = 0; y < blocks[x].length;y++){
        for (int z = 0; z < blocks[x][y].length;z++){
           
          
          
          if (blocks[x][y][z] != null){
            Block block = blocks[x][y][z];
            PVector[] texCoords = this.world.textureCoords.get(block.blockType);
            if(!block.isNature()){
              if((x<15 && x>0) && (z<15 && z>0) && (y<127 & y>0)){
               

                if (blocks[x][y-1][z] == null ||(blocks[x][y-1][z].isTransparent() && ! block.isTransparent())){
                  block.drawTop(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[0]); 
                }
                
                
                if (blocks[x][y][z+1] == null ||(blocks[x][y][z+1].isTransparent() && ! block.isTransparent())){
                  block.drawSide1(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                  
                }
                  
                            
                if (blocks[x+1][y][z] == null ||(blocks[x+1][y][z].isTransparent() && ! block.isTransparent())){
                  block.drawSide2(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                }
                  
      
                
                  
                if (blocks[x][y][z-1] == null ||(blocks[x][y][z-1].isTransparent() && ! block.isTransparent())){
                  block.drawSide3(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                }
                  
                
                
                
                if (blocks[x-1][y][z] == null ||(blocks[x-1][y][z].isTransparent() && ! block.isTransparent())){
                  block.drawSide4(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                }
                  
                  
                  
                if (blocks[x][y+1][z] == null ||(blocks[x][y+1][z].isTransparent() && ! block.isTransparent())){
                  block.drawBottom(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[2]); 
                }
            
              
              }
              else{
                if(x == 0){
                  
                  Chunk chunk = this.world.getChunkAt(lowestXPos/16 -1, lowestZPos/16);
                  if(chunk != null){
                    if(chunk.blocks[15][y][z] == null ||(chunk.blocks[15][y][z].isTransparent() && ! block.isTransparent())){
                      block.drawSide4(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                    }
                  }
                }
                else{
                  if (blocks[x-1][y][z] == null ||(blocks[x-1][y][z].isTransparent() && ! block.isTransparent())){
                    block.drawSide4(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                  }
                }
                if(x == 15){
                  Chunk chunk = this.world.getChunkAt(lowestXPos/16 +1, lowestZPos/16);
                  if(chunk != null){
                    if(chunk.blocks[0][y][z] == null ||(chunk.blocks[0][y][z].isTransparent() && ! block.isTransparent())){
                      block.drawSide2(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                    }
                  }
                }
                else{
                  if (blocks[x+1][y][z] == null ||(blocks[x+1][y][z].isTransparent() && ! block.isTransparent())){
                    block.drawSide2(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                  }
                }
                
                if(z == 15){
                  Chunk chunk = this.world.getChunkAt(lowestXPos/16 , lowestZPos/16+1);
                  if(chunk != null){
                    if(chunk.blocks[x][y][0] == null ||(chunk.blocks[x][y][0].isTransparent() && ! block.isTransparent())){
                      block.drawSide1(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                    }
                  }
                }
                else{
                  if (blocks[x][y][z+1] == null ||(blocks[x][y][z+1].isTransparent() && ! block.isTransparent())){
                    block.drawSide1(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                    
                  }
                }
                if(z == 0){
                  Chunk chunk = this.world.getChunkAt(lowestXPos/16, lowestZPos/16-1);
                  if(chunk != null){
                    if(chunk.blocks[x][y][15] == null ||(chunk.blocks[x][y][15].isTransparent() && ! block.isTransparent())){
                      block.drawSide3(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                    }
                  }
                }
                else{
                  if (blocks[x][y][z-1] == null ||(blocks[x][y][z-1].isTransparent() && ! block.isTransparent())){
                    block.drawSide3(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                  }
                }
                
                if(y == 0){
                  block.drawTop(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[0]); 
                }
                else if(y == 127){
                  block.drawBottom(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[2]); 
                }
                if(y!= 0 ){
                  if (blocks[x][y-1][z] == null ||(blocks[x][y-1][z].isTransparent() && ! block.isTransparent())){
                    block.drawTop(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[0]); 
                  }
                }
                
                if(y!= 127 ){
                  if (blocks[x][y+1][z] == null ||(blocks[x][y+1][z].isTransparent() && ! block.isTransparent())){
                    block.drawBottom(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[2]); 
                  }
                }
                
                
                            
                
                  
                
                
                
                
              }
            }else block.drawNature(newMesh, this.lowestXPos + x, this.lowestYPos + y, this.lowestZPos + z, texCoords[1]);
            
          }
        }
      }
    }
    
    newMesh.endShape();
    this.mesh = newMesh;
    
    //println("Generating mesh actually took: " + (millis()-timeStamp1)+ " ms");
    //println("------");
  }
  
  public String toString(){
    return("Chunk at " + this.lowestXPos + ", " + this.lowestZPos);
  }
  public void decorate(boolean nat){
    for (int x = 0; x< 16; x++) {
      for (int y = 0; y<16; y++) {
        int highness = 128-((int)map(noise(((this.lowestXPos+ x)/75.0f), (this.lowestZPos + y)/75.0f), 0, 1, 5, 100));
        if(highness > WATERLEVEL){
            for(int water = WATERLEVEL; water < highness; water ++){
              this.setBlock(4, x, water, y, false);
            }
          }
        if(highness < WATERLEVEL -6 &&((x<14 &&x > 1) &&(y<14 && y>1)) && nat){
          float random = random(0, 20);
          //println(random);
          if(random < 0.3f){
            generateTree(highness, x, y);
            
            
          }
          else if (random<0.6f){
            this.setBlock(12, x, highness-1, y, false);
          }
          else if(random<1){
            this.setBlock(13, x, highness-1, y, false);
          }
          else if(random <3){
            this.setBlock(14, x, highness-1, y, false);
          }
          else if(random < 3.3f){
            this.setBlock(19, x, highness-1, y, false);
          }
          else if(random < 3.6f){
            this.setBlock(20, x, highness-1, y, false);
          }
          
        }  
        if(highness > WATERLEVEL - 6){
          for (int h = highness; h<highness+2; h++) {
            this.setBlock(5, x, h, y, false);
          }
          for (int h = highness+2; h<highness+3; h++) {
            this.setBlock(8, x, h, y, false);
          }
        }else{
          for (int h = highness; h<highness+3; h++) {
            if(noise((this.lowestXPos + x)/20.0f, (128-h)/20.0f, (this.lowestZPos + y)/20.0f) > 0.3f)this.setBlock(1, x, h, y, false);
          }
        }
        for(int h = highness+3; h < 128; h++){
          if(noise((this.lowestXPos + x)/20.0f, (128-h)/20.0f, (this.lowestZPos + y)/20.0f) > 0.3f){
            this.setBlock(2, x, h, y, false);
          }
        }
      }
    }
    this.generateOres();
  }
  public void decorateFlat(){
    for (int x = 0; x< 16; x++) {
      for (int y = 0; y<16; y++) {
        int highness = 80;
        
        for (int h = highness; h<highness+3; h++) {
          this.setBlock(1, x, h, y, false);
        }
        for(int h = highness+3; h < 128; h++){
          this.setBlock(2, x, h, y, false);
        }
      }
    }
    
  }
  
  public void decorateExtreme(boolean nat){
    for (int x = 0; x< 16; x++) {
      for (int y = 0; y<16; y++) {
        float nx = ((this.lowestXPos+ x)/50.0f);
        float nz = ((this.lowestZPos + y)/50.0f);
        float e = 
                  1 * noise(1 * nx, 1 * nz) + 0.5f;
            

        e = pow(e, 5);
        int highness = 128-((int)map(e, 0.03125f, 7.59375f, 10, 127));
        if(highness > WATERLEVEL){
            for(int water = WATERLEVEL; water < highness; water ++){
              this.setBlock(4, x, water, y, false);
            }
        }
        if(highness < WATERLEVEL -6 &&((x<14 &&x > 1) &&(y<14 && y>1)) && nat){
          float random = random(0, 20);
          //println(random);
          if(random < 0.1f){
            generateTree(highness, x, y);
            
            
          }
          else if (random<0.4f){
            this.setBlock(12, x, highness-1, y, false);
          }
          else if(random<0.8f){
            this.setBlock(13, x, highness-1, y, false);
          }
          else if(random <2.8f){
            this.setBlock(14, x, highness-1, y, false);
          }
          
        }  
        for (int h = highness; h<highness+3; h++) {
          
          
          if(highness > WATERLEVEL - 6){
            this.setBlock(5, x, h, y, false);
          }
          else this.setBlock(1, x, h, y, false);
        }
        for(int h = highness+3; h < 128; h++){
          this.setBlock(2, x, h, y, false);
        }
      }
      
    }
    
  }
  public void decorateIsland(boolean nat){
    for (int x = 0; x< 16; x++) {
      for (int y = 0; y<16; y++) {
        int highness = 128-((int)map(noise(((this.lowestXPos+ x)/50.0f), (this.lowestZPos + y)/50.0f), 0, 1, 50, 100));
        if(highness > WATERLEVEL){
            for(int water = WATERLEVEL; water < highness; water ++){
              this.setBlock(4, x, water, y, false);
            }
          }
        if(highness < WATERLEVEL -6 &&((x<14 &&x > 1) &&(y<14 && y>1)) && nat){
          float random = random(0, 20);
          //println(random);
          if(random < 0.3f){
            generateTree(highness, x, y);
            
            
          }
          else if (random<0.6f){
            this.setBlock(12, x, highness-1, y, false);
          }
          else if(random<1){
            this.setBlock(13, x, highness-1, y, false);
          }
          else if(random <3){
            this.setBlock(14, x, highness-1, y, false);
          }
          
        }  
        
        for (int h = highness; h<highness+3; h++) {
          
          
          if(highness > WATERLEVEL - 6){
            this.setBlock(5, x, h, y, false);
          }
          else if(noise((this.lowestXPos + x)/20.0f, (128-h)/20.0f, (this.lowestZPos + y)/20.0f) > 0.3f)this.setBlock(1, x, h, y, false);
        }
        for(int h = highness+3; h < 128; h++){
          if(noise((this.lowestXPos + x)/20.0f, (128-h)/20.0f, (this.lowestZPos + y)/20.0f) > 0.3f){
            this.setBlock(2, x, h, y, false);
          }
        }
      }
    }
    this.generateOres();
  }
  public void generateTree(int highness, int x, int y){
    int tree = highness-1;
    for(tree = highness - 1; tree > highness -1 - random(2, 7); tree--){
      if (tree>0)this.setBlock(3, x, tree, y, false);
      
    }
    
    for(int level = 3; level > -1; level--){
      if (level < 2){
        for(int xOff = -2; xOff <3; xOff ++){
          for(int yOff = -2; yOff<3; yOff ++){
            
            this.setBlock(11, x + xOff, tree -level, y + yOff, false);
            
          }
        }
      }
      else{
        
        this.setBlock(11, x + 1, tree -level, y , false);
        
        this.setBlock(11, x - 1, tree -level, y , false);
        
        this.setBlock(11, x , tree -level, y-1 , false);
        
        this.setBlock(11, x , tree -level, y +1, false);
        
        this.setBlock(11, x , tree -level, y, false);
        
      }
    }
    if(random(0, 10) < 4.5f){
      this.removeBlock(x + 2, tree, y + 2, false);
    }
    if(random(0, 10) < 4.5f){
      this.removeBlock(x - 2, tree, y + 2, false);
    }
    if(random(0, 10) < 4.5f){
      this.removeBlock(x + 2, tree, y - 2, false);
    }
    if(random(0, 10) < 4.5f){
      this.removeBlock(x -2, tree, y - 2, false);
    }
    if(random(0, 10) < 4.5f){
      this.removeBlock(x + 2, tree - 1, y + 2, false);
    }
    if(random(0, 10) < 4.5f){
      this.removeBlock(x - 2, tree - 1, y + 2, false);
    }
    if(random(0, 10) < 4.5f){
      this.removeBlock(x + 2, tree-1, y - 2, false);
    }
    if(random(0, 10) < 4.5f){
      this.removeBlock(x -2, tree-1, y - 2, false);
    }
    
  }
  
  public void generateOres(){
    int diamondX = (int)random(15);
    int diamondZ = (int)random(15);
    //println("Diamond generated at " + (this.lowestXPos + diamondX) + ", " + (this.lowestZPos + diamondZ));
    for(int x = 0; x<(int)random(1,3); x++){
      for(int z = 0; z<(int)random(1,3); z++){
        for(int y = 0; y<(int)random(1,3); y++){
          if(this.blocks[diamondX + x][ 116][ diamondZ + z]!= null)this.setBlock(10, diamondX + x, 116 + y, diamondZ + z, false);
        }
      }
    }
    for(int rep = 0; rep < 2; rep++){
      int ironX = (int)random(0,14);
      int ironZ = (int)random(0,14);
      int ironY = (int)random(0, 15);
      //println("Iron generated at " + (this.lowestXPos + ironX) + ", " + (this.lowestZPos + ironZ));
      for(int x = 0; x<(int)random(1,4); x++){
        for(int z = 0; z<(int)random(1,4); z++){
          for(int y = 0; y<(int)    random(1,4); y++){
            if(this.blocks[ironX + x][ 116-ironY + y][ ironZ + z] != null && this.blocks[ironX + x][ 116-ironY + y][ ironZ + z].isTransparent())this.setBlock(17, ironX + x, 116 - ironY+y, ironZ + z, false);
          }
        }
      }
    }
  }
  
  
}
  
  
 
//A class that represents all things that have hitboxes, and are not fixed to the world grid.
public class Entity{
  float xPos, yPos, zPos;
  float vDeg, hDeg, dDeg;
  float xPosition, yPosition, zPosition;
  float gravity = 0.35f;
  
  String[] drops;
  
  boolean dead;
  int deadCount = 0;
  
  float hitboxWidth, hitboxHeight, hitboxLength;
  
  float legRotation;
  int health = 20;
  boolean onGround = false;
  boolean walking = false;
  boolean jumping = false;
  
  PShape shape, legs;
  
  PVector targetedPosition = new PVector(this.xPosition, this.zPosition);
  PVector delta = new PVector();
  int legDirection = 5;
  float targetedRotation = PI;
  float txPos, tzPos;
  
  public Entity(float xPos, float yPos, float zPos) {

    this.xPos = 0;
    this.yPos = 0;
    this.zPos = 0;
    this.hDeg = 0;
    this.vDeg = 0;
    this.dDeg = 0;
    this.xPosition = xPos;
    this.yPosition = yPos;
    this.zPosition = zPos;
    this.hitboxWidth = 0.5f;
    this.hitboxHeight = 1.5f;
    this.hitboxLength = 0.5f;
    this.legRotation = 0;
    this.drops = new String[2];
    
    this.targetedPosition = new PVector(this.xPosition, this.zPosition);
  }
  
  public void update(){
    if(! this.dead){
    //println(walking);
      if (! debug){
        this.wander();
        
      }
      else this.xPos = this.zPos = 0;
      
      this.yPos += gravity*(1f/60);
      
      if(this.jumping && this.onGround){
        this.onGround = false;
        this.yPos += -7*(1.0f/60);
        
        //println("HI");
        this.jumping = false;
        
      }
      
      
      
      
      this.xPosition += this.xPos;
      this.checkCollisions(new PVector(this.xPos, 0,0));
      
      
      this.yPosition += this.yPos;
      this.checkCollisions(new PVector(0, this.yPos, 0));
      this.zPosition += this.zPos;
      this.checkCollisions(new PVector(0, 0, this.zPos));
      
      this.drawShape();
      
      //this.xPos *= 0.89;as
  
      //this.zPos *= 0.89;
      
      
      
    }else{
      this.deadCount += 1;
      this.shape.translate(0, -this.hitboxHeight, 0);
      this.shape.rotate(radians(5), 0, 0, 1);
      this.shape.translate(0, this.hitboxHeight, 0);
      this.dDeg += radians(5);
      
      //print("die");
      if(this.deadCount > 18)deadentities.remove(this);
      this.drawShape();
      
    }
    
  }
   
  public void checkCollisions(PVector vel){
    //beginShape();
    //stroke(255);
    float xPosition = this.xPosition;
    float yPosition = this.yPosition;
    float zPosition = this.zPosition;
    for(int x = floor(this.xPosition - this.hitboxWidth/2.0f); x < xPosition + this.hitboxWidth/2.0f; x++){
      //println(x);
      for(int y = floor(this.yPosition); y < yPosition +this.hitboxHeight; y++){
        for(int z = floor(this.zPosition - this.hitboxLength/2.0f); z < zPosition + this.hitboxLength/2.0f; z++){
          
          //vertex(x,y,z);
          int xPos = floor(x);
          int yPos = floor(y);
          int zPos = floor(z);
          Block block = c.getBlockAt(xPos, yPos, zPos);
          if(block != null && !block.isTransparent()){
            
            
            if (vel.y < 0){
              this.yPosition = yPos +1+0.01f;
              this.yPos = 0;
            }
            if(vel.x >0){
              this.xPosition = xPos-(this.hitboxWidth/2 + 0.0001f);
              this.jumping = true;
              //this.xPos = 0;
            }
            
            else if(vel.x <0){
              this.xPosition = xPos+1 + (this.hitboxWidth/2 + 0.0001f);
              this.jumping = true;
              //this.xPos = 0;
            }
            if(vel.z >0){
              this.zPosition = zPos-(this.hitboxLength/2 + 0.0001f);
              this.jumping = true;
              //this.xPos = 0;
            }
            
            else if(vel.z <0){
              this.zPosition = zPos+1 + (this.hitboxLength/2 + 0.0001f);
              this.jumping = true;
              //this.xPos = 0;
            }
            
            if(vel.y>0){
              this.onGround = true;
              this.yPosition =yPos  - this.hitboxHeight;
              this.yPos = 0;
              
            }
            
            
            
            
          }
          
        }
      }
    }
    
    //endShape(CLOSE);
    
  }
  
  public void drawShape(){
    pushMatrix();
    //println("hi");
    tint(255);
   
    //rotateY(radians(this.hDeg));
    
    translate(this.xPosition, this.yPosition, this.zPosition);
    stroke(255);
    
    rotateY(TWO_PI-this.hDeg);
    rotateX(TWO_PI-this.vDeg);
    //println(this.hDeg);
    translate(- this.hitboxWidth/2, 0, -this.hitboxLength/2);
    shape(this.shape);
    
    popMatrix();
    
    
  }
  
  
  public void createRectPrism(PVector cornerCoords, PVector lengths, PVector textureCoords, PVector dimensions, PVector centerDimensions){
    this.shape.tint(204);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z,textureCoords.x - dimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    
    this.shape.tint(153);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    
    
    this.shape.tint(204);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    
    this.shape.tint(153);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x +centerDimensions.x, textureCoords.y - centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y - centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x +centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x +centerDimensions.x +centerDimensions.x, textureCoords.y - centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    
    this.shape.tint(255);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y - dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +centerDimensions.x, textureCoords.y);

    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + centerDimensions.y + dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y + dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + centerDimensions.y + dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
  }
  
  public void createShapeOnShape(PShape shape, PVector cornerCoords, PVector lengths, PVector textureCoords, PVector dimensions, PVector centerDimensions){
    shape.tint(204);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z,textureCoords.x - dimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    
    shape.tint(153);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    
    
    shape.tint(204);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    
    shape.tint(153);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x +centerDimensions.x, textureCoords.y - centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y - centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x +centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x +centerDimensions.x +centerDimensions.x, textureCoords.y - centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    
    shape.tint(255);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y - dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +centerDimensions.x, textureCoords.y);

    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + centerDimensions.y + dimensions.y);
    
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y + dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + centerDimensions.y + dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
  }
  
  
  public void goToLocation(PVector location){
    this.walking = true;
    delta = new PVector(-(this.xPosition - location.x), -(this.zPosition - location.y));
    delta.setMag(0.02f);
    this.targetedRotation = delta.heading() - PI/2;
       
    this.txPos = delta.x;
    this.tzPos = delta.y;
    
    this.targetedPosition = location.copy();
      
  }
  public void die(){
    this.dead = true;

    this.shape.disableStyle();
    this.legs.disableStyle();
    deadentities.add(this);
    entities.remove(this);
    mob_death.play();
    int rand = (int)random(this.drops.length);
    if (this.drops[rand] != null){
      player.addToInventory(Integer.parseInt(this.drops[rand].substring(0,3)), Integer.parseInt(this.drops[rand].substring(3)));
    }
    //println(deadentities);
  }
  public void wander(){
    if(abs(this.targetedPosition.x- this.xPosition ) <= 2.0f && abs(this.targetedPosition.y - this.zPosition) <= 2.0f){
      //println("hi");
      this.walking = false;
      this.legRotation = 0;
      this.xPos = 0;
      this.zPos = 0;  
      this.goToLocation(new PVector(player.xPosition + random(-100, 100), player.zPosition + random(-100, 100)));
      
    }else{
      if(abs(this.legRotation) >= 45)this.legDirection = -this.legDirection;
      this.legRotation += this.legDirection;
      
    }
    if (abs(this.hDeg - this.targetedRotation) > radians(10)){
      
      if(this.hDeg - this.targetedRotation > radians(10)){
        this.hDeg -= radians(5);
      }
      else if(this.targetedRotation -this.hDeg > radians(10)){
        this.hDeg += radians(5);
      }
    }
    else{
      
      this.xPos = txPos;
      this.zPos = tzPos;
      
    }
    
  }
  
  
  
  
}
//Handles mob spawns and other things
public ArrayList<Entity> entities = new ArrayList<Entity>();
public ArrayList<Entity> deadentities = new ArrayList<Entity>();
public ArrayList<Arrow> arrows = new ArrayList<Arrow>();
public String[] entityTypes = new String[]{"Pig", "Panda", "Monster"};

public void checkSpawnEntities(){
  if(frameCount %120 == 0 && entities.size()<50){
    try{
      Entity newEntity;
      float randomType = random(0, entityTypes.length-1);
      float px = player.xPosition + random(-100, 100);
      float pz = player.zPosition + random(-100, 100);
      if(randomType <= MONSTER_SPAWN_RATE)newEntity = new Monster(px,c.getHighestBlockAt(floor(px),floor(pz)) -5, pz);
      else if(randomType <= MONSTER_SPAWN_RATE + 0.5f)newEntity = new Panda(px,c.getHighestBlockAt(floor(px),floor(pz))-5, pz);
      else newEntity = new Pig(px,c.getHighestBlockAt(floor(px),floor(pz))-1, pz);
      entities.add(newEntity);
     
    }catch(Exception e){
      //println(e);
    }
    
    
  }
  
  
}
public void updateEntities(){
  ArrayList<Entity> newEntities = new ArrayList<Entity>(entities);
  for(Entity entity: newEntities){
    try{
      if(entity != null)entity.update();
      if(entity == null)entities.remove(entity);
      if(entity != null && dist(entity.xPosition, entity.zPosition, player.xPosition, player.zPosition) >141)entities.remove(entity);
    }catch(Exception e){
    }
  }
  ArrayList<Arrow> newArrows = new ArrayList<Arrow>(arrows);
  for(Arrow entity: newArrows){
    try{
      if(entity != null)entity.update();
      else entities.remove(entity);
      if(entity != null && dist(entity.xPosition, entity.zPosition, player.xPosition, player.zPosition) >141)entities.remove(entity);
    }catch(Exception e){

    }
  }
  ArrayList<Entity> dead = new ArrayList<Entity>(deadentities);
  for(Entity entity: dead){
    try{
      if(entity != null)entity.update();
      else deadentities.remove(entity);
      if(entity != null && dist(entity.xPosition, entity.zPosition, player.xPosition, player.zPosition) >141)deadentities.remove(entity);
    }catch(Exception e){
      
    }
  }
  
}

public Entity getEntityAt(PVector position){
  for(Entity entity :entities){
    if(position.x > entity.xPosition-entity.hitboxWidth/2.0f && position.x < entity.xPosition +entity.hitboxWidth/2.0f && position.y > entity.yPosition && position.y < entity.yPosition + entity.hitboxHeight && position.z > entity.zPosition - entity.hitboxLength/2.0f && position.z < entity.zPosition +entity.hitboxLength/2.0f){
      return entity;
    }
  }
  return null;
  
}

enum GameState{
  LOADING,
  MENU,
  PLAYING_GAME,
  MENU_START
  
}
GameState state = GameState.MENU;
public void drawGameFrame(){
  switch(state){
    case LOADING:
      drawLoading();
      break;
    case PLAYING_GAME:
      drawPlayingFrame();
      break;
    case MENU:
      drawMenu();
      break;
    case MENU_START:
      drawMenuStart();
      break;
  }
  
  
}

public void drawPlayingFrame(){
  try{
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
    c.drawWorld();

    resetShader();
    drawingUI = true;
    checkSpawnEntities();
    
    perspective(PI/3f, PApplet.parseFloat(width)/PApplet.parseFloat(height), 0.01f, 1000f);
    
    player.updateCamera();
    
    drawingUI = false;
    f = frameRate;
      
    
    
    pMouse.x = mouse.x;
    pMouse.y = mouse.y;
    bmouseclicked = false;
    
  }catch(Exception e){
    handleError(e);
  }
  
  
  
}
int randcolor = color(random(0, 255), random(0, 255), random(255));
public void handleError(Exception e){
  perspective(PI/3f, PApplet.parseFloat(width)/PApplet.parseFloat(height), 0.01f, 1000f);
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
  popMatrix();
  //fill(255, 0,0);
  textSize(50);
  textAlign(CENTER);
  text("There was an error.", width/2, height/2-50);
  text(e.toString(),width/2, height/2 + 50);
  println(e);
  noLoop();
  
  
}

public void loadThread(){
  
  
  c = new World(WORLDSIZE);
  
  thread("checkChunks");
  thread("checkMouseClicked");
  delay(10000);
  state = GameState.PLAYING_GAME;
}

public void drawLoading(){
  background(randcolor);
  image(logo, width/2 - 514, height/2 - 301);
  drawingUI = true;
  pushMatrix();
  pushStyle();
  textSize(50);
  fill(245, 239, 66);
  textAlign(CENTER);
  text(toast, width/2, height/2 + 200);
  translate(width/2, height/2 + 300);
  rotate(radians((frameCount*5)%360));
  fill(66, 133, 244); 
  circle(25, 0, 15);
  fill(219, 68, 55);
  circle(-25, 0, 15);
  fill(244, 160, 5);
  circle(0, 25, 15);
  fill(15, 157, 88);
  circle(0, -25, 15);
  colorMode(HSB);
  fill((frameCount + 50) % 255, 255, 255);
  circle(0, 0, 15);
  popStyle();
  popMatrix();
  drawingUI = false;
  bmouseclicked = false;
}
public void drawMenu(){

  background(bk);
  cursor();
  image(logo, width/2 - 514, height/2 - 301);  
  drawingUI = true;
  if(button(width/2-400, height/2, 800, 80, buttonTexture, cbuttonTexture, "Play", 28)){
        
    
    state = GameState.MENU_START;
    
   }
  drawingUI = false;
  bmouseclicked = false;
}
public void drawMenuStart(){
  background(0);
  tint(100);
  for(int x = 0; x<width; x+=128){
    for(int y = 0; y<height; y+=128){
      image(background, x, y, 128, 128);
    }
  }
  tint(255);
  cursor();
  image(logo, width/2 - 514, height/2 - 501);  
  drawingUI = true;
  switch(type){
    case NORM:
      if(button(width/2-400, height/2, 800, 80, buttonTexture, cbuttonTexture, "World Type: Normal", 28)){    
        type = WorldType.FLAT;
      }
      break;
    case FLAT:
      if(button(width/2-400, height/2, 800, 80, buttonTexture, cbuttonTexture, "World Type: Flat", 28)){    
        type = WorldType.EXTREME;
      }
      break;
    case EXTREME:
      if(button(width/2-400, height/2, 800, 80, buttonTexture, cbuttonTexture, "World Type: Extreme", 28)){    
        type = WorldType.ISLANDS;
      }
      break;
    case ISLANDS:
      if(button(width/2-400, height/2, 800, 80, buttonTexture, cbuttonTexture, "World Type: Islands", 28)){    
        type = WorldType.NORM;
      }
      break;
  
  }
  if (nature){
    if(button(width/2-400, height/2+100, 800, 80, buttonTexture, cbuttonTexture, "Nature: Yes", 28)){
      nature = false;
    }
    
  }else{
    if(button(width/2-400, height/2+100, 800, 80, buttonTexture, cbuttonTexture, "Nature: No", 28)){
      nature = true;
    }
  }
  if(button(width/2-400, height/2+300, 800, 80, buttonTexture, cbuttonTexture, "Start", 28)){
    
    
    state = GameState.LOADING;
    noCursor();
    
    thread("loadThread");
  }
  drawingUI = false;
  bmouseclicked = false;
}
public void fakeLoadThread(){
  
  
  
}
public boolean button(int tX, int tY, int w, int h, PImage texture, PImage ctexture, String text, int textSize){
  if(mouseX > tX && mouseX < tX + w && mouseY > tY && mouseY < tY + h ){
    image(ctexture, tX, tY, w, h);
    pushStyle();
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(textSize);
    text(text, tX + w/2, tY + h/2);
    popStyle();
    if( bmouseclicked){
      return true;
    }
  }
  else{
    image(texture, tX, tY, w, h);
    pushStyle();
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(textSize);
    text(text, tX + w/2, tY + h/2); 
    popStyle();
    return false;
    
  }
  return false;
}
  
//Class for storing stacks of items in the inventory
public class ItemStack{
  
  public int itemType;
  public int amount;
  
  
  public PImage icon;
  
  public Player player;
  
  public ItemStack(int itemType, Player player){
    this.itemType = itemType;
    this.player = player;
    this.amount = 1;
    this.icon = loadImage("/icons/" + this.itemType + ".png");
  }
  public ItemStack(int itemType, int amount, Player player){
    this.itemType = itemType;
    this.player = player;
    this.amount = amount;
    this.icon = loadImage("/icons/" + this.itemType + ".png");
  }
  
  public void drawStack(PVector coords){
    pushStyle();
    if(this.icon != null)image(this.icon, coords.x, coords.y , 64, 64);
    if(this.amount >1){
      textSize(28);
      textAlign(RIGHT, TOP);
      text(this.amount, coords.x + 65, coords.y + 40);
    }
    popStyle();
  }
  
  public ItemStack createCopy(){
    return new ItemStack(this.itemType, this.amount, this.player);
  }
  
  
  
      
  
  
  
  
}
//Class for reading ItemTypes from files and determining features of itemtypes.
public class ItemType{
  public int type, maxAmount, breakingSpeed;
  
  public Method functionLeft, functionRight;
  public ItemType(String filepath){
    String file = "/items/" + filepath;
    String[] lines = loadStrings(file);
    this.type = Integer.parseInt(lines[0]);
    this.maxAmount = Integer.parseInt(lines[1]);
    if (lines.length == 4)this.breakingSpeed = 1;
    else this.breakingSpeed = Integer.parseInt(lines[4]);
    try{
      this.functionLeft = Player.class.getMethod(lines[2]);
    }catch(NoSuchMethodException e){
      try{
        this.functionLeft = Player.class.getMethod("BREAK");
      }catch(NoSuchMethodException f){
        //not possible
      }
    }
    try{
      this.functionRight = Player.class.getMethod(lines[3]);
    }catch(NoSuchMethodException e){
      try{
        this.functionRight = Player.class.getMethod("PLACE");
      }catch(NoSuchMethodException f){
        //not possible
      }
    }
    
  }
  public void put(){
    ItemTypes.put(this.type,this);
  }
  
  
}
//For handling keyboard input
boolean isLeft, isRight, isUp, isDown, isSpace, isShift; 
float playerSpeed = 0.1f;


public void keyPressed() {

  if(key == 'w') isUp = true;  
  if(key == 's') isDown = true; 
  if(key == 'a') isLeft = true; 
  if(key == 'd') isRight = true;
  
  if(key == 'q') isShift = true; 
  if(key == 'D')  debug = !debug;
    
    
  if(key == '1') player.selectedSlot = 0;
  if(key == '2') player.selectedSlot = 1;
  if(key == '3') player.selectedSlot = 2;
  if(key == '4') player.selectedSlot = 3;
  if(key == '5') player.selectedSlot = 4;
  if(key == '6') player.selectedSlot = 5;
  if(key == '7') player.selectedSlot = 6;
  if(key == '8') player.selectedSlot = 7;
  if(key == '9') player.selectedSlot = 8;
  if(key == 'e'){
    mouseclicked = false;
    drawingInventory = !drawingInventory;
    if(drawingInventory){
      cursor();
      mouseControl.mouseMove(0, 0);
      
      
      
    }
    else {
      
      
      noCursor();
    }
  }
  if(key == ' '){
    //println("hi");
    isSpace = true;
    
  }
  
}

public void keyReleased() {
  if(key == 'w') isUp = false;  
  if(key == 's') isDown = false; 
  if(key == 'a') isLeft = false; 
  if(key == 'd') isRight = false;
  if(key == ' ') isSpace = false; 
  if(key == 'q') isShift = false; 
  
}
 
public void checkKeys(){
  if(!player.dead){
    if (isLeft) {
      player.xPos  += sin(PI/2-player.hDeg)/10 * playerSpeed;
      
      player.zPos += cos(PI/2-player.hDeg)/10* playerSpeed;
        
      //}
      //else{
        
      //}
    }
    if (isRight) {
      player.xPos  -= sin(PI/2-player.hDeg)/10* playerSpeed;
      //if (player.zPosition -cos(PI/2-player.hDeg)/10* playerSpeed>1.5){
      player.zPos -= cos(PI/2-player.hDeg)/10* playerSpeed;
        
      //}
      //else{
        
      //}
    }
  
    if (isUp) {
      player.xPos-= sin(player.hDeg)/10* playerSpeed;
      //if (player.zPosition +cos(player.hDeg)/10* playerSpeed>1.5){
      player.zPos += cos(player.hDeg)/10* playerSpeed;
        
      //}
      //else{
        
      //}
    }
    if (isDown) {
      player.xPos +=sin(player.hDeg)/10* playerSpeed;
      //if (player.zPosition -cos(player.hDeg)/10* playerSpeed>1.5){
      player.zPos -= cos(player.hDeg)/10* playerSpeed;
      //}
      //else{
        
      //}
    }
    if (isSpace && player.isUnderwater){
      player.yPos += -2.5f*(1.0f/60);
    }else if(isSpace && player.isUnderlava){
      player.yPos += -2.5f*(1.0f/60);
    }
    else if (isSpace && player.onGround && !player.isUnderwater) {
      player.yPos += -7*(1.0f/60);
      player.onGround = false;
    }
  }
  
  //if (isShift) {
  //  player.yPos += 0.1* playerSpeed;
  //}
  
  //if ( (int) (player.yPosition +1.62)
  
}





  
public class Monster extends Entity{
  int bowCharge;
  PShape arms;
  float speed;
  public Monster(float xPos, float yPos, float zPos){
    super(xPos, yPos, zPos);
    this.hitboxWidth = 0.5f;
    this.hitboxHeight = 2;
    this.hitboxLength = 0.5f;
    this.drops = new String[]{"15101", "15102", "15103", "15103", "15103", "15104", "15105", "15106", "11601", "11601", "11601", null, null, null, null, null, null, null, null, null};
    this.bowCharge = 0;
    this.shape = createShape();
    this.shape.beginShape(TRIANGLE);
    this.shape.noStroke();
    this.shape.texture(monster);
    this.createRectPrism(new PVector(0,0,0), new PVector(8/16.0f, 8/16.0f, 8/16.0f), new PVector(8,8), new PVector(8, 8), new PVector(8,8));
    this.createRectPrism(new PVector(0/16.0f, 8/16.0f, 2/16.0f), new PVector(8/16.0f, 12/16.0f, 4/16.0f), new PVector(48, 16), new PVector(4, 4), new PVector(8, 12));
    
    this.shape.endShape();
    
    this.legs = createShape();
    this.legs.beginShape(TRIANGLE);

    this.legs.noStroke();
    this.legs.texture(monster);
    this.createShapeOnShape(this.legs, new PVector(0,0,-1/16.0f), new PVector(2/16.0f, 12/16.0f, 2/16.0f), new PVector(33, 12), new PVector(2,2), new PVector(2,12));
    this.legs.endShape();
    
    this.arms = createShape();
    this.arms.beginShape(TRIANGLE);

    this.arms.noStroke();
    this.arms.texture(monster);
    this.createShapeOnShape(this.arms, new PVector(-2/16.0f, 0, -1/16.0f), new PVector(2/16.0f, 12/16.0f, 2/16.0f), new PVector(27, 12), new PVector(2,2), new PVector(2, 12));
    //this.createShapeOnShape(this.arms, new PVector(8/16.0, 0, -1/16.0), new PVector(2/16.0, 12/16.0, 2/16.0), new PVector(27, 12), new PVector(2,2), new PVector(2, 12));
    this.arms.endShape();
  }
  
  public void drawShape(){
    pushMatrix();
    //println("hi");
    
    pushStyle();
    tint(255, 0,0);
    noStroke();
    
    //go to position
    translate(this.xPosition, this.yPosition, this.zPosition);
    
    rotateY(TWO_PI-this.hDeg);
    translate(- this.hitboxWidth/2, 0, -this.hitboxLength/2);
    
    
    
    shape(this.shape);
    
    //draw first arm, rotate outward
    if(!this.dead){
      pushMatrix();
      translate(0, 8/16.0f, 4/16.0f);
      rotateX(radians(80));
      rotate(-radians(10), 0, 0, 1);
      shape(this.arms);
      //draw second arm, rotate left
      rotate(radians(10), 0, 0, 1);
      pushMatrix();
      translate(10/16.0f, 0, 0);
      rotate(radians(20), 0, 0, 1);
      shape(this.arms);
      popMatrix();
      
      //draw bow, rotate upright
      translate(0, 12/16.0f, 0);
      rotateX(-radians(80));
      translate(3/16.0f, 0, -1/16.0f);
      rotate(radians(10), 0, 0, 1);
      shape(bowShape);
      popMatrix();
    }
    //draw legs
    translate(0, this.hitboxHeight, 0);
    rotate(this.dDeg, 0, 0, 1);
    translate(0, -this.hitboxHeight, 0);
    translate(1/16.0f, 20/16.0f, 4/16.0f);
    rotateX(radians(this.legRotation));
    shape(this.legs);
    
    translate(4/16.0f, 0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    popStyle();
    popMatrix();
    
    
  
  }
  public void update(){
    if(! this.dead){
    //println(walking);
      if (! debug){
      
        
        if(dist(this.xPosition, this.zPosition, player.xPosition, player.zPosition)> 16){
          this.wander();
          this.bowCharge = 0;
        }else if(dist(this.xPosition, this.zPosition, player.xPosition, player.zPosition)< 5){
          delta = new PVector(-(this.xPosition - player.xPosition), -(this.zPosition - player.zPosition));
          this.hDeg = delta.heading() - PI/2;
          //delta = new PVector(sin(PI/2-this.hDeg)/10,cos(PI/2-this.hDeg)/10).setMag(0.06); 
          this.xPos = 0;
      
          this.zPos = 0;
          
          
          this.bowCharge += 1;
          if (this.bowCharge > 40){
            this.bowCharge = 0;
            arrows.add(new MonsterArrow(this.xPosition, this.yPosition, this.zPosition, new PVector(player.xPosition - this.xPosition, player.yPosition - this.yPosition, player.zPosition - this.zPosition)));
          }
        }else{ 
          if(abs(this.legRotation) >= 35)this.legDirection = -this.legDirection;
          this.legRotation += this.legDirection * 1.5f;
          delta = new PVector(-(this.xPosition - player.xPosition), -(this.zPosition - player.zPosition));
          delta.setMag(0.08f);
          this.hDeg = delta.heading() - PI/2;
          this.xPos = delta.x;
          this.zPos = delta.y;
          this.bowCharge += 1;
          if (this.bowCharge > 40){
            this.bowCharge = 0;
            arrows.add(new MonsterArrow(this.xPosition, this.yPosition, this.zPosition, new PVector(player.xPosition - this.xPosition, player.yPosition - this.yPosition, player.zPosition - this.zPosition)));
          }
        }
      }
      else this.xPos = this.zPos = 0;
      
      this.yPos += gravity*(1f/60);
      
      if(this.jumping && this.onGround){
        this.onGround = false;
        this.yPos += -7*(1.0f/60);
        
        //println("HI");
        this.jumping = false;
        
      }
      
      
      
      
      this.xPosition += this.xPos;
      this.checkCollisions(new PVector(this.xPos, 0,0));
      
      
      this.yPosition += this.yPos;
      this.checkCollisions(new PVector(0, this.yPos, 0));
      this.zPosition += this.zPos;
      this.checkCollisions(new PVector(0, 0, this.zPos));
      
      this.drawShape();
      
      //this.xPos *= 0.89;as
  
      //this.zPos *= 0.89;
      
      
      
    }else{
      this.deadCount += 1;
      this.shape.translate(0, -this.hitboxHeight, 0);
      this.shape.rotate(radians(5), 0, 0, 1);
      this.shape.translate(0, this.hitboxHeight, 0);
      this.dDeg += radians(5);
      
      //print("die");
      if(this.deadCount > 18)deadentities.remove(this);
      this.drawShape();
      
    }
    
  }
  public void wander(){
    if(this.txPos == 0 && this.tzPos == 0){
      this.xPos = this.zPos = 0;
      this.goToLocation(new PVector(player.xPosition + random(-100, 100), player.zPosition + random(-100, 100)));
    }
    if(abs(this.targetedPosition.x- this.xPosition ) <= 2.0f && abs(this.targetedPosition.y - this.zPosition) <= 2.0f){
      //println("hi");
      this.walking = false;
      this.legRotation = 0;
      this.xPos = 0;
      this.zPos = 0;  
      this.goToLocation(new PVector(player.xPosition + random(-100, 100), player.zPosition + random(-100, 100)));
      
    }else{
      if(abs(this.legRotation) >= 35)this.legDirection = -this.legDirection;
      this.legRotation += this.legDirection;
      
    }
    if (abs(this.hDeg - this.targetedRotation) > radians(10)){
      
      if(this.hDeg - this.targetedRotation > radians(10)){
        this.hDeg -= radians(5);
      }
      else if(this.targetedRotation -this.hDeg > radians(10)){
        this.hDeg += radians(5);
      }
    }
    else{
      this.xPos = txPos;
      this.zPos = tzPos;
      
    }
    
  }
  
    
  
  
  
}
public class MonsterArrow extends Arrow{
  
  public MonsterArrow(float xPos, float yPos, float zPos, PVector vel){
    super(xPos, yPos, zPos, vel);
    this.hDeg = new PVector(vel.x, vel.z).heading() - PI/2;
    
  }
  public void update(){
    if (! debug){
      if(! this.onGround){
        
        this.yPosition += this.yPos;
        
        this.xPosition += this.xPos;
      
        this.zPosition += this.zPos;
        float d = new PVector(this.xPos, this.zPos).mag();
        this.vDeg = atan(this.yPos/d);
        this.checkCollisions(new PVector(this.xPos, this.yPos, this.zPos));
        if(this.xPosition > player.xPosition-player.hitboxWidth/2.0f && this.xPosition < player.xPosition +player.hitboxWidth/2.0f && this.yPosition > player.yPosition && this.yPosition < player.yPosition + player.hitboxHeight && zPosition > player.zPosition - player.hitboxLength/2.0f && zPosition < player.zPosition +player.hitboxLength/2.0f){
          player.takeDamage(3);
        }
        
        this.yPos += gravity*(1f/260);
      }
      if(! this.onGround){
        
        this.yPosition += this.yPos;
        
        this.xPosition += this.xPos;
      
        this.zPosition += this.zPos;
        float d = new PVector(this.xPos, this.zPos).mag();
        this.vDeg = atan(this.yPos/d);
        this.checkCollisions(new PVector(this.xPos, this.yPos, this.zPos));
        if(this.xPosition > player.xPosition-player.hitboxWidth/2.0f && this.xPosition < player.xPosition +player.hitboxWidth/2.0f && this.yPosition > player.yPosition && this.yPosition < player.yPosition + player.hitboxHeight && zPosition > player.zPosition - player.hitboxLength/2.0f && zPosition < player.zPosition +player.hitboxLength/2.0f){
          player.takeDamage(3);
          arrows.remove(this);
        }
        
        this.yPos += gravity*(1f/260);
      }
      this.drawShape();
      
      
    }
    
  }
  public void checkCollisions(PVector vel){
    //beginShape();
    //stroke(255);
    float xPosition = this.xPosition;
    float yPosition = this.yPosition;
    float zPosition = this.zPosition;
    for(int x = floor(this.xPosition - this.hitboxWidth/2); x < xPosition + this.hitboxWidth/2; x++){
      //println(x);
      for(int y = floor(this.yPosition); y < yPosition +this.hitboxHeight; y++){
        for(int z = floor(this.zPosition - this.hitboxLength/2); z < zPosition + this.hitboxLength/2; z++){
          
          //vertex(x,y,z);
          
          Block block = c.getBlockAt(x, y, z);
          if(block != null && !block.isTransparent()){
            
            
            if (vel.y < 0){
              //this.yPosition = y +1+0.01;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            if(vel.x >0){
              //this.xPosition = x-(this.hitboxWidth/2 + 0.0001);
              this.onGround = true;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            
            else if(vel.x <0){
              //this.xPosition = x+1 + (this.hitboxWidth/2 + 0.0001);
              this.onGround = true;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            if(vel.z >0){
              //this.zPosition = z-(this.hitboxLength/2 + 0.0001);
              this.onGround = true;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            
            else if(vel.z <0){
              //this.zPosition = z+1 + (this.hitboxLength/2 + 0.0001);
              this.jumping = true;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
            }
            
            if(vel.y>0){
              this.onGround = true;
              //this.yPosition =y  - this.hitboxHeight;
              this.zPos = 0;
              this.xPos = 0;
              this.yPos = 0;
              
            }
            
            arrows.remove(this);

            
            
          }
          
        }
      }
    }
    
    //endShape(CLOSE);
    
  }
  
  
}
//For handling mouse input
public void checkMouse(){
  
  if(!drawingInventory && !player.dead){
    mouse = MouseInfo.getPointerInfo().getLocation();
    if (pMouse == null)pMouse = new Point(mouse.x, mouse.y);
      
    
    
    
    if (mouse.x > 1918 && (mouse.x-pMouse.x) >0 ){
      int y = mouse.y;
      
      mouseControl.mouseMove(2, y);
      mouse.x = 2;
      pMouse.x = 2;
     
    }
    else if (mouse.x < 1 && (mouse.x-pMouse.x )< 0){
      int y = mouse.y;
      mouseControl.mouseMove(1918, y);
      mouse.x = 1918;
      pMouse.x = 1918;
    }
      
    
    
    
    player.vDeg = map(mouse.y, 0, height, 0, PI);
    
    
    
    player.hDeg = map(mouse.x, 2, 1918, 0, TWO_PI);
    
  
  
  }
  
}

public void checkMouseClicked(){
  for(;;delay(16)){
    
    if(mousePressed&& !drawingInventory && !player.dead && state == GameState.PLAYING_GAME){ 
      if (mouseButton == LEFT){
        if(player.getSelectedStack()!= null){
          ItemType item = ItemTypes.get(player.getSelectedStack().itemType);
          try{
            item.functionLeft.invoke(player);
          }catch(Exception e){
            println(e);
          }
          
        }
        else {
          player.BREAK();
          
        }
        
      }else if(mouseButton == RIGHT){
        if(player.getSelectedStack()!= null){
          ItemType item = ItemTypes.get(player.getSelectedStack().itemType);
          try{
            item.functionRight.invoke(player);
          }catch(Exception e){
            println(e);
          }
          delay(100);
        }
      }
    }
  }
        
}

public int getInventorySlot(){
  if(mouseX>=width/2-320 && mouseX<=width/2+320){ 
   if(mouseY>=height/2+236 && mouseY<=height/2+300){
     return (int)(  (mouseX-(width/2-320))/72);
   }
   else if(mouseY>=height/2+4 && mouseY< height/2 + 220){
     return ((int)((mouseY-(height/2+4))/72) + 1)*9 + (int)(  (mouseX-(width/2-320))/72);
   }
   else if(mouseX >= width/2+4 &&mouseX<width/2 + 212 && mouseY >= height/2 -260 && mouseY< height/2 -44){
     return (int)((mouseY-(height/2-260))/72)*3 + (int)((mouseX-(width/2+4))/72) + 36;
     
   }
   else if(mouseX>=width/2 + 260&& mouseX<= width/2 + 332 && mouseY>=height/2-188 && mouseY <= height/2-116){
     return 45;
   }
  }
  return -1;
}

public void mouseClicked(){
  mouseclicked = true;
  
}
public void mousePressed(){
  bmouseclicked = true;
}
public void mouseReleased(){
  if(state == GameState.PLAYING_GAME){
    player.blockDamage = 0;
    player.bowCharge = 0;
    player.pov = 70;
    if(player.charged){
      player.ARROW();
    }
  }
}

public void mouseWheel(MouseEvent event){
  if (drawingInventory){
    if(player.holding != null && player.holding.amount > 1){
      int x = getInventorySlot();
      if(x <36 && x>-1){
        if(player.inventory[x] == null){
          player.inventory[x] = new ItemStack(player.holding.itemType, (int)player.holding.amount/2, player);
          player.holding.amount -= (int)player.holding.amount/2;
        }
      }
    }
    
  }
  else{
    if (event.getCount() > 0){
      if (player.selectedSlot < 8)player.selectedSlot += 1;
      else player.selectedSlot = 0;
      
    }
    else if (event.getCount() < 0){
      if (player.selectedSlot > 0)player.selectedSlot -= 1;
      else player.selectedSlot = 8;
      
    }
  }
}
public class Panda extends Entity{
  
  public Panda(float xPos, float yPos, float zPos){
    super(xPos, yPos, zPos);
    this.hitboxWidth = 1;
    this.hitboxHeight = 1;
    this.hitboxLength = 1;
    this.shape = createShape();
    this.shape.beginShape(TRIANGLE);
    //this.shape.noFill();
    this.shape.noStroke();
    this.shape.texture(panda);
    
    
    this.createRectPrism(new PVector(-0.09375f,-0.375f,-0.59375f), new PVector(1.1875f, 0.8125f, 1.625f), new PVector(26, 55), new PVector(26, 26), new PVector(19, 13));
    this.createRectPrism(new PVector(0.09375f, -0.1875f, 1.03125f), new PVector(0.8125f,0.625f, 0.5625f), new PVector(9, 10), new PVector(9,9), new PVector(13, 10));
    this.createRectPrism(new PVector(0.09375f - 1/8.0f, -0.1875f-3/16.0f, 1.03125f + 5/16.0f), new PVector(5/16.0f, 4/16.0f, 1/16.0f), new PVector(36, 4), new PVector(1, 1), new PVector(5, 4));
    this.createRectPrism(new PVector(0.90625f - 3/16.0f, -0.1875f-3/16.0f, 1.03125f + 5/16.0f), new PVector(5/16.0f, 4/16.0f, 1/16.0f), new PVector(36, 4), new PVector(1, 1), new PVector(5, 4));
    this.shape.endShape();
    //this.createRectPrism(new PVector(0.2, 0.5, 0.05), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.6, 0.5, 0.05), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.2, 0.5, 0.5), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.6, 0.5, 0.5), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    this.legs = createShape();
    this.legs.beginShape(TRIANGLE);
    //this.shape.noFill();
    this.legs.noStroke();
    this.legs.texture(panda);
    this.createShapeOnShape(this.legs, new PVector(0,0,-0.1875f), new PVector(0.375f, 0.5625f, 0.375f), new PVector(1, 1), new PVector(1,1), new PVector(1,1));
    this.legs.endShape();
    
  }
  
  public void drawShape(){
    pushMatrix();
    //println("hi");
    
    pushStyle();
    //rotateY(radians(this.hDeg));
    tint(255, 0,0);
    translate(this.xPosition, this.yPosition, this.zPosition);
    
    rotateY(TWO_PI-this.hDeg);
    //println(this.hDeg);
    translate(- this.hitboxWidth/2, 0, -this.hitboxLength/2);
    
    
    
    shape(this.shape);
    translate(0, this.hitboxHeight, 0);
    rotate(this.dDeg, 0, 0, 1);
    translate(0, -this.hitboxHeight, 0);
    //textSize(0.1);
    //stroke(255);
    //line(0,0,0, 0, -100, 0);
    //text(this.targetedPosition.toString(), 0, -1, 0);
    
    translate(-0.09375f, 0.4375f, -0.40265f);
    rotateX(radians(this.legRotation));
    
    
    shape(this.legs);
    translate(0.8125f,0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    rotateX(radians(1*this.legRotation));
    translate(0,0,1.25f);
    rotateX(radians(this.legRotation));
    shape(this.legs);
    translate(-0.8125f, 0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    popStyle();
    popMatrix();
    
    
  }
  
  
}
public class Pig extends Entity{
  
  public Pig(float xPos, float yPos, float zPos){
    super(xPos, yPos, zPos);
    this.hitboxWidth = 0.8f;
    this.hitboxHeight = 0.9f;
    this.hitboxLength = 0.9f;
    this.shape = createShape();
    this.shape.beginShape(TRIANGLE);
    //this.shape.noFill();
    this.shape.noStroke();
    this.shape.texture(testImage);
    
    
    this.createRectPrism(new PVector(0.2f,0.1f,0), new PVector(0.6f, 0.4f, 0.7f), new PVector(40, 16), new PVector(16, 16), new PVector(8,8));
    this.createRectPrism(new PVector(0.22f, 0, 0.5f), new PVector(0.56f,0.5f, 0.5f), new PVector(8, 8), new PVector(8,8), new PVector(8,8)); 
    this.shape.endShape();
    //this.createRectPrism(new PVector(0.2, 0.5, 0.05), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.6, 0.5, 0.05), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.2, 0.5, 0.5), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.6, 0.5, 0.5), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    this.legs = createShape();
    this.legs.beginShape(TRIANGLE);
    //this.shape.noFill();
    this.legs.noStroke();
    this.legs.texture(testImage);
    this.createShapeOnShape(this.legs, new PVector(0,0,-0.125f), new PVector(0.2f, 0.4f, 0.25f), new PVector(16, 32), new PVector(8,8), new PVector(8,8));
    this.legs.endShape();
    //this.shape.vertex(0,0, 0, 8, 0);
    //this.shape.vertex(0, 0, hitboxLength, 24, 0);
    //this.shape.vertex(0, hitboxHeight, hitboxLength, 24, 8);
    //this.shape.vertex(0, hitboxHeight, 0, 8, 8);
    //this.shape.vertex(0,0, 0, 8, 0);
    //this.shape.vertex(0, hitboxHeight, hitboxLength, 24, 8);

    
    //this.shape.vertex(0,0, 0, 0, 0);
    //this.shape.vertex(hitboxWidth, 0, 0, 8, 0);
    //this.shape.vertex(hitboxWidth, hitboxHeight, 0, 8, 8);
    //this.shape.vertex(0, hitboxHeight, 0, 0, 8);
    //this.shape.vertex(0,0, 0, 0, 0);
    //this.shape.vertex(hitboxWidth, hitboxHeight, 0, 8, 8);
    
    //this.shape.vertex(hitboxWidth,0, 0, 8, 0);
    //this.shape.vertex(hitboxWidth, 0, hitboxLength, 24, 0);
    //this.shape.vertex(hitboxWidth, hitboxHeight, hitboxLength, 24, 8);
    //this.shape.vertex(hitboxWidth, hitboxHeight, 0, 8, 8);
    //this.shape.vertex(hitboxWidth,0, 0, 8, 0);
    //this.shape.vertex(hitboxWidth, hitboxHeight, hitboxLength, 24, 8);
    
    //this.shape.vertex(0,0, hitboxLength, 0, 8);
    //this.shape.vertex(hitboxWidth, 0, hitboxLength, 8, 8);
    //this.shape.vertex(hitboxWidth, hitboxHeight, hitboxLength, 8, 16);
    //this.shape.vertex(0, hitboxHeight, hitboxLength, 0, 16);
    //this.shape.vertex(0,0, hitboxLength, 0, 8);
    //this.shape.vertex(hitboxWidth, hitboxHeight, hitboxLength, 8, 16);
    
    //this.shape.vertex(0,0,0, 8,0);
    //this.shape.vertex(0, 0, hitboxLength, 24, 0);
    //this.shape.vertex(hitboxWidth, 0, hitboxLength, 24, 8);
    //this.shape.vertex(hitboxWidth, 0, 0, 8, 8);
    //this.shape.vertex(0,0,0, 8,0);
    //this.shape.vertex(hitboxWidth, 0, hitboxLength, 24, 8);
    
    
    
  }
  
  public void drawShape(){
    pushMatrix();
    //println("hi");
    pushStyle();
    tint(255, 0, 0);
    //rotateY(radians(this.hDeg));
    
    translate(this.xPosition, this.yPosition, this.zPosition);
    
    rotateY(TWO_PI-this.hDeg);
    //println(this.hDeg);
    translate(- this.hitboxWidth/2, 0, -this.hitboxLength/2);
    
    
    
    shape(this.shape);
    //textSize(0.1);
    translate(0, this.hitboxHeight, 0);
    rotate(this.dDeg, 0, 0, 1);
    translate(0, -this.hitboxHeight, 0);
    
    translate(0.2f, 0.5f, 0.125f);
    rotateX(radians(this.legRotation));
    
    
    shape(this.legs);
    translate(0.4f,0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    rotateX(radians(1*this.legRotation));
    translate(0,0,0.45f);
    rotateX(radians(this.legRotation));
    shape(this.legs);
    translate(-0.4f, 0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    popStyle();
    popMatrix();
    
    
  }
  
  
}
//Exteds entity class, handles player features
public class Player extends Entity{

  int selectedSlot, damageCount;
  
  int blockDamage = 0;

  boolean charged;
  int bowCharge;
  float pov = 70;
  boolean dead = false;
  boolean isUnderwater, isUnderlava, headUnderlava, takingDamage;
  public ItemStack[] inventory, craftingGrid;
  public ItemStack outputSlot;

  public ArrayList<Recipe> recipes;

  public ItemStack holding = null;
  

  public Player(float xPos, float yPos, float zPos) {
    super(xPos, yPos, zPos);
    this.selectedSlot = 0;
    
    
    perspective(PI/3f, PApplet.parseFloat(width)/PApplet.parseFloat(height), 0.01f, 1000f);

    this.inventory = new ItemStack[36];
    
    this.craftingGrid = new ItemStack[9];

    recipes = new ArrayList<Recipe>();
    
    File recipe = new File(dataPath("") + "/recipes");

    for (File fileEntry : recipe.listFiles()) {
      recipes.add(new Recipe(fileEntry.getName()));
    }
    File items = new File(dataPath("") + "/items");
    for (File fileEntry : items.listFiles()) {
      ItemType itemtype = new ItemType(fileEntry.getName());
      itemtype.put();
    }
    File blocks = new File(dataPath("") + "/blocks");
    for (File fileEntry : blocks.listFiles()) {
      BlockType itemtype = new BlockType(fileEntry.getName());
      itemtype.put();
    }
  }


  public void updateCamera() {
    if(!this.dead){ 
      this.yPos += this.gravity*(1f/60);
      this.gravity = 0.35f;
      this.xPosition += this.xPos;
      this.checkCollisions(new PVector(this.xPos, 0,0));
      
      this.yPosition += this.yPos;
      this.checkCollisions(new PVector(0, this.yPos, 0));
      
      this.zPosition += this.zPos;
      this.checkCollisions(new PVector(0, 0, this.zPos));
      
      
      //checkCollisions();
      
      if(frameCount % 60 == 0 && damageCount == 0)this.health += 1;
      
      if(this.health>20)this.health=20;
      
      else if (this.health<=0){
        this.dead = true;
        die.play();
      }
      
      //if (! (isLeft || isRight||isUp||isDown||isShift)) {
  
      //  this.xPos *= 0.7;
  
      //  this.zPos *= 0.7;
      
      this.xPos *= 0.89f;
  
      this.zPos *= 0.89f;
      
  
  
      float yCenter = this.yPosition - cos(this.vDeg);
      float xCenter = this.xPosition -  sin(this.hDeg) * sin(this.vDeg);
      float zCenter = this.zPosition +  cos(this.hDeg) * sin(this.vDeg);
      //println(sqrt(pow(xPos, 2) + pow(zPos, 2)));
  
      if(this.takingDamage)this.damageCount += 1;
      if(this.damageCount >30){
        this.takingDamage = false;
        this.damageCount = 0;
      }
  
      stroke(255);
      strokeWeight(7);
      
      camera(this.xPosition, this.yPosition, this.zPosition, xCenter, yCenter, zCenter, 0, 1, 0);
      
  
      //drawingUI = true;
      pushMatrix();
      hint(DISABLE_DEPTH_TEST);
      resetMatrix();
      applyMatrix(originalMatrix);
  
  
      this.drawGui();
  
      hint(ENABLE_DEPTH_TEST);
  
      popMatrix();
      //drawingUI = false;
      noStroke();
    }
    else{
      this.pov -= 0.1f;
      pushMatrix();
      
      hint(DISABLE_DEPTH_TEST);
      resetMatrix();
      applyMatrix(originalMatrix);
      cursor();
      fill(255, 0,0,100);
      noStroke();
      rect(0,0,width, height);
      textAlign(CENTER);
      textSize(100);
      fill(100);
      text("You died!", width/2+12, height/2 - 187);
      fill(255);
      text("You died!", width/2, height/2 - 200);
      if(button(width/2-400, height/2, 800, 80, buttonTexture, cbuttonTexture, "Respawn", 28)){
        
        this.dead = false;
        this.health = 20;
        noCursor();
        this.pov = 70;
      }
      hint(ENABLE_DEPTH_TEST);
  
      popMatrix();
      
    }
    
  }

 
    
    
  
  public void drawGui() {
    textAlign(LEFT, TOP);
    if (isUnderwater){
      image(underwater, 0,0,width, height);
      this.yPos *= 0.75f;
    }else if(isUnderlava){
      
      this.takeDamage(3);
      this.yPos *= 0.5f;
      
    }
    if(headUnderlava){
      pushStyle();
      fill(207, 16,32, 249);
      noStroke();
      rect(0,0,width, height);
      popStyle();
    }
    for(int x = 0; x < 20; x+=2){
      int rand;
      
      if(this.health < 6)rand = (int)random(0,12);
      else if(this.health == 20)rand = 12 - constrain((abs(x/2-((frameCount%60)/3))*6),0,12);
      else rand = 0;
      image(healthBack, width/2-364 + x*16, height-128 - rand, 36,36);
      if(this.damageCount > 0 && this.damageCount % 10 >= 4)image(health3, width/2-364 + x*16, height-128 - rand, 36,36);
      if(x<this.health)image(health1, width/2-364 + x*16, height-128 - rand, 36,36);
      
    }
    
    image(gui, width/2-364, height-88, 728, 88); 
    
    if(this.blockDamage >0){
      pushStyle();
      fill(200, 100);
      noStroke();
      rect(width/2-20, height/2+12, 40, 5);

      rect(width/2-20, height/2+12 , (int)map(this.blockDamage, 0, 180, 0, 40), 5);
      
      popStyle();
    }
    fill(255);
    image(indicator, width/2-368 + this.selectedSlot * 80, height-92, 96, 96);

    for (int slot = 0; slot < 9; slot ++) {
      if (player.inventory[slot] != null)player.inventory[slot].drawStack(new PVector(width/2-352 + slot * 80, height-76));
    }
    
    if (debug) {
      textSize(30);
      
      text("FPS: " + f, 30, 50);
      text(this.xPosition + "/ " + this.yPosition + "/ " +this.zPosition, 30, 85);
      text("Speed: " + (sqrt(this.xPos * this.xPos + this.zPos * this.zPos)*f), 30, 120);
      text("Facing: " + degrees(this.hDeg) + "/ " + degrees(this.vDeg), 30, 155);
      text("Graphics: " + PGraphicsOpenGL.OPENGL_RENDERER, 30, 190);
      text("OpenGL version: " + PGraphicsOpenGL.OPENGL_VERSION, 30, 225);
    }

    if (drawingInventory) {
      drawInventory();
    } else point(width/2, height/2);
  }
  
  public void drawInventory() {
    image(overlay, 0, 0, width, width);
    image(inventoryImage, width/2-352, height/2 - 332, 704, 664);
    int inventorySlot = getInventorySlot();
    //draw hotbar
    for (int slot = 0; slot <9; slot ++) {
      if (this.inventory[slot] != null)this.inventory[slot].drawStack(new PVector(width/2-320 + 72*slot, height/2+236));

      if (inventorySlot == slot)image(highlight, width/2-320 + 72*slot, height/2+236, 64, 64);
    }
    //draw inventory
    for (int slot = 9; slot <36; slot ++) {
      if (this.inventory[slot] != null)this.inventory[slot].drawStack(new PVector(width/2-320 + 72*(slot%9), height/2+4 + (72*(int)((slot-9)/9))));

      if (inventorySlot == slot)image(highlight, width/2-320 + 72*(slot%9), height/2+4 + (72*(int)((slot-9)/9)), 64, 64);
    }
    //draw crafting grid
    for (int slot = 0; slot<9; slot ++) {
      if (this.craftingGrid[slot] != null)this.craftingGrid[slot].drawStack(new PVector(width/2+4 + 72*(slot%3), height/2-260 + (72*(int)(slot/3))));
      if (inventorySlot == slot + 36)image(highlight, width/2+4 + 72*(slot%3), height/2-260 + (72*(int)(slot/3)), 64, 64);
    }
    //draw output slot
    if (outputSlot != null)outputSlot.drawStack(new PVector(width/2 + 264, height/2-188));


    if (inventorySlot == 45)image(highlight, width/2 + 264, height/2-188, 64, 64);

    //if holding item
    if (holding != null) {
      holding.drawStack(new PVector(mouseX-32, mouseY-32));
      if (mouseclicked) {

        if (inventorySlot>-1) {
          //if in inventory
          if (inventorySlot < 36) { 
            if (this.inventory[inventorySlot]!=null) {
              //stackable
              if (this.inventory[inventorySlot].itemType == holding.itemType) {
                if (this.inventory[inventorySlot].amount + holding.amount<=64) {
                  this.inventory[inventorySlot].amount += holding.amount;
                  holding =null;
                }
              } else {//swap
                ItemStack stack = new ItemStack(this.inventory[inventorySlot].itemType, this);
                stack.amount = this.inventory[inventorySlot].amount;
                this.inventory[inventorySlot] = holding;
                holding = stack;
              }
            } else {
              this.inventory[inventorySlot] = holding;
              holding =null;
            }
          }
          //if in crafting grid
          else if (inventorySlot < 45) {
            if (craftingGrid[inventorySlot-36]!= null) { 
              //if stackable
              if (this.craftingGrid[inventorySlot-36].itemType == holding.itemType) {
                if (this.craftingGrid[inventorySlot-36].amount + holding.amount<=64) {
                  this.craftingGrid[inventorySlot-36].amount += holding.amount;
                  holding =null;
                }
              }
              //swap
              else {
                ItemStack stack = new ItemStack(this.craftingGrid[inventorySlot-36].itemType, this);
                stack.amount = this.craftingGrid[inventorySlot-36].amount;
                this.craftingGrid[inventorySlot-36] = holding;
                holding = stack;
              }
            } else {
              this.craftingGrid[inventorySlot-36] = holding;
              holding =null;
            }
            checkSlots();
          }
          mouseclicked = false;
        }
      }
    } else {
        //if not holding item
      if (mouseclicked) {

        if (inventorySlot>-1) {
          //if in inventory
          if (inventorySlot <36) { 
            holding =this.inventory[inventorySlot];
            this.inventory[inventorySlot] = null;
            mouseclicked = false;
          
          } else if (inventorySlot == 45) {
            //if in crafting grid
            holding = outputSlot;
            outputSlot = null;
            
            if(holding != null){
              for (int slot = 0; slot < 9; slot ++) {
                ItemStack stack = craftingGrid[slot];
                if (stack!= null) {
                  if (stack.amount > 1)stack.amount -= 1;
                  else craftingGrid[slot] = null;
                }
              }
              checkSlots();
            }
          } else {
            holding =this.craftingGrid[inventorySlot-36];
            this.craftingGrid[inventorySlot-36] = null;
            checkSlots();
          }
        
          mouseclicked = false;
        }
      }
    }
  }
  
  
  
  
  public void checkCollisions(PVector vel){
    
    float xPosition = this.xPosition;
    float yPosition = this.yPosition;
    float zPosition = this.zPosition;
    for(int x = floor(this.xPosition - this.hitboxWidth/2); x < xPosition + this.hitboxWidth/2; x++){
      //println(x);
      for(int y = floor(this.yPosition); y < yPosition +this.hitboxHeight; y++){
        for(int z = floor(this.zPosition - this.hitboxLength/2); z < zPosition + this.hitboxLength/2; z++){
          
          //point(x,y,z);
          int xPos = floor(x);
          int yPos = floor(y);
          int zPos = floor(z);
          Block block = c.getBlockAt(xPos, yPos, zPos);
          if(block != null && !block.isTransparent()){
            if (vel.y < 0){
              this.yPosition = yPos +1+0.01f;
              this.yPos = 0;
            }
            
            if(vel.x >0){
              this.xPosition = xPos-(this.hitboxWidth/2 + 0.0001f);
              this.xPos = 0;
              //this.xPos = 0;
            }
            
            else if(vel.x <0){
              this.xPosition = xPos+1 + (this.hitboxWidth/2 + 0.0001f);
              this.xPos = 0;
              //this.xPos = 0;
            }
            if(vel.z >0){
              this.zPosition = zPos-(this.hitboxLength/2 + 0.0001f);
              this.zPos = 0;
              //this.xPos = 0;
            }
            
            else if(vel.z <0){
              this.zPosition = zPos+1 + (this.hitboxLength/2 + 0.0001f);
              this.zPos = 0;
              //this.xPos = 0;
            }
            
            if(vel.y>0){
              this.onGround = true;
              takeDamage(constrain((int)map(vel.y, 0.2f, 0.85f, 0,20),0,20));
              rotate(PI);
              this.yPosition =yPos  - this.hitboxHeight;
              this.yPos = 0;
              
            }
            
            
          }
          
          
        }
      }
    }
    
    Block block = c.getBlockAt(floor(this.xPosition), floor(this.yPosition), floor(this.zPosition));
    if (block != null && block.blockType == 4){
      this.gravity = 0.6f;
      this.isUnderwater = true;
    }else if (block != null && block.blockType == 9){
      this.headUnderlava = true;
    }
    block = c.getBlockAt(floor(this.xPosition), floor(this.yPosition+1), floor(this.zPosition));
    if(block != null && block.blockType == 9){
      this.gravity = 0.8f;
      this.isUnderlava = true;
    }
  }

  public void checkSlots() {
    boolean correct = false;
    for (Recipe recipe : recipes) {
      if (recipe.compare(craftingGrid)) {
        outputSlot = recipe.output.createCopy();
        correct = true;
      }
    }
    if (!correct)outputSlot = null;
  }
  public void takeDamage(int amount){
    if(!this.takingDamage && amount > 0){
      hurt.play();
      this.health -= amount;
      this.takingDamage = true;
    }
  }
  
  //inventory functions
  public void addToInventory(int drop){
    for (int x = 0; x < this.inventory.length; x++){
      if(this.inventory[x] == null){
        this.inventory[x] = new ItemStack(drop, this);
        return;
      }
      else if (this.inventory[x].itemType == drop){
        if(this.inventory[x].amount<64)this.inventory[x].amount ++;
        else continue;
        return;
      }
    }
  }
  public void addToInventory(int drop, int amount){
    int deposited = amount;
    for (int x = 0; x < this.inventory.length; x++){
      if(this.inventory[x] == null){
        this.inventory[x] = new ItemStack(drop, deposited, this);
        return;
      }
      else if (this.inventory[x].itemType == drop){
        if(this.inventory[x].amount<=64-deposited)this.inventory[x].amount += deposited;
        else{
          int off = 64-this.inventory[x].amount;
          this.inventory[x].amount += off;
          deposited -= off;
        }
        return;
      }
    }
  }
  public void useItem(){
    if(this.inventory[this.selectedSlot].amount > 1){
      this.inventory[this.selectedSlot].amount -= 1;
    }
    else this.inventory[this.selectedSlot] = null;
  }
  public ItemStack getSelectedStack(){
    return this.inventory[this.selectedSlot];
  }
  
  //item functions
  public void BREAK(){
    if(player.getSelectedStack()!= null){
      ItemType item = ItemTypes.get(player.getSelectedStack().itemType);
      this.blockDamage += item.breakingSpeed;
    }else{
      
      this.blockDamage += 1;
    }
      
    
    if(this.blockDamage >= 180)breakBlock();
  }
  
  
  public void PLACE(){
    placeBlock();
  }
  public void PLACELIQUID(){
    placeLiquid();
  }
  
  public void NONE(){
  }
  
  public void PLACETREE(){
    
    int[] coords = findTargetedBlock();
    Chunk chunk = c.getChunkAt(coords[0],coords[1]);
    useItem();
    try{
      chunk.generateTree(coords[3],coords[2],coords[4]);
    }catch(Exception e){
      //its ok
    }
    chunk.betterGenerateMesh();
    player.useItem();
    
  }
  
  public void SHOOTARROW(){
    if(! this.charged){  
      for( ItemStack stack: this.inventory){
        if (stack != null && stack.itemType == 151){
          this.pov -= 0.4f;
          this.bowCharge += 1;
        
        
        
          if(this.bowCharge >= 40){
            this.bowCharge = 0;
            this.charged = true;
            
          }
          break;
        }
      }
    }
  }
  public void ARROW(){
    this.charged = false;
    arrows.add(new Arrow(player.xPosition, player.yPosition -0.2f, player.zPosition, new PVector( - sin(player.hDeg) * sin(player.vDeg)/100, -cos(player.vDeg)/100, cos(player.hDeg) * sin(player.vDeg)/100)));
    int count = 0;
    for( ItemStack stack: this.inventory){
      if (stack != null && stack.itemType == 151){
        if (stack.amount > 1)stack.amount -= 1;
        else player.inventory[count] = null;
        break;
      }
      count++;
    }
    
    this.pov = 70;
  }
  public void KILL(){
    Entity targeted = findTargetedEntity();
    if(targeted != null){
      targeted.die();
      delay(1000);
    }
  }
  
  public void BUCKET(){
    getLiquid();
    delay(100);
  }
}


//public void checkPlayerChunk(){
//  int oldPX =floor(player.xPosition/16);
//  int oldPZ =floor(player.zPosition/16);
//  for(;;delay(0)){
//    if (floor(player.xPosition/16) != oldPX || floor(player.zPosition/16) != oldPZ){
//      playerChunk = c.getChunkAt(floor(player.xPosition/16),floor(player.zPosition/16));
//      println("hi");
//      oldPX = floor(player.xPosition/16);
//      oldPZ = floor(player.zPosition/16);
//    }
//  }
  
  
//}
//Handles raycasting for players targeted block
public void breakBlock(){
  player.blockDamage = 0;
  float yDelta = - cos(player.vDeg)/100;
  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/100;
  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/100;
    
  float yCenter = player.yPosition + yDelta;
  float xCenter = player.xPosition + xDelta;
  float zCenter = player.zPosition +  zDelta;
  
  int counter = 0;
  try{
    while ((c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] == null ||c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16].isLiquid())&&counter < 1200){

      yCenter += yDelta;
      xCenter += xDelta;
      zCenter += zDelta;
      
      counter ++;
      
    }
    if(counter <1200){
      
      Chunk chunk = c.getChunkAt(floor(xCenter/16),floor(zCenter/16));
     
      Block block = chunk.blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ) )*16];
      chunk.removeBlock((floor(xCenter )-(floor(xCenter/16) )*16), floor( yCenter), (floor(zCenter))-(floor(zCenter/16 ) )*16, true);
      BlockType blocktype = BlockTypes.get(block.blockType);
      int drop = blocktype.dropped;

      
      player.addToInventory(drop);

    }
  }catch(Exception e){
    //println(floor(xCenter )-(floor(xCenter/16) )*16);
  }
  
}

public void placeBlock(){
  //float time1 = millis();
  float yDelta = - cos(player.vDeg)/10;
  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/10;
  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/10;
    
  float yCenter = player.yPosition + yDelta;
  float xCenter = player.xPosition + xDelta;
  float zCenter = player.zPosition +  zDelta;
  PVector playerPosition = new PVector(floor(player.xPosition), floor(player.yPosition), floor(player.zPosition));
  PVector playerPositionplusOne = new PVector(floor(player.xPosition), floor(player.yPosition+1.499f), floor(player.zPosition));
  int counter = 0;
  try{
    while (c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] == null){

      yCenter += yDelta;
      xCenter += xDelta;
      zCenter += zDelta;
      counter ++;
      
    }
    while (c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] != null){
      yCenter -= yDelta/100;
      xCenter -= xDelta/100;
      zCenter -= zDelta/100;
      
      
    }
    if(counter <120 &&(! new PVector(floor(xCenter), floor(yCenter), floor(zCenter) ).equals(playerPosition)) &&(! new PVector(floor(xCenter), floor(yCenter), floor(zCenter) ).equals(playerPositionplusOne))){
   
      Chunk chunk = c.getChunkAt(floor(xCenter/16),floor(zCenter/16));
      //Block block = chunk.blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ) )*16];
      if (player.getSelectedStack() != null){
        chunk.setBlock( player.getSelectedStack().itemType,(floor(xCenter )-(floor(xCenter/16) )*16), floor( yCenter), (floor(zCenter))-(floor(zCenter/16 ) )*16, true);
        player.useItem();
      }
      
    }
  }catch(Exception  e){
  }
  
}


public int[] findTargetedBlock(){

  float yDelta = - cos(player.vDeg)/100;
  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/100;
  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/100;
    
  float yCenter = player.yPosition + yDelta;
  float xCenter = player.xPosition + xDelta;
  float zCenter = player.zPosition +  zDelta;
  
  int counter = 0;
  
  int[] nums = new int[5];
  try{
    while (c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] == null){
      
      yCenter += yDelta;
      xCenter += xDelta;
      zCenter += zDelta;
      
      counter ++;
      
    }
    if(counter <1200){
      

      nums[0] = floor(xCenter/16);
      nums[1] = floor(zCenter/16);
     
      nums[2] = floor(xCenter )-(floor(xCenter/16) )*16;
      nums[3] = floor( yCenter);
      nums[4] = (floor(zCenter))-(floor(zCenter/16 ) )*16;

      

    }
    
  }catch(Exception e){
  }
  return nums;
}

public Entity findTargetedEntity(){
  float yDelta = - cos(player.vDeg)/100;
  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/100;
  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/100;
    
  float yCenter = player.yPosition + yDelta;
  float xCenter = player.xPosition + xDelta;
  float zCenter = player.zPosition +  zDelta;
  
  int counter = 0;
  
  while (getEntityAt(new PVector(xCenter, yCenter, zCenter))==null && counter < 300){
    
    yCenter += yDelta;
    xCenter += xDelta;
    zCenter += zDelta;
    
    counter ++;
    
  }
    
  return getEntityAt(new PVector(xCenter, yCenter, zCenter));  
}

public void getLiquid(){
  player.blockDamage = 0;
  float yDelta = - cos(player.vDeg)/100;
  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/100;
  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/100;
    
  float yCenter = player.yPosition + yDelta;
  float xCenter = player.xPosition + xDelta;
  float zCenter = player.zPosition +  zDelta;
  
  int counter = 0;
  try{
    while ((c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] == null ||!c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16].isLiquid())&&counter < 1200){
      
      yCenter += yDelta;
      xCenter += xDelta;
      zCenter += zDelta;
      
      counter ++;
      
    }
    if(counter <1200){
      
      Chunk chunk = c.getChunkAt(floor(xCenter/16),floor(zCenter/16));
     
      Block block = chunk.blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ) )*16];
      chunk.removeBlock((floor(xCenter )-(floor(xCenter/16) )*16), floor( yCenter), (floor(zCenter))-(floor(zCenter/16 ) )*16, true);
      BlockType blocktype = BlockTypes.get(block.blockType);
      int drop = blocktype.dropped;

      player.useItem();
      player.addToInventory(drop);

    }
  }catch(Exception e){
  }
  
}
public void placeLiquid(){
  float yDelta = - cos(player.vDeg)/10;
  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/10;
  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/10;
    
  float yCenter = player.yPosition + yDelta;
  float xCenter = player.xPosition + xDelta;
  float zCenter = player.zPosition +  zDelta;
  PVector playerPosition = new PVector(floor(player.xPosition), floor(player.yPosition), floor(player.zPosition));
  PVector playerPositionplusOne = new PVector(floor(player.xPosition), floor(player.yPosition+1.499f), floor(player.zPosition));
  int counter = 0;
  try{
    while (c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] == null){

      yCenter += yDelta;
      xCenter += xDelta;
      zCenter += zDelta;
      counter ++;
      
    }
    while (c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] != null){
      yCenter -= yDelta/100;
      xCenter -= xDelta/100;
      zCenter -= zDelta/100;
      
      
    }
    if(counter <120 &&(! new PVector(floor(xCenter), floor(yCenter), floor(zCenter) ).equals(playerPosition)) &&(! new PVector(floor(xCenter), floor(yCenter), floor(zCenter) ).equals(playerPositionplusOne))){
   
      Chunk chunk = c.getChunkAt(floor(xCenter/16),floor(zCenter/16));
      //Block block = chunk.blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ) )*16];
      if (player.getSelectedStack() != null){
        chunk.setBlock( player.getSelectedStack().itemType,(floor(xCenter )-(floor(xCenter/16) )*16), floor( yCenter), (floor(zCenter))-(floor(zCenter/16 ) )*16, true);
        player.useItem();
        player.addToInventory(160);
      }
      
    }
  }catch(Exception  e){
    println("HI");
  }
}
//Reads recipes from file
public class Recipe{
  public int[] grid;
  public ItemStack output;
  
  public Recipe(String filepath){
    String file = "/recipes/"+filepath;
    this.grid = new int[9];
    String[] lines = loadStrings(file);
    output = new ItemStack(Integer.parseInt(lines[1]), Integer.parseInt(lines[2]), player);
    String[] gridIn = split(lines[0], ",");
    for(int x = 0; x<3; x++){
      for(int y = 0; y<3; y++){
        this.grid[x*3 + y] = Integer.parseInt(gridIn[x*3 + y]);
      }
    }
  }
  public String toString(){
    return ("Recipe, returns " + output.itemType + ", " + output.amount);
  }
  public boolean compare(ItemStack[] grid){
    for(int slot = 0 ; slot<9; slot++){
      if(grid[slot] != null){
        if(grid[slot].itemType!=this.grid[slot]){
          return false;
        }
      }
      else if(this.grid[slot] !=0){
        return false;
        
      }
    }
    return true;
  }
}
//Class for handling the world, such as chunk loading
//import java.util.*;
public class World {
  public ArrayList<Chunk> chunkMemory;



  public int size;
  public String status;
  PImage texture = loadImage("/textures/texture_atlas.png");

  Hashtable<Integer, PVector[]> textureCoords = new Hashtable<Integer, PVector[]>();

  // coords are 1 + 130(x-1), 1 + 130(y-1)





  public World(int size) {

    loadStatus = "Creating world";
    println(loadStatus);
    this.size = size;
    

    chunkMemory = new ArrayList<Chunk>();

    

    textureCoords.put(1, new PVector[]{new PVector(0, 0), new PVector (16, 0), new PVector(32, 0)});//grass
    textureCoords.put(2, new PVector[]{new PVector(48, 0), new PVector (48, 0), new PVector(48, 0)});//stone
    textureCoords.put(3, new PVector[]{new PVector(80, 0), new PVector(64, 0), new PVector(80, 0)});//log
    textureCoords.put(4, new PVector[]{new PVector(96, 0), new PVector(96, 0), new PVector(96, 0)});//water
    textureCoords.put(5, new PVector[]{new PVector(16, 16), new PVector(16, 16), new PVector(16, 16)});//sand
    textureCoords.put(6, new PVector[]{new PVector(32, 16), new PVector(32, 16), new PVector(32, 16)});//oakplank
    textureCoords.put(7, new PVector[]{new PVector(48, 16), new PVector(64, 16), new PVector(32, 0)});//snow
    textureCoords.put(8, new PVector[]{new PVector(80, 16), new PVector(80, 16), new PVector(80, 16)});//gravel
    textureCoords.put(9, new PVector[]{new PVector(176, 0), new PVector(176, 0), new PVector(176, 0)});//lava
    textureCoords.put(10, new PVector[]{new PVector(0, 16), new PVector (0, 16), new PVector(0, 16)});//diamondore
    textureCoords.put(11, new PVector[]{new PVector(96, 16), new PVector(96, 16), new PVector(96, 16)});//leaves
    textureCoords.put(12, new PVector[]{new PVector(112, 0), new PVector(112, 0), new PVector(112, 0)});//poppy flower
    textureCoords.put(13, new PVector[]{new PVector(128, 0), new PVector(128, 0), new PVector(128, 0)});//dandelion flower
    textureCoords.put(14, new PVector[]{new PVector(144, 0), new PVector(144, 0), new PVector(144, 0)});//grass flower
    textureCoords.put(15, new PVector[]{new PVector(160, 0), new PVector(160, 0), new PVector(160, 0)});//cobblestone
    textureCoords.put(16, new PVector[]{new PVector(32, 0), new PVector (32, 0), new PVector(32, 0)});//dirt
    textureCoords.put(17, new PVector[]{new PVector(0, 32), new PVector (0, 32), new PVector(0, 32)});//ironore
    textureCoords.put(18, new PVector[]{new PVector(16, 32), new PVector (16, 32), new PVector(16, 32)});//goldore
    textureCoords.put(19, new PVector[]{new PVector(112, 16), new PVector (112, 16), new PVector(112, 16)});//blueorchid
    textureCoords.put(20, new PVector[]{new PVector(128, 16), new PVector(128, 16), new PVector(128, 16)});//daisy
    textureCoords.put(21, new PVector[]{new PVector(32, 32), new PVector (32, 32), new PVector(32, 32)});//whiteconcretepowder
    textureCoords.put(22, new PVector[]{new PVector(48, 32), new PVector (48, 32), new PVector(48, 32)});//blackconcretepowder
    textureCoords.put(23, new PVector[]{new PVector(64, 32), new PVector (64, 32), new PVector(64, 32)});//redconcretepowder
    textureCoords.put(24, new PVector[]{new PVector(80, 32), new PVector (80, 32), new PVector(80, 32)});//blueconcretepowder
    textureCoords.put(25, new PVector[]{new PVector(96, 32), new PVector (96, 32), new PVector(96, 32)});//yellowconcretepowder

    
    //for (int x = 0;x < chunkMemory.length; x++){
    //   for (int y = 0;y < chunkMemory.length; y++){
    //     Chunk c = chunkMemory[x][y];
    //     for (int a = 0;a<c.blocks.length;a++){
    //       for(int b = 0;b<c.blocks[a][0].length;b++){
    //         if(heightMap[a + x*16][b + y*16] > 86){
    //           for(int h = 86; h<heightMap[a + x*16][b + y*16];h++){
    //             c.setBlock(4, a, h, b, false);
    //           }
    //         }
    //         for(int h = heightMap[a + x*16][b + y*16]; h<heightMap[a + x*16][b + y*16]+4;h++){


    //           if(heightMap[a + x*16][b + y*16] <38){
    //             c.setBlock(7, a, h, b, false);
    //           }
    //           else if(heightMap[a + x*16][b + y*16] <55){
    //             c.setBlock(8, a, h, b, false);
    //           }
    //           else if(heightMap[a + x*16][b + y*16] <81){
    //             c.setBlock(1, a, h, b, false);
    //           }

    //           else c.setBlock(5, a, h, b, false);

    //             //println(noise(((x*16) + a)/10, (128-h)/10, ((y*16) + b)/10));



    //         }
    //         for(int h = heightMap[a + x*16][b + y*16]+4; h<128;h++){
    //           if (caveMap[a + x*16][h][b + y*16] > 0.25){

    //             if (caveMap[a + x*16][h][b + y*16] > 0.2699 && caveMap[a + x*16][h][b + y*16] < 0.27){
    //               c.setBlock(10, a, h, b, false);
    //             }
    //             else{

    //               c.setBlock(2, a, h, b, false);
    //             }
    //             //println(noise(((x*16) + a)/10, (128-h)/10, ((y*16) + b)/10));
    //           }


  }

  public void drawWorld() {
    ArrayList<Chunk> chunks= new ArrayList<Chunk>(this.chunkMemory);
    
    for (Chunk x : chunks) {
      
      x.betterDrawChunk();
      
    }
  }
  
  public PImage getTexture() {
    return this.texture;
  }

  public Chunk getChunkAt(int x, int z) {
    //println(this.chunkMemory);
    ArrayList<Chunk> chunks= new ArrayList<Chunk>(this.chunkMemory);
    for(Chunk ch: chunks){
      
      if(ch.lowestZPos == z*16 && ch.lowestXPos == x*16){

        return ch;
        
      }
    }

    return null;

  }
  
  public Block getBlockAt(int x, int y, int z){
    
    Chunk chunk = this.getChunkAt(floor(x/16.0f), floor(z/16.0f));
    try{
      return chunk.blocks[x-floor(x/16.0f)*16][y][z-floor(z/16.0f)*16];
    }
    catch(Exception e){
      //println((x-floor(x/16.0)*16) + ", " + y + ", " + (z-floor(z/16.0)*16));
      return null;
    }
      
    
  }
  
  public int getHighestBlockAt(int x, int z){
    return 128-((int)map(noise(((x)/75.0f), (z)/75.0f), 0, 1, 5, 100));
  }
}



public void generateMeshes() {
  for (Chunk c : c.chunkMemory) {
    c.betterGenerateMesh();
  }
}

public void checkChunks() {

  for (;; delay(50)) {
    

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
    

    for (int s = 0; s<(WORLDSIZE+1)/2; s++) {
      for (int x = 0; x<s+1; x++) {
        int y = s-x;
        
        Chunk dummy = c.getChunkAt((px) + x, (pz)+y) ;
        if(dummy== null){
          Chunk newChunk = new Chunk((px + x)*16, 0, (pz + y)*16, c);
          decorateChunk(newChunk);

          regenerate.add(newChunk);
          c.chunkMemory.add(newChunk);
          //println(regenerate);


          Chunk chunk = c.getChunkAt(px+x, pz+y-1);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px+x, pz+y+1);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px+x+1, pz+y);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px+x-1, pz+y);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
        }
      }

      for (int x = 0; x<s+1; x++) {
        int y = s-x;
        
        Chunk dummy = c.getChunkAt((px) + y, (pz)-x) ;
        if(dummy== null){
          Chunk newChunk = new Chunk((px + y)*16, 0, (pz -x)*16, c);
          decorateChunk(newChunk);

          regenerate.add(newChunk);
          c.chunkMemory.add(newChunk);
          //println(regenerate);


          Chunk chunk = c.getChunkAt(px+y, pz-x-1);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px+y, pz-x+1);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px+y+1, pz-x);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px+y-1, pz-x);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
        }
      }

      for (int x = 0; x<s+1; x++) {
        int y = s-x;
        
        Chunk dummy = c.getChunkAt((px) - x, (pz)-y) ;
        if(dummy== null){
          Chunk newChunk = new Chunk((px - x)*16, 0, (pz - y)*16, c);
          decorateChunk(newChunk);

          regenerate.add(newChunk);
          c.chunkMemory.add(newChunk);
          //println(regenerate);


          Chunk chunk = c.getChunkAt(px-x, pz-y-1);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px-x, pz-y+1);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px-x+1, pz-y);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px-x-1, pz-y);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
        }
      }

      for (int x = 0; x<s+1; x++) {
        int y = s-x;
        
        Chunk dummy = c.getChunkAt((px) - y, (pz)+x) ;
        if(dummy== null){
          Chunk newChunk = new Chunk((px - y)*16, 0, (pz +x)*16, c);
          decorateChunk(newChunk);

          regenerate.add(newChunk);
          c.chunkMemory.add(newChunk);
          //println(regenerate);


          Chunk chunk = c.getChunkAt(px-y, pz+x-1);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px-y, pz+x+1);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px-y+1, pz+x);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
          }
          
          chunk = c.getChunkAt(px-y-1, pz+x);
          if(chunk != null){  
            if (! regenerate.contains(chunk)) {
              regenerate.add(chunk);
            }
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
enum WorldType{
  NORM,
  FLAT,
  EXTREME,
  ISLANDS
  
}
boolean nature = true;
boolean caves = true;
WorldType type = WorldType.NORM;
public void decorateChunk(Chunk chunk){
  switch(type){
    case NORM:
      chunk.decorate(nature);
      break;
    case FLAT:
      chunk.decorateFlat();
      break;
    case EXTREME:
      WATERLEVEL = 110;
      chunk.decorateExtreme(nature);
      break;
    case ISLANDS:
      WATERLEVEL = 53;
      chunk.decorateIsland(nature);
    
  }
}
  public void settings() {  fullScreen(P3D);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RaymonGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
