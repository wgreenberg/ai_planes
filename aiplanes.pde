int windowX = 500;
int windowY = 500;

interface JavaScript {
  void initBehavior();
}

void bindJavascript(JavaScript js){
  javascript = js;
  javascript.initBehavior();
}

JavaScript javascript;
Plane enemy = new Plane(#FF0000, windowX, windowY, new PVector(400.0, 450.0));
Plane player = new Plane(#000000, windowX, windowY, new PVector(50.0, 100.0));

void setup(){
  size(windowX, windowY);
  enemy.enemy = player;
  player.enemy = enemy;
}

int color = 0;
int prevTime = 0;

void draw(){
  background(100);
  float now = millis();
  float dt = now - prevTime;

  if(dt > 100){
    if(enemyBehavior != undefined)
      enemyBehavior.evalState();
    if(playerBehavior != undefined)
      playerBehavior.evalState();
    prevTime = now;
  }

  enemy.update();
  enemy.draw();

  player.update();
  player.draw();
}

Plane getPlane(id){
  if(id == "player") return player;
  else if(id == "enemy") return enemy;
  else return null;
}

PVector getPosition(meOrHim){
  if(meOrHim == "me") return player.pos;
  else if(meOrHim == "him") return enemy.pos;
}

int executeCommand(command, parameter, id){
  Plane plane;
  if(id == "player") plane = player;
  else if(id == "enemy") plane = enemy;
  else return -1;

  switch(command){
    case "maintainHeading":
      plane.maintainHeading();
      break;
    case "changeSpeedTo":
      plane.changeSpeedTo(parameter);
      break;
    case "turnRightBy":
      plane.turnRightBy(parseFloat(parameter));
      break;
    case "turnLeftBy":
      plane.turnLeftBy(parseFloat(parameter));
      break;
    case "fireMissile":
      plane.fireMissile();
      break;
    case "goToState":
      plane.changeState(parameter);
      break;
    default: // command not recognized
      return -1;
      break;
  }
  return 1;
}
