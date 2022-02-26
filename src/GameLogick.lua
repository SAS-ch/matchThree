API = {
field = {};
}
--[[ Create the game field with bound of argument size
@param: size - table with X and Y field
@return: instance of field
]]
function API:init(size)
    require ("Field");
    local field = Field:new(size,nil)
    field:fill();
    self.field = field;
  return field;
end
--[[ toogle game step
]]
function API:tick()
    self.field:tick();
end
--[[ shuffle the field (just recreate it)
]]
function API:mix ()
    local field = Field:new(size,nil)
    field:fill();
    self.field = field;
end
--[[ make user step 
@param userCommand - returning object from Console:readUserCommand
@return - true if step make changing, else false;
]]
function API:move (userCommand)
    if not userCommand then return nil end;
    require("Crystalls")
    local match = self.field:makeChoice(userCommand)
    if match.match then
    Crystal:match(match); 
         return true;
    else 
         print ("There is no Choice");
         field:cancelChoice(ret); 
         return false
   end
end
function API:dump ()
    require("Console")
    Console:drawField(self.field);
end