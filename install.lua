local USER = ...
if not USER or USER == "" then
  print("Usage: install <github-user> [repo] [branch]")
  return
end

local REPO = select(2, ...) or "zevelian-horizon"
local BRANCH = select(3, ...) or "main"
local BASE = "https://raw.githubusercontent.com/" .. USER .. "/" .. REPO .. "/" .. BRANCH .. "/"

local manifest = {
  "README.md",
  "auth.lua",
  "boot.lua",
  "browser.lua",
  "chat.lua",
  "config.lua",
  "desktop.lua",
  "diagnostics.lua",
  "environment.lua",
  "hw.lua",
  "inventory.lua",
  "meta.lua",
  "music.lua",
  "redstone.lua",
  "settings.lua",
  "startup.lua",
  "system.lua",
  "theme.lua",
  "ui.lua",
  "zevelian.lua"
}

local stage = ".zevelian_stage"

if fs.exists(stage) then
  fs.delete(stage)
end

fs.makeDir(stage)

local function download(name)
  print("Downloading " .. name)

  local h = http.get(BASE .. name)

  if not h then
    error("Could not download " .. name)
  end

  local data = h.readAll()
  h.close()

  if not data or #data == 0 then
    error("Empty file: " .. name)
  end

  local f = fs.open(fs.combine(stage, name), "w")
  f.write(data)
  f.close()
end

local ok, err = pcall(function()
  for _, name in ipairs(manifest) do
    download(name)
  end
end)

if not ok then
  printError("INSTALL FAILED")
  printError(tostring(err))
  fs.delete(stage)
  return
end

for _, name in ipairs(manifest) do
  if fs.exists(name) then
    fs.delete(name)
  end

  fs.move(fs.combine(stage, name), name)
end

fs.delete(stage)

print("")
print("================================")
print(" ZEVELIAN OS HORIZON INSTALLED")
print(" Version 2.2.0")
print("================================")
print("")
print("Type reboot to start ZEVELIAN OS.")
