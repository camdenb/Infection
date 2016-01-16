/*************************************************************

 _____             ___               _    _                   
|_   _|          .' ..]             / |_ (_)                  
  | |   _ .--.  _| |_  .---.  .---.`| |-'__   .--.   _ .--.   
  | |  [ `.-. |'-| |-'/ /__\\/ /'`\]| | [  |/ .'`\ \[ `.-. |  
 _| |_  | | | |  | |  | \__.,| \__. | |, | || \__. | | | | |  
|_____|[___||__][___]  '.__.''.___.'\__/[___]'.__.' [___||__] 
                    
                                                              
Author: Camden Bickel

*************************************************************/



boolean LIMIT_INFECTION;
int limitPercentIncrease;
int currentInfectionLimit;

int tickTime;
int lastUpdateTime;

int minClassSize;
int maxClassSize;
int maxPeople;

int pctOfStudentsWhoTeach;


int positionDev;
float personSize;
int infectionAlpha;
boolean showParents;
int parentAlpha;

int worldSpaceSize;
int panelSize;

int totalInfected;

int newestInfectionVersion;
Infection newestInfection;

ArrayList<Person> world;

HashMap<Integer, Infection> toBeInfected;

boolean randomDistributionMode;

// global vars
float personSizeIncrement = 0.2;

void initAllVariables() {
  
   // config
   LIMIT_INFECTION = false;
   limitPercentIncrease = 10;
   currentInfectionLimit = 0;
  
   tickTime = 10;
   lastUpdateTime = tickTime + 1;
  
   maxPeople = 10000; // must be greater than maxClassSize
   loadDistributionValues();
 
   positionDev = 20; // how far +- is a student away from a teacher
   personSize = 4;
   infectionAlpha = 40;
   showParents = false;
   parentAlpha = 20;
  
   worldSpaceSize = 500;
   panelSize = 300; //size of left-hand gui panel
  
  //stats!
   totalInfected = 0;
  
  
   newestInfectionVersion = 0;
  
  // the world contains a list of Persons, but throughout the program
  // each Person will often be referred to by its index in world
  world = new ArrayList<Person>();
  
  // a list of people (in the form of world indices) who will be infected in the next tick
  toBeInfected = new HashMap<Integer, Infection>();
  
}

void loadDistributionValues() {
  minClassSize = 1;  // these variables (more importantly average class size) are inversely proportional the the spread
  maxClassSize = 30; // of the graph
  
  pctOfStudentsWhoTeach = 5; // (out of 100) percentage of people who are both students and teachers this
                                 // variable is inversely proportional to the visual spread of the graph
                                 // by creating more "clusters" of quarantined people the lower it is
                                 
  if (randomDistributionMode) {
    minClassSize = randInt(0,20);
    maxClassSize = minClassSize + randInt(0, 30);
    pctOfStudentsWhoTeach = randInt(1,20);
  }
}

void setup() {
  initAllVariables();
  size(800, 500); //these should match worldSpaceSize and panelSize -- had to use magic nums :'(
  runTests();
  generateWorld();
  colorMode(HSB);
  lastUpdateTime = millis(); // get current time
}  



void runTests() {
  ArrayList<TestResult> testResults = new Tester().runAll();
  
  println(testResults.size() + " tests ran.");
  
  int successes = 0;
  
  for (TestResult tr : testResults) {
    if (tr.success)
      successes++;
  }
  
  println(successes + " out of " + testResults.size() + " tests passed.");
  
  for (TestResult tr : testResults) {
    if (!tr.success)
      println(tr.message);
  }
  
  world.clear();
}

void draw() {
  update();
  //clear();
  background(0, 0, 255);
  
  drawPeople();
  drawPanel();
  drawGUI();
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

void mousePressed() {
  if (mouseButton == LEFT) {
    startRandomInfection();
  } else if (mouseButton == RIGHT) {
    if (currentInfectionLimit == 0) {
      LIMIT_INFECTION = true;
    }
    currentInfectionLimit = (currentInfectionLimit + limitPercentIncrease) % 100;
    if (currentInfectionLimit == 0)
      LIMIT_INFECTION = false;
  }
}

void keyReleased() {
  if (key == 'l') {
    showParents = !showParents;  
  } else if (key == 'r') {
    randomDistributionMode = false;
    setup(); // restart! 
  } else if (key == 'R') {
    randomDistributionMode = true;
    setup();
  } else if (key == '-') {
    addToPersonSize(-5);
  } else if (key == '=') {
    addToPersonSize(5);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  addToPersonSize((int) e);
}

void addToPersonSize(int multiplier) {
  float amt = (float)((int)(100 * multiplier * personSizeIncrement)) / 100;
  personSize += amt;
}

void generateWorld () {
  
  // first person, has no students (yet) and no teachers (ever)
  Person firstPerson = new Person();
  firstPerson.setPosition(randInt(panelSize, width), randInt(0, height));
  
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