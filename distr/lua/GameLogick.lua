API = {
field = {};
}
---public
--Create game field by size
--@param size - table {X=.., Y=..}
--@return instance of Field class
function API:init(size)
    require ("Field");
    local field = Field:new(size,nil)
    field:fill();
    self.field = field;
  return field;
end


---public
--Toggle the game cycle
function API:tick()
    self.field:tick();
end


---public
--Shuffle the field (in this realization just recreate in)
--@warning  - creating field use C random function with constant key -- if restart game the key will be old - therefore 
-- game field will be same 
function API:mix ()
    local field = Field:new(size,nil)
    field:fill();
    self.field = field;
end

---public
--make user step
--@param userCommand - instance of UserCommand class, returned by Console.readUserCommand
--@return true - if the step is possible
--        false - if he step is incorrect
function API:move (userCommand)
    if not userCommand then return nil end;
    require("Crystalls")
    local match = self.field:makeChoice(userCommand)
    if match.match then
    Crystal:match(match); 
         return true;
    else 
         print ("There is no match");
         self.field:cancelChoice(userCommand); 
         return false
   end
end

---
--write game field to the console 
function API:dump ()
    require("Console")
    Console:drawField(self.field);
end