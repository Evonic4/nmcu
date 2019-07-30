fseta = 0
fun1 = 0

function readf(d1, find1, znach)
    local str1 = ""
    file.open(d1, "r+")
    file.seek("set", 0)
    str1 = file.readline()
    file.close();
    
    if znach == true then
        return str1
    else
        ki = string.find(str1, find1)
        if ki == nil then
            return false
        else
            return true
        end
    end
end

function savef(d2, zna)
    file.remove(d2)
    file.open(d2,"w")
    file.writeline(zna)
    file.close()
end

function gpwr(gp, n)
if gp < 9 then
if n == 3 then
    if readf("pin"..tostring(gp)..".txt", "0", false) == true then
        gpio.write(gp, gpio.HIGH)
        print("pin"..tostring(gp).."=0")
    else
        gpio.write(gp, gpio.LOW)
        print("pin"..tostring(gp).."=1")
    end
end
if n == 0 then
    savef("pin"..tostring(gp)..".txt", 0)
    gpio.write(gp, gpio.HIGH)
end
if n == 1 then
    savef("pin"..tostring(gp)..".txt", 1)
    gpio.write(gp, gpio.LOW)
end
end
end

-- timer0 - wifi
function timer0_do()
    dofile("timer0.lua")
end
-- timer1 - sendDATA
function timer1_do()
    dofile("timer1.lua")
end
function timer2_do()
    dofile("timer2.lua")
end


-- init pin mode, gpio
for i = 0, 8 do
if not file.exists("pin"..tostring(i)..".txt") then
    savef("pin"..tostring(i)..".txt", 0)
end
gpio.mode(i, gpio.OPENDRAIN)
gpwr(i, 3)
end

-- Init
fconfig = ""
local function s1def()
    fconfig = "cfg1.lua"
    savef("nconf.txt", 1)
end

if readf("nconf.txt", "0", true) ~= nil then
  if file.exists("nconf.txt") then
    fconfig = "cfg" .. string.gsub(readf("nconf.txt", "0", true),"\n", "") .. ".lua"
    if not file.exists(fconfig) then
        print ("not ", fconfig)
        s1def()
    end
  else
    s1def()
  end
else
    s1def()
end

print ("use ", fconfig)
dofile(fconfig)

-- Init Wifi
dofile("wifi.lua")


-- Init httpd
dofile("httpd.lua")

--timers
function treg(tn)
if tn == 0 then
    -- Start timer0 __*1000 сек.
    tmr.register(0, cfg["pwf"]*1000, tmr.ALARM_AUTO, timer0_do)
    if cfg["wfcli"] == 1 then
    if cfg["timer0"] == 1 then
        print("Start timer0")
        tmr.start(0)
    end
    end
end

if tn == 1 then
    -- Start timer1 __*1000 сек.
    tmr.register(1, cfg["period_sd"]*1000, tmr.ALARM_AUTO, timer1_do)
    if cfg["send_data"] == 1 then
        print("Start timer1")
        tmr.start(1)
    end
end

if tn == 2 then
    -- Start timer11
    tmr.register(2, cfg["f1time"], tmr.ALARM_AUTO, timer2_do)
    if fun1 == 1 then
        print("Start function1")
        gpwr(cfg["f1gpio"], 1)
        tmr.start(2)
    end
end

end


treg(0)
treg(1)

print("Started.")

