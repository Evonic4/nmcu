--Create HTTP Server
http=net.createServer(net.TCP)

function receive_http(sck, data)    
  print(data)

  local request = string.match(data,"([^\r,\n]*)[\r,\n]",1)
  if request == 'GET /reboot HTTP/1.1' then
    print("reboot")
    node.restart()
  end
  if request == 'GET /defco HTTP/1.1' then
    print("defco")
    file.remove("cfg"..tostring(cfg["config"])..".lua")
    savef("nconf.txt", cfg["config"])
    dofile("cfg0.lua")
    cfg["config"] = string.gsub(readf("nconf.txt", "0", true), "\n", "")
    dofile("save_cfg.lua")
    node.restart()
  end
  
  if request == 'GET /fun1=1 HTTP/1.1' then
    fun1 = 1
    treg(2)
  end
   --pins --pin0 
  for i = 0, 8 do
    if request == 'GET /pin'..i..' HTTP/1.1' then
        if readf("pin"..tostring(i)..".txt", "0", false) == true then
            gpwr(i, 1)
        else
            gpwr(i, 0)
        end
    end
  end

  --pins --pin0=1
  local ddd1 = string.find(request,"=")
  if ddd1 ~= nil then
  print("=+")
  local ddd2 = string.find(request,"pin")
  if ddd2 ~= nil then
    local numpin = string.sub(request, ddd1-1, ddd1-1)
    local gpv = string.sub(request, ddd1+1, ddd1+2)
    print("pin"..numpin.."="..gpv)
    if tonumber(gpv) ~= nil then
        if tonumber(numpin) ~= nil then
            gpwr(tonumber(numpin), tonumber(gpv))
        end
    end
  else
  
    --params
    for key,value in pairs(cfg) do
    local ddd = string.find(request,key)
        if ddd ~= nil then
            ddd1 = string.sub(request, ddd1+1, string.len(request)-9)
            print(key, "="..ddd1, "-->"..cfg[key].."<--")
            
            if tonumber(cfg[key]) == nil then
                ddd1 = tostring(ddd1)
            else
                ddd1 = tonumber(ddd1)
            end

            if ddd1 ~= cfg[key] then
                if key == "config" then
                    savef("nconf.txt", ddd1)
                    print("node.restart")
                    node.restart()
                else
                    cfg[key] = ddd1
                    dofile("save_cfg.lua")
                end
            else
                print(ddd1, "dont change")
            end
        end
    end
  end
  end
  
  print("---Input---")
  --print(request)

    if cfg["seta"] == 1 then
        fseta = 1
        dofile("timer1.lua")
    end
  
-- Use the nodemcu specific pool servers
--"<a href=\"on1\">On1</a> <a href=\"off1\">Off1</a>status="..gpio11.."<br>"..
  sck:on("sent", function(sck) sck:close() collectgarbage() end)
  local response = "HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n"..
     "<html><title>c4nmu"..cfg["esp"].."</title><body>".."<h1>c4nmu"..cfg["esp"].."</h1>".."<hr>"..
     "pin0="..string.gsub(readf("pin0.txt", "0", true), "\n", "").."<br>"..
     "pin1="..string.gsub(readf("pin1.txt", "0", true), "\n", "").."<br>"..
     "pin2="..string.gsub(readf("pin2.txt", "0", true), "\n", "").."<br>"..
     "pin3="..string.gsub(readf("pin3.txt", "0", true), "\n", "").."<br>"..
     "pin4="..string.gsub(readf("pin4.txt", "0", true), "\n", "").."<br>"..
     "pin5="..string.gsub(readf("pin5.txt", "0", true), "\n", "").."<br>"..
     "pin6="..string.gsub(readf("pin6.txt", "0", true), "\n", "").."<br>"..
     "pin7="..string.gsub(readf("pin7.txt", "0", true), "\n", "").."<br>"..
     "pin8="..string.gsub(readf("pin8.txt", "0", true), "\n", "").."<br>"..
     "config="..cfg["config"].."<br>"..
     "wfssid2="..cfg["wfssid2"].."<br>"..
     "wfcli="..cfg["wfcli"].."<br>"..
     "timer0="..cfg["timer0"].."<br>"..
     "send_data="..cfg["send_data"].."<br>"..
     "period_sd="..cfg["period_sd"].."<br>"..
     "pwf="..cfg["pwf"].."<br>"..
     "col_wifi_st="..cfg["col_wifi_st"].."<br>"..
     "time_wf_ap="..cfg["time_wf_ap"].."<br>"..
	 "f1time="..cfg["f1time"].."<br>"..
	 "f1gpio="..cfg["f1gpio"].."<br>"..
     "</body></html>"
  sck:send(response)
end
 
if http then
  http:listen(444, function(conn)
    conn:on("receive", receive_http)
  end)
end
