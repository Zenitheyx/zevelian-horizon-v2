local M={}
function M.login(m)
 while true do
  m.clear();m.setCursorPos(1,1);m.setTextColor(colors.cyan);m.write("ZEVELIAN OS");m.setTextColor(colors.white);m.setCursorPos(1,3);m.write("HORIZON FINAL");m.setCursorPos(1,5);m.write("Username: ");local u=read();m.setCursorPos(1,7);m.write("Password: ");local p=read("*")
  if u=="admin" and p=="zevelian" then return true end
  m.setTextColor(colors.red);m.setCursorPos(1,9);m.write("Invalid credentials.");sleep(1)
 end
end
return M
