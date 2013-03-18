function Behavior(pjs, id){
  this.pjs = pjs;
  this.id = id;
  this.states =
    [
      {stateName: "Idle",
       actions: [
         { name: "Do nothing",
           predicates: [],
           commands: [{fn: "maintainHeading", param: undefined}] 
         }]
      }
    ];
  this.currentState = this.states[0];
}

Behavior.prototype.always = function(){ return true; };

Behavior.prototype.assertEnemyDirection = function(proposedDir){
  var that = this;
  return function(){
    return proposedDir == that.getDirection();
  };
};

Behavior.prototype.getDirection = function(){
  // return the relative position of the enemy
  // 135   105  75    45
  //     NW | N  | NE
  // 180 W  | me | E  0
  //     SW | S  | SE
  // 225   255  285   315

  var diff = this.pjs.angleFromPlayerToEnemy();

/*  if(diff >= 85 && diff <= 95) return "N";
  else if(diff > 95 && diff <= 180) return "NW";
  else if(diff > 0 && diff < 85) return "NE";
  else return "S";
 */
  if(diff >= 340 && diff <= 20) return "N";
  else if(diff > 20 && diff <= 90) return "NW";
  else if(diff < 340 && diff > 270) return "NE";
  else return "S";
};

Behavior.prototype.evalState = function(){
  // this.states = [{name: stateName, predicates: [p_fn1, p_fn2, ...], commands}]
  //   where commands = [{fn: fnName, param: parameter},...]
  var state = this.currentState;
  for(j in state.actions){
    var action = state.actions[j];
    var allTrue = true;
    for(i in action.predicates){
      allTrue = allTrue && action.predicates[i]();
    }
    if(allTrue){
      this.runCommands(action.commands);
    }
  }
};

Behavior.prototype.runCommands = function(commands){
  // commands = [{fn: fnName, param: parameter},...]
  var result;
  for(i in commands){
    var thisCommand = commands[i],
        cmdName = thisCommand.fn,
        cmdParam = thisCommand.param;
    if(cmdName == "goToState"){
      var foundState = false;
      for(j in this.states){
        if(this.states[j].name == cmdParam){
          this.currentState = this.states[j];
          foundState = true;
        }
      }
      if(!foundState){
        console.log("Couldn't find state: " + cmdParam);
        return -1;
      }
    }
    result = this.pjs.executeCommand(cmdName, cmdParam, this.id);
  }
  return 1;
};
