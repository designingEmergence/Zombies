import java.util.Iterator;

int boundary = 10;
int initHuman = 100;
int initZombie = 20;
int zCounterInit = 1500;
int humanSpawns = 1;
float evolutionRate = 0.05;

color humanColor = color(250,120,120);
color zombieColor = color(160,170,90);

//  color humanColor = color(255);
  //color zombieColor = color(0);

Crowd crowd;

void setup(){
  size(1280,720);
  background(247,238,190);
  crowd = new Crowd();
  initializeCreatures(initHuman, false);
  initializeCreatures(initZombie, true);
}

void draw(){
  background(240,239,225);
  crowd.run();
}

void initializeCreatures(int num,boolean zState){
  for (int i=0;i<num;i++){
    PVector location = new PVector(random(width),random(height));
    float mspeed = random(0.5,2);
    float mforce = random(0.002,.02);
    float desSep = random(10,200);
    float vision = random(20,200);
    float sep = random(0.2,2);
    float att = random(0.2,2);
    float ali = random(0.2,2);
    float coh = random(0.2,2);
    Creature c = new Creature(zState,location, mspeed,mforce,desSep,vision, sep, att, ali, coh);
    crowd.addCreature(c, zState);
  }
}

void mouseClicked(){
  //crowd.createHuman(new PVector(mouseX,mouseY));
  //crowd.makeAllZombies();
  crowd.printStats();
}

  
