//Reads recipes from file
public class Recipe{
  public int[] grid;
  public ItemStack output;
  
  public Recipe(String filepath){
    String file = "/recipes/"+filepath;
    this.grid = new int[9];
    String[] lines = loadStrings(file);
    output = new ItemStack(Integer.parseInt(lines[1]), Integer.parseInt(lines[2]), player);
    String[] gridIn = split(lines[0], ",");
    for(int x = 0; x<3; x++){
      for(int y = 0; y<3; y++){
        this.grid[x*3 + y] = Integer.parseInt(gridIn[x*3 + y]);
      }
    }
  }
  public String toString(){
    return ("Recipe, returns " + output.itemType + ", " + output.amount);
  }
  public boolean compare(ItemStack[] grid){
    for(int slot = 0 ; slot<9; slot++){
      if(grid[slot] != null){
        if(grid[slot].itemType!=this.grid[slot]){
          return false;
        }
      }
      else if(this.grid[slot] !=0){
        return false;
        
      }
    }
    return true;
  }
}
