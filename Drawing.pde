void drawPeople() {
  color uninfected = color(0, 0, 0, infectionAlpha);
  ellipseMode(CORNER);
  noStroke();
  for (Person p : world) {
     if (p.infected) {
       fill(p.infection.infColor);
     } else {
       fill(uninfected);
     }
     ellipse(p.px, p.py, personSize, personSize);
     
     if (showParents) {
       if (p.infected) {
         stroke(hue(p.infection.infColor), saturation(p.infection.infColor), brightness(p.infection.infColor), parentAlpha);
       } else {
         stroke(0,0,0,50);
       }
       ellipseMode(CENTER);
       for (int st : p.students) {
         Person s = world.get(st);
         line(p.px, p.py, s.px, s.py);
       }
     }
  }
}