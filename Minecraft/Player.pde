public class Player {
  float xPos, yPos, zPos;
  float vDeg, hDeg;
  float xPosition, yPosition, zPosition;
  
  int selectedSlot;
  
  public ItemStack[] inventory;
  
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
    
    this.inventory = new ItemStack[9];
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
      this.xPos *= 0.9;
      this.yPos *= 0.9;
      this.zPos *= 0.9;
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
    image(gui, width/2-364 , height-88, 728, 88); 
    image(indicator, width/2-368 + this.selectedSlot * 80, height-92, 96, 96);
    
    for(int slot = 0; slot < player.inventory.length; slot ++){
      if(player.inventory[slot] != null)player.inventory[slot].drawStack(new PVector(width/2-352 + slot * 80, height-76));
    }
    
    if(debug){
      text("FPS: " + f, 30, 50);
      text(this.xPosition + ", " + this.yPosition + ", " +this.zPosition, 30, 85);
      
    }
    
    point(width/2, height/2);

    hint(ENABLE_DEPTH_TEST);

    popMatrix();
    drawingUI = false;
    noStroke();
  }

  
  public PVector getChunkPosition() {
    int x  = (int) this.xPosition/16;
    int y = (int) this.yPosition/16;
    return new PVector(x, y);
  }
}
