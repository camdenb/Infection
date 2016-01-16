void drawPeople() {
  color uninfected = color(0, 0, 0, infectionAlpha);
  //ellipseMode(CORNER);
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
         stroke(0,0,0,parentAlpha);
       }
       strokeWeight(1);
       ellipseMode(CENTER);
       for (int st : p.students) {
         Person s = world.get(st);
         line(p.px, p.py, s.px, s.py);
       }
     }
  }
}

void drawPanel() {
    
  //draw panel bg
  fill(0,0,255);
  rect(0, 0, panelSize, height);
  
  //draw border
  stroke(0,0,0);
  strokeWeight(5);
  //line(panelSize, 0, panelSize - 5, height);
  
}

void drawGUI() {
  fill(0,0,0);
  
  text("Total Infected: " + totalInfected, 10, 40);
  text("Percent Infected: " + ((int)(10000 * ((totalInfected * 1.0) / world.size())) / 100.0), 10, 60);
  text("Limit Infection? (Right-Click to Cycle): " + LIMIT_INFECTION, 10, 120);
  if(LIMIT_INFECTION)
    text("Limiting at: " + currentInfectionLimit + "% of Population Infected", 10, 140);
 
  
  text("Total People (Estimated): ", 10, height - 20);
  text("Minimum Class Size: ", 10, height - 40);
  text("Maximum Class Size: ", 10, height - 60);
  text("% of Students Who Also Teach: ", 10, height - 80);
  
  if(newestInfection != null) {
    text("Number of Infections So Far: " + (newestInfection.version + 1), 10, 80);
    fill(hue(newestInfection.infColor), saturation(newestInfection.infColor), brightness(newestInfection.infColor), 255);
    text("Current Infection: " + newestInfection.flavorName, 10, 20); 
  } else {
    text("Click anywhere to start a random infection", 10, height / 2); 
  }
}