
//public void breakBlock(){
//  float time1 = millis();
//  float yDelta = - cos(player.vDeg)/100;
//  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/100;
//  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/100;
    
//  float yCenter = player.yPosition + yDelta;
//  float xCenter = player.xPosition + xDelta;
//  float zCenter = player.zPosition +  zDelta;
  
//  int counter = 0;
//  try{
//    while (c.chunkMemory[(int)(xCenter /16 + 0.0625)][(int)(zCenter /16 +0.0625)].blocks[(int)((xCenter + 1)%16)][(int)( yCenter + 1)][(int)((zCenter + 1)%16 )] == null){
//      yCenter += yDelta;
//      xCenter += xDelta;
//      zCenter += zDelta;
//      counter ++;
      
//    }
//    if(counter <1200){
//      Block block = c.chunkMemory[(int)(xCenter /16 +0.0625)][(int)(zCenter /16  + 0.0625)].blocks[(int)((xCenter + 1)%16)][(int)( yCenter + 1)][(int)((zCenter + 1)%16) ];
//      float time2 = millis();
//      println("Finding targeted block took: " + (time2-time1) + " ms");
//      if (block.blockType == 1)grass.play();
//      else if(block.blockType == 2)stone.play();
//      else if(block.blockType == 5)sand.play();
//      else if(block.blockType == 4)water.play();
//      else if(block.blockType == 10)diamond.play();
//      float time3 = millis();
//      println("Playing sound took: " + (time3-time2) + " ms");
//      c.chunkMemory[(int)(xCenter /16 +0.0625)][(int)(zCenter /16  + 0.0625)].removeBlock((int)((xCenter + 1)%16),(int)( yCenter + 1),(int)((zCenter + 1)%16 ), true);    
//      println("Rebuilding mesh took: " + (millis()-time3)+ " ms");
//      println("Removed Block at: " +  ((int)xCenter%16 + 1) + ", " +  ((int) yCenter+1) + ", " + ((int)zCenter%16 + 1));
//      println("In chunk: " + ((int)(xCenter /16)) + ", " + ((int)(zCenter /16 )));
      
//    }
//  }catch(ArrayIndexOutOfBoundsException e){
//    println("Tried to acess : " + ((int)(xCenter /16.0)) + ", " + ((int)(zCenter /16.0)));
//  }
//  //c.chunkMemory[(int)(x/16)][(int)(z/16)].betterGenerateMesh();
  
//}

//public void placeBlock(){
//  float time1 = millis();
//  float yDelta = - cos(player.vDeg)/10;
//  float xDelta = - sin(player.hDeg) * sin(player.vDeg)/10;
//  float zDelta = + cos(player.hDeg) * sin(player.vDeg)/10;
    
//  float yCenter = player.yPosition + yDelta;
//  float xCenter = player.xPosition + xDelta;
//  float zCenter = player.zPosition +  zDelta;
  
//  int counter = 0;
//  try{
//    while (c.chunkMemory[(int)(xCenter /16 + 0.0625)][(int)(zCenter /16 +0.0625)].blocks[(int)((xCenter + 1)%16)][(int)( yCenter + 1)][(int)((zCenter + 1)%16 )] == null){
//      yCenter += yDelta;
//      xCenter += xDelta;
//      zCenter += zDelta;
//      counter ++;
      
//    }
//    while (c.chunkMemory[(int)(xCenter /16 + 0.0625)][(int)(zCenter /16 +0.0625)].blocks[(int)((xCenter + 1)%16)][(int)( yCenter + 1)][(int)((zCenter + 1)%16 )] != null){
//      yCenter -= yDelta/100;
//      xCenter -= xDelta/100;
//      zCenter -= zDelta/100;
      
      
//    }
//    if(counter <120){
//      float time2 = millis();
//      //sound.play();
//      println("Finding targeted block took: " + (time2-time1) + " ms");

//      c.chunkMemory[(int)(xCenter /16 +0.0625)][(int)(zCenter /16  + 0.0625)].setBlock(6, (int)((xCenter + 1)%16),(int)( yCenter + 1),(int)((zCenter + 1)%16 ), true);    
//      println("Rebuilding mesh took: " + (millis()-time2)+ " ms");

//      println("Removed Block at: " +  ((int)xCenter%16 + 1) + ", " +  ((int) yCenter+1) + ", " + ((int)zCenter%16 + 1));
//      println("In chunk: " + ((int)(xCenter /16)) + ", " + ((int)(zCenter /16 )));
      
//    }
//  }catch(ArrayIndexOutOfBoundsException e){
//    println("Tried to acess : " + ((int)(xCenter /16.0)) + ", " + ((int)(zCenter /16.0)));
//  }
//  //c.chunkMemory[(int)(x/16)][(int)(z/16)].betterGenerateMesh();
  
//}

//public void breakThread(){
  
  
//}
