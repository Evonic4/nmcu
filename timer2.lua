-- timer11
print("timer2.stop")
tmr.stop(2)
gpwr(cfg["f1gpio"], 0)
fun1 = 0
tmr.unregister(2)
collectgarbage()
