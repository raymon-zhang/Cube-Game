public class Panda extends Entity{
  
  public Panda(float xPos, float yPos, float zPos){
    super(xPos, yPos, zPos);
    this.hitboxWidth = 1;
    this.hitboxHeight = 1;
    this.hitboxLength = 1;
    this.shape = createShape();
    this.shape.beginShape(TRIANGLE);
    //this.shape.noFill();
    this.shape.noStroke();
    this.shape.texture(panda);
    
    
    this.createRectPrism(new PVector(-0.09375,-0.375,-0.59375), new PVector(1.1875, 0.8125, 1.625), new PVector(26, 55), new PVector(26, 26), new PVector(19, 13));
    this.createRectPrism(new PVector(0.09375, -0.1875, 1.03125), new PVector(0.8125,0.625, 0.5625), new PVector(9, 10), new PVector(9,9), new PVector(13, 10));
    this.createRectPrism(new PVector(0.09375 - 1/8.0, -0.1875-3/16.0, 1.03125 + 5/16.0), new PVector(5/16.0, 4/16.0, 1/16.0), new PVector(36, 4), new PVector(1, 1), new PVector(5, 4));
    this.createRectPrism(new PVector(0.90625 - 3/16.0, -0.1875-3/16.0, 1.03125 + 5/16.0), new PVector(5/16.0, 4/16.0, 1/16.0), new PVector(36, 4), new PVector(1, 1), new PVector(5, 4));
    this.shape.endShape();
    //this.createRectPrism(new PVector(0.2, 0.5, 0.05), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.6, 0.5, 0.05), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.2, 0.5, 0.5), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.6, 0.5, 0.5), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    this.legs = createShape();
    this.legs.beginShape(TRIANGLE);
    //this.shape.noFill();
    this.legs.noStroke();
    this.legs.texture(panda);
    this.createShapeOnShape(this.legs, new PVector(0,0,-0.1875), new PVector(0.375, 0.5625, 0.375), new PVector(1, 1), new PVector(1,1), new PVector(1,1));
    this.legs.endShape();
    
  }
  
  public void drawShape(){
    pushMatrix();
    //println("hi");
    
    pushStyle();
    //rotateY(radians(this.hDeg));
    tint(255, 0,0);
    translate(this.xPosition, this.yPosition, this.zPosition);
    rotateY(TWO_PI-this.hDeg);
    //println(this.hDeg);
    translate(- this.hitboxWidth/2, 0, -this.hitboxLength/2);
    
    
    
    shape(this.shape);
    
    //textSize(0.1);
    //stroke(255);
    //line(0,0,0, 0, -100, 0);
    //text(this.targetedPosition.toString(), 0, -1, 0);
    
    translate(-0.09375, 0.4375, -0.40265);
    rotateX(radians(this.legRotation));
    
    
    shape(this.legs);
    translate(0.8125,0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    rotateX(radians(1*this.legRotation));
    translate(0,0,1.25);
    rotateX(radians(this.legRotation));
    shape(this.legs);
    translate(-0.8125, 0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    popStyle();
    popMatrix();
    
    
  }
  
  
}
