--base class
--Input and output operation with console
--There is singleton prototype, console have only one instance
Console = {
}


--cutting
write = io.write

---
--Write visual representation of field to console
--@param field - instance of field
function Console:drawField (field)
    write ("  ")
    for i = 0, #field.map do -- head of output table
        write (i);
    end
    write ("\n  ")
    for i = 0, #field.map do -- head of output table
        write ("-");
    end
    write ('\n')
    for i = 0, #field.map do
        write (i.."|")
        for j = 0 , #field.map[0] do
            write (field.map[i][j].color);
        end
        write ('\n');
    end
end


----
--Read user command from console
--@param field - instance of field class - for checking bound
--@return instance of UserCommand class
function Console:readUserCommand (field)
    require ('UserCommand')
    print ("Enter command:")
    local line = io.read();
    local command, xPos, yPos, direction = splitStr(line," "); -- rename variable 

    local commandRight = false; -- check arg
    for i = 1, #UserCommand.commandTypes do
        if command == UserCommand.commandTypes[i] then commandRight = true end;
    end
    if not commandRight then print ("Wrong command!"); return nil end;
--in case exit command
    if command == UserCommand.commandTypes[2]then os.exit() end;
--in case command = move
    if command == UserCommand.commandTypes[1] then
       xPos = tonumber (xPos);
       yPos = tonumber (yPos);
       if xPos < 0 or xPos>field.size.X then print ("Wrong x position, should be in range = { 0 , "..field.size.X.." }") return nil end;
       if yPos < 0 or yPos>field.size.Y then print ("Wrong y position, should be in range = { 0 , "..field.size.Y.." }") return nil end;
   
       directionRight = false;
       for i = 1, #UserCommand.directionTypes do
            if direction==UserCommand.directionTypes[i] then directionRight = true end;
       end
       if not directionRight then print ("Wrong direction, should be u, d, r or l") return nil end;
   
       return UserCommand:new (command,{startX = xPos, startY = yPos, direction = direction});
    end
end

------------MISC----------------
--function split string to the array of string separating by " "
--@return string array
function splitStr (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t[1], t[2], t[3], t[4]
end