public class Arrow extends Entity{
  
  PVector vel;
  Boolean onGround = false;
  float pVDeg;
  public Arrow(float xPos, float yPos, float zPos, PVector vel){
    super(xPos, yPos, zPos);
    bowSound.play();
    this.vel = vel.setMag(0.45);
    
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
    
    this.shape.vertex(2.5/16.0, 0, 0, 0, 0);
    this.shape.vertex(2.5/16.0, 0, 16/16.0, 16, 0);
    this.shape.vertex(2.5/16.0, 5/16.0, 16/16.0, 16, 5);
    this.shape.vertex(2.5/16.0, 5/16.0, 0, 0, 5);
    this.shape.vertex(2.5/16.0, 0, 0, 0, 0);
    this.shape.vertex(2.5/16.0, 5/16.0, 16/16.0, 16, 5);
    
    this.shape.vertex(0, 2.5/16.0, 0, 0, 0);
    this.shape.vertex(5/16.0, 2.5/16.0, 0, 0, 5);
    this.shape.vertex(5/16.0, 2.5/16.0, 16/16.0, 16, 5);
    this.shape.vertex(0, 2.5/16.0, 16/16.0, 16, 0);
    this.shape.vertex(0, 2.5/16.0, 0, 0, 0);
    this.shape.vertex(5/16.0, 2.5/16.0, 16/16.0, 16, 5);
    
    this.shape.vertex(0, 0, 1/16.0, 0, 5);
    this.shape.vertex(5/16.0, 0, 1/16.0, 5, 5);
    this.shape.vertex(5/16.0, 5/16.0, 1/16.0, 5, 10);
    this.shape.vertex(0, 5/16.0, 1/16.0, 0, 10);
    this.shape.vertex(0, 0, 1/16.0, 0, 5);
    this.shape.vertex(5/16.0, 5/16.0, 1/16.0, 5, 10);
    
    if(degrees(this.hDeg)%180 > 45 && degrees(this.hDeg)%180 <135){
      this.shape.translate(5.5/16.0, -1/16.0, -5.5/16.0);
      this.hitboxWidth = 1;
      this.hitboxHeight = 3/16.0;
      this.hitboxLength = 1/16.0;
      
    }else{
      this.hitboxWidth = 1/16.0;
      this.hitboxHeight = 3/16.0;
      this.hitboxLength = 16/16.0;
      this.shape.translate(-2/16.0, -1/16.0, 0);
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
