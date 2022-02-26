--Base class of Field
Field =  {
potentialMatchCount = 0
}
--[[
Create a new instance of Field class
@param:
  size  - table {X,Y} if a field size
  geometry_opt - table {(X,Y),{X,Y}} - array of void point on a map
]]
require ("Crystalls")
function Field:new (size, geometry_opt)
  local obj = {}
  obj.map = {};
  self.__index = self;
  setmetatable (obj, self);
  obj.size = size;
  obj.isHaveChange = false;
  obj:fillZero(obj.map);
  return obj;
  end

function Field:fillZero(map)
require ("Crystalls")
for i = 0, self.size.Y-1 do
    local  _rows = {}
    for j = 0, self.size.X-1 do
     table.insert (_rows,j,Crystal:getBaseCrystal({X=i,Y=j},self))
    end
    table.insert (map,i,_rows)
     end
end
--Initialize the field with random colors
function Field:fill ()

  for i = 0,#self.map do
    for j = 0, #self.map[0] do
      print ("generate for i = "..i.." j="..j)
      self.map[i][j] = self:getRandomCrystallAtPoint(i,j);
    end
  end
  self:checkForPotentialMatch();
  if self.potentialMatchCount == 0 then self:fill(); end;
end

function Field:getRandomCrystallAtPoint (x,y) 
 --local candidate = getRandomColor ();
  local candidate = Crystal:getRandomCrystal({X=x,Y=y},self);
  local candidate_is_good = false;
  while not candidate_is_good  do
  candidate = Crystal:getRandomCrystal({X=x,Y=y},self);
  candidate_is_good = not self:isMakeThreeMatch(candidate,x,y)
  end
  return candidate;
end
require ("Matching")
function Field:isMakeThreeMatch (crystal, x,y)
--Several case

--By X coordinate - vertical
if self:isSame(crystal, x-2, y) and self:isSame(crystal, x-1, y) then return Match:new(MatchType[1],x-1,y,self) end;
if self:isSame(crystal, x+2, y) and self:isSame(crystal, x+1, y) then return Match:new(MatchType[1],x+1,y,self) end;
if self:isSame(crystal, x-1, y) and self:isSame(crystal, x+1, y) then return Match:new(MatchType[1],x,y,self) end;
--By Y coordinate
if self:isSame(crystal, x, y-2) and self:isSame(crystal, x, y-1) then return Match:new(MatchType[2],x,y-1,self) end;
if self:isSame(crystal, x, y+2) and self:isSame(crystal, x, y+1) then return Match:new(MatchType[2],x,y+1,self) end;
if self:isSame(crystal, x, y-1) and self:isSame(crystal, x, y+1) then return Match:new(MatchType[2],x,y,self) end;

return nill;
end

function Field:isSame (crystal, x, y)
  if x>#(self.map) or x<0 or y<0 or y>#(self.map[0])  then return false end; -- check bound
  if self.map[x][y].color==crystal.color then 
  return true;
  else
  return false
  end;
end

function Field:checkForPotentialMatch ()
self.potentialMatchCount = 0;
for i = 0,#self.map do
    for j = 0, #self.map[0] do
      
      
      self:makePseudoChoise({X=i,Y=j},{X=i+1,Y=j});
      self:makePseudoChoise({X=i,Y=j},{X=i,Y=j+1});
    end
  end
print ("potential choises: ".. self.potentialMatchCount);

return false
end


--[[Check for matching after make a move 
@params: point_from - table {X,Y} the dot from crystal move
            point_to - table {X,Y} the dot where crystal move
@return true if make match]] 
      
function Field:makePseudoChoise (point_from, point_to)
--check for bounds
  if point_to.X>#(self.map)-1 or point_to.X<0 or point_to.Y<0 or point_to.Y>#(self.map[0]) -1 then return false end; 
  result = false;
  --swap the crystals
  local _temp_Crystal = self.map[point_to.X][point_to.Y];
  self.map[point_to.X][point_to.Y] = self.map[point_from.X][point_from.Y];
  self.map[point_from.X][point_from.Y] = _temp_Crystal;
  
  if self:isMakeThreeMatch(_temp_Crystal,point_from.X,point_from.Y) then
    self.potentialMatchCount = self.potentialMatchCount + 1;
    result = true;
  elseif self:isMakeThreeMatch(self.map[point_to.X][point_to.Y],point_to.X,point_to.Y) then
    self.potentialMatchCount = self.potentialMatchCount + 1;
    result = true;
  end
  
  --swap the crystals back
  _temp_Crystal = self.map[point_to.X][point_to.Y];
  self.map[point_to.X][point_to.Y] = self.map[point_from.X][point_from.Y];
  self.map[point_from.X][point_from.Y] = _temp_Crystal;
  return result;
end

function Field:makeChoice (userCommand)
  self.isHaveChange = true;
 local _temp_Crystal = self.map[userCommand.finishX][userCommand.finishY];
 self.map[userCommand.finishX][userCommand.finishY] = self.map[userCommand.startX][userCommand.startY];
 self.map[userCommand.startX][userCommand.startY] = _temp_Crystal;
 self.map[userCommand.finishX][userCommand.finishY].position = {X = userCommand.finishX, Y = userCommand.finishY};
 self.map[userCommand.startX][userCommand.startY].position = {X = userCommand.startX, Y = userCommand.startY};
 local matching = {}
 matching.match = false;
 local match = self:isMakeThreeMatch(_temp_Crystal,userCommand.startX,userCommand.startY);
 if match then
     matching.match = true
     matching[1] = match
 end
 local match2 =  self:isMakeThreeMatch(self.map[userCommand.finishX][userCommand.finishY],userCommand.finishX,userCommand.finishY);
 if match2 then
     matching.match = true
     matching[2] = match2
 end
 return matching;
end
function Field:cancelChoice (userCommand)
self.isHaveChange = false;
  local _temp_Crystal = self.map[userCommand.finishX][userCommand.finishY];
  self.map[userCommand.finishX][userCommand.finishY] = self.map[userCommand.startX][userCommand.startY];
  self.map[userCommand.startX][userCommand.startY] = _temp_Crystal;
  self.map[userCommand.finishX][userCommand.finishY].position = {X = userCommand.finishX, Y = userCommand.finishY};
  self.map[userCommand.startX][userCommand.startY].position = {X = userCommand.startX, Y = userCommand.startY};
end

function Field:tick ()
self.isHaveChange = false;
for i = #self.map-1,0, -1 do
    for j = 0, #self.map[0] do
      self.map [i][j]:tick();
    end
end
end