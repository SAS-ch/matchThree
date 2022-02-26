
--Base class for all Crystal type
Crystal = {
--color = "no_color"; no way
}

--[[
Create a new Instance of Crystal class
@param: 
  color - string representation of color [A-F]
]]
function Crystal:new (color, position, field)
   obj = {}
   self.__index = self;
   setmetatable(obj,self);
   obj.color = color;
   obj.position = position;
   obj.field = field;
   obj.isVoid = false;
   return obj;
   end

Colors = {
}
Colors[0] = "A";
Colors[1] = "B";
Colors[2] = "C";
Colors[3] = "D";
Colors[4] = "E";
Colors[5] = "F";

EmptyColor = "0"
--private
function getRandomColor () 
  local r = math.random(0,#Colors);
  return Colors[r];
end

function Crystal:getRandomCrystal (position,field)
return self:new(getRandomColor(),position,field);
end

function Crystal:getBaseCrystal (position,field)
local crystal = self:new(Colors[0],position,field);
return crystal;
end
function Crystal:tick()
    if (self:getUnderCrystal().isVoid and not self.isVoid) then 
     local old_position = self.position;
     self.field.map[self:getUnderCrystal().position.X][self:getUnderCrystal().position.Y] = self;
     self.position = self:getUnderCrystal().position;
      self.field.isHaveChange = true; 
      --TODO put on old place empty crystall
      void_crystal = Crystal:new (EmptyColor,old_position,self.field);
      void_crystal.isVoid = true;
      self.field.map[old_position.X][old_position.Y] =void_crystal;
    end;
end
function Crystal:getUnderCrystal ()
  return self.field.map[self.position.X+1][self.position.Y]
end
function Crystal:match(matching)
  if  matching[1]  then 
    for i = 1,  #matching[1].crystall_to_match do
        matching[1].crystall_to_match[i].isVoid = true;
        matching[1].crystall_to_match[i].color = EmptyColor;
    end
  end
  if  matching[2]  then 
    for i = 1,  #matching[2].crystall_to_match do
        matching[2].crystall_to_match[i].isVoid = true;
        matching[2].crystall_to_match[i].color = EmptyColor;
    end
  end
end