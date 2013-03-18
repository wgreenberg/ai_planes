float dt = 0.1;

class Plane{
  PVector pos, vel;
  float heading, speed;
  Plane enemy;
  String state;
  int windowX, windowY, health;

  final float HIGH = 10;
  final float MEDIUM = 5;
  final float LOW = 2;

  public Plane(int color, int windowX, int windowY, PVector pos){
    this.color = color;
    this.health = 100;
    this.windowX = windowX;
    this.windowY = windowY;
    this.pos = pos;
    this.vel = new PVector(0.0, 0.0);
    this.speed = 0.0;
    this.heading = 0.0;
    this.headingV = new PVector(1.0, 0.0);
    this.enemy = null;
    this.state = "Start";
  }

  public void changeState(String newState){
    this.state = newState;
  }

  public void maintainHeading(){
    //console.log("Maintaining heading!");
  }

  public void changeSpeedTo(String desiredSpeed){
    if(desiredSpeed = "high")
      this.speed = HIGH;
    else if(desiredSpeed = "medium")
      this.speed = MEDIUM;
    else if(desiredSpeed = "low")
      this.speed = LOW;
  }

  public void turnByHeading(float dHeading){
    this.heading += dHeading;
    this.heading = this.heading % 360.0;
    float headingVx = cos(radians(this.heading));
    float headingVy = sin(radians(this.heading));
    this.headingV.set(headingVx, headingVy, 0.0);
  }

  public void turnRightBy(float degrees){
    this.turnByHeading(degrees);
  }

  public void turnLeftBy(float degrees){
    this.turnByHeading(-degrees);
  }

  public void fireMissile(){
    console.log("Firing missile!");
  }

  public void draw(){
    //draw plane
    stroke(0);
    fill(this.color);
    ellipse(this.pos.x, this.pos.y, 10, 10);

    //draw heading indicator
    stroke(255);
    float dx = 10.0*cos(radians(this.heading));
    float dy = 10.0*sin(radians(this.heading));
    line(this.pos.x, this.pos.y, this.pos.x + dx, this.pos.y + dy);
  }

  public void update(){
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
  }
}
