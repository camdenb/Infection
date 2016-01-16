class Person implements Comparable<Person> {
  // Note: this class has a natural ordering that is inconsistent with equals.
  // Comparison only looks at position
  
  int teacher; // teachers and students are stored as a list of indices
  boolean hasTeacher = false;
  ArrayList<Integer> students = new ArrayList<Integer>(); // see above ;)
  
  boolean infected = false;
  Infection infection;
  Infection nextInfection; // do not initialize this variable, only used in modeling infections
  
  int id = int(10000 + random(1) * 90000);
  int index;
  int px;
  int py;
   
  Person () {
    world.add(this);
    this.index = world.indexOf(this);
  }
  
  Person (int teacher) {
    this();
    this.teacher = teacher;
    this.hasTeacher = true;
    this.assignRandomPosition();
    this.constrainPosition();
  }
  
  void constrainPosition() {
    if (this.px + personSize > width) this.px = width - personSize;
    if (this.px < panelSize) this.px = panelSize;
    if (this.py + personSize > height) this.py = height - personSize;
    if (this.py < 0) this.py = 0;
  }
  
  void assignRandomPosition() {
    this.px = world.get(teacher).px + randInt(-positionDev, positionDev);
    this.py = world.get(teacher).py + randInt(-positionDev, positionDev); 
  }
  
  void setPosition (int x, int y) {
    this.px = x;
    this.py = y;
    this.constrainPosition();
  }
  
  void setTeacher (int t) {
    this.teacher = t;
    this.hasTeacher = true;
  }
    
  void addStudent (int s) {
    this.students.add(s); 
  }
  
  void addStudents (ArrayList<Integer> s) {
    this.students.addAll(s); 
  }
  
  String toString() {
    String infectedStr;
    if (infected) {
      infectedStr = "[I]";
    } else {
      infectedStr = "[ ]";
    }
    return infectedStr + "[" + this.index + "] Teacher: [" + teacher + "]; Students: " + students.toString();
  }
  
  //only compares position
  int compareTo(Person p) {
     if (this.px == p.px && this.py == p.py) {
       return 0; 
     } else if (this.py > p.py || (this.py == p.py && this.px > p.px)) {
       return 1;  
     } else {
       return -1; 
     }
  }
  
}