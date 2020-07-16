//A class that represents all things that have hitboxes, and are not fixed to the world grid.
public class Entity{
  float xPos, yPos, zPos;
  float vDeg, hDeg;
  float xPosition, yPosition, zPosition;
  float gravity = 0.35f;
  
  float hitboxWidth, hitboxHeight, hitboxLength;
  
  float legRotation;
  int health = 20;
  boolean onGround = false;
  boolean walking = false;
  boolean jumping = false;
  
  PShape shape, legs;
  
  PVector targetedPosition = new PVector(this.xPosition, this.zPosition);
  PVector delta = new PVector();
  int legDirection = 5;
  float targetedRotation = PI;
  float txPos, tzPos;
  
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
    
    this.targetedPosition = new PVector(this.xPosition, this.zPosition);
  }
  
  public void update(){
    
    //println(walking);
    if (! debug){
    
      if(abs(this.targetedPosition.x- this.xPosition ) <= 2.0 && abs(this.targetedPosition.y - this.zPosition) <= 2.0){
        //println("hi");
        this.walking = false;
        this.legRotation = 0;
        this.xPos = 0;
        this.zPos = 0;  
        this.goToLocation(new PVector(player.xPosition + random(-100, 100), player.zPosition + random(-100, 100)));
        
      }else{
        if(abs(this.legRotation) >= 45)this.legDirection = -this.legDirection;
        this.legRotation += this.legDirection;
        
      }
      if (abs(this.hDeg - this.targetedRotation) > radians(10)){
        
        if(this.hDeg - this.targetedRotation > radians(10)){
          this.hDeg -= radians(5);
        }
        else if(this.targetedRotation -this.hDeg > radians(10)){
          this.hDeg += radians(5);
        }
      }
      else{
        
        this.xPos = txPos;
        this.zPos = tzPos;
        
      }
    }
    else this.xPos = this.zPos = 0;
    
    this.yPos += gravity*(1f/60);
    
    if(this.jumping && this.onGround){
      this.onGround = false;
      this.yPos += -7*(1.0/60);
      
      //println("HI");
      this.jumping = false;
      
    }
    
    
    
    
    this.xPosition += this.xPos;
    this.checkCollisions(new PVector(this.xPos, 0,0));
    
    
    this.yPosition += this.yPos;
    this.checkCollisions(new PVector(0, this.yPos, 0));
    this.zPosition += this.zPos;
    this.checkCollisions(new PVector(0, 0, this.zPos));
    
    
    
    //this.xPos *= 0.89;

    //this.zPos *= 0.89;
    
    this.drawShape();
    
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
    
    //endShape(CLOSE);
    
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
  
  
  public void createRectPrism(PVector cornerCoords, PVector lengths, PVector textureCoords, PVector dimensions, PVector centerDimensions){
    this.shape.tint(204);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z,textureCoords.x - dimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    
    this.shape.tint(153);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    
    
    this.shape.tint(204);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    
    this.shape.tint(153);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x +centerDimensions.x, textureCoords.y - centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y - centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x +centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x +centerDimensions.x +centerDimensions.x, textureCoords.y - centerDimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    
    this.shape.tint(255);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y - dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +centerDimensions.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +centerDimensions.x, textureCoords.y);
    this.shape.tint(102);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + centerDimensions.y + dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y + dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    this.shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + centerDimensions.y + dimensions.y);
    this.shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
  }
  
  public void createShapeOnShape(PShape shape, PVector cornerCoords, PVector lengths, PVector textureCoords, PVector dimensions, PVector centerDimensions){
    shape.tint(204);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z,textureCoords.x - dimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x - dimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    
    shape.tint(153);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    
    
    shape.tint(204);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + dimensions.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    
    shape.tint(153);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x +centerDimensions.x, textureCoords.y - centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y - centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x +centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x +centerDimensions.x +centerDimensions.x, textureCoords.y - centerDimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y);
    
    shape.tint(255);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y - dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +centerDimensions.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y);
    shape.vertex(cornerCoords.x, cornerCoords.y, cornerCoords.z, textureCoords.x, textureCoords.y - dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y, cornerCoords.z + lengths.z, textureCoords.x +centerDimensions.x, textureCoords.y);
    shape.tint(102);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + centerDimensions.y + dimensions.y);
    
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y + dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x, textureCoords.y + centerDimensions.y);
    shape.vertex(cornerCoords.x, cornerCoords.y + lengths.y, cornerCoords.z, textureCoords.x, textureCoords.y + centerDimensions.y + dimensions.y);
    shape.vertex(cornerCoords.x + lengths.x, cornerCoords.y + lengths.y, cornerCoords.z + lengths.z, textureCoords.x + centerDimensions.x, textureCoords.y + centerDimensions.y);
  }
  
  
  public void goToLocation(PVector location){
    this.walking = true;
    delta = new PVector(-(this.xPosition - location.x), -(this.zPosition - location.y));
    delta.setMag(0.02);
    this.targetedRotation = delta.heading() - PI/2;
       
    this.txPos = delta.x;
    this.tzPos = delta.y;
    
    this.targetedPosition = location.copy();
      
  }
  
  
  
  
  
}
