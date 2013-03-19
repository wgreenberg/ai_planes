float dt = 0.1;

class Missile {
  PVector startPos, missile_pos;
  float missile_heading, missile_speed;
  Plane[] planes;
  int isDetonated = 0;
  int timeFired;

  final int gracePeriod = 100;
  final float maxDist = 500.0;
  final float detonationDist = 20.0;
  final int damage = 25;

  public Missile(PVector startPos, float heading, Plane[] planes){
    this.timeFired = millis();
    this.missile_pos = startPos.get();
    this.startPos = startPos.get();
    this.missile_heading = heading;
    this.planes = planes;
    this.missile_speed = 50;
    this.damage = 25;
  }

  public void m_update(){
    int detonate = 0;

    this.missile_pos.x += this.missile_speed * cos(radians(this.missile_heading)) * dt;
    this.missile_pos.y += this.missile_speed * sin(radians(this.missile_heading)) * dt;

    for(int i=0; i<2; i++){
      Plane plane = this.planes[i];
      float distance = this.missile_pos.dist(plane.pos);
      if(distance <= detonationDist) detonate = 1;
    }
    if(this.missile_pos.dist(this.startPos) > this.maxDist) detonate = 1;

    int timeSinceFired = millis() - this.timeFired;
    if(detonate && timeSinceFired > this.gracePeriod) this.detonate();
  }

  public void detonate(){
    for(int i=0; i<2; i++){
      Plane plane = this.planes[i];
      float distance = this.missile_pos.dist(plane.pos);
      if(distance <= detonationDist) plane.damage(this.damage);
    }

    fill(#FF0000);
    ellipse(this.missile_pos.x, this.missile_pos.y, this.detonationDist, this.detonationDist);
    this.isDetonated = 1;
  }

  public void m_draw(){
    fill(#FF0000);
    ellipse(this.missile_pos.x, this.missile_pos.y, 5, 5);
  }

}
