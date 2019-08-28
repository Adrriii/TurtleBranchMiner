-- Wait for any file to be received and saved over modem

local channel = 2435

local modem = peripheral.wrap("back")

modem.open(channel)

local writing = false
local currentFile = nil

while true do
    local type,data,f,r,msg,distance = os.pullEvent()
    
    if type == "key" then
        break
    elseif type == "modem_message" then
        if not writing then
           currentFile = fs.open(msg,"w")
           writing = true
        else
            if msg ~= "<endFile>" then
                print(msg)
                currentFile.write(msg.."\n")
            else
                currentFile.close()
                writing = false
                modem.transmit(r,f,"ok")
            end
        end
    end
end
