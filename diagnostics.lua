local ui=require("ui");local hw=require("hw");local M={}
function M.run(m) while true do ui.clear(m);ui.header(m,"DIAGNOSTICS");local w,h=m.getSize();local y=3;local p=hw.list();m.setCursorPos(2,y);m.write("Peripherals: "..#p);y=y+2;for _,v in ipairs(p) do if y>=h-1 then break end;m.setCursorPos(2,y);m.write((v[1].." ["..v[2].."]"):sub(1,w-2));y=y+1 end;ui.back(m);local _,x,yy=os.pullEvent("monitor_touch");if yy==h and x<=10 then return end end end
return M
