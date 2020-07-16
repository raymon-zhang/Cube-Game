//Exteds entity class, handles player features
public class Player extends Entity{

  int selectedSlot;
  
  int blockDamage;

  boolean dead = false;
  public ItemStack[] inventory, craftingGrid;
  public ItemStack outputSlot;

  public ArrayList<Recipe> recipes;

  public ItemStack holding = null;
  

  public Player(float xPos, float yPos, float zPos) {
    super(xPos, yPos, zPos);
    this.selectedSlot = 0;
    
    
    perspective(PI/3f, float(width)/float(height), 0.01f, 1000f);

    this.inventory = new ItemStack[36];
    this.inventory[1] = new ItemStack(104, this);
    this.inventory[2] = new ItemStack(150, this);
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
      
      if(frameCount % 60 == 0)this.health += 1;
      
      if(this.health>20)this.health=20;
      
      else if (this.health<=0)this.dead = true;
      
      //if (! (isLeft || isRight||isUp||isDown||isShift)) {
  
      //  this.xPos *= 0.7;
  
      //  this.zPos *= 0.7;
      
      this.xPos *= 0.89;
  
      this.zPos *= 0.89;
      
  
  
      float yCenter = this.yPosition - cos(this.vDeg);
      float xCenter = this.xPosition -  sin(this.hDeg) * sin(this.vDeg);
      float zCenter = this.zPosition +  cos(this.hDeg) * sin(this.vDeg);
      //println(sqrt(pow(xPos, 2) + pow(zPos, 2)));
  
  
  
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
        popStyle();
      }
      hint(ENABLE_DEPTH_TEST);
  
      popMatrix();
      
    }
    
  }

  public void drawGui() {
    textAlign(LEFT, TOP);
    if (isUnderwater){
      image(underwater, 0,0,width, height);
      this.yPos *= 0.75;
    }
    for(int x = 0; x < 10; x++){
      image(healthBack, width/2-364 + x*32, height-128, 36,36);
      
    }
    for(int x = 0; x < this.health; x+=2){
      image(health1, width/2-364 + x*16, height-128, 36,36);
      
    }
    image(gui, width/2-364, height-88, 728, 88); 
    
    if(this.blockDamage >0){
      pushStyle();
      fill(200, 100);
      noStroke();
      rect(width/2-20, height/2+12, 40, 5);

      rect(width/2-20, height/2+12 , this.blockDamage, 5);
      
      popStyle();
    }
    
    image(indicator, width/2-368 + this.selectedSlot * 80, height-92, 96, 96);

    for (int slot = 0; slot < 9; slot ++) {
      if (player.inventory[slot] != null)player.inventory[slot].drawStack(new PVector(width/2-352 + slot * 80, height-76));
    }

    if (debug) {
      textSize(30);
      text("FPS: " + f, 30, 50);
      text(this.xPosition + ", " + this.yPosition + ", " +this.zPosition, 30, 85);
      text("Speed: " + (sqrt(this.xPos * this.xPos + this.zPos * this.zPos)*f), 30, 120);
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
              this.yPosition = yPos +1+0.01;
              this.yPos = 0;
            }
            
            if(vel.x >0){
              this.xPosition = xPos-(this.hitboxWidth/2 + 0.0001);
              this.xPos = 0;
              //this.xPos = 0;
            }
            
            else if(vel.x <0){
              this.xPosition = xPos+1 + (this.hitboxWidth/2 + 0.0001);
              this.xPos = 0;
              //this.xPos = 0;
            }
            if(vel.z >0){
              this.zPosition = zPos-(this.hitboxLength/2 + 0.0001);
              this.zPos = 0;
              //this.xPos = 0;
            }
            
            else if(vel.z <0){
              this.zPosition = zPos+1 + (this.hitboxLength/2 + 0.0001);
              this.zPos = 0;
              //this.xPos = 0;
            }
            
            if(vel.y>0){
              this.onGround = true;
              this.health -= constrain((int)map(vel.y, 0.15, 0.85, 0,20),0,20);
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
            this.gravity = 0.6;
            isUnderwater = true;
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
  
  
  
  
  //item functions
  public void BREAK(){
    if(player.inventory[player.selectedSlot]!= null){
      ItemType item = ItemTypes.get(player.inventory[player.selectedSlot].itemType);
      this.blockDamage += item.breakingSpeed;
    }else{
      
      this.blockDamage += 1;
    }
      
    
    if(this.blockDamage >= 40)breakBlock();
  }
  public void PLACE(){
    placeBlock();
  }
  public void MOVEFORWARD(){
    this.xPos = 0.1;
  }
  public void NONE(){
  }
  
  public void PLACETREE(){
    
      int[] coords = findTargetedBlock();
      Chunk chunk = c.getChunkAt(coords[0],coords[1]);
    try{
      chunk.generateTree(coords[3],coords[2],coords[4]);
    }catch(Exception e){
      //its ok
    }
      chunk.betterGenerateMesh();
    
    
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
    return false;
  }
  return false;
}
