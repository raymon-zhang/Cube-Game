public class Monster extends Entity{
  int bowCharge;
  PShape arms;
  public Monster(float xPos, float yPos, float zPos){
    super(xPos, yPos, zPos);
    this.hitboxWidth = 0.5;
    this.hitboxHeight = 2;
    this.hitboxLength = 0.5;
    this.bowCharge = 0;
    this.shape = createShape();
    this.shape.beginShape(TRIANGLE);
    this.shape.noStroke();
    this.shape.texture(monster);
    this.createRectPrism(new PVector(0,0,0), new PVector(8/16.0, 8/16.0, 8/16.0), new PVector(8,8), new PVector(8, 8), new PVector(8,8));
    this.createRectPrism(new PVector(0/16.0, 8/16.0, 2/16.0), new PVector(8/16.0, 12/16.0, 4/16.0), new PVector(48, 16), new PVector(4, 4), new PVector(8, 12));
    
    this.shape.endShape();
    
    this.legs = createShape();
    this.legs.beginShape(TRIANGLE);

    this.legs.noStroke();
    this.legs.texture(monster);
    this.createShapeOnShape(this.legs, new PVector(0,0,-1/16.0), new PVector(2/16.0, 12/16.0, 2/16.0), new PVector(33, 12), new PVector(2,2), new PVector(2,12));
    this.legs.endShape();
    
    this.arms = createShape();
    this.arms.beginShape(TRIANGLE);

    this.arms.noStroke();
    this.arms.texture(monster);
    this.createShapeOnShape(this.arms, new PVector(-2/16.0, 0, -1/16.0), new PVector(2/16.0, 12/16.0, 2/16.0), new PVector(27, 12), new PVector(2,2), new PVector(2, 12));
    //this.createShapeOnShape(this.arms, new PVector(8/16.0, 0, -1/16.0), new PVector(2/16.0, 12/16.0, 2/16.0), new PVector(27, 12), new PVector(2,2), new PVector(2, 12));
    this.arms.endShape();
  }
  
  public void drawShape(){
    pushMatrix();
    //println("hi");
    
    pushStyle();
    tint(255, 0,0);
    noStroke();
    
    //go to position
    translate(this.xPosition, this.yPosition, this.zPosition);
    
    rotateY(TWO_PI-this.hDeg);
    translate(- this.hitboxWidth/2, 0, -this.hitboxLength/2);
    
    
    pushMatrix();
    shape(this.shape);
    
    //draw first arm, rotate outward
    translate(0, 8/16.0, 4/16.0);
    rotateX(radians(80));
    rotate(-radians(10), 0, 0, 1);
    shape(this.arms);
    //draw second arm, rotate left
    rotate(radians(10), 0, 0, 1);
    pushMatrix();
    translate(10/16.0, 0, 0);
    rotate(radians(20), 0, 0, 1);
    shape(this.arms);
    popMatrix();
    
    //draw bow, rotate upright
    translate(0, 12/16.0, 0);
    rotateX(-radians(80));
    translate(3/16.0, 0, -1/16.0);
    rotate(radians(10), 0, 0, 1);
    shape(bowShape);
    popMatrix();
    //draw legs
    translate(0, this.hitboxHeight, 0);
    rotate(this.dDeg, 0, 0, 1);
    translate(0, -this.hitboxHeight, 0);
    translate(1/16.0, 20/16.0, 4/16.0);
    rotateX(radians(this.legRotation));
    shape(this.legs);
    
    translate(4/16.0, 0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    popStyle();
    popMatrix();
    
    
  
  }
  public void update(){
    if(! this.dead){
    //println(walking);
      if (! debug){
      
        
        if(dist(this.xPosition, this.zPosition, player.xPosition, player.zPosition)> 16){
          this.wander();
          this.bowCharge = 0;
        }else if(dist(this.xPosition, this.zPosition, player.xPosition, player.zPosition)< 5){
          delta = new PVector(-(this.xPosition - player.xPosition), -(this.zPosition - player.zPosition));
          this.hDeg = delta.heading() - PI/2;
          //delta = new PVector(sin(PI/2-this.hDeg)/10,cos(PI/2-this.hDeg)/10).setMag(0.06); 
          this.xPos = 0;
      
          this.zPos = 0;
          
          
          this.bowCharge += 1;
          if (this.bowCharge > 40){
            this.bowCharge = 0;
            arrows.add(new MonsterArrow(this.xPosition, this.yPosition, this.zPosition, new PVector(player.xPosition - this.xPosition, player.yPosition - this.yPosition, player.zPosition - this.zPosition)));
          }
        }else{ 
          if(abs(this.legRotation) >= 35)this.legDirection = -this.legDirection;
          this.legRotation += this.legDirection;
          delta = new PVector(-(this.xPosition - player.xPosition), -(this.zPosition - player.zPosition));
          delta.setMag(0.04);
          this.hDeg = delta.heading() - PI/2;
          this.xPos = delta.x;
          this.zPos = delta.y;
          this.bowCharge += 1;
          if (this.bowCharge > 40){
            this.bowCharge = 0;
            arrows.add(new MonsterArrow(this.xPosition, this.yPosition, this.zPosition, new PVector(player.xPosition - this.xPosition, player.yPosition - this.yPosition, player.zPosition - this.zPosition)));
          }
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
      
      this.drawShape();
      
      //this.xPos *= 0.89;as
  
      //this.zPos *= 0.89;
      
      
      
    }else{
      this.deadCount += 1;
      this.shape.translate(0, -this.hitboxHeight, 0);
      this.shape.rotate(radians(5), 0, 0, 1);
      this.shape.translate(0, this.hitboxHeight, 0);
      this.dDeg += radians(5);
      
      //print("die");
      if(this.deadCount > 18)deadentities.remove(this);
      this.drawShape();
      
    }
    
  }
  public void wander(){
    if(this.txPos == 0 && this.tzPos == 0){
      this.xPos = this.zPos = 0;
      this.goToLocation(new PVector(player.xPosition + random(-100, 100), player.zPosition + random(-100, 100)));
    }
    if(abs(this.targetedPosition.x- this.xPosition ) <= 2.0 && abs(this.targetedPosition.y - this.zPosition) <= 2.0){
      //println("hi");
      this.walking = false;
      this.legRotation = 0;
      this.xPos = 0;
      this.zPos = 0;  
      this.goToLocation(new PVector(player.xPosition + random(-100, 100), player.zPosition + random(-100, 100)));
      
    }else{
      if(abs(this.legRotation) >= 35)this.legDirection = -this.legDirection;
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
  
    
  
  
  
}
