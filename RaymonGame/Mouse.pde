public void checkMouse(){
  
  if(!drawingInventory){
    mouse = MouseInfo.getPointerInfo().getLocation();
    if (pMouse == null)pMouse = new Point(mouse.x, mouse.y);
      
    
    
    
    if (mouse.x > 1918 && (mouse.x-pMouse.x) >0 ){
      int y = mouse.y;
      
      mouseControl.mouseMove(2, y);
      mouse.x = 2;
      pMouse.x = 2;
     
    }
    else if (mouse.x < 1 && (mouse.x-pMouse.x )< 0){
      int y = mouse.y;
      mouseControl.mouseMove(1918, y);
      mouse.x = 1918;
      pMouse.x = 1918;
    }
      
    
    
    
    player.vDeg = map(mouse.y, 0, height, 0, PI);
    
    
    if (mouse.x < 960) {
      player.hDeg = map(mouse.x, 2, 960, 0, PI);
    } else if (mouse.x >= 960) {
      player.hDeg = map(mouse.x, 960, 1918, PI, TWO_PI);
    } 
  
  
  }
  
}

public void checkMouseClicked(){
  for(;;delay(100)){
    if(mousePressed){ 
      if (mouseButton == LEFT){
        breakBlock();
      }else if(mouseButton == RIGHT){
        placeBlock();
      }
    }
  }
}
