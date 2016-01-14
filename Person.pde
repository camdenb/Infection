class Person {
  
  int teacher; // teachers and students are stored as a list of indices
  ArrayList<Integer> students = new ArrayList<Integer>(); // see above ;)
  boolean infected = false;
  int id = int(10000 + random(1) * 90000);
  int index;
  String SITE_VERSION;                                                     // CHANGE AND IMPLEMENT ME
  int px;
  int py;
   
   
  Person () {
    world.add(this);
    this.index = world.indexOf(this);
  }
  
  Person (int teacher) {
    this();
    this.teacher = teacher;
    this.px = world.get(teacher).px + randInt(-positionDev, positionDev);
    this.py = world.get(teacher).py + randInt(-positionDev, positionDev);
    this.constrainPosition();
  }
  
  void constrainPosition() {
    if (this.px + personSize > width) this.px = width - personSize;
    if (this.px < 0) this.px = 0;
    if (this.py + personSize > height) this.py = height - personSize;
    if (this.py < 0) this.py = 0;
  }
  
  void setPosition (int x, int y) {
    this.px = x;
    this.py = y;
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
  
}