local user=...
if not user or user=="" then print("Usage: install <user> [repo] [branch]"); return end
local repo=select(2,...) or "zevelian-horizon"
local branch=select(3,...) or "main"
local base="https://raw.githubusercontent.com/"..user.."/"..repo.."/"..branch.."/"
local files={"README.md","auth.lua","boot.lua","browser.lua","chat.lua","config.lua","desktop.lua","diagnostics.lua","environment.lua","hw.lua","inventory.lua","meta.lua","music.lua","redstone.lua","settings.lua","startup.lua","system.lua","theme.lua","ui.lua","zevelian.lua"}
local stage=".zstage"; local backup=".zbackup"
if fs.exists(stage) then fs.delete(stage) end; if fs.exists(backup) then fs.delete(backup) end
fs.makeDir(stage); fs.makeDir(backup)
for _,name in ipairs(files) do
 print("Downloading "..name)
 local ok,err=pcall(function()
  local h=http.get(base..name,nil,true); if not h then error("request failed") end
  local code=h.getResponseCode and h.getResponseCode() or 200
  if code<200 or code>=300 then h.close(); error("HTTP "..code) end
  local data=h.readAll(); h.close(); if not data or #data==0 then error("empty file") end
  local f=fs.open(fs.combine(stage,name),"w"); f.write(data); f.close()
 end)
 if not ok then printError("FAILED: "..name.." / "..tostring(err)); fs.delete(stage); fs.delete(backup); return end
end
for _,name in ipairs(files) do if fs.exists(name) then fs.copy(name,fs.combine(backup,name)) end end
local ok,err=pcall(function()
 for _,name in ipairs(files) do if fs.exists(name) then fs.delete(name) end; fs.move(fs.combine(stage,name),name) end
end)
if not ok then
 printError("Install failed; restoring previous files")
 for _,name in ipairs(files) do if fs.exists(name) then fs.delete(name) end; local p=fs.combine(backup,name); if fs.exists(p) then fs.copy(p,name) end end
 fs.delete(stage); fs.delete(backup); return
end
fs.delete(stage); fs.delete(backup); print("ZEVELIAN Horizon Final installed. Reboot to start.")
