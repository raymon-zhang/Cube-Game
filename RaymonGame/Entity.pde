public class Entity{
  float xPos, yPos, zPos;
  float vDeg, hDeg;
  float xPosition, yPosition, zPosition;
  
  float hitboxWidth, hitboxHeight, hitboxLength;
  
  float legRotation;
  boolean onGround = false;
  boolean walking = false;
  boolean jumping = false;
  
  PShape shape, legs;
  
  PVector targetedPosition = new PVector();
  PVector delta = new PVector();
  int legDirection = 4;
  
  public Entity(float xPos, float yPos, float zPos) {

    this.xPos = 0;
    this.yPos = 0;
    this.zPos = 0;
    this.hDeg = 0;
    this.vDeg = 0;
    this.xPosition = xPos;
    this.yPosition = yPos;
    this.zPosition = zPos;
    this.hitboxWidth = 0.5;
    this.hitboxHeight = 1.5;
    this.hitboxLength = 0.5;
    this.legRotation = 0;
    
  }
  
  public void update(){
    
    //println(walking);
    
    
    if(abs(this.targetedPosition.x- this.xPosition ) <= 1.0 && abs(this.targetedPosition.y - this.zPosition) <= 1.0){
      //println("hi");
      this.walking = false;
      this.legRotation = 0;
      this.xPos = 0;
      this.zPos = 0;
    }else{
      this.xPos = delta.x;
      this.zPos = delta.y;
      if(abs(this.legRotation) >= 45)this.legDirection = -this.legDirection;
      this.legRotation += this.legDirection;
    }
    if (abs(player.xPosition- this.xPosition ) >= 1.0 || abs(player.zPosition - this.zPosition) >= 1.0&& walking == false){
      this.goToLocation(new PVector(player.xPosition, player.zPosition));
      //println("HI");
    }
    
    this.yPos += 0.35f*(1f/60);
    
    if(this.jumping && this.onGround){
      this.onGround = false;
      this.yPos += -7*(1.0/60);
      
      //println("HI");
      this.jumping = false;
      
    }
    
    this.yPosition += this.yPos;
    this.checkCollisions(new PVector(0, this.yPos, 0));
    
    
    this.xPosition += this.xPos;
    this.checkCollisions(new PVector(this.xPos, 0,0));
    
    
    
    this.zPosition += this.zPos;
    this.checkCollisions(new PVector(0, 0, this.zPos));
    
    
    
    this.xPos *= 0.89;

    this.zPos *= 0.89;
    
    this.drawShape();
    
  }
  
   
  public void checkCollisions(PVector vel){
    //stroke(255);
    float xPosition = this.xPosition;
    float yPosition = this.yPosition;
    float zPosition = this.zPosition;
    for(float x = this.xPosition - this.hitboxWidth/2; x <= xPosition + this.hitboxWidth/2; x+=this.hitboxWidth-0.001){
      //println(x);
      for(float y = this.yPosition; y <= yPosition +this.hitboxHeight; y+= this.hitboxHeight - 0.001){
        for(float z = this.zPosition - this.hitboxLength/2; z <= zPosition + this.hitboxLength/2; z+=this.hitboxLength-0.001){
          
          //point(x,y,z);
          int xPos = floor(x);
          int yPos = floor(y);
          int zPos = floor(z);
          Block block = c.getBlockAt(xPos, yPos, zPos);
          if(block != null && !block.isTransparent()){
            
            
            if(vel.x >0){
              this.xPosition = xPos-(this.hitboxWidth/2 + 0.0001);
              this.jumping = true;
              //this.xPos = 0;
            }
            
            else if(vel.x <0){
              this.xPosition = xPos+1 + (this.hitboxWidth/2 + 0.0001);
              this.jumping = true;
              //this.xPos = 0;
            }
            if(vel.z >0){
              this.zPosition = zPos-(this.hitboxLength/2 + 0.0001);
              this.jumping = true;
              //this.xPos = 0;
            }
            
            else if(vel.z <0){
              this.zPosition = zPos+1 + (this.hitboxLength/2 + 0.0001);
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
    
    
    
  }
  
  public void drawShape(){
    pushMatrix();
    //println("hi");

   
    //rotateY(radians(this.hDeg));
    
    translate(this.xPosition, this.yPosition, this.zPosition);
    rotateY(TWO_PI-this.hDeg);
    //println(this.hDeg);
    translate(- this.hitboxWidth/2, 0, -this.hitboxLength/2);
    
    shape(this.shape);
    
    popMatrix();
    
    
  }
  
  
  public void createRectPrism(PVector cornerCoords, PVector lengths, PVector textureCoords, PVector dimensions){
    this.shape.tint(204);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + 8);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z,textureCoords.x - dimensions.x, textureCoords.y + 8);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + 8);
    
    this.shape.tint(153);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + 8);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    
    
    this.shape.tint(204);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + 8, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + dimensions.x + 8, textureCoords.y + 8);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + 8, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    
    this.shape.tint(153);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x + 8 +8, textureCoords.y - 8);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y - 8);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + 8 + 8, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x + 8 + 8, textureCoords.y - 8);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y);
    
    this.shape.tint(255);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y - dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +8, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +8, textureCoords.y);
    this.shape.tint(102);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + 8 + dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y + 8 + dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + 8);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + 8 + dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
  }
  
  public void createShapeOnShape(PShape shape, PVector cornerCoords, PVector lengths, PVector textureCoords, PVector dimensions){
    shape.tint(204);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + 8);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z,textureCoords.x - dimensions.x, textureCoords.y + 8);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + 8);
    
    shape.tint(153);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + 8);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    
    
    shape.tint(204);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + 8, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + dimensions.x + 8, textureCoords.y + 8);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + 8, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    
    shape.tint(153);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x + 8 +8, textureCoords.y - 8);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y - 8);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + 8 + 8, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x + 8 + 8, textureCoords.y - 8);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y);
    
    shape.tint(255);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y - dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +8, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +8, textureCoords.y);
    shape.tint(102);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + 8 + dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + 8, textureCoords.y + 8 + dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + 8);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + 8 + dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + 8, textureCoords.y + 8);
    
    
    
  }
  
  
  public void goToLocation(PVector location){
    this.walking = true;
    delta = new PVector(-(this.xPosition - location.x), -(this.zPosition - location.y));
    delta.setMag(0.04);
    this.hDeg = delta.heading() - PI/2;
       
    this.xPos = delta.x;
    this.zPos = delta.y;
    
    this.targetedPosition = location.copy();
      
  }
  
  
  
  
  
}
