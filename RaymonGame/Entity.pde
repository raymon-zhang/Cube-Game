public class Entity{
  float xPos, yPos, zPos;
  float vDeg, hDeg;
  float xPosition, yPosition, zPosition;
  
  boolean onGround = false;
  
  PShape shape;
  
  public Entity(float xPos, float yPos, float zPos) {

    this.xPos = 0;
    this.yPos = 0;
    this.zPos = 0;
    this.hDeg = 0;
    this.vDeg = 0;
    this.xPosition = xPos;
    this.yPosition = yPos;
    this.zPosition = zPos;
  }
  
  public void update(){
    this.xPosition += this.xPos;
    this.checkCollisions(new PVector(this.xPos, 0,0));
    
    this.yPosition += this.yPos;
    this.checkCollisions(new PVector(0, this.yPos, 0));
    
    this.zPosition += this.zPos;
    this.checkCollisions(new PVector(0, 0, this.zPos));
    
    this.xPos *= 0.89;

    this.zPos *= 0.89;
    
    this.drawShape();
  }
  
   
  public void checkCollisions(PVector vel){
    float xPosition = this.xPosition;
    float yPosition = this.yPosition;
    float zPosition = this.zPosition;
    for(float x = this.xPosition - 0.25; x <= xPosition + 0.25; x+=0.5){
      //println(x);
      for(float y = this.yPosition; y <= yPosition +1.5; y+= 1.499){
        for(float z = this.zPosition - 0.25; z <= zPosition + 0.25; z+=0.5){
          
          int xPos = floor(x);
          int yPos = floor(y);
          int zPos = floor(z);
          Block block = c.getBlockAt(xPos, yPos, zPos);
          if(block != null && !block.isTransparent()){
            if(vel.x >0){
              this.xPosition = xPos-0.2501;
              this.xPos = 0;
              //this.xPos = 0;
            }
            
            else if(vel.x <0){
              this.xPosition = xPos+1 + 0.2501;
              this.xPos = 0;
              //this.xPos = 0;
            }
            if(vel.z >0){
              this.zPosition = zPos-0.2501;
              this.zPos = 0;
              //this.xPos = 0;
            }
            
            else if(vel.z <0){
              this.zPosition = zPos+1 + 0.2501;
              this.zPos = 0;
              //this.xPos = 0;
            }
            
            if(vel.y>0){
              this.onGround = true;
              this.yPosition =yPos  - 1.5;
              this.yPos = 0;
              
            }
            
            
          }
          
        }
      }
    }
    
    
    
  }
  
  public void drawShape(){
    pushMatrix();
    
    translate(this.xPosition, this.zPosition);
    rotate(this.hDeg);
    shape(shape);
    
    popMatrix();
    
    
  }
  
  
}
