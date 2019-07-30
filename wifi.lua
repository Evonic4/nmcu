--WiFi Settup
station_cfg={}
station_cfg.pwd=cfg["wfpwd1"]

if file.exists("wf.txt") then
    local col = 0
    local col1 = ""
    col1 = readf("wf.txt", "0", true)
    col = tonumber(col1)
    print("col="..col)
    if col >= cfg["col_wifi_st"] then
        file.remove("wf.txt")
        print("WIFI STATIONAP TEMP")
        station_cfg.ssid=cfg["wfssid2"]
        wifi.setmode(wifi.STATIONAP) --192.168.4.1
        wifi.ap.config(station_cfg)
        station_cfg = nil
        cfg["send_data"] = 0
        cfg["pwf"] = cfg["time_wf_ap"]
    end
else
    if cfg["wfcli"] == 1 then
        print("WIFI STATION ON")
        station_cfg.ssid=cfg["wfssid1"]
        wifi.setmode(wifi.STATION) --wi-fi клиент
        wifi.sta.config(station_cfg)
    else
        print("WIFI STATIONAP ON")
        station_cfg.ssid=cfg["wfssid2"]
        wifi.setmode(wifi.STATIONAP) --192.168.4.1
        wifi.ap.config(station_cfg)
        station_cfg = nil
        cfg["send_data"] = 0
    end

end

tmr.delay(10*1000000)
print(wifi.sta.getip())

collectgarbage()
