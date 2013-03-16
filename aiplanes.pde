int windowX = 500;
int windowY = 500;

Plane plane = new Plane(windowX, windowY, new PVector(50.0, 50.0));

void setup(){
  size(windowX, windowY);
}

int color = 0;

void draw(){
  background(100);

  plane.update();
  plane.draw();
}

int executeCommand(command, parameter){
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
