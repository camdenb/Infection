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
int tickTime = 1000;
int avgClassSize = 25; // each class is between (avgClassSize - classSizeDev)
int classSizeDev = 10;  //                   and (avgClassSize + classSizeDev)
int minClassSize = avgClassSize - classSizeDev;
int maxClassSize = avgClassSize + classSizeDev;
int maxPeople = 200; // must be greater than maxClassSize

int pctOfStudentsWhoTeach = 20; // (out of 100) percentage of people who are both students and teachers

// the world contains a list of Persons, but throughout the program
// each Person will often be referred to by its index in world
ArrayList<Person> world = new ArrayList<Person>();

void setup() {
  size(480, 480);
  generateWorld();
  lastUpdateTime = millis(); // get current time
}  

void draw() {
  update();
  clear();
}

void update() {
  if (millis() - lastUpdateTime > tickTime) {
    tick();
    lastUpdateTime = millis();
  }
}

void tick() {
  
}

void generateWorld () {
  
  // first person, has no students (yet) and no teachers (ever)
  Person firstPerson = new Person();
  
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
  printWorld();
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
    Person newStudent = new Person();
    newStudent.addTeacher(teacher);
    students.add(newStudent.index);
  }
  
  return students;
  
}

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
  for (Person p : world) {
   println(p); 
  }
}





class Person {
  
  ArrayList<Integer> teachers = new ArrayList<Integer>(); // teachers and students are stored as a list of indices
  ArrayList<Integer> students = new ArrayList<Integer>(); // see above ;)
  boolean infected;
  int id = int(10000 + random(1) * 90000);
  int index;
  String SITE_VERSION;                                                                              // CHANGE AND IMPLEMENT ME
   
  Person () {
    world.add(this);
    this.index = world.indexOf(this);
  }
   
  Person (ArrayList<Integer> t, ArrayList<Integer> s) {
    this.teachers = t;
    this.students = s;
    world.add(this);
    this.index = world.indexOf(this);
  }
  
  void addTeacher (int t) {
    this.teachers.add(t); 
  }
  
  void addTeachers (ArrayList<Integer> t) {
    this.teachers.addAll(t); 
  }
  
  void addStudent (int s) {
    this.students.add(s); 
  }
  
  void addStudents (ArrayList<Integer> s) {
    this.students.addAll(s); 
  }
  
  String toString() {
    return "[" + this.index + "] Teachers: " + teachers.toString() + "; Students: " + students.toString();
  }
  
}