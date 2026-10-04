local hw=require("hw");local cfg=require("config");local auth=require("auth");local desktop=require("desktop")
local M={}
function M.run() local m=hw.monitor();if not m then error("No monitor detected") end;local c=cfg.load();pcall(m.setTextScale,c.scale or 1);auth.login(m);desktop.run(m,c) end
return M
