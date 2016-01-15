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

*************************************************************/


// config
final boolean LIMIT_INFECTION = false;

int tickTime = 10;
int lastUpdateTime = tickTime + 1;
int infectionPerTickLimit = 300;

int minClassSize = 1; // these variables (more importantly average class size) are inversely proportional the the spread
int maxClassSize = 30; // of the graph
int maxPeople = 10000; // must be greater than maxClassSize

int pctOfStudentsWhoTeach = 5; // (out of 100) percentage of people who are both students and teachers this
                               // variable is inversely proportional to the visual spread of the graph
                               // by creating more "clusters" of quarantined people the lower it is


int positionDev = 20; // how far +- is a student away from a teacher
int personSize = 4;
int infectionAlpha = 40;
boolean showParents = true;
int parentAlpha = 10;

int newestInfectionVersion = 0;
Infection newestInfection;

// the world contains a list of Persons, but throughout the program
// each Person will often be referred to by its index in world
ArrayList<Person> world = new ArrayList<Person>();

// a list of people (in the form of world indices) who will be infected in the next tick
HashMap<Integer, Infection> toBeInfected = new HashMap<Integer, Infection>();

void setup() {
  size(600, 600);
  generateWorld();
  colorMode(HSB);
  lastUpdateTime = millis(); // get current time
}  

void draw() {
  update();
  //clear();
  background(0, 0, 255);
  drawPeople();
  fill(255,255,255);
  if(newestInfection != null)
    text("Current Infection: " + newestInfection.flavorName, 10, 10);
}

void update() {
  if (millis() - lastUpdateTime > tickTime) {
    tick();
    lastUpdateTime = millis();
  }
}

void tick() {
  infectNextPeople();
}

void mouseClicked() {
  startRandomInfection();
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
  //sortWorldByPosition();
}

void sortWorldByPosition() {
  
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