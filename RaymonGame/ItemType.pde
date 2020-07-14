//Class for reading ItemTypes from files and determining features of itemtypes.
public class ItemType{
  public int type, maxAmount, breakingSpeed;
  
  public Method functionLeft, functionRight;
  public ItemType(String filepath){
    String file = "/items/" + filepath;
    String[] lines = loadStrings(file);
    this.type = Integer.parseInt(lines[0]);
    this.maxAmount = Integer.parseInt(lines[1]);
    if (lines.length == 4)this.breakingSpeed = 1;
    else this.breakingSpeed = Integer.parseInt(lines[4]);
    try{
      this.functionLeft = Player.class.getMethod(lines[2]);
    }catch(NoSuchMethodException e){
      try{
        this.functionLeft = Player.class.getMethod("BREAK");
      }catch(NoSuchMethodException f){
        //not possible
      }
    }
    try{
      this.functionRight = Player.class.getMethod(lines[3]);
    }catch(NoSuchMethodException e){
      try{
        this.functionRight = Player.class.getMethod("PLACE");
      }catch(NoSuchMethodException f){
        //not possible
      }
    }
    
  }
  public void put(){
    ItemTypes.put(this.type,this);
  }
  
  
}
