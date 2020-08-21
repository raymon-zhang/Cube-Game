enum WorldType{
  NORM,
  FLAT,
  EXTREME,
  ISLANDS
  
}
boolean nature = true;
boolean caves = true;
WorldType type = WorldType.NORM;
void decorateChunk(Chunk chunk){
  switch(type){
    case NORM:
      chunk.decorate(nature);
      break;
    case FLAT:
      chunk.decorateFlat();
      break;
    case EXTREME:
      WATERLEVEL = 110;
      chunk.decorateExtreme(nature);
      break;
    case ISLANDS:
      WATERLEVEL = 53;
      chunk.decorateIsland(nature);
    
  }
}
