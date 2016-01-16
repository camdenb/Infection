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
   //println(p); 
  }
}

// ANDs all of the booleans in the array, used for unit tests
boolean andMap (boolean[] arr) {
  boolean result = true;
  
  for (boolean b : arr) {
    result = result && b;
  }
  
  return result;  
}

// TESTS

boolean assertEquals(Object o1, Object o2) {
  return o1.equals(o2); 
}