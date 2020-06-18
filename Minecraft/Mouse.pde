public void checkMouse(){
  if (mouseX > 1918){
    int y = mouseY;
    mouseControl.mouseMove(2, y);
  }
  else if (mouseX < 1){
    int y = mouseY;
    mouseControl.mouseMove(1917, y);
  }
  
  
  player.vDeg = map(mouseY, 0, height, 0, PI);
  
  
  if (mouseX < 960) {
    player.hDeg = map(mouseX, 0, 960, 0, PI);
  } else if (mouseX >= 960) {
    player.hDeg = map(mouseX, 960, 1920, PI, TWO_PI);
  } 
  
  
}
