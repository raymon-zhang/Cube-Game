
public class Chunk{
  public int lowestXPos, lowestYPos, lowestZPos;

  
  public final int cWidth = 16, cLength = 16, cHeight = 128;
  
  
  
  public PShape mesh;
  public World world;
  
  
  Block[][][] blocks;
  
  public Chunk(int lowestXPos, int lowestYPos, int lowestZPos, World world){
    this.lowestXPos = lowestXPos;
    this.lowestYPos = lowestYPos;
    this.lowestZPos = lowestZPos;
    
    this.blocks = new Block[cWidth][cHeight][cLength];
    this.mesh = createShape();
    
    this.world = world;
    
    
  }
  
  public void removeBlock(int x, int y, int z, boolean byUser){
    blocks[x][y][z] = null;
    if (byUser){
      this.betterGenerateMesh();
      try{
      
        if(x == 0){
          println("Checking chunk: " + ((lowestXPos)/16 -1) + ", " + lowestZPos/16);
          this.world.getChunkAt(lowestXPos/16-1, lowestZPos/16).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(x == 15){
          println("Checking chunk: " + ((lowestXPos)/16 + 1) + ", " + lowestZPos/16);
          this.world.getChunkAt(lowestXPos/16+1,lowestZPos/16).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(z == 0){
          println("Checking chunk: ", + (lowestXPos/16) + ", " + ((lowestZPos)/16 -1) );
          this.world.getChunkAt(lowestXPos/16, lowestZPos/16-1).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(z == 15){
          println("Checking chunk: " +(lowestXPos/16) + ", " + ((lowestZPos)/16 + 1)  );
          this.world.getChunkAt(lowestXPos/16, lowestZPos/16+1).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
    }
  }
  public void setBlock(int blockId, int x, int y, int z, boolean byUser){
    blocks[x][y][z] = new Block(blockId);
    if (byUser){
      this.betterGenerateMesh();
      try{
      
        if(x == 0){
          println("Checking chunk: " + ((lowestXPos)/16 -1) + ", " + lowestZPos/16);
          this.world.getChunkAt(lowestXPos/16-1, lowestZPos/16).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(x == 15){
          println("Checking chunk: " + ((lowestXPos)/16 + 1) + ", " + lowestZPos/16);
          this.world.getChunkAt(lowestXPos/16+1,lowestZPos/16).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(z == 0){
          println("Checking chunk: ", + (lowestXPos/16) + ", " + ((lowestZPos)/16 -1) );
          this.world.getChunkAt(lowestXPos/16, lowestZPos/16-1).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
      try{
      
        if(z == 15){
          println("Checking chunk: " +(lowestXPos/16) + ", " + ((lowestZPos)/16 + 1)  );
          this.world.getChunkAt(lowestXPos/16, lowestZPos/16+1).betterGenerateMesh();
        }
      }catch(ArrayIndexOutOfBoundsException e){
        
      }
    }
    
  }
  

  
  
  
  public void betterDrawChunk(){
    shape(this.mesh);
    
  }
  public void betterGenerateMesh(){
    
    
    int timeStamp1 = millis();
    while(drawingUI == true) delay(1);
    PShape newMesh = createShape();
    newMesh.beginShape(TRIANGLE);
    newMesh.noStroke();
    newMesh.texture(this.world.getTexture());
    //this.mesh = createShape(); //reset coords
    //this.mesh.beginShape(TRIANGLE);
    //this.mesh.noStroke();
    //this.mesh.texture(this.world.getTexture());
    
    
    
    for (int x = 0; x < blocks.length;x++){ //add face vertices to coords
      for (int y = 0; y < blocks[x].length;y++){
        for (int z = 0; z < blocks[x][y].length;z++){
           
          
          
          if (blocks[x][y][z] != null){
            Block block = blocks[x][y][z];
            PVector[] texCoords = this.world.textureCoords.get(block.blockType);
            boolean one, two, three, four, top, bottom;
            one = two = three = four = top = bottom = false;
            
             
            try{
              
              if (blocks[x][y][z+1] == null ||(blocks[x][y][z+1].isTransparent() && ! block.isTransparent())){
                one = true;
                //block.drawSide1(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              //println("fadskfajsdk");
              try{
                if (this.world.getChunkAt(lowestXPos/16, lowestZPos/16 + 1).blocks[x][y][0] == null ||(this.world.getChunkAt(lowestXPos/16, lowestZPos/16 + 1).blocks[x][y][0].isTransparent() && ! block.isTransparent())){ // neighboring chunk
                  one = true;
                  //block.drawSide1(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                  //println(this.world.textureCoords.get(block.blockType)[1].y);
                    
                  
                }
                
              }
              catch(ArrayIndexOutOfBoundsException f){
                //block.drawSide1(this.mesh); 
              }
              
            }
            
            try{
              if (blocks[x+1][y][z] == null ||(blocks[x+1][y][z].isTransparent() && ! block.isTransparent())){
                two = true;
                //block.drawSide2(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              
              try{
                if (this.world.getChunkAt(lowestXPos/16+1, lowestZPos/16).blocks[0][y][z] == null ||(this.world.getChunkAt(lowestXPos/16+1, lowestZPos/16).blocks[0][y][z].isTransparent() && ! block.isTransparent())){
                  two = true;
                  //block.drawSide2(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                }
                
              }
              catch(ArrayIndexOutOfBoundsException f){
                //block.drawSide2(this.mesh); 
                
              }
              
            }  
            
            try{
              
              if (blocks[x][y][z-1] == null ||(blocks[x][y][z-1].isTransparent() && ! block.isTransparent())){
                three = true;
                //block.drawSide3(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              
              try{
                if (this.world.getChunkAt(lowestXPos/16, lowestZPos/16-1).blocks[x][y][15] == null ||(this.world.getChunkAt(lowestXPos/16, lowestZPos/16-1).blocks[x][y][15].isTransparent() && ! block.isTransparent())){
                  three = true;
                  //block.drawSide3(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                  
                }
                
                
              }
              catch(ArrayIndexOutOfBoundsException f){
                //block.drawSide3(this.mesh); 
              }
            }
            
            
            try{
              if (blocks[x-1][y][z] == null ||(blocks[x-1][y][z].isTransparent() && ! block.isTransparent())){
                four = true;
                //block.drawSide4(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              
              try{
                if (this.world.getChunkAt(lowestXPos/16-1, lowestZPos/16).blocks[15][y][z] == null ||(this.world.getChunkAt(lowestXPos/16-1, lowestZPos/16).blocks[15][y][z].isTransparent() && ! block.isTransparent())){
                  four = true;
                  //block.drawSide4(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[1]); 
                  
                }
                
                
                
              }
              catch(ArrayIndexOutOfBoundsException f){
                //block.drawSide4(this.mesh);
              }
              
            }
            
            try{
              
              if (blocks[x][y-1][z] == null ||(blocks[x][y-1][z].isTransparent() && ! block.isTransparent())){
                top = true;
                //block.drawTop(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[0]); 
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              
              //block.drawTop(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[0]); 
            }
            
            try{
              
              if (blocks[x][y+1][z] == null ||(blocks[x][y+1][z].isTransparent() && ! block.isTransparent())){
                bottom  = true;
                //block.drawBottom(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[2]); 
              }
              
            }
            catch(ArrayIndexOutOfBoundsException e){
              bottom = true;
              //block.drawBottom(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, texCoords[2]); 
            }
            //newMesh.noTint();
            block.drawShape(newMesh,this.lowestXPos + x,this.lowestYPos + y,this.lowestZPos + z,texCoords,one,two,three,four,top,bottom);
          }
        }
      }
    }
    
    newMesh.endShape();
    this.mesh = newMesh;
    
    println("Generating mesh actually took: " + (millis()-timeStamp1)+ " ms");
    //println("------");
  }
  
  public String toString(){
    return("Chunk at " + this.lowestXPos + ", " + this.lowestZPos);
  }
  public void decorate(){
    for (int x = 0; x< 16; x++) {
      for (int y = 0; y<16; y++) {
        int highness = 128-((int)map(noise(((this.lowestXPos+ x)/75.0), (this.lowestZPos + y)/75.0), 0, 1, 10, 70));
        if(highness > WATERLEVEL){
            for(int water = WATERLEVEL; water < highness; water ++){
              this.setBlock(4, x, water, y, false);
            }
          }
        if(highness < WATERLEVEL -6 &&((x<14 &&x > 1) &&(y<14 && y>1))){
          float random = random(0, 20);
          //println(random);
          if(random < 0.3){
            int tree = highness-1;
            for(tree = highness - 1; tree > highness -1 - random(3, 5); tree--){
              if (tree>0)this.setBlock(3, x, tree, y, false);
              
            }
            
            for(int level = 3; level > -1; level--){
              if (level < 2){
                for(int xOff = -2; xOff <3; xOff ++){
                  for(int yOff = -2; yOff<3; yOff ++){
                    
                    this.setBlock(11, x + xOff, tree -level, y + yOff, false);
                    
                  }
                }
              }
              else{
                
                this.setBlock(11, x + 1, tree -level, y , false);
                
                this.setBlock(11, x - 1, tree -level, y , false);
                
                this.setBlock(11, x , tree -level, y-1 , false);
                
                this.setBlock(11, x , tree -level, y +1, false);
                
                this.setBlock(11, x , tree -level, y, false);
                
              }
            }
            if(random(0, 10) < 4.5){
              this.removeBlock(x + 2, tree, y + 2, false);
            }
            if(random(0, 10) < 4.5){
              this.removeBlock(x - 2, tree, y + 2, false);
            }
            if(random(0, 10) < 4.5){
              this.removeBlock(x + 2, tree, y - 2, false);
            }
            if(random(0, 10) < 4.5){
              this.removeBlock(x -2, tree, y - 2, false);
            }
            if(random(0, 10) < 4.5){
              this.removeBlock(x + 2, tree - 1, y + 2, false);
            }
            if(random(0, 10) < 4.5){
              this.removeBlock(x - 2, tree - 1, y + 2, false);
            }
            if(random(0, 10) < 4.5){
              this.removeBlock(x + 2, tree-1, y - 2, false);
            }
            if(random(0, 10) < 4.5){
              this.removeBlock(x -2, tree-1, y - 2, false);
            }
            
            
          }
        }  
        
        for (int h = highness; h<highness+3; h++) {
          
          
          if(highness > WATERLEVEL - 6){
            this.setBlock(5, x, h, y, false);
          }
          else this.setBlock(1, x, h, y, false);
        }
        for(int h = highness+3; h < 128; h++){
          this.setBlock(2, x, h, y, false);
        }
      }
    }
  }
  
}
  
  
 