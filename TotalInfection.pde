/*************************************************************

 _____             ___               _    _                   
|_   _|          .' ..]             / |_ (_)                  
  | |   _ .--.  _| |_  .---.  .---.`| |-'__   .--.   _ .--.   
  | |  [ `.-. |'-| |-'/ /__\\/ /'`\]| | [  |/ .'`\ \[ `.-. |  
 _| |_  | | | |  | |  | \__.,| \__. | |, | || \__. | | | | |  
|_____|[___||__][___]  '.__.''.___.'\__/[___]'.__.' [___||__] 
                    
                                                              
Author: Camden Bickel

Notes:

I've made a few assumptions in this program.
First, every person has at most one teacher.
Second, one-on-one tutors don't exist -- only classes.


*************************************************************/


// config
int lastUpdateTime;
int tickTime = 100;
int avgClassSize = 20; // each class is between (avgClassSize - classSizeDev)
int classSizeDev = 10;  //                   and (avgClassSize + classSizeDev)
int minClassSize = avgClassSize - classSizeDev;
int maxClassSize = avgClassSize + classSizeDev;
int maxPeople = 10; // must be greater than maxClassSize

int pctOfStudentsWhoTeach = 10; // (out of 100) percentage of people who are both students and teachers

// how far +- is a student away from a teacher
int positionDev = 15;
int personSize = 5;

// the world contains a list of Persons, but throughout the program
// each Person will often be referred to by its index in world
ArrayList<Person> world = new ArrayList<Person>();

// a list of people (in the form of world indices) who will be infected in the next tick
ArrayList<Integer> toBeInfected = new ArrayList<Integer>();

void setup() {
  size(600, 600);
  generateWorld();
  lastUpdateTime = millis(); // get current time
}  

void draw() {
  update();
  clear();
  drawPeople();
}

void update() {
  if (millis() - lastUpdateTime > tickTime) {
    tick();
    lastUpdateTime = millis();
  }
}

void tick() {
  //infectNextPeople();
  //printWorld();
}

void generateWorld () {
  
  // first person, has no students (yet) and no teachers (ever)
  Person firstPerson = new Person();
  firstPerson.setPosition(randInt(0, width), randInt(0, height));
  
  ArrayList<Integer> firstStudents = generateStudentsForTeacher(firstPerson, randInt(minClassSize, maxClassSize));
  ArrayList<Integer> newestStudents = possiblyMakeStudentsOfStudents(firstStudents);
  
  int potentialWorldSize = world.size();
  
  while(potentialWorldSize < maxPeople) {
    ArrayList<Integer> tempStudents = possiblyMakeStudentsOfStudents(newestStudents);
    if (newestStudents.size() == 0) {
      generateWorld();
      return; 
    }
    newestStudents = tempStudents;
    potentialWorldSize = world.size() + newestStudents.size();
  }
  infectRandom();
  //printWorld();
}

ArrayList<Integer> generateStudentsForTeacher(Person teacher, int numStudents) {
  ArrayList<Integer> students = makeStudentsOf(world.indexOf(teacher), numStudents); 
  teacher.addStudents(students);
  return students;
}

// iterate over a list of students, and for each one, possibly generate students for it
// returns a list of all students generated
ArrayList<Integer> possiblyMakeStudentsOfStudents (ArrayList<Integer> students) {
  
  ArrayList<Integer> newStudents = new ArrayList<Integer>();
  
  for (int s : students) {
    if (percentDieRoll(pctOfStudentsWhoTeach)) { // if a student is a teacher, too
    
      int constrainedMaxClassSize = min(maxClassSize, maxPeople - world.size());
      
      if (constrainedMaxClassSize < minClassSize || world.size() >= maxPeople) { // stop adding students if you've reached the limit!
        return generateStudentsForTeacher(world.get(s), constrainedMaxClassSize);
      } 
      newStudents.addAll(generateStudentsForTeacher(world.get(s), randInt(minClassSize, constrainedMaxClassSize)));
    }
  }
  
  return newStudents;
  
}


// makes the given number of students for a certain person, and returns an array of the students
ArrayList<Integer> makeStudentsOf (int teacher, int num) {
  
  ArrayList<Integer> students = new ArrayList<Integer>();
  
  for (int i = 0; i < num; i++) {
    Person newStudent = new Person(teacher);
    students.add(newStudent.index);
  }
  
  return students;
  
}

void infect (int p) {
  Person person = world.get(p);
  person.infected = true;
  //if (toBeInfected.contains(p)) {
  //  toBeInfected.remove(p); 
  //}
  toBeInfected.clear();
  toBeInfected.add(person.teacher);
  toBeInfected.addAll(person.students);
}

void infectNextPeople() {
  ArrayList<Integer> tempToBeInfected = new ArrayList<Integer>();
  for (int p : toBeInfected) {
    tempToBeInfected.add(p);
  }
  for (int p : tempToBeInfected) {
    infect(p);
  }
}

void infectRandom() {
  infect(randInt(0, world.size() - 1));
}

void mouseClicked() {
  //infectRandom();
  infectNextPeople();
}