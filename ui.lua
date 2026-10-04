local t=require("theme"); local M={}
function M.clear(m) m.setBackgroundColor(t.bg);m.setTextColor(t.text);m.clear() end
function M.header(m,s) local w=m.getSize();m.setBackgroundColor(t.panel);m.setTextColor(t.text);m.setCursorPos(1,1);m.clearLine();m.write(" "..s:sub(1,w-1)) end
function M.btn(m,x,y,w,s,on) m.setBackgroundColor(on and t.accent or t.button);m.setTextColor(colors.white);m.setCursorPos(x,y);s=s:sub(1,w);m.write(s..string.rep(" ",math.max(0,w-#s))) end
function M.back(m) local w,h=m.getSize();M.btn(m,1,h,math.min(10,w),"< BACK") end
return M
