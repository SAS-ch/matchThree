gamelogic = require ("GameLogick")
local function main()
print "hello world"
end


--
main()

size = {};
size.Y = 10;
size.X = 10;
require ("Field");
field = Field:new(size,nil)
field:fill(); 
require ("Console")
Console:drawField(field);
field:checkForPotentialMatch ();
