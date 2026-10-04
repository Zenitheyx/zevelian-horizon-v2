local ok,err=pcall(function() require("boot").run() end)
if not ok then term.setTextColor(colors.red); print("ZEVELIAN OS ERROR"); print(tostring(err)); term.setTextColor(colors.white); print("Type reboot to retry.") end
