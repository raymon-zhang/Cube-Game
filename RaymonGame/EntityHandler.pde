//Handles mob spawns and other things
public ArrayList<Entity> entities = new ArrayList<Entity>();
public String[] entityTypes = new String[]{"Pig", "Panda"};
public void checkSpawnEntities(){
  if(frameCount %120 == 0 && entities.size()<20){
    try{
      Entity newEntity;
      float randomType = random(0, entityTypes.length-1);
      float px = player.xPosition + random(-100, 100);
      float pz = player.zPosition + random(-100, 100);
      if(randomType <= 0.5)newEntity = new Pig(px,c.getHighestBlockAt(floor(px),floor(pz)) -1, pz);
      else if(randomType <= 1)newEntity = new Panda(px,c.getHighestBlockAt(floor(px),floor(pz))-5, pz);
      else newEntity = new Panda(px,c.getHighestBlockAt(floor(px),floor(pz))-1, pz);
      entities.add(newEntity);
     
    }catch(Exception e){
      //println(e);
    }
    
    
  }
  
  
}
public void updateEntities(){
  ArrayList<Entity> newEntities = new ArrayList<Entity>(entities);
  for(Entity entity: newEntities){
    try{
      if(entity != null)entity.update();
      if(entity == null)entities.remove(entity);
      if(dist(entity.xPosition, entity.zPosition, player.xPosition, player.zPosition) >141)entities.remove(entity);
    }catch(Exception e){
      //println(e);
    }
  }
  
}

public Entity getEntityAt(PVector position){
  for(Entity entity :entities){
    if(position.x > entity.xPosition && position.x < entity.xPosition +entity.hitboxWidth && position.y > entity.yPosition && position.y < entity.yPosition + entity.hitboxHeight && position.z > entity.zPosition && position.z < entity.zPosition +entity.hitboxLength){
      println("HI");
      return entity;
    }
  }
  return null;
  
}
