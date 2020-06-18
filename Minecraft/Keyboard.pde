boolean isLeft, isRight, isUp, isDown, isSpace, isShift; 
float playerSpeed = 0.1;

void keyPressed() {
  setMove(key, true);
}
 
void keyReleased() {
  setMove(key, false);
}
 
 
boolean setMove(int k, boolean b) {
  switch (k) {
  case 'w':
    return isUp = b;
 
  case 's':
    return isDown = b;
 
  case 'a':
    return isLeft = b;
 
  case 'd':
    return isRight = b;
 
  case ' ': 
    return isSpace = b;
  
  case 'q': 
    return isShift = b;
  
  default:
    return b;
  }
}
void checkKeys(){
  if (isLeft) {
    player.xPos  += sin(PI/2-player.hDeg)/10 * playerSpeed;
    if (player.zPosition +  cos(PI/2-player.hDeg)/10* playerSpeed >1.5){
      player.zPos += cos(PI/2-player.hDeg)/10* playerSpeed;
      
    }
    else{
      
    }
  }
  if (isRight) {
    player.xPos  -= sin(PI/2-player.hDeg)/10* playerSpeed;
    if (player.zPosition -cos(PI/2-player.hDeg)/10* playerSpeed>1.5){
      player.zPos -= cos(PI/2-player.hDeg)/10* playerSpeed;
      
    }
    else{
      
    }
  }

  if (isUp) {
    player.xPos-= sin(player.hDeg)/10* playerSpeed;
    if (player.zPosition +cos(player.hDeg)/10* playerSpeed>1.5){
      player.zPos += cos(player.hDeg)/10* playerSpeed;
      
    }
    else{
      
    }
  }
  if (isDown) {
    player.xPos +=sin(player.hDeg)/10* playerSpeed;
    if (player.zPosition -cos(player.hDeg)/10* playerSpeed>1.5){
      player.zPos -= cos(player.hDeg)/10* playerSpeed;
    }
    else{
      
    }
  }
  if (isSpace) {
    player.yPos -= 0.1* playerSpeed;
  }
  if (isShift) {
    player.yPos += 0.1* playerSpeed;
  }
  
  //if ( (int) (player.yPosition +1.62)
  
}
