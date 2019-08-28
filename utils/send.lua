-- Send file contents over a channel on modem

local arg = {...}

local modem = peripheral.wrap("left")

local channel = 2435
local replyChannel = 2436

local filePath = arg[1]

if fs.exists(filePath) then
    file = fs.open(filePath,"r")
    
    modem.transmit(channel,replyChannel,filePath)
    print("Started transmitting ",filePath)
    local next = file.readLine()
    while next do
        modem.transmit(channel,replyChannel,next)
        print(next)
        next = file.readLine()
    end
    print("Done.")
    modem.transmit(channel,replyChannel,"<endFile>")
    file.close()
else
    print("Wrong path ! Make sure to use an absolute path")
end
