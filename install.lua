-- ZEVELIAN OS v2.1.1 Horizon installer
-- Works with the flattened GitHub repository layout used by zevelian-horizon.
local user = ...
if not user or user == "" then
  print("Usage: install <github-username> [repo] [branch]")
  print("Example: install Zenitheyx zevelian-horizon main")
  return
end

local repo = select(2, ...) or "zevelian-horizon"
local branch = select(3, ...) or "main"
local base = ("https://raw.githubusercontent.com/%s/%s/%s/"):format(user, repo, branch)

-- GitHub filename -> CC:Tweaked destination.
local manifest = {
  {"startup.lua", "startup.lua"},
  {"zevelian.lua", "zevelian.lua"},

  {"auth.lua", "lib/auth.lua"},
  {"config.lua", "lib/config.lua"},
  {"hw.lua", "lib/hw.lua"},
  {"meta.lua", "lib/meta.lua"},
  {"theme.lua", "lib/theme.lua"},
  {"ui.lua", "lib/ui.lua"},

  {"boot.lua", "core/boot.lua"},
  {"desktop.lua", "core/desktop.lua"},

  {"chat.lua", "apps/chat.lua"},
  {"environment.lua", "apps/environment.lua"},
  {"inventory.lua", "apps/inventory.lua"},
  {"redstone.lua", "apps/redstone.lua"},
  {"settings.lua", "apps/settings.lua"},
  {"system.lua", "apps/system.lua"},
  {"music.lua", "apps/music.lua"},
  {"browser.lua", "apps/browser.lua"},
  {"diagnostics.lua", "apps/diagnostics.lua"},
}

local function fetch(path)
  local url = base .. path
  local h, err = http.get(url)
  if not h then
    return nil, err or "HTTP request failed"
  end
  local body = h.readAll()
  h.close()
  return body
end

local function ensureParent(path)
  local dir = fs.getDir(path)
  if dir and dir ~= "" then
    fs.makeDir(dir)
  end
end

print("")
print("================================")
print("  ZEVELIAN OS // HORIZON 2.1.1")
print("================================")
print("Repository: " .. user .. "/" .. repo .. " [" .. branch .. "]")
print("")
print("Checking files before changing anything...")

local staged = {}

for _, pair in ipairs(manifest) do
  local source, destination = pair[1], pair[2]
  local body, err = fetch(source)

  if not body then
    print("")
    print("FAILED TO DOWNLOAD: " .. source)
    print(tostring(err))
    print("")
    print("Nothing was changed.")
    return
  end

  -- Compile-check every Lua program before installation.
  local chunk, compileErr = load(body, "=" .. source)
  if not chunk then
    print("")
    print("FAILED LUA CHECK: " .. source)
    print(tostring(compileErr))
    print("")
    print("Nothing was changed.")
    return
  end

  staged[destination] = body
  print("  OK  " .. source .. " -> " .. destination)
end

local backup = "zevelian_horizon_backup"
if fs.exists(backup) then
  fs.delete(backup)
end
fs.makeDir(backup)

print("")
print("Creating rollback backup...")

for _, pair in ipairs(manifest) do
  local destination = pair[2]
  if fs.exists(destination) then
    local backupPath = fs.combine(backup, destination)
    ensureParent(backupPath)
    fs.copy(destination, backupPath)
  end
end

local changed = {}

local ok, problem = pcall(function()
  for destination, body in pairs(staged) do
    ensureParent(destination)

    local h = fs.open(destination, "w")
    if not h then
      error("Cannot write " .. destination)
    end

    h.write(body)
    h.close()
    table.insert(changed, destination)
  end
end)

if not ok then
  print("")
  print("INSTALL FAILED: " .. tostring(problem))
  print("Rolling back...")

  for _, destination in ipairs(changed) do
    if fs.exists(destination) then
      fs.delete(destination)
    end
  end

  for _, pair in ipairs(manifest) do
    local destination = pair[2]
    local backupPath = fs.combine(backup, destination)

    if fs.exists(backupPath) then
      ensureParent(destination)
      fs.copy(backupPath, destination)
    end
  end

  fs.delete(backup)

  print("Rollback completed.")
  print("Your previous installation was preserved.")
  return
end

fs.delete(backup)

print("")
print("================================")
print("  INSTALLATION COMPLETE")
print("================================")
print("")
print(#manifest .. " files installed.")
print("Repository layout was converted automatically.")
print("")
print("Reboot to start ZEVELIAN OS.")
print("Default login: admin / zevelian")
print("")
