
--Base class for all Crystal type
Crystal = {
color = "no_color";
}

--[[
Create a new Instance of Crystal class
@param: 
  color - string representation of color [A-F]
]]
function Crystal:new (color)
   obj = {}
   self.__index = self;
   setmetatable(obj,self);
   obj.color = color or self.color;
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

--private
function getRandomColor () 
  local r = math.random(0,#Colors);
  return Colors[r];
end

function Crystal:getRandomCrystal ()
return self:new(getRandomColor())
end
