//Handles mob spawns and other things
public ArrayList<Entity> entities = new ArrayList<Entity>();
public ArrayList<Entity> deadentities = new ArrayList<Entity>();
public ArrayList<Arrow> arrows = new ArrayList<Arrow>();
public String[] entityTypes = new String[]{"Pig", "Panda", "Monster"};

public void checkSpawnEntities(){
  if(frameCount %120 == 0 && entities.size()<50){
    try{
      Entity newEntity;
      float randomType = random(0, entityTypes.length-1);
      float px = player.xPosition + random(-100, 100);
      float pz = player.zPosition + random(-100, 100);
      if(randomType <= MONSTER_SPAWN_RATE)newEntity = new Monster(px,c.getHighestBlockAt(floor(px),floor(pz)) -5, pz);
      else if(randomType <= MONSTER_SPAWN_RATE + 0.5)newEntity = new Panda(px,c.getHighestBlockAt(floor(px),floor(pz))-5, pz);
      else newEntity = new Pig(px,c.getHighestBlockAt(floor(px),floor(pz))-1, pz);
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
      println(e);
    }
  }
  ArrayList<Arrow> newArrows = new ArrayList<Arrow>(arrows);
  for(Arrow entity: newArrows){
    try{
      if(entity != null)entity.update();
      if(entity == null)entities.remove(entity);
      if(dist(entity.xPosition, entity.zPosition, player.xPosition, player.zPosition) >141)entities.remove(entity);
    }catch(Exception e){
      println(e);
    }
  }
  ArrayList<Entity> dead = new ArrayList<Entity>(deadentities);
  for(Entity entity: dead){
    try{
      if(entity != null)entity.update();
      if(entity == null)deadentities.remove(entity);
      if(dist(entity.xPosition, entity.zPosition, player.xPosition, player.zPosition) >141)deadentities.remove(entity);
    }catch(Exception e){
      println("dead error");
      println(e);
    }
  }
  
}

public Entity getEntityAt(PVector position){
  for(Entity entity :entities){
    if(position.x > entity.xPosition-entity.hitboxWidth/2.0 && position.x < entity.xPosition +entity.hitboxWidth/2.0 && position.y > entity.yPosition && position.y < entity.yPosition + entity.hitboxHeight && position.z > entity.zPosition - entity.hitboxLength/2.0 && position.z < entity.zPosition +entity.hitboxLength/2.0){
      return entity;
    }
  }
  return null;
  
}
