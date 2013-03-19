function Behavior(pjs, id){
  this.pjs = pjs;
  this.id = id;
  this.plane = pjs.getPlane(id);
  this.states =
    [
      {stateName: "Idle",
       actions: [
         { name: "do_nothing",
           predicates: [],
           commands: [{fn: "maintainHeading", param: undefined}] 
         }]
      }
    ];
  this.states = [];
}

Behavior.prototype.always = function(){ return true; };

Behavior.prototype.flushStates = function(newStates, i){
  if(i == undefined) i = 0;
  this.states = newStates;
  this.currentState = this.states[i];
};

Behavior.prototype.assertEnemyDirection = function(proposedDir){
  var that = this;
  return function(){
    return proposedDir == that.getDirection();
  };
};

Behavior.prototype.getDirection = function(){
  // return the relative position of the enemy
  //     SW | W  | NW
  //     S  | me | N
  //     SE | E  | NE

  var diff = this.plane.angleFromPlayerToEnemy();

  if(diff >= 350 || diff <= 10) return "N";
  else if(diff > 10 && diff <= 150) return "NW";
  else if(diff < 350 && diff > 240) return "NE";
  else return "S";
};

Behavior.prototype.addState = function(state, setAsCurrent){
  this.states.push(state);
  if(setAsCurrent === true) this.currentState = state;
};

Behavior.prototype.evalState = function(){
  // this.states = [{name: stateName, predicates: [p_fn1, p_fn2, ...], commands}]
  //   where commands = [{fn: fnName, param: parameter},...]
  var state = this.currentState;
  var commandsToExecute = [];
  $("." + this.id + "action").attr('class', this.id + "action");
  for(j in state.actions){
    var action = state.actions[j];
    var allTrue = true;
    for(i in action.predicates){
      try{
      allTrue = allTrue && action.predicates[i].fn();
      }catch(e){}
    }
    if(allTrue){
      $("#" + this.id + "-" + state.stateName + "-action" + j).attr('class', this.id + 'action activeAction');
      commandsToExecute = commandsToExecute.concat(action.commands);
    }
    else{
      $("#" + this.id + "-" + state.stateName + "-action" + j).attr('class', this.id + 'action');
    }
  }
  this.runCommands(commandsToExecute);
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
        if(this.states[j].stateName == cmdParam){
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
