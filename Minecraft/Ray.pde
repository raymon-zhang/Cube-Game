
public void breakBlock(){
  float yDelta = - cos(player.vDeg)/100;
  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/100;
  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/100;
    
  float yCenter = player.yPosition + yDelta;
  float xCenter = player.xPosition + xDelta;
  float zCenter = player.zPosition +  zDelta;
  
  int counter = 0;
  try{
    while (c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] == null){
      println("Step");
      println(floor(xCenter )-(floor(xCenter/16) )*16);
      yCenter += yDelta;
      xCenter += xDelta;
      zCenter += zDelta;
      
      counter ++;
      
    }
    if(counter <1200){
      
      Chunk chunk = c.getChunkAt(floor(xCenter/16),floor(zCenter/16));
     
      Block block = chunk.blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ) )*16];

      chunk.removeBlock((floor(xCenter )-(floor(xCenter/16) )*16), floor( yCenter), (floor(zCenter))-(floor(zCenter/16 ) )*16, true);
      for (int x = 0; x < player.inventory.length; x++){
        if(player.inventory[x] == null){
          player.inventory[x] = new ItemStack(block.blockType, player);
          return;
        }
        else if (player.inventory[x].itemType == block.blockType){
          player.inventory[x].amount ++;
          return;
        }
      }

    }
  }catch(ArrayIndexOutOfBoundsException e){
    println(floor(xCenter )-(floor(xCenter/16) )*16);
  }
  
}

public void placeBlock(){
  //float time1 = millis();
  float yDelta = - cos(player.vDeg)/10;
  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/10;
  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/10;
    
  float yCenter = player.yPosition + yDelta;
  float xCenter = player.xPosition + xDelta;
  float zCenter = player.zPosition +  zDelta;
  
  int counter = 0;
  try{
    while (c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] == null){
      println("Step");
      yCenter += yDelta;
      xCenter += xDelta;
      zCenter += zDelta;
      counter ++;
      
    }
    while (c.getChunkAt(floor(xCenter/16),floor(zCenter/16)).blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ))*16] != null){
      yCenter -= yDelta/100;
      xCenter -= xDelta/100;
      zCenter -= zDelta/100;
      
      
    }
    if(counter <120){
   
      Chunk chunk = c.getChunkAt(floor(xCenter/16),floor(zCenter/16));
      Block block = chunk.blocks[floor(xCenter )-(floor(xCenter/16) )*16][floor( yCenter)][(floor(zCenter))-(floor(zCenter/16 ) )*16];
      try{
        chunk.setBlock( player.inventory[player.selectedSlot].itemType,(floor(xCenter )-(floor(xCenter/16) )*16), floor( yCenter), (floor(zCenter))-(floor(zCenter/16 ) )*16, true);
        if(player.inventory[player.selectedSlot].amount > 1){
          player.inventory[player.selectedSlot].amount -= 1;
        }
        else player.inventory[player.selectedSlot] = null;
      }catch(NullPointerException e){
        
      }
      
    }
  }catch(ArrayIndexOutOfBoundsException e){
    println(floor(xCenter )-(floor(xCenter/16) )*16);
  }
  
}
