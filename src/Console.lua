--base class
Console = {
}
write = io.write
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
    
    write (field.map[i][j]);
   end
  write ('\n');
  end
  end