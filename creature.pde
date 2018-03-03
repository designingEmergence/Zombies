class Creature {
  
  //BASIC VARIABLES
  PVector location,velocity,acceleration;
  PVector diff;
  float r;
  boolean zombieState;
  boolean dead = false;
  
  //GLOBAL DNA
  float maxspeed, maxforce, desiredSeparation, vision, separate, attract, align, cohesion;
  
  //HUMAN DNA
  int humanSize = 3;
  
  
  //ZOMBIE DNA
  int zombieSize = 4;
  int zombieCounter = zCounterInit;
  
  Creature(boolean zs, PVector pos, float ms, float mf, float ds, float v, float _s, float _at, float _al, float _c){
    location = pos.get();
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    
    zombieState = zs; 
    
    separate = _s;
    attract = _at;
    align = _al;
    cohesion = _c;
      
    maxspeed = ms;
    maxforce = mf;
    desiredSeparation = ds;
    vision = v;
  }
  
  //HELPER FUNCTIONS
  
  void applyForce(PVector force){
    acceleration.add(force);
  }
  
  PVector seek(PVector target){
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    return steer;
  }
  
  //FLOCKING FUNCTIONS
  
  PVector align(ArrayList<Creature> creatures){
      PVector sum = new PVector(0,0);
      int count = 0;
      
      for (Creature other:creatures){
        if(zombieState == false && other.zombieState == false || zombieState ==true && other.zombieState == true){
          float d = PVector.dist(location,other.location);
          if ((d>0) && (d<vision)){
            //PVector locationDiff = PVector.sub(location, other.location);
            sum.add(other.velocity);
            count++;
          }
        }
      }
      
      if(count>0){
        sum.div(count);
        sum.normalize();
        sum.mult(maxspeed);
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxforce);
        return steer;
      }else{
        return new PVector(0,0);
      }
  }
  
  PVector cohesion(ArrayList<Creature> creatures){
      PVector sum = new PVector(0,0);
      int count = 0;
      
      for (Creature other:creatures){
        if(zombieState == false && other.zombieState == false || zombieState ==true && other.zombieState == true){
          float d = PVector.dist(location,other.location);
          if ((d>0) && (d<vision)){
            //PVector locationDiff = PVector.sub(location, other.location);
            //float angleBetween = acos((velocity.dot(locationDiff))/(velocity.mag()*locationDiff.mag()));
            sum.add(other.location);
            count++;
          }
        }
      }
      if(count > 0){
        sum.div(count);
        return seek(sum);
      }else{
        return new PVector(0,0);
      }
  }
  
  PVector separateSimilar(ArrayList<Creature> creatures){
    PVector sum = new PVector();
    PVector steer = new PVector();
    int count = 0;
    for(Creature other: creatures){
      if(zombieState == false && other.zombieState == false || zombieState ==true && other.zombieState == true){
          float d = PVector.dist(location,other.location);
          if ((d>0) && (d<vision)){
            PVector diff = PVector.sub(other.location, location);
            diff.mult(-1);
            diff.normalize();
            diff.div(d);
            sum.add(diff);
            count++;
        }
      }
    }
    if(count>0){
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
    }
    return steer;
  }    
  
  PVector attractDifferent(ArrayList<Creature> creatures){
    PVector sum = new PVector();
    PVector steer = new PVector();
    int count = 0;
    for(Creature other: creatures){
      if(zombieState == false && other.zombieState == true || zombieState ==true && other.zombieState == false){
          float d = PVector.dist(location,other.location);
          if ((d>0) && (d<vision)){
            PVector diff = PVector.sub(other.location, location);
            if(!zombieState){
              diff.mult(-1);
            }
            diff.normalize();
            diff.div(d);
            sum.add(diff);
            count++;
        }
      }
    }
    if(count>0){
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
    }
    return steer;
  }    
  //follow/not follow flow field.
  
  //behavioral function
  
  //become zombie function
  
  void becomeZombie(float ms, float mf, float ds, float v, float _s, float _at, float _al, float _c){
    zombieState = true;
    maxspeed = ms;
    maxforce = mf;
    desiredSeparation = ds;
    vision = v;
    separate = _s;
    attract = _at;
    align = _al;
    cohesion = _c;
  }      
  
  //GLOBAL FUNCTIONS
  
  void applyBehaviours(ArrayList<Creature> creatures){
    PVector sep = separateSimilar(creatures);
    PVector att = attractDifferent(creatures);
    PVector ali = align(creatures);
    PVector coh = cohesion(creatures);
    
    sep.mult(separate);
    att.mult(attract);
    ali.mult(align);
    coh.mult(cohesion);

    applyForce(sep);
    applyForce(att);
    applyForce(ali);
    applyForce(coh);
}
    
  void update(){
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
    limitLocation();
    display();
    if(zombieState ==true){
      zombieCounter --;
      if(zombieCounter <1){
        dead = true;
      }
    }
    else{
      //HUMAN FUNCTIONS
    }
  }
  void resetTimer(){
    zombieCounter = zCounterInit;
  }
  void display(){
    pushMatrix();
    translate(location.x,location.y);
    fill(123);
    rotate(velocity.heading2D() +PI/2);
    
    noStroke();
    //println(zombieState);
    if(zombieState==true){
      r = zombieSize;
      fill(zombieColor);
    }else if(zombieState ==false){
      r = humanSize;
      fill(humanColor);
    }
    //ellipse(0,0,10,10);
    beginShape();
    vertex(0,-r*2);
    vertex(-r,r*2);
    vertex(r,r*2);
    
    endShape(CLOSE);
    popMatrix();
  }
  
  void limitLocation(){
    if(location.x>width+boundary){
      location.x = -boundary;
    }
    else if(location.x<-boundary){
      location.x = width+boundary;
    }
    if(location.y>height+boundary){
      location.y=-boundary;
    }
    else if(location.y<-boundary){
      location.y=height+boundary;
    }
  }
  
}
  
  
  
  
  
