# nmcu
integration of esp8266 into the smart house
different configs>-1 are provided

lower an example of the configuration file (cfg1.lua)
esp=4, - a device number;
config=1, - number of a configuration;
wfssid1= "sid1" - the access point sid;
wfpwd1= "pass>" - a pass;
wfssid2= "sid2" - the LED of the access point, at unavailability of WIFI;
wfcli=1 - nodeMCU works as the client of WIFI;
ip_send= "192.168.8.8" - controller ip;
timer0=1 - to check wifi connection to a point;
send_data=1 - to send or not data to the controller
seta=1, - to send data after switching to the mode of AP;
period_sd=30 - the period of sending data for the controller __ sec.;
pwf=10 - the period of verification of presence of wi-fi of network __ sec.;
col_wifi_st=5 - number of resets before abnormal inclusion of AP;
time_wf_ap=600 - time of abnormal inclusion of AP __ sec.

