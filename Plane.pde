float dt = 0.1;

class Plane{
  PVector pos, vel;
  float heading, speed;
  Plane enemy;
  String state;
  int windowX, windowY, health, dead=0, timeOfDeath;
  Missile missileFired;

  final int maxhealth = 100;
  final float respawnTime = 1000;
  final float HIGH = 10;
  final float MEDIUM = 5;
  final float LOW = 2;

  public Plane(int color, int windowX, int windowY, PVector pos){
    this.color = color;
    this.health = this.maxhealth;
    this.windowX = windowX;
    this.windowY = windowY;
    this.pos = pos;
    this.vel = new PVector(0.0, 0.0);
    this.speed = 0.0;
    this.heading = 0.0;
    this.headingV = new PVector(1.0, 0.0);
    this.enemy = null;
    this.state = "Start";
    this.missileFired = null;
  }

  float angleFromPlayerToEnemy(){
    PVector meToEnemy = PVector.sub(this.enemy.pos, this.pos);
    float angleBetween = PVector.angleBetween(this.headingV, meToEnemy);
    meToEnemy.set(-meToEnemy.y, meToEnemy.x, 0.0);
    float dot = this.headingV.dot(meToEnemy);
    if(dot >= 0) return degrees(angleBetween);
    else if(dot < 0) return 360.0 - degrees(angleBetween);
    else return 0;
  }

  public void changeState(String newState){
    this.state = newState;
  }

  public void maintainHeading(){
    //console.log("Maintaining heading!");
  }

  public void changeSpeedTo(String desiredSpeed){
    if(desiredSpeed == "HIGH")
      this.speed = HIGH;
    else if(desiredSpeed == "MEDIUM")
      this.speed = MEDIUM;
    else if(desiredSpeed == "LOW")
      this.speed = LOW;
  }

  public void turnByHeading(float dHeading){
    this.heading += dHeading;
    this.heading = this.heading % 360.0;
    float headingVy = sin(radians(this.heading));
    float headingVx = cos(radians(this.heading));
    this.headingV.set(headingVx, headingVy, 0.0);
  }

  public void turnRightBy(float degrees){
    this.turnByHeading(degrees);
  }

  public void turnLeftBy(float degrees){
    this.turnByHeading(-degrees);
  }

  public void fireMissile(){
    if(this.missileFired == null)
      this.missileFired = new Missile(this.pos, this.heading, {this, this.enemy});
  }

  public void draw(){
    if(this.dead == 1){

    }
    else{
      //draw plane
      stroke(0);
      fill(this.color);
      ellipse(this.pos.x, this.pos.y, 10, 10);

      //draw heading indicator
      stroke(255);
      float dx = 10.0*cos(radians(this.heading));
      float dy = 10.0*sin(radians(this.heading));
      line(this.pos.x, this.pos.y, this.pos.x + dx, this.pos.y + dy);

      if(this.missileFired != null)
        this.missileFired.m_draw();
    }
  }

  public void damage(int damageDone){
    console.log("BOOM!");
    this.health -= damageDone;
    if(health <= 0){
      this.dead = 1;
      this.timeOfDeath = millis();
    }
  }

  public void update(){
    if(this.dead == 1){
      if(millis() - this.timeOfDeath >= respawnTime){
        this.pos.x = random(0, windowX);
        this.pos.y = random(0, windowY);
        this.health = this.maxhealth;
        this.dead = 0;
      }
    }
    else{
      // update velocity by current speed/heading
      this.vel.x = this.speed * cos(radians(this.heading));
      this.vel.y = this.speed * sin(radians(this.heading));

      // update position by velocity * dt

      this.pos.x += this.vel.x * dt;
      this.pos.y += this.vel.y * dt;

      if(this.pos.x < 0) this.pos.x = this.windowX + this.pos.x;
      if(this.pos.y < 0) this.pos.y = this.windowY + this.pos.y;
      if(this.pos.x > this.windowX) this.pos.x = this.pos.x - this.windowX;
      if(this.pos.y > this.windowY) this.pos.y = this.pos.y - this.windowY;

      // update enemy observations
      if(this.enemy != null){

      }

      if(this.missileFired != null){
        if(this.missileFired.isDetonated == 1) this.missileFired = null;
        else
          this.missileFired.m_update();
      }
    }
  }
}
