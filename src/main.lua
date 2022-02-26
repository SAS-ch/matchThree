gamelogic = require ("GameLogick")



  size = {};
  size.Y = 10;
  size.X = 10;
  require ("Field");
  field = Field:new(size,nil)
  field:fill(); 
  require ("Console")
  Console:drawField(field);
  field:checkForPotentialMatch ();
  local ret = Console:readUserCommand(field);
  local match = field:makeChoice(ret)
  if match.match then print ("Good choice!") 
  else print ("bad choice");
       field:cancelChoice(ret); --cancel choice there
   end
  Crystal:match(match);
  while field.isHaveChange do 
   field:tick();
  end;
  --field:fillVoid();
  Console:drawField(field);
  print ("debug");
 --[[ require ("Console");
  require ("Field");
  local field = Field:new({X=9,Y=9});
  local ret = Console:readUserCommand(field,nil);
  if not ret:commandIsGood(field) then print ("out of bounds"); end ]]
