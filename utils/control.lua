-- Use WASD to control the Turtle (ZQSD on AZERTY)
-- Press Ctrl to escape

while true do
    local type, key = os.pullEvent()

    if type == "key" then
        if key == 44 or key == 17 then
            turtle.forward()
        elseif key == 31 then
            turtle.back()
        elseif key == 200 then
            turtle.up()
        elseif key == 208 then
            turtle.down()
        elseif key == 16 or key == 30 then
            turtle.turnLeft()
        elseif key == 32 then
            turtle.turnRight()
        elseif key == 18 then
            turtle.dig()
        elseif key == 33 then
            turtle.select(1)
            turtle.refuel(1)
        elseif key == 29 then break
        end

    end
end
