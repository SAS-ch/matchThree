---possible command type and command argument
UserCommand = {
    commandTypes = {
    "m","q"
    },
    directionTypes = {
    "u","d","r","l"
    },
}

---Create a new instance if UserCommand
--@param commandType - char from array super class 
--@param arg - additional on example - position, direction
function UserCommand:new (commandType,arg)
    obj = {}
    obj.commandType = commandType
    self.__index = self;
    setmetatable (obj, self);
    obj:parseArg (commandType,arg)
    return obj;
end

---private
--Check and parse command argument
--@param commandType - char from array super class 
--@param arg - additional on example - position, direction
function UserCommand:parseArg (commandType,arg)
  if commandType == self.commandTypes[1] then -- in case move
  self.startX = arg.startX;
  self.startY = arg.startY;
  if arg.direction == self.directionTypes[1] then
    self.finishY = arg.startY;
    self.finishX = arg.startX -1;
  end
  if arg.direction == self.directionTypes[2] then
    self.finishY =  arg.startY;
    self.finishX = arg.startX +1;
  end
  if arg.direction == self.directionTypes[3] then
    self.finishX = arg.startX;
    self.finishY = arg.startY+1;
  end
  if arg.direction == self.directionTypes[4] then
    self.finishX = arg.startX;
    self.finishY = arg.startY-1;
  end
end
end

---public 
--Check command is correct
--@return true - if correct
--        false - if incorrect 
function UserCommand:commandIsGood (field)
    if self.finishX< 0 or self.finishX > field.size.X or self.finishY < 0 or self.finishY> field.size.Y then return false end; -- in case out of bound
    return true;
end