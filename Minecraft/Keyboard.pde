boolean isLeft, isRight, isUp, isDown, isSpace, isShift; 
float playerSpeed = 0.1;

void keyPressed() {

  if(key == 'w') isUp = true;  
  if(key == 's') isDown = true; 
  if(key == 'a') isLeft = true; 
  if(key == 'd') isRight = true;
  if(key == ' ') isSpace = true; 
  
  if(key == 'q') isShift = true; 
  if(key == 'D')  debug = !debug;
    
    
  
  
  
}
 
void keyReleased() {
  if(key == 'w') isUp = false;  
  if(key == 's') isDown = false; 
  if(key == 'a') isLeft = false; 
  if(key == 'd') isRight = false;
  if(key == ' ') isSpace = false; 
  if(key == 'q') isShift = false; 
  
}
 
void checkKeys(){
  if (isLeft) {
    player.xPos  += sin(PI/2-player.hDeg)/10 * playerSpeed;
    //if (player.zPosition +  cos(PI/2-player.hDeg)/10* playerSpeed >1.5){
    player.zPos += cos(PI/2-player.hDeg)/10* playerSpeed;
      
    //}
    //else{
      
    //}
  }
  if (isRight) {
    player.xPos  -= sin(PI/2-player.hDeg)/10* playerSpeed;
    //if (player.zPosition -cos(PI/2-player.hDeg)/10* playerSpeed>1.5){
    player.zPos -= cos(PI/2-player.hDeg)/10* playerSpeed;
      
    //}
    //else{
      
    //}
  }

  if (isUp) {
    player.xPos-= sin(player.hDeg)/10* playerSpeed;
    //if (player.zPosition +cos(player.hDeg)/10* playerSpeed>1.5){
    player.zPos += cos(player.hDeg)/10* playerSpeed;
      
    //}
    //else{
      
    //}
  }
  if (isDown) {
    player.xPos +=sin(player.hDeg)/10* playerSpeed;
    //if (player.zPosition -cos(player.hDeg)/10* playerSpeed>1.5){
    player.zPos -= cos(player.hDeg)/10* playerSpeed;
    //}
    //else{
      
    //}
  }
  if (isSpace) {
    player.yPos -= 0.1* playerSpeed;
  }
  if (isShift) {
    player.yPos += 0.1* playerSpeed;
  }
  
  //if ( (int) (player.yPosition +1.62)
  
}
