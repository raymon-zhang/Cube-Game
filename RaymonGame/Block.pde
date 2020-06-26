public class Block{
  
  
  public int blockType;
  
  
  
  
  public Block(int type){
    
    
    this.blockType = type;
    
    
  }
  
  
  
  
  
  
  //better
  public void drawTop(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(255);
    
    
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex(x, y, (z+1), texture.x + 16, texture.y);   
    shape.vertex((x+1), y, (z+1), texture.x + 16, texture.y + 16);  
    shape.vertex((x+1), y, z, texture.x, texture.y + 16);
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex((x+1), y, (z+1), texture.x + 16, texture.y + 16);  

    
    
  }
  public void drawBottom(PShape shape,  int x, int y, int z, PVector texture){
    
    shape.tint(102);
    
    shape.vertex(x, y+1, z, texture.x, texture.y);
    shape.vertex(x, y+1, (z+1), texture.x + 16, texture.y);   
    shape.vertex((x+1), y+1, (z+1), texture.x + 16, texture.y + 16);  
    shape.vertex((x+1), y+1, z, texture.x, texture.y + 16);
    shape.vertex(x, y+1, z, texture.x, texture.y);
    shape.vertex((x+1), y+1, (z+1), texture.x + 16, texture.y + 16);  

    
  }
  
  
  
  public void drawSide4(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(204);
    
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex(x, y, (z+1), texture.x + 16, texture.y);   
    shape.vertex((x), y+1, (z+1), texture.x + 16, texture.y + 16);  
    shape.vertex((x), y+1, z, texture.x, texture.y + 16);
    shape.vertex(x, y, z, texture.x, texture.y);
    shape.vertex((x), y+1, (z+1), texture.x + 16, texture.y + 16);  
    
  }
  public void drawSide3(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(153);
    
    shape.vertex(x+1, y, z, texture.x, texture.y);
    shape.vertex(x, y, (z), texture.x + 16, texture.y);   
    shape.vertex((x), y+1, (z), texture.x + 16, texture.y + 16);  
    shape.vertex((x+1), y+1, z, texture.x, texture.y+ 16);
    shape.vertex(x+1, y, z, texture.x, texture.y);
    shape.vertex((x), y+1, (z), texture.x + 16, texture.y + 16);  

    
    
  }
  
  public void drawSide2(PShape shape, int x, int y, int z, PVector texture){
    
    shape.tint(204);
    
    shape.vertex(x+1, y, z+1, texture.x, texture.y);
    shape.vertex(x+1, y, (z), texture.x + 16, texture.y);   
    shape.vertex((x+1), y+1, (z), texture.x + 16, texture.y + 16);  
    shape.vertex((x+1), y+1, z+1, texture.x, texture.y + 16);
    shape.vertex(x+1, y, z+1, texture.x, texture.y);
    shape.vertex((x+1), y+1, (z), texture.x + 16, texture.y + 16);  

    
    
  }
  
  public void drawSide1(PShape shape, int x, int y, int z, PVector texture){
    
    
    shape.tint(153);
    
    shape.vertex(x, y, z+1, texture.x, texture.y);
    shape.vertex(x+1, y, (z+1), texture.x + 16, texture.y);   
    shape.vertex((x+1), y+1, (z+1), texture.x + 16, texture.y + 16);  
    shape.vertex((x), y+1, z+1, texture.x, texture.y + 16);
    shape.vertex(x, y, z+1, texture.x, texture.y);
    shape.vertex((x+1), y+1, (z+1),  texture.x + 16, texture.y + 16);  

    
    
  }
  
  public void drawShape(PShape shape, int x, int y, int z, PVector[] texture, boolean one, boolean two, boolean three, boolean four, boolean top, boolean bottom){
    if(one)this.drawSide1(shape, x, y, z, texture[1]);
    if(two)this.drawSide2(shape, x, y, z, texture[1]);
    if(three)this.drawSide3(shape, x, y, z, texture[1]);
    if(four)this.drawSide4(shape, x, y, z, texture[1]);
    if(top)this.drawTop(shape, x, y, z, texture[0]);
    if(bottom)this.drawBottom(shape, x, y, z, texture[2]);
  }
  public boolean isTransparent(){
    return this.blockType == 4;
  }
  
  
}
