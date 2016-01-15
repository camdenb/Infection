void drawPeople() {
  ellipseMode(CORNER);
  color uninfected = color(0, 0, 0, infectionAlpha);
  stroke(0,0,0,0);
  for (Person p : world) {
     if (p.infected) {
       fill(p.infection.hue);
     } else {
       fill(uninfected);
     }
     ellipse(p.px, p.py, personSize, personSize);
  }
}

//https://forum.processing.org/two/discussion/10615/memory-leak-using-arraylist
void diag() {
  fill(255,255,255);
  int MEGABYTE = 1024 * 1024;
  int maxMemory = int(Runtime.getRuntime().maxMemory()/MEGABYTE);
  int totalMemory = int(Runtime.getRuntime().totalMemory()/MEGABYTE);
  int freeMemory = int(Runtime.getRuntime().freeMemory()/MEGABYTE);
  int percentage = int((float)freeMemory/totalMemory*100);
 
 text("max: " + maxMemory + " | total: " + totalMemory + " (" + percentage + "%)" + " | free: " + freeMemory, 15, 200);
}