local M={}
local function find(ts) for _,t in ipairs(ts) do local p=peripheral.find(t); if p then return p end end end
function M.monitor() return peripheral.find("monitor") end
function M.speaker() return peripheral.find("speaker") end
function M.chat() return find({"chat_box","chatBox"}) end
function M.environment() return find({"environment_detector","environmentDetector"}) end
function M.inventory() return find({"inventory_manager","inventoryManager"}) end
function M.redstone() return find({"redstone_integrator","redstoneIntegrator"}) end
function M.list() local a={}; for _,n in ipairs(peripheral.getNames()) do a[#a+1]={n,peripheral.getType(n) or "unknown"} end; table.sort(a,function(x,y)return x[1]<y[1] end); return a end
return M
