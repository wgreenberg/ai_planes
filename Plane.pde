float dt = 0.1;

class Plane{
  PVector pos, vel;
  float heading, speed;
  Plane enemy;
  String state;
  int windowX, windowY;

  final float HIGH = 10;
  final float MEDIUM = 5;
  final float LOW = 2;

  public Plane(int windowX, int windowY, PVector pos){
    this.windowX = windowX;
    this.windowY = windowY;
    this.pos = pos;
    this.vel = new PVector(0.0, 0.0);
    this.speed = 0.0;
    this.heading = 0.0;
    this.enemy = null;
    this.state = "Start";
  }

  public void changeState(String newState){
    this.state = newState;
  }

  public void maintainHeading(){
    console.log("Maintaining heading!");
  }

  public void changeSpeedTo(String desiredSpeed){
    console.log(desiredSpeed);
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
    console.log("new heading: " + this.heading);
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
    fill(0);
    ellipse(this.pos.x, this.pos.y, 10, 10);
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
