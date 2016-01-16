
// Using this hacky tester class because I'm using a Processing 
// development environment and I was unable to import JUnit.
// Hey, it works! 

class Tester {
  
  ArrayList<TestResult> runAll() {
    ArrayList<Test> allTests = new ArrayList<Test>();
    allTests.addAll(testPerson());
    
    ArrayList<TestResult> results = new ArrayList<TestResult>();
    
    for (Test t : allTests) {
      results.add(runTest(t));
    }
    
    return results;
  }
  
  TestResult runTest (Test t) {
    if (t.assertion) {
      return new TestResult("Test Passed", true);
    } else {
      return new TestResult("Test Failed: " + t.failMessage, false);
    }
      
  }
  
  boolean testHelperFunctions() {
    return true; 
  }
  
  ArrayList<Test> testPerson() {
    ArrayList<Test> tests = new ArrayList<Test>();
    
    Person p1 = new Person();
    p1.setPosition(10, 10);
    Person p2 = new Person();
    p2.setPosition(10, 20);
    Person p3 = new Person();
    p3.setPosition(-102, 100000);
    
    p1.setTeacher(world.indexOf(p2));
    p2.addStudent(world.indexOf(p1));
    
    tests.add(new Test(p1.hasTeacher, "hasTeacher should return true if a Person has a teacher."));
    tests.add(new Test(p2.students.get(0).equals(world.indexOf(p1)), "Person.students should contain the person's students")); 
    tests.add(new Test(p3.px >= panelSize, "Person's position should be constrained by world bounds"));
    tests.add(new Test(p3.py <= height, "Person's position should be constrained by world bounds"));
    
    return tests;
  }
  
  boolean testInfection() {
    return true;
  }
  
  
  
  
}

static class Test {
 
  boolean assertion;
  String failMessage;
  
  Test (boolean a, String f) {
    this.assertion = a;
    this.failMessage = f;
  }
  
}

class TestResult {
  
  String message;
  boolean success;
  
  TestResult (String m, boolean s) {
    this.message = m;
    this.success = s;
  }
  
}