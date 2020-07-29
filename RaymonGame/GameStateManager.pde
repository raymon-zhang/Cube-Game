
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
   
    perspective(PI/3f, float(width)/float(height), 0.01f, 1000f);
    
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
color randcolor = color(random(0, 255), random(0, 255), random(255));
public void handleError(Exception e){
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
  println(e);
  noLoop();
  
  
}

void loadThread(){
  
  
  c = new World(WORLDSIZE);
  
  thread("checkChunks");
  thread("checkMouseClicked");
  delay(10000);
  state = GameState.PLAYING_GAME;
}

void drawLoading(){
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
void drawMenu(){

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
void drawMenuStart(){
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
void fakeLoadThread(){
  
  
  
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
  
