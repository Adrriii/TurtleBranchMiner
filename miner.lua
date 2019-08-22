---- DEFINITIONS ----

function checkBlock(dir)
	local block = nil
	local success = false
	if dir == "left" then
		turtle.turnLeft()
		success, block = turtle.inspect()
	elseif dir == "right" then
		turtle.turnRight()
        success, block = turtle.inspect()
	elseif dir == "front" then
		success, block = turtle.inspect()
	elseif dir == "top" then
		success, block = turtle.inspectUp()
	elseif dir == "bot" then
		success, block = turtle.inspectDown()
	end

	if not success or not block then return false
	else
	if type(block) == "boolean" then return false end
	    return nonOreBlocks[block["name"]] ~= 1
	end
end

function printPosition()
	print("Turtle position relative to start :\nx:",x,"\ny:",y,"\nz:",z)
end

function refuel()
	local slot = 1
	while turtle.getFuelLevel() < 100 do
			turtle.select(slot)
			if not turtle.refuel(1) then
				slot = slot + 1
			end
		if slot > 16 then slot = 1 end
	end
	return true
end

function mineBlock(dir)
	local blocked = true
	while blocked do
		if dir == "forward" then
			turtle.dig()
			blocked, block = turtle.inspect()
		elseif dir == "top" then
			turtle.digUp()
			blocked, block = turtle.inspectUp()
		elseif dir == "bot" then
			turtle.digDown()
			blocked, block = turtle.inspectDown()
		end
		if blocked and type(block) ~= boolean then
			blocked = nonBlocking[block["name"]] ~= 1
		end
	end
end

function mineDeposit()
	if checkBlock("front") then
		mineBlock("forward")
		move("forward")
		mineDeposit()
		move("back")
	end
	if checkBlock("top") then
		mineBlock("top")
		move("top")
		mineDeposit()
		move("bot")
	end
	if checkBlock("bot") then
		mineBlock("bot")
		move("bot")
		mineDeposit()
		move("top")
	end
	if checkBlock("left") then
		mineBlock("forward")
		move("forward")
		mineDeposit()
		move("back")
	end
	turtle.turnRight()
	if checkBlock("right") then
		mineBlock("forward")
		move("forward")
		mineDeposit()
		move("back")
	end
	turtle.turnLeft()
end

function move(dir)
	if turtle.getFuelLevel() < 100 then
		if not refuel() then return false
		end
	end
	if dir == "forward" then
		mineBlock("forward")
		repeat until turtle.forward()
		x = x + 1
	elseif dir == "back" then
		repeat until turtle.back()
		x = x - 1
	elseif dir == "top" then
		mineBlock("top")
		repeat until turtle.up()
		y = y + 1
	elseif dir == "bot" then
		mineBlock("bot")
		repeat until turtle.down()
		y = y - 1
	end
	return true
end

function selectItem(itemName)
	local slot = 1

	while slot < 17 do
		if turtle.getItemCount(slot) > 0 then
			print("Trying to find",itemName,"on slot",slot)
			item = turtle.getItemDetail(slot)
			if item["name"] == itemName then
				turtle.select(slot)
				return true
			end
		end
		slot = slot + 1
	end
	return false
end

function tunnelDig(length)
	local tunnel_x = 0
	local tunnel_y = 0
	t_time = t_interval

	while tunnel_x < length do
		mineBlock("forward")
		move("forward")
		tunnel_x = tunnel_x + 1
		mineBlock("top")
		mineDeposit()
		move("top")
		tunnel_y = tunnel_y + 1
		mineDeposit()
		move("bot")
		tunnel_y = tunnel_y - 1

		t_time = t_time - 1
		if t_time == 0 then
			if selectItem("minecraft:torch") then
				turtle.placeUp()
			end
			t_time = t_interval
		end
	end
	while tunnel_y > 1 do
		move("bot")
		tunnel_y = tunnel_y - 1
	end

	while tunnel_x > 0 do
		move("back")
		tunnel_x = tunnel_x - 1
	end
end

function emptyInventory()
	local itemCounts = {}
	local itemsDropped = {}
	local droppedCount = 0
	local slot = 1

	while slot < 17 do
		if turtle.getItemCount(slot) > 0 then
			turtle.select(slot)
			local item = turtle.getItemDetail()
			local itemCount = tonumber(item["count"])

			if not table.containsIndex(itemCounts, item["name"]) then
				itemCounts[item["name"]] = itemCount
			else
				itemCounts[item["name"]] = itemCounts[item["name"]] + itemCount
			end

			local c = 0
			if table.containsIndex(keptBlocks, item["name"]) then
				local itemKeep = tonumber(keptBlocks[item["name"]])

				if itemKeep < itemCounts[item["name"]] then
					local dropAmount = itemCounts[item["name"]] - itemKeep
					turtle.dropDown(dropAmount)
					itemCounts[item["name"]] = itemCounts[item["name"]] - dropAmount

					if not table.containsIndex(itemsDropped, item["name"]) then
						itemsDropped[item["name"]] = dropAmount
					else
						itemsDropped[item["name"]] = itemsDropped[item["name"]] + dropAmount
					end
					droppedCount = droppedCount + dropAmount
				end
			else
				turtle.dropDown(itemCount)
				itemCounts[item["name"]] = itemCounts[item["name"]] - itemCount

				if not table.containsIndex(itemsDropped, item["name"]) then
					itemsDropped[item["name"]] = itemCount
				else
					itemsDropped[item["name"]] = itemsDropped[item["name"]] + itemCount
				end
				droppedCount = droppedCount + itemCount
			end
		end
		slot = slot + 1
	end

	if droppedCount > 0 then
		print("Unloaded",droppedCount,"items :")
		for k,v in pairs(itemsDropped) do
			print("x"..v,k)
		end
	end
end

function table.containsIndex(table, index)
  for key, v in pairs(table) do
    if index == key then
      return true
    end
  end
  return false
end

---- GLOBAL VARIABLES ----

-- Blocks not counting as ores therefore not mined in mineDeposit()
nonOreBlocks = {}
nonOreBlocks["minecraft:chest"] = 1
nonOreBlocks["minecraft:stone"] = 1
nonOreBlocks["minecraft:torch"] = 1
nonOreBlocks["minecraft:cobblestone"] = 1
nonOreBlocks["minecraft:dirt"] = 1
nonOreBlocks["minecraft:bedrock"] = 1
nonOreBlocks["minecraft:obsidian"] = 1
nonOreBlocks["minecraft:water"] = 1
nonOreBlocks["minecraft:lava"] = 1
nonOreBlocks["minecraft:flowing_lava"] = 1
nonOreBlocks["minecraft:flowing_water"] = 1
nonOreBlocks["minecraft:gravel"] = 1
nonOreBlocks["minecraft:sand"] = 1
nonOreBlocks["thermalfoundation:ore_fluid"] = 1

-- 'Blocks' through which the turtle can go --
nonBlocking = {}
nonBlocking["minecraft:flowing_lava"] = 1
nonBlocking["minecraft:flowing_water"] = 1
nonBlocking["minecraft:lava"] = 1
nonBlocking["minecraft:water"] = 1
nonBlocking["thermalfoundation:ore_fluid"] = 1

-- Blocks that should be kept and how many of them --
keptBlocks = {}
keptBlocks["minecraft:coal"] = 64
keptBlocks["minecraft:torch"] = 64

-- Relative position of the turtle --
x = 0
y = 0
z = 0

-- Every nth blocks a torch is palced
t_interval = 7
-- Blocks until next torch place
t_time = t_interval

-- Amount of tunnels to dig
tunnel_n = 10
-- Length of each tunnels
tunnel_l = 100
-- Interval between tunnels
tunnel_i = 3
-- Number of tunnels to ignore (Already dug for example)
tunnel_ignore = 0

---- CODE START ----
local arg = {...}
local targetDist = 100
local minerHigh = 2
local current_tn = 0

if arg[1] ~= nil then
	targetDist = tonumber(arg[1])
end

emptyInventory()

while current_tn < tunnel_n do
	if current_tn >= tunnel_ignore then
		tunnelDig(tunnel_l)
		if z ~= 0 then
			turtle.turnRight()
			while z~= 0 do
				move("back")
				z = z -1
			end
			turtle.turnLeft()
		end
		emptyInventory()
	end

	current_tn = current_tn + 1

	if current_tn < tunnel_n then
		turtle.turnRight()
		while z ~= (tunnel_i+1)*current_tn do
			move("forward")
			z = z + 1
		end
		turtle.turnLeft()
	end
end