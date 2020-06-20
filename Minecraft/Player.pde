public class Player{
  float xPos, yPos, zPos;
  float vDeg, hDeg;
  float xPosition, yPosition, zPosition;

  public Player(float xPos, float yPos, float zPos){
    this.xPos = 0;
    this.yPos = 0;
    this.zPos = 0;
    this.hDeg = 0;
    this.vDeg = 0;
    this.xPosition = xPos;
    this.yPosition = yPos;
    this.zPosition = zPos;
    
  }
  
  
  public void updateCamera(){
    this.xPosition += this.xPos;
    this.yPosition += this.yPos;
    this.zPosition += this.zPos;
    float yCenter = this.yPosition - cos(this.vDeg);
    float xCenter = this.xPosition -  sin(this.hDeg) * sin(this.vDeg);
    float zCenter = this.zPosition +  cos(this.hDeg) * sin(this.vDeg);
    
    //if (this.xPos > 1){

    //  this.xPos =1;
      
    //}else if (this.xPos < -1){

    //  this.xPos =-1;
      
    //}
    //if (this.zPos > 1){

    //  this.zPos =1;
      
    //}else if (this.zPos < -1){

    //  this.zPos =-1;
      
    //}
    //if (this.yPos > 1){

    //  this.yPos =1;
      
    //}
    //else if (this.yPos < -1){

    //  this.yPos =-1;
      
    //}
    
    if (! (isLeft || isRight||isUp||isDown||isShift||isSpace)){

      this.xPos *= 0.7;
      this.yPos *= 0.7;
      this.zPos *= 0.7;
    }
    else{
      this.xPos *= 0.94;
      this.yPos *= 0.94;
      this.zPos *= 0.94;
    }
    
    //println((this.xPos) + this.zPos);
    //text(String.valueOf(this.xPos/10), 80, -50, 80);
      
    //stroke(255);
    
    //line(0, 0, 0, xCenter, yCenter, zCenter);
    stroke(255);
    strokeWeight(5);
    
    camera(this.xPosition, this.yPosition, this.zPosition, xCenter, yCenter, zCenter, 0, 1, 0);
    perspective(PI/3, 1.777777, this.zPosition/2000, this.zPosition*2000);
    point(xCenter, yCenter, zCenter);
    noStroke();
  }
  
  public PVector getChunkPosition(){
    int x  = (int) this.xPosition/16;
    int y = (int) this.yPosition/16;
    return new PVector(x, y);
  }
  
  
  
  
}
