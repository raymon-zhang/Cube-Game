public class Block{
  
  
  public int blockType;
  
  
  
  
  public Block(int type){
    
    
    this.blockType = type;
    
    
  }
  
  
  
  
  
  
  //better
  public void drawTop(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(255);
    
    
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex(x, y, (z+1), texture.x + 128, texture.y);   
    shape.vertex((x+1), y, (z+1), texture.x + 128, texture.y + 128);  
    shape.vertex((x+1), y, z, texture.x, texture.y + 128);
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex((x+1), y, (z+1), texture.x + 128, texture.y + 128);  

    
    
  }
  public void drawBottom(PShape shape,  int x, int y, int z, PVector texture){
    
    shape.tint(102);
    
    shape.vertex(x, y+1, z, texture.x, texture.y);
    shape.vertex(x, y+1, (z+1), texture.x + 128, texture.y);   
    shape.vertex((x+1), y+1, (z+1), texture.x + 128, texture.y + 128);  
    shape.vertex((x+1), y+1, z, texture.x, texture.y + 128);
    shape.vertex(x, y+1, z, texture.x, texture.y);
    shape.vertex((x+1), y+1, (z+1), texture.x + 128, texture.y + 128);  

    
  }
  
  
  
  public void drawSide4(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(204);
    
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex(x, y, (z+1), texture.x + 128, texture.y);   
    shape.vertex((x), y+1, (z+1), texture.x + 128, texture.y + 128);  
    shape.vertex((x), y+1, z, texture.x, texture.y + 128);
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex((x), y+1, (z+1), texture.x + 128, texture.y + 128);  
    
  }
  public void drawSide3(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(153);
    
    shape.vertex(x+1, y, z, texture.x, texture.y);
    shape.vertex(x, y, (z), texture.x + 128, texture.y);   
    shape.vertex((x), y+1, (z), texture.x + 128, texture.y + 128);  
    shape.vertex((x+1), y+1, z, texture.x, texture.y+ 128);
    shape.vertex(x+1, y, z, texture.x, texture.y);
    shape.vertex((x), y+1, (z), texture.x + 128, texture.y + 128);  

    
    
  }
  
  public void drawSide2(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(204);
    
    shape.vertex(x+1, y, z+1, texture.x, texture.y);
    shape.vertex(x+1, y, (z), texture.x + 128, texture.y);   
    shape.vertex((x+1), y+1, (z), texture.x + 128, texture.y + 128);  
    shape.vertex((x+1), y+1, z+1, texture.x, texture.y + 128);
    shape.vertex(x+1, y, z+1, texture.x, texture.y);
    shape.vertex((x+1), y+1, (z), texture.x + 128, texture.y + 128);  

    
    
  }
  
  public void drawSide1(PShape shape, int x, int y, int z, PVector texture){
    
    
    shape.tint(153);
    
    shape.vertex(x, y, z+1, texture.x, texture.y);
    shape.vertex(x+1, y, (z+1), texture.x + 128, texture.y);   
    shape.vertex((x+1), y+1, (z+1), texture.x + 128, texture.y + 128);  
    shape.vertex((x), y+1, z+1, texture.x, texture.y + 128);
    shape.vertex(x, y, z+1, texture.x, texture.y);
    shape.vertex((x+1), y+1, (z+1),  texture.x + 128, texture.y + 128);  

    
    
  }
  public boolean isTransparent(){
    if(this.blockType == 4){
      return true;
    }
    else return false;
  }
  
  
}
