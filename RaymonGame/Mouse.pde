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
  for(;;delay(25)){
    
    if(mousePressed&& !drawingInventory ){ 
      if (mouseButton == LEFT){
        
        breakBlock();
        delay(75);
        
      }else if(mouseButton == RIGHT){
        if(player.inventory[player.selectedSlot]!= null){
          if( player.inventory[player.selectedSlot].itemType<100){  
            placeBlock();
            delay(75);
          }
        }
      }
    }
  }
        
}

public int getInventorySlot(){
  if(mouseX>=width/2-320 && mouseX<=width/2+320){ 
   if(mouseY>=height/2+236 && mouseY<=height/2+300){
     return (int)(  (mouseX-(width/2-320))/72);
   }
   else if(mouseY>=height/2+4 && mouseY< height/2 + 220){
     return ((int)((mouseY-(height/2+4))/72) + 1)*9 + (int)(  (mouseX-(width/2-320))/72);
   }
   else if(mouseX >= width/2+4 &&mouseX<=width/2 + 212 && mouseY >= height/2 -260 && mouseY<= height/2 -44){
     return (int)((mouseY-(height/2-260))/72)*3 + (int)((mouseX-(width/2+4))/72) + 36;
     
   }
   else if(mouseX>=width/2 + 260&& mouseX<= width/2 + 332){
     return 45;
   }
  }
  return -1;
}

void mouseClicked(){
  mouseclicked = true;
  
}
