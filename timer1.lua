-- timer1
function sendData()
print("senddata")
conn=net.createConnection(net.TCP, 0) 
conn:on("receive", function(conn, payload) print(payload) end)
conn:connect(80,cfg["ip_send"])
conn:send("GET /c4_nmu.php"..data.." HTTP/1.1\r\n") 
conn:send("Host: "..cfg["ip_send"].."\r\n") 
conn:send("Accept: */*\r\n") 
conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
conn:send("\r\n")
conn:on("sent",function(conn)
                      print("Closing connection")
                      conn:close()
                  end)
conn:on("disconnection", function(conn)
                                print("Got disconnection...")
  end)
end

print("timer1.start")
if fseta == 0 then
    tmr.stop(1)
    tmr.unregister(1)
end
--сбор и подготовка данных
data1 = wifi.sta.getip()
local p0 = string.gsub(readf("pin0.txt", "0", true), "\n", "")
local p1 = string.gsub(readf("pin1.txt", "0", true), "\n", "")
local p2 = string.gsub(readf("pin2.txt", "0", true), "\n", "")
local p3 = string.gsub(readf("pin3.txt", "0", true), "\n", "")
local p4 = string.gsub(readf("pin4.txt", "0", true), "\n", "")
local p5 = string.gsub(readf("pin5.txt", "0", true), "\n", "")
local p6 = string.gsub(readf("pin6.txt", "0", true), "\n", "")
local p7 = string.gsub(readf("pin7.txt", "0", true), "\n", "")
local p8 = string.gsub(readf("pin8.txt", "0", true), "\n", "")
data2 = "&p0="..p0.."&p1="..p1.."&p2="..p2.."&p3="..p3.."&p4="..p4.."&p5="..p5.."&p6="..p6.."&p7="..p7.."&p8="..p8
data = "?n="..cfg["esp"].."&i="..data1..data2
print(cfg["ip_send"]..data)
sendData()
print("timer1.send.data")

if fseta == 0 then
    treg(1)
end
fseta = 0

collectgarbage()
