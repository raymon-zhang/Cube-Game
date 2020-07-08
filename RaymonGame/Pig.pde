public class Pig extends Entity{
  
  public Pig(float xPos, float yPos, float zPos){
    super(xPos, yPos, zPos);
    this.hitboxWidth = 0.8;
    this.hitboxHeight = 0.9;
    this.hitboxLength = 0.9;
    this.shape = createShape();
    this.shape.beginShape(TRIANGLE);
    //this.shape.noFill();
    this.shape.noStroke();
    this.shape.texture(testImage);
    
    
    this.createRectPrism(new PVector(0.2,0.1,0), new PVector(0.6, 0.4, 0.7), new PVector(40, 16), new PVector(16, 16));
    this.createRectPrism(new PVector(0.22, 0, 0.5), new PVector(0.56,0.5, 0.5), new PVector(8, 8), new PVector(8,8)); 
    this.shape.endShape();
    //this.createRectPrism(new PVector(0.2, 0.5, 0.05), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.6, 0.5, 0.05), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.2, 0.5, 0.5), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    //this.createRectPrism(new PVector(0.6, 0.5, 0.5), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    this.legs = createShape();
    this.legs.beginShape(TRIANGLE);
    //this.shape.noFill();
    this.legs.noStroke();
    this.legs.texture(testImage);
    this.createShapeOnShape(this.legs, new PVector(0,0,-0.075), new PVector(0.2, 0.4, 0.15), new PVector(16, 32), new PVector(8,8));
    this.legs.endShape();
    //this.shape.vertex(0,0, 0, 8, 0);
    //this.shape.vertex(0, 0, hitboxLength, 24, 0);
    //this.shape.vertex(0, hitboxHeight, hitboxLength, 24, 8);
    //this.shape.vertex(0, hitboxHeight, 0, 8, 8);
    //this.shape.vertex(0,0, 0, 8, 0);
    //this.shape.vertex(0, hitboxHeight, hitboxLength, 24, 8);

    
    //this.shape.vertex(0,0, 0, 0, 0);
    //this.shape.vertex(hitboxWidth, 0, 0, 8, 0);
    //this.shape.vertex(hitboxWidth, hitboxHeight, 0, 8, 8);
    //this.shape.vertex(0, hitboxHeight, 0, 0, 8);
    //this.shape.vertex(0,0, 0, 0, 0);
    //this.shape.vertex(hitboxWidth, hitboxHeight, 0, 8, 8);
    
    //this.shape.vertex(hitboxWidth,0, 0, 8, 0);
    //this.shape.vertex(hitboxWidth, 0, hitboxLength, 24, 0);
    //this.shape.vertex(hitboxWidth, hitboxHeight, hitboxLength, 24, 8);
    //this.shape.vertex(hitboxWidth, hitboxHeight, 0, 8, 8);
    //this.shape.vertex(hitboxWidth,0, 0, 8, 0);
    //this.shape.vertex(hitboxWidth, hitboxHeight, hitboxLength, 24, 8);
    
    //this.shape.vertex(0,0, hitboxLength, 0, 8);
    //this.shape.vertex(hitboxWidth, 0, hitboxLength, 8, 8);
    //this.shape.vertex(hitboxWidth, hitboxHeight, hitboxLength, 8, 16);
    //this.shape.vertex(0, hitboxHeight, hitboxLength, 0, 16);
    //this.shape.vertex(0,0, hitboxLength, 0, 8);
    //this.shape.vertex(hitboxWidth, hitboxHeight, hitboxLength, 8, 16);
    
    //this.shape.vertex(0,0,0, 8,0);
    //this.shape.vertex(0, 0, hitboxLength, 24, 0);
    //this.shape.vertex(hitboxWidth, 0, hitboxLength, 24, 8);
    //this.shape.vertex(hitboxWidth, 0, 0, 8, 8);
    //this.shape.vertex(0,0,0, 8,0);
    //this.shape.vertex(hitboxWidth, 0, hitboxLength, 24, 8);
    
    
    
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
    
    
    
    translate(0.2, 0.5, 0.125);
    rotateX(radians(this.legRotation));
    
    
    shape(this.legs);
    translate(0.4,0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    rotateX(radians(1*this.legRotation));
    translate(0,0,0.45);
    rotateX(radians(this.legRotation));
    shape(this.legs);
    translate(-0.4, 0,0);
    rotateX(radians(-2*this.legRotation));
    shape(this.legs);
    popMatrix();
    
    
  }
  
  
}
