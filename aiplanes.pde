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
Plane enemy = new Plane(#FF0000, windowX, windowY, new PVector(100.0, 50.0));
Plane player = new Plane(#000000, windowX, windowY, new PVector(50.0, 100.0));

void setup(){
  size(windowX, windowY);
  enemy.enemy = player;
  player.enemy = enemy;
}

int color = 0;

void draw(){
  background(100);

  if(enemyBehavior != undefined)
    enemyBehavior.evalState();
  if(playerBehavior != undefined)
    playerBehavior.evalState();

  enemy.update();
  enemy.draw();

  player.update();
  player.draw();
}

float angleFromPlayerToEnemy(){
  PVector playerToEnemy = PVector.sub(enemy.pos, player.pos);
  float angleBetween = PVector.angleBetween(player.headingV, playerToEnemy);
  return degrees(angleBetween);
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
