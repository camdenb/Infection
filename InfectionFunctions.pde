void startRandomInfection() {
  makeInfection();
  infectRandom(); 
}

void makeInfection() {
  newestInfection = new Infection();
}

void infectRandom() {
  infectAndSpread(randInt(0, world.size() - 1), newestInfection);
}

void infectAndSpread (int p, Infection i) {
  Person person = world.get(p);
  person.infected = true;
  person.infection = i;

  infectNextIfAcceptable(person.teacher, i);
  
  for (int s : person.students) {
    infectNextIfAcceptable(s, i);
  }
}

void infectNextIfAcceptable(int p, Infection i) {
  // does the person have a different infection and 
  if (world.get(p).infection != i) {
    toBeInfected.put(p, i);
    world.get(p).nextInfection = i;
  }
}

void infectNextPeople() {
  
  HashMap<Integer, Infection> tempToBeInfected = new HashMap<Integer, Infection>();
  for (int p : toBeInfected.keySet()) { //duplicate the array to avoid concurrent modification exception
    tempToBeInfected.put(p, world.get(p).nextInfection);
  }
  
  toBeInfected.clear();
  
  for (int p : tempToBeInfected.keySet()) {
    infectAndSpread(p, world.get(p).nextInfection);
  }
}