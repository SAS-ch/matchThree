Match = {}

MatchType = {
"vertical",
"horizontal"
}
function Match:new (type, centerX, centerY,field)
 local obj = {}
  setmetatable(obj,self);
  self.__index = self;
  obj.type = type
  obj.centerX = centerX;
  obj.centerY = centerY;
  obj.crystall = field.map[centerX][centerY];
  obj.field = field;
  obj.crystall_to_match = {}

  obj:calculateMatching ();
  return obj;
end

function Match:calculateMatching ()
--adding center crystal
  table.insert(self.crystall_to_match,self.crystall);
  if self.type == MatchType[1] then 
      --at first from center to top
      
      for x = self.centerX-1 ,0 , -1 do
          if self.field:isSame(self.crystall, x, self.centerY) then table.insert(self.crystall_to_match, self.field.map[x][self.centerY]) 
          else break end;
      end
      -- second from center to bottom
      for x = self.centerX+1, self.field.size.X do
          if self.field:isSame(self.crystall, x, self.centerY) then table.insert(self.crystall_to_match, self.field.map [x][self.centerY]) 
          else break end;    
      end
  end
  if self.type == MatchType[2] then
      --at first from right to left
      for y = self.centerY-1, 0 , -1 do
          if self.field:isSame(self.crystall, self.centerX, y) then table.insert(self.crystall_to_match,self.field.map [self.centerX][y])
          else break end;
      end
      -- second - from left to right 
      for y = self.centerY+1, self.field.size.Y do
          if self.field:isSame(self.crystall, self.centerX, y) then table.insert(self.crystall_to_match,self.field.map [self.centerX][y])
          else break end;
      end
  
  end
end