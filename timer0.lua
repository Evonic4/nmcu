-- timer0
tmr.stop(0)
tmr.unregister(0)

local wifion = wifi.sta.getip()
print("timer0.start", wifion, "+")
if wifion == nil then
    if file.exists("wf.txt") then
        local col = 0
        local col1 = ""
        col1 = readf("wf.txt", "0", true)
        col = tonumber(col1)
        col = col + 1
        savef("wf.txt", col)
        print("col++", col)
    else
        savef("wf.txt", 1)
    end
print("node.restart")
node.restart()
else
    savef("wifiip.txt", wifion)
    --print("timer0.ip +")
end

treg(0)

collectgarbage()
