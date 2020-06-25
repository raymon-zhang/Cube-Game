boolean isLeft, isRight, isUp, isDown, isSpace, isShift; 
float playerSpeed = 0.06;

void keyPressed() {

  if(key == 'w') isUp = true;  
  if(key == 's') isDown = true; 
  if(key == 'a') isLeft = true; 
  if(key == 'd') isRight = true;
  if(key == ' ') isSpace = true; 
  
  if(key == 'q') isShift = true; 
  if(key == 'D')  debug = !debug;
    
    
  if(key == '1') player.selectedSlot = 0;
  if(key == '2') player.selectedSlot = 1;
  if(key == '3') player.selectedSlot = 2;
  if(key == '4') player.selectedSlot = 3;
  if(key == '5') player.selectedSlot = 4;
  if(key == '6') player.selectedSlot = 5;
  if(key == '7') player.selectedSlot = 6;
  if(key == '8') player.selectedSlot = 7;
  if(key == '9') player.selectedSlot = 8;
  
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


void mouseWheel(MouseEvent event){
  if (event.getCount() > 0){
    if (player.selectedSlot < 8)player.selectedSlot += 1;
    
  }
  else if (event.getCount() < 0){
    if (player.selectedSlot > 0)player.selectedSlot -= 1;
    
  }
}
