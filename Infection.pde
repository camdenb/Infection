class Infection {
  
  int version = 0;
  String flavorName = "1.0";
  color infColor;
  
  Infection() {
    this.version = newestInfectionVersion;
    newestInfectionVersion++;
    this.infColor = color(randInt(0,255), 255, 120, infectionAlpha);
    this.flavorName = generateFlavorName();
  }
  
  String generateFlavorName() {
    char[] alphabet = "abcdefghijklmnopqrstuvwxyz".toCharArray();
    String str = "1.";
    str += randInt(0, 999);
    if (percentDieRoll(60)) str += "." + randInt(0,99);
    if (percentDieRoll(70)) str += alphabet[randInt(0, alphabet.length - 1)];
    if (percentDieRoll(60)) str += alphabet[randInt(0, alphabet.length - 1)];
    return "Version " + str;
  }
  
}