//Class that reads blocktypes from file and determines features of thos blocks
public class BlockType{
  public int type, dropped;
  
  public Method functionLeft, functionRight;
  public BlockType(String filepath){
    String file = "/blocks/" + filepath;
    String[] lines = loadStrings(file);
    this.type = Integer.parseInt(lines[0]);
    this.dropped = Integer.parseInt(lines[1]);
    
  }
  public void put(){
    BlockTypes.put(this.type,this);
  }
  
  
}
