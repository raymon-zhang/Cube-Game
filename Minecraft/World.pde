//import java.util.*;
public class World {
  public ArrayList<Chunk> chunkMemory;



  public int size;
  public String status;
  PImage texture = loadImage("texture_atlas.png");

  Hashtable<Integer, PVector[]> textureCoords = new Hashtable<Integer, PVector[]>();

  // coords are 1 + 130(x-1), 1 + 130(y-1)





  public World(int size) {

    loadStatus = "Creating world";
    println(loadStatus);
    this.size = size;
    

    chunkMemory = new ArrayList<Chunk>();

    

    textureCoords.put(1, new PVector[]{new PVector(1, 1), new PVector (131, 1), new PVector(261, 1)});//grass
    textureCoords.put(2, new PVector[]{new PVector(391, 1), new PVector (391, 1), new PVector(391, 1)});//stone
    textureCoords.put(3, new PVector[]{new PVector(651, 1), new PVector(521, 1), new PVector(651, 1)});//log
    textureCoords.put(4, new PVector[]{new PVector(781, 1), new PVector(781, 1), new PVector(781, 1)});//water
    textureCoords.put(5, new PVector[]{new PVector(131, 131), new PVector(131, 131), new PVector(131, 131)});//sand
    textureCoords.put(6, new PVector[]{new PVector(261, 131), new PVector(261, 131), new PVector(261, 131)});//oakplank
    textureCoords.put(7, new PVector[]{new PVector(521, 131), new PVector(391, 131), new PVector(261, 1)});//snow
    textureCoords.put(8, new PVector[]{new PVector(651, 131), new PVector(651, 131), new PVector(651, 131)});//gravel
    textureCoords.put(10, new PVector[]{new PVector(1, 131), new PVector (1, 131), new PVector(1, 131)});//diamond


    

    loadStatus  = "Generating cave map";
    println(loadStatus);
    
    loadStatus = "Creating Chunks";
    println(loadStatus);

    int px = ((int) player.xPosition/16)*16;
    int py = ((int) player.zPosition/16)*16;


    for (int x = 0; x < (int)size; x ++) {
      for (int y = 0; y < (int)size; y++) {
        chunkMemory.add(new Chunk( px + x*16, 0, py + y*16, this));
        
        //try{
        //  Chunk test = this.getChunkAt(px + (x*16), py + (y*16));
        //}catch(ArrayIndexOutOfBoundsException e){
        //  chunkMemory.add( new Chunk(px + (x*16), 0, py + (y*16), this));
        //}
        //try{
        //  Chunk test = this.getChunkAt(px - (y*16), py - (x*16));
        //}catch(ArrayIndexOutOfBoundsException e){
        //  chunkMemory.add( new Chunk(px - (y*16), 0, py + (x*16), this));
        //}
        //try{
        //  Chunk test = this.getChunkAt(px - (x*16), py - (y*16));
        //}catch(ArrayIndexOutOfBoundsException e){
        //  chunkMemory.add( new Chunk(px - (x*16), 0, py - (y*16), this));
        //}
        //try{
        //  Chunk test = this.getChunkAt(px - (y*16), py - (x*16));
        //}catch(ArrayIndexOutOfBoundsException e){
        //  chunkMemory.add( new Chunk(px + (y*16), 0, py - (x*16), this));
          
        //}
      }
    }
    loadStatus  = "Placing Blocks";
    println(loadStatus);
    //for (int x = 0;x < chunkMemory.length; x++){
    //   for (int y = 0;y < chunkMemory.length; y++){
    //     Chunk c = chunkMemory[x][y];
    //     for (int a = 0;a<c.blocks.length;a++){
    //       for(int b = 0;b<c.blocks[a][0].length;b++){
    //         if(heightMap[a + x*16][b + y*16] > 86){
    //           for(int h = 86; h<heightMap[a + x*16][b + y*16];h++){
    //             c.setBlock(4, a, h, b, false);
    //           }
    //         }
    //         for(int h = heightMap[a + x*16][b + y*16]; h<heightMap[a + x*16][b + y*16]+4;h++){


    //           if(heightMap[a + x*16][b + y*16] <38){
    //             c.setBlock(7, a, h, b, false);
    //           }
    //           else if(heightMap[a + x*16][b + y*16] <55){
    //             c.setBlock(8, a, h, b, false);
    //           }
    //           else if(heightMap[a + x*16][b + y*16] <81){
    //             c.setBlock(1, a, h, b, false);
    //           }

    //           else c.setBlock(5, a, h, b, false);

    //             //println(noise(((x*16) + a)/10, (128-h)/10, ((y*16) + b)/10));



    //         }
    //         for(int h = heightMap[a + x*16][b + y*16]+4; h<128;h++){
    //           if (caveMap[a + x*16][h][b + y*16] > 0.25){

    //             if (caveMap[a + x*16][h][b + y*16] > 0.2699 && caveMap[a + x*16][h][b + y*16] < 0.27){
    //               c.setBlock(10, a, h, b, false);
    //             }
    //             else{

    //               c.setBlock(2, a, h, b, false);
    //             }
    //             //println(noise(((x*16) + a)/10, (128-h)/10, ((y*16) + b)/10));
    //           }



    //         }


    //       }

    //     }

    //   }

    //}

    for (Chunk c : chunkMemory) {
      for (int x = 0; x< 16; x++) {
        for (int y = 0; y<16; y++) {
          for (int h = 127-((int)map(noise(((c.lowestXPos+ x)/100.0), (c.lowestZPos + y)/100.0), 0, 1, 10, 100)); h<128; h++) {

            c.setBlock(1, x, h, y, false);
          }
        }
      }
    }
    
    for(Chunk c: chunkMemory){
      println(c.string());
    }

    thread("generateMeshes");
  }

  public void drawWorld() {

    for (Chunk c : chunkMemory) {
      c.betterDrawChunk();
    }
  }
  public PImage getTexture() {
    return this.texture;
  }

  public Chunk getChunkAt(int x, int z) throws ArrayIndexOutOfBoundsException{
    //println(this.chunkMemory);
    for(int l = 0; l < this.chunkMemory.size(); l ++){
      Chunk ch = this.chunkMemory.get(l);
      if(ch.lowestZPos == z*16){
        //println("fasfkfaj");
        if (ch.lowestXPos == x*16){
          //println("I like cheese");
          return ch;
        }
      }
    }


    //println("Hfadsfsf");
    throw new ArrayIndexOutOfBoundsException();

    //return new Chunk(0,0, 0, this);
  }
}



public void generateMeshes() {
  for (Chunk c : c.chunkMemory) {
    c.betterGenerateMesh();
  }
}
