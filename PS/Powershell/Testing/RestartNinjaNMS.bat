sc stop NinjaNetworkManageAgent

rem cause a ~15 second sleep... 
ping 127.0.0.1 -n 15 -w 1000 > nul

sc stop NinjaNetworkManageServer

rem cause a ~15 second sleep... 
ping 127.0.0.1 -n 15 -w 1000 > nul

sc start NinjaNetworkManageAgent

rem cause a ~15 second sleep... 
ping 127.0.0.1 -n 15 -w 1000 > nul

sc start NinjaNetworkManageServer