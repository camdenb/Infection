void drawPeople() {
  ellipseMode(CORNER);
  color uninfected = color(255, 0, 0, 100);
  color infected = color(0, 255, 0, 100);
  stroke(0,0,0,0);
  for (Person p : world) {
     if (p.infected) {
       fill(infected);
     } else {
       fill(uninfected);
     }
     ellipse(p.px, p.py, personSize, personSize);
  }
}