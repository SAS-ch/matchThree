--Base class of Field
Field =  {
potentialMatchCount = 0
}
require ("Crystalls")

---public
--return a new instance of the field class
--@param size - table {X=..,Y=..} of 2D Shape represent game field
--@param geometry_opt - not realized - for difficult  game field
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

---private
--fill the field by one type of the crystals
--@param map - field class sub-table - two-dimensional array of instance of crystal class  
function Field:fillZero(map)
    for i = 0, self.size.Y-1 do
        local  _rows = {}
        for j = 0, self.size.X-1 do
           table.insert (_rows,j,Crystal:getBaseCrystal({X=i,Y=j},self))
         end
         table.insert (map,i,_rows)
    end
end

---private
--Fill the field by random crystal without creating matches
function Field:fill ()
    for i = 0,#self.map do
        for j = 0, #self.map[0] do
            self.map[i][j] = self:getRandomCrystallAtPoint(i,j);
        end
    end
    self:checkForPotentialMatch();
    if self.potentialMatchCount == 0 then self:fill(); end; -- if there is no potential match - recreate field
end

---private
--Get instance crystal at point witch will don't create matches 
--@param x,y - coordinate of future crystal in the field
--@return instance of Crystal class
function Field:getRandomCrystallAtPoint (x,y) 
    local candidate = Crystal:getRandomCrystal({X=x,Y=y},self);
    local candidate_is_good = false;
    while not candidate_is_good  do
      candidate = Crystal:getRandomCrystal({X=x,Y=y},self);
      candidate_is_good = not self:isMakeThreeMatch(candidate,x,y)
    end
    return candidate;
end


require ("Matching")

---private
-- Check will crystal in this place create a match
-- @param crystal - instance of crystal class
-- @param x,y - position crystal below in the game field
-- @return instance if Match class - in case where this crystal create a match  
--         nil (false) if crystal don't create a match
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

---private
--compare crystal
--@param crystal -  instance of crystal
--@param x,t - position crystal in the game field to compare
--@return true - if same
--        false if not

function Field:isSame (crystal, x, y)
    if x>#(self.map) or x<0 or y<0 or y>#(self.map[0])  then return false end; -- check bound
    if self.map[x][y].color==crystal.color then 
        return true;
    else
        return false
    end;
end

---public 
--calculate potential matches in game field
--result write in potentialMatchCount variable
function Field:checkForPotentialMatch ()
    self.potentialMatchCount = 0;
    for i = 0,#self.map do
        for j = 0, #self.map[0] do
            self:makePseudoChoise({X=i,Y=j},{X=i+1,Y=j});
            self:makePseudoChoise({X=i,Y=j},{X=i,Y=j+1});
        end
    end
--print ("potential choises: ".. self.potentialMatchCount);
    return false
end


---private
--@param point_from - table {X,Y} the dot from crystal move
--       point_to - table {X,Y} the dot where crystal move
--@return true if make match
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


---public
--change game field by user step
--@param userCommand - instance of UserCommand class returned by Console.readUserCommand

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

---public
--cancel user step
--@param  userCommand - instance of UserCommand class returned by Console.readUserCommand
function Field:cancelChoice (userCommand)
    self.isHaveChange = false;
    local _temp_Crystal = self.map[userCommand.finishX][userCommand.finishY];
    self.map[userCommand.finishX][userCommand.finishY] = self.map[userCommand.startX][userCommand.startY];
    self.map[userCommand.startX][userCommand.startY] = _temp_Crystal;
    self.map[userCommand.finishX][userCommand.finishY].position = {X = userCommand.finishX, Y = userCommand.finishY};
    self.map[userCommand.startX][userCommand.startY].position = {X = userCommand.startX, Y = userCommand.startY};
end

---public 
--make game step (main loop feedback)
function Field:tick ()
    self.isHaveChange = false;
    for i = #self.map-1,0, -1 do
        for j = 0, #self.map[0] do
            self.map [i][j]:tick();
        end
    end
    if not self.isHaveChange then self:fillVoid();
--there check for created matches
        self:checkAndMatch ();
    end
end

---private
--calculating existing matches
function Field:checkAndMatch ()
    for i = 0,#self.map do
        for j = 0, #self.map[0] do
            if not self.map[i][j].isVoid then
                local match = self:isMakeThreeMatch (self.map[i][j], i,j)
                if match then
                    local matching = {}
                    matching [1] = match;
                    Crystal:match(matching);
                    self.isHaveChange = true;
                end;
            end
        end
    end
end

---private
--fill empty space in field by random crystal
function Field:fillVoid ()
    for i = 0,#self.map do
        for j = 0, #self.map[0] do
            if self.map[i][j].isVoid then
                self.map[i][j] = Crystal:getRandomCrystal({X=i,Y=j},self);
            end
        end
    end
end