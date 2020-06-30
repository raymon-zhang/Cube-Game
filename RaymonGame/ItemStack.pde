public class ItemStack{
  
  public int itemType;
  public int amount;
  
  
  public PImage icon;
  
  public Player player;
  
  public ItemStack(int itemType, Player player){
    this.itemType = itemType;
    this.player = player;
    this.amount = 1;
    this.icon = loadImage("/icons/" + this.itemType + ".png");
  }
  public ItemStack(int itemType, int amount, Player player){
    this.itemType = itemType;
    this.player = player;
    this.amount = amount;
    this.icon = loadImage("/icons/" + this.itemType + ".png");
  }
  
  public void drawStack(PVector coords){
    pushStyle();
    if(this.icon != null)image(this.icon, coords.x, coords.y , 64, 64);
    if(this.amount >1){
      textSize(28);
      textAlign(LEFT, TOP);
      text(this.amount, coords.x + 33, coords.y + 37);
    }
    popStyle();
  }
  
  public ItemStack createCopy(){
    return new ItemStack(this.itemType, this.amount, this.player);
  }
  
  
  
      
  
  
  
  
}
