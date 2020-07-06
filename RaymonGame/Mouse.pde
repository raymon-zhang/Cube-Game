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
        if(player.inventory[player.selectedSlot]!= null){
          ItemType item = ItemTypes.get(player.inventory[player.selectedSlot].itemType);
          try{
            item.functionLeft.invoke(player);
          }catch(Exception e){
            println(e);
          }
          delay(75);
        }
        else {
          player.BREAK();
          delay(75);
        }
        
      }else if(mouseButton == RIGHT){
        if(player.inventory[player.selectedSlot]!= null){
          ItemType item = ItemTypes.get(player.inventory[player.selectedSlot].itemType);
          try{
            item.functionRight.invoke(player);
          }catch(Exception e){
            println(e);
          }
          delay(75);
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
   else if(mouseX >= width/2+4 &&mouseX<width/2 + 212 && mouseY >= height/2 -260 && mouseY< height/2 -44){
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
void mouseReleased(){
  player.blockDamage = 0;
}

void mouseWheel(MouseEvent event){
  if (drawingInventory){
    if(player.holding != null && player.holding.amount > 1){
      int x = getInventorySlot();
      if(x <36 && x>-1){
        if(player.inventory[x] == null){
          player.inventory[x] = new ItemStack(player.holding.itemType, (int)player.holding.amount/2, player);
          player.holding.amount -= (int)player.holding.amount/2;
        }
      }
    }
    
  }
  else{
    if (event.getCount() > 0){
      if (player.selectedSlot < 8)player.selectedSlot += 1;
      else player.selectedSlot = 0;
      
    }
    else if (event.getCount() < 0){
      if (player.selectedSlot > 0)player.selectedSlot -= 1;
      else player.selectedSlot = 8;
      
    }
  }
}
