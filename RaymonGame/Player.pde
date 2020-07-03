public class Player {
  float xPos, yPos, zPos;
  float vDeg, hDeg;
  float xPosition, yPosition, zPosition;

  int selectedSlot;

  boolean onGround = false;
  public ItemStack[] inventory, craftingGrid;
  public ItemStack outputSlot;

  public ArrayList<Recipe> recipes;

  public ItemStack holding = null;
  

  public Player(float xPos, float yPos, float zPos) {
    this.selectedSlot = 0;
    this.xPos = 0;
    this.yPos = 0;
    this.zPos = 0;
    this.hDeg = 0;
    this.vDeg = 0;
    this.xPosition = xPos;
    this.yPosition = yPos;
    this.zPosition = zPos;
    perspective(PI/3f, float(width)/float(height), 0.01f, 1000f);

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
    this.xPosition += this.xPos;
    this.yPosition += this.yPos;
    this.zPosition += this.zPos;
    
    if (! (isLeft || isRight||isUp||isDown||isShift)) {

      this.xPos *= 0.7;

      this.zPos *= 0.7;
    } else {
      this.xPos *= 0.89;

      this.zPos *= 0.89;
    }
    
    checkCollisions();
    



    float yCenter = this.yPosition - cos(this.vDeg);
    float xCenter = this.xPosition -  sin(this.hDeg) * sin(this.vDeg);
    float zCenter = this.zPosition +  cos(this.hDeg) * sin(this.vDeg);
    //println(sqrt(pow(xPos, 2) + pow(zPos, 2)));



    stroke(255);
    strokeWeight(5);

    camera(this.xPosition, this.yPosition, this.zPosition, xCenter, yCenter, zCenter, 0, 1, 0);


    drawingUI = true;
    pushMatrix();
    hint(DISABLE_DEPTH_TEST);
    resetMatrix();
    applyMatrix(originalMatrix);


    this.drawGui();

    hint(ENABLE_DEPTH_TEST);

    popMatrix();
    drawingUI = false;
    noStroke();
  }

  public void drawGui() {
    image(gui, width/2-364, height-88, 728, 88); 
    image(indicator, width/2-368 + this.selectedSlot * 80, height-92, 96, 96);

    for (int slot = 0; slot < 9; slot ++) {
      if (player.inventory[slot] != null)player.inventory[slot].drawStack(new PVector(width/2-352 + slot * 80, height-76));
    }

    if (debug) {
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
  
  public void checkCollisions(){
    Chunk playerChunk = c.getChunkAt(floor(player.xPosition/16.0),floor(player.zPosition/16.0));
    if(playerChunk != null){ 
      this.yPos += 0.35f*(1f/60);
      
      if(playerChunk.blocks[floor((this.xPosition )%16)][ floor(this.yPosition + 1.5)][ floor((this.zPosition)%16)] != null ){
        this.yPosition =(int)this.yPosition + 0.5f;
        this.yPos = 0;
        this.onGround = true;
      }
      if(playerChunk.blocks[floor((this.xPosition )%16)][ floor(this.yPosition -1)][ floor((this.zPosition)%16)] != null ){
        float penetration = (int) this.yPosition - this.yPosition;
        if(-penetration < 0.25f){
          this.yPos = 0;
          this.yPosition += (0.25 + penetration);
        }
      }
      if(floor(this.xPosition%16)<15){
        if((playerChunk.blocks[floor((this.xPosition +1)%16)][ floor(this.yPosition)][ floor((this.zPosition)%16)] != null)|| (playerChunk.blocks[floor((this.xPosition +1)%16)][ floor(this.yPosition+1)][ floor((this.zPosition)%16)] != null) ){
          float penetration = this.xPosition - (int)this.xPosition;
          if(!(penetration < 0.75f)){
            this.xPosition -= (penetration - 0.75f);
            this.xPos = 0;
          }
        }
      }else{
        Chunk pX = c.getChunkAt(floor(player.xPosition/16.0)+1,floor(player.zPosition/16.0));
        if((pX.blocks[floor((this.xPosition +1)%16)][ floor(this.yPosition)][ floor((this.zPosition)%16)] != null)|| (pX.blocks[floor((this.xPosition +1)%16)][ floor(this.yPosition+1)][ floor((this.zPosition)%16)] != null) ){
          float penetration = this.xPosition - (int)this.xPosition;
          if(!(penetration < 0.75f)){
            this.xPosition -= (penetration - 0.75f);
            this.xPos = 0;
          }
        }
      
      }
      if(floor(this.xPosition%16)>0){ 
        if((playerChunk.blocks[floor((this.xPosition -1)%16)][ floor(this.yPosition)][ floor((this.zPosition)%16)] != null)|| (playerChunk.blocks[floor((this.xPosition -1)%16)][ floor(this.yPosition+1)][ floor((this.zPosition)%16)] != null) ){
          float penetration = (int)this.xPosition - this.xPosition;
          if((-penetration < 0.25f)){
            this.xPosition += (0.25 + penetration);
            this.xPos = 0;
          }
        }
      }else{
        Chunk nX = c.getChunkAt(floor(player.xPosition/16.0)-1,floor(player.zPosition/16.0));
        if((nX.blocks[floor((this.xPosition -1)%16)][ floor(this.yPosition)][ floor((this.zPosition)%16)] != null)|| (nX.blocks[floor((this.xPosition -1)%16)][ floor(this.yPosition+1)][ floor((this.zPosition)%16)] != null) ){
          float penetration = (int)this.xPosition - this.xPosition;
          if((-penetration < 0.25f)){
            this.xPosition += (0.25 + penetration);
            this.xPos = 0;
          }
        }
        
      }
      if((playerChunk.blocks[floor((this.xPosition)%16)][ floor(this.yPosition)][ floor((this.zPosition + 1)%16)] != null)|| (playerChunk.blocks[floor((this.xPosition)%16)][ floor(this.yPosition+1)][ floor((this.zPosition + 1)%16)] != null) ){
        float penetration = this.zPosition - (int)this.zPosition;
        if(!(penetration < 0.75f)){
          this.zPosition -= (penetration - 0.75f);
          this.zPos = 0;
        }
      }
      if((playerChunk.blocks[floor((this.xPosition)%16)][ floor(this.yPosition)][ floor((this.zPosition - 1)%16)] != null)|| (playerChunk.blocks[floor((this.xPosition)%16)][ floor(this.yPosition+1)][ floor((this.zPosition - 1)%16)] != null) ){
        float penetration = (int)this.zPosition - this.zPosition;
        if((-penetration < 0.25f)){
          this.zPosition += (0.25 + penetration);
          this.zPos = 0;
        }
      }
    }
  }
  
  
  //item functions
  public void BREAK(){
    breakBlock();
  }
  public void PLACE(){
    placeBlock();
  }
  public void MOVEFORWARD(){
    this.xPos = 0.1;
  }
  public void NONE(){
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
