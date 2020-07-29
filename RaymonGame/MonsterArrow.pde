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
        if(this.xPosition > player.xPosition-player.hitboxWidth/2.0 && this.xPosition < player.xPosition +player.hitboxWidth/2.0 && this.yPosition > player.yPosition && this.yPosition < player.yPosition + player.hitboxHeight && zPosition > player.zPosition - player.hitboxLength/2.0 && zPosition < player.zPosition +player.hitboxLength/2.0){
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
        if(this.xPosition > player.xPosition-player.hitboxWidth/2.0 && this.xPosition < player.xPosition +player.hitboxWidth/2.0 && this.yPosition > player.yPosition && this.yPosition < player.yPosition + player.hitboxHeight && zPosition > player.zPosition - player.hitboxLength/2.0 && zPosition < player.zPosition +player.hitboxLength/2.0){
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
