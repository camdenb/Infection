/***********\
* UTILITIES *
\***********/

boolean percentDieRoll (int chanceOutOf100) {
  return int(100 * random(1)) <= chanceOutOf100;
}

int randInt (int lo, int hi) {
  return int(random(lo, hi + 1));
}

void printWorld() {
  
  println("-----------WORLD-----------");
  for (Person p : world) {
   println(p); 
  }
}