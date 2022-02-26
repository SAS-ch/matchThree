require ("GameLogick")
require ("Console")
--at first create size arg
local size = {};
size.Y = 10;
size.X = 10;
local field = API:init(size);
while true do --main game loop
    API:dump();
    API:move(Console:readUserCommand(field)); -- wait for user step
    while field.isHaveChange do
        API:tick();
        API:dump();
    end
    field:checkForPotentialMatch ();
    if field.potentialMatchCount==0 then 
        API:mix();
        API:dump();
    end
end
