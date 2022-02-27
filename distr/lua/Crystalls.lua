
--Super class
Crystal = {
}


---public 
--Create a new Instance of Crystal class
--@param color - string representation of color [A-F] from global variable Colors
--@param position - position if the current crystal in the game field
--@param field - instance of class field
--@return instance of crystal class 
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
---global variable
Colors = {
}
Colors[0] = "A";
Colors[1] = "B";
Colors[2] = "C";
Colors[3] = "D";
Colors[4] = "E";
Colors[5] = "F";
---String representation of empty dot in the field
EmptyColor = "0"

---private
--get random color from Colors variable
--@return string color
function getRandomColor () 
    local r = math.random(0,#Colors);
    return Colors[r];
end

---public 
--get random crystal 
--@param position - position if the current crystal in the game field
--@param field - instance of class field
--@return instance of crystal class 
function Crystal:getRandomCrystal (position,field)
    return self:new(getRandomColor(),position,field);
end

---public
--get crystal with color "A"
--@param position - position if the current crystal in the game field
--@param field - instance of class field
--@return instance of crystal class 
function Crystal:getBaseCrystal (position,field)
    local crystal = self:new(Colors[0],position,field);
    return crystal;
end

---public
--make step of crystal (fall)
function Crystal:tick()
    if self.position == {X=5, Y=4} then
        print ("catch!"); end
    if self:getUnderCrystal().isVoid and not self.isVoid then 
        local old_position = self.position;
        local new_position = self:getUnderCrystal().position;
        self.field.map[self:getUnderCrystal().position.X][self:getUnderCrystal().position.Y] = self;
        self.position = new_position; -- bug
        self.field.isHaveChange = true; 
        void_crystal = Crystal:new (EmptyColor,old_position,self.field);
        void_crystal.isVoid = true;
        self.field.map[old_position.X][old_position.Y] =void_crystal;
   end;
end

---private
--get crystal under the current crystal
--@return instance of crystal class 
function Crystal:getUnderCrystal ()
    return self.field.map[self.position.X+1][self.position.Y]
end

---public
--realize behavior of the crystal then matching happened 
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