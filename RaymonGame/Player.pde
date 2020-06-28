public class Player {
  float xPos, yPos, zPos;
  float vDeg, hDeg;
  float xPosition, yPosition, zPosition;
  
  int selectedSlot;
  
  public ItemStack[] inventory;
  
  public ItemStack holding = new ItemStack(1, this);
  
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
    perspective(PI/3, 1.777777, 0.01f, 1000f);
    
    this.inventory = new ItemStack[36];
    this.inventory[10] = new ItemStack(1, this);
    
  }


  public void updateCamera() {
    this.xPosition += this.xPos;
    this.yPosition += this.yPos;
    this.zPosition += this.zPos;
    float yCenter = this.yPosition - cos(this.vDeg);
    float xCenter = this.xPosition -  sin(this.hDeg) * sin(this.vDeg);
    float zCenter = this.zPosition +  cos(this.hDeg) * sin(this.vDeg);

    

    if (! (isLeft || isRight||isUp||isDown||isShift||isSpace)) {

      this.xPos *= 0.7;
      this.yPos *= 0.7;
      this.zPos *= 0.7;
    } else {
      this.xPos *= 0.89;
      this.yPos *= 0.89;
      this.zPos *= 0.89;
    }
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
  
  public void drawGui(){
    image(gui, width/2-364 , height-88, 728, 88); 
    image(indicator, width/2-368 + this.selectedSlot * 80, height-92, 96, 96);
    
    for(int slot = 0; slot < 9; slot ++){
      if(player.inventory[slot] != null)player.inventory[slot].drawStack(new PVector(width/2-352 + slot * 80, height-76));
    }
    
    if(debug){
      text("FPS: " + f, 30, 50);
      text(this.xPosition + ", " + this.yPosition + ", " +this.zPosition, 30, 85);
      text("Speed: " + (sqrt(this.xPos * this.xPos + this.zPos * this.zPos)*f), 30, 120);
      
    }
    
    if(drawingInventory){
      drawInventory();
    }
    
    else point(width/2, height/2);
    
    
    
  }
  public void drawInventory(){
    image(overlay, 0, 0, width, width);
    image(inventoryImage, width/2-352, height/2 - 332, 704, 664);
    for(int slot = 0; slot <9; slot ++){
      if(this.inventory[slot] != null)this.inventory[slot].drawStack(new PVector(width/2-320 + 72*slot, height/2+236));
    }
    for(int slot = 9; slot <36; slot ++){
      if(this.inventory[slot] != null)this.inventory[slot].drawStack(new PVector(width/2-320 + 72*(slot%9), height/2+4 + (72*(int)((slot-9)/9))));
    }
    if(holding != null){
      holding.drawStack(new PVector(mouseX-32, mouseY-32));
      if(mouseclicked){
        int slot = getInventorySlot();
        if(slot>-1){
          if(this.inventory[slot]!=null){
            if(this.inventory[slot].itemType == holding.itemType){
              if(this.inventory[slot].amount + holding.amount<=64){
                this.inventory[slot].amount += holding.amount;
                holding =null;
              }
            }
            else{
              ItemStack stack = new ItemStack(this.inventory[slot].itemType, this);
              stack.amount = this.inventory[slot].amount;
              this.inventory[slot] = holding;
              holding = stack;
            }
          }
          else{
            this.inventory[slot] = holding;
            holding =null;
          }
          
          mouseclicked = false;
        }
      }
    }
    else{
      if(mouseclicked){
        int slot = getInventorySlot();
        if(slot>-1){
          holding =this.inventory[slot];
          this.inventory[slot] = null;
          mouseclicked = false;
        }
      }
    }
  }
  
  

  

}
