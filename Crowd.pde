class Crowd{
  
  ArrayList<Creature> creatures;
  ArrayList<Creature> humans;
  ArrayList<Creature> zombies;
  ArrayList<Creature> zombieCage;
  
  float zms, zmf, zdf, zds, zv, zs, zat, zal, zc;
  float hms, hmf, hdf, hds, hv, hs, hat, hal, hc;
  
  Crowd(){
    creatures = new ArrayList<Creature>();
    humans = new ArrayList<Creature>();
    zombies = new ArrayList<Creature>();
    zombieCage = new ArrayList<Creature>();
  }
  
  void computeAverageValues(){
    int countz = 0;
    int counth = 0;
    zms = zmf = zdf = zds = zv = zat = zal = zc = 0;
    for(Creature c :zombies){
      zms += c.maxspeed;
      zmf += c.maxforce;
      zds += c.desiredSeparation;
      zv += c.vision;
      zs += c.separate;
      zat += c.attract;
      zal += c.align;
      zc += c.cohesion;
      countz ++;
    }
    zms /= countz;
    zmf /= countz;
    zds /= countz;
    zv /= countz;
    zs /= countz;
    zat /= countz;
    zal /= countz;
    zc /= countz;
    
    hms = hmf = hdf = hds = hv = hat = hal = hc = 0;
    for(Creature h :humans){
      hms += h.maxspeed;
      hmf += h.maxforce;
      hds += h.desiredSeparation;
      hv += h.vision;
      hs += h.separate;
      hat += h.attract;
      hal += h.align;
      hc += h.cohesion;
      counth ++;
    }
    hms /= counth;
    hmf /= counth;
    hds /= counth;
    hv /= counth;
    hs /= counth;
    hat /= counth;
    hal /= counth;
    hc /= counth;
  }
  
  float rnd(float number) {
    return (float)(round((number*pow(10, 3))))/pow(10, 3);
  }

  void printStats(){
    println("h: " + humans.size() + "  z: " + zombies.size());
    println("Zombies: "+ "ms: "+rnd(zms)+",mf "+rnd(zmf)+",ds "+rnd(zds)+",v "+rnd(zv)+",s "+rnd(zs)+",at "+rnd(zat)+",al "+rnd(zal)+",zc "+rnd(zc));
    println("Humans: "+"ms: "+rnd(hms)+",mf "+rnd(hmf)+",ds "+rnd(hds)+",v "+rnd(hv)+",s "+rnd(hs)+",at "+rnd(hat)+",al "+rnd(hal)+",zc "+rnd(hc));
    println(" ");
  }
    
  void displayText(){
    noStroke();
    textSize(30);
    fill(zombieColor);
    text(zombies.size(),20,80);
    fill(humanColor);
    text(humans.size(), 20,50);
  }
    
  void run(){    
    displayText();
    //println();
    computeAverageValues();
    makeZombies();
    for(Creature h: humans){
      h.applyBehaviours(creatures);
      h.update();
    }
    Iterator<Creature> zit = zombies.iterator();
    while(zit.hasNext()){
      Creature z = zit.next();
      z.applyBehaviours(creatures);
      z.update();
      if(z.dead == true){
        if(zombies.size()>5){
          for(int i=0; i<humanSpawns; i++){
             PVector rand = new PVector(int(random(-10,10)),int(random(10,10)));
             PVector loc= PVector.add(rand,z.location);
             createHuman(loc);
          } 
          zit.remove();
        }
      }
    }
  }
  
  float addVar(float num){
    float tolerance = num*evolutionRate;
    float var = random(-tolerance, tolerance);
    num += var;
    return num;
  }

  
  void addCreature(Creature c, boolean zombieState){
    creatures.add(c);
    if (zombieState){
      zombies.add(c);
    }else{
      humans.add(c);
    }
  }
  
  void makeZombies(){
    Iterator<Creature> hit = humans.iterator();
    while(hit.hasNext()){
      Creature h = hit.next();
      for(Creature z: zombies){
        if(PVector.dist(h.location,z.location)<5){
          z.resetTimer();
          zombieCage.add(h);
          h.becomeZombie(addVar(zms), addVar(zmf),addVar(zds),addVar(zv),addVar(zs),addVar(zat),addVar(zal),addVar(zc));
          hit.remove();
          break;
        }
      }
    }
    for(Creature c: zombieCage){
      zombies.add(c);
    }
    zombieCage.clear();
  } 
  
  void createHuman(PVector pos){
    Creature spawn = new Creature(false, pos, addVar(hms),addVar(hmf),addVar(hds),addVar(hv),addVar(hs),addVar(hat),addVar(hal),addVar(hc));
    addCreature(spawn, false);        
  }
}
