class Infection {
  
  int version = 0;
  String flavorName = "1.0";
  color infColor;
  
  Infection() {
    this.version = newestInfectionVersion;
    newestInfectionVersion++;
    this.infColor = color(randInt(0,255), 255, 120, infectionAlpha);
  }
  
  String generateFlavorName() {
    char[] alphabet = "abcdefghijklmnopqrstuvwxyz".toCharArray();
    String part1 = "1";
    if (percentDieRoll(30)) part1 += alphabet[randInt(0, alphabet.length)];
    return "";
  }
  
}