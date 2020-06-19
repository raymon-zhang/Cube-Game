
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
            
            
             
            try{
              
              if (blocks[x][y][z+1] == null ||(blocks[x][y][z+1].isTransparent() && ! block.isTransparent())){
                block.drawSide1(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[1]); 
                
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              //println("fadskfajsdk");
              try{
                if (this.world.getChunkAt(lowestXPos/16, lowestZPos/16 + 1).blocks[x][y][0] == null ||(this.world.getChunkAt(lowestXPos/16, lowestZPos/16 + 1).blocks[x][y][0].isTransparent() && ! block.isTransparent())){ // neighboring chunk
                  block.drawSide1(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[1]); 
                  //println(this.world.textureCoords.get(block.blockType)[1].y);
                    
                  
                }
                
              }
              catch(ArrayIndexOutOfBoundsException f){
                //block.drawSide1(this.mesh); 
              }
              
            }
            
            try{
              if (blocks[x+1][y][z] == null ||(blocks[x+1][y][z].isTransparent() && ! block.isTransparent())){
                block.drawSide2(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[1]); 
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              
              try{
                if (this.world.getChunkAt(lowestXPos/16+1, lowestZPos/16).blocks[0][y][z] == null ||(this.world.getChunkAt(lowestXPos/16+1, lowestZPos/16).blocks[0][y][z].isTransparent() && ! block.isTransparent())){
                  block.drawSide2(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[1]); 
                }
                
              }
              catch(ArrayIndexOutOfBoundsException f){
                //block.drawSide2(this.mesh); 
                
              }
              
            }  
            
            try{
              
              if (blocks[x][y][z-1] == null ||(blocks[x][y][z-1].isTransparent() && ! block.isTransparent())){
                block.drawSide3(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[1]); 
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              
              try{
                if (this.world.getChunkAt(lowestXPos/16, lowestZPos/16-1).blocks[x][y][15] == null ||(this.world.getChunkAt(lowestXPos/16, lowestZPos/16-1).blocks[x][y][15].isTransparent() && ! block.isTransparent())){
                  block.drawSide3(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[1]); 
                  
                }
                
                
              }
              catch(ArrayIndexOutOfBoundsException f){
                //block.drawSide3(this.mesh); 
              }
            }
            
            
            try{
              if (blocks[x-1][y][z] == null ||(blocks[x-1][y][z].isTransparent() && ! block.isTransparent())){
                block.drawSide4(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[1]); 
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              
              try{
                if (this.world.getChunkAt(lowestXPos/16-1, lowestZPos/16).blocks[15][y][z] == null ||(this.world.getChunkAt(lowestXPos/16-1, lowestZPos/16).blocks[15][y][z].isTransparent() && ! block.isTransparent())){
                  block.drawSide4(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[1]); 
                  
                }
                
                
                
              }
              catch(ArrayIndexOutOfBoundsException f){
                //block.drawSide4(this.mesh);
              }
              
            }
            
            try{
              
              if (blocks[x][y-1][z] == null ||(blocks[x][y-1][z].isTransparent() && ! block.isTransparent())){
                block.drawTop(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[0]); 
              }
              
            }
            
            catch(ArrayIndexOutOfBoundsException e){
              
              block.drawTop(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[0]); 
            }
            
            try{
              
              if (blocks[x][y+1][z] == null ||(blocks[x][y+1][z].isTransparent() && ! block.isTransparent())){
                block.drawBottom(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[2]); 
              }
              
            }
            catch(ArrayIndexOutOfBoundsException e){
              block.drawBottom(newMesh, this.lowestXPos + x , this.lowestYPos + y , this.lowestZPos + z, this.world.textureCoords.get(block.blockType)[2]); 
            }
            newMesh.noTint();
          }
        }
      }
    }
    
    newMesh.endShape();
    this.mesh = newMesh;
    println("Generating mesh actually took: " + (millis()-timeStamp1)+ " ms");
  }
  
  public String string(){
    return("Chunk at " + this.lowestXPos + ", " + this.lowestZPos);
  }
  
}
  
  
 
