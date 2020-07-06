public class Entity{
  float xPos, yPos, zPos;
  float vDeg, hDeg;
  float xPosition, yPosition, zPosition;
  
  boolean onGround = false;
  
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
    
    float yCenter = this.yPosition - cos(this.vDeg);
    float xCenter = this.xPosition -  sin(this.hDeg) * sin(this.vDeg);
    float zCenter = this.zPosition +  cos(this.hDeg) * sin(this.vDeg);
  }
  
   
  public void checkCollisions(PVector vel){
    
    for(float x = this.xPosition - 0.25; x < this.xPosition + 0.25; x+=0.5){
      for(float y = this.yPosition ; y <= this.yPosition +1.5; y+= 1.5){
        for(float z = this.zPosition - 0.25; z < this.zPosition + 0.25; z+=0.5){
          
          int xPos = floor(x);
          int yPos = floor(y);
          int zPos = floor(z);
          Block block = c.getBlockAt(xPos, yPos, zPos);
          if(block != null && !block.isTransparent()){
            if(vel.y>0){
              this.onGround = true;
              this.yPosition =yPos  - 1.5;
              this.yPos = 0;
              
            }
            
            
          }
          //println(vel.y);
        }
      }
    }
    
    
    
  }
  
  
}
