-- save cfg

local fconfig = ""
fconfig = "cfg" .. string.gsub(readf("nconf.txt", "0", true),"\n", "") .. ".lua"

file.open(fconfig, "w")
file.writeline("cfg = {")
  for key,value in pairs(cfg) do
    if tonumber(cfg[key]) == nil then
        file.writeline(key..'="'..value..'",')
    else
        file.writeline(key..'='..value..',')
    end
  end
file.writeline("}")
file.close()
dofile(fconfig);
print("Configuration is saved.")

collectgarbage()
