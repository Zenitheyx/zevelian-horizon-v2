local M={}; local path="zevelian.cfg"; local d={scale=1}
function M.load() if not fs.exists(path) then return {scale=d.scale} end local f=fs.open(path,"r"); local s=f.readAll(); f.close(); local ok,t=pcall(textutils.unserialize,s); if ok and type(t)=="table" then return t end return {scale=1} end
function M.save(t) local f=fs.open(path,"w"); f.write(textutils.serialize(t)); f.close() end
return M
