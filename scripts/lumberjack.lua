-- INVENTORY SLOTS
-- 1 - fuel
-- 2 - saplings

local Args = { ... }

function placeSapling()
    local saplingSlot = findSlotItemByName({"sapling"})
    if saplingSlot then
        turtle.select(saplingSlot)
        turtle.place() 
    end
end

-- turtle needs to start at base
function cutTree(params)
    local y = 0
    turtle.dig()
    moveForward()
    while true do
        if y > 3 then
            if spinSearch({"log"}) then
                mineVein({"log", "leaves"})
            end
        end
        if not topBlockIsIn({"log"}) then
            while moveDown() do end
            break
        else
            turtle.digUp()
            moveUp()
            y = y + 1
        end
    end
    
    goBack(params["pos"])
    placeSapling(saplingSlot)
end

local function handleDetect(params)
    local index = params["index"]
    local direction = params["direction"]
    print("DETECTED: "..index)
    if tonumber(index) > 1 then
        print("Found leaves")
        if direction == "front" then
            turtle.dig()
        elseif direction == "up" then
            turtle.digUp()
        elseif direction == "down" then
            turtle.digDown()
        end
    elseif tonumber(index) == 1 then
        print("Found tree!")
        if direction == "front" then
            cutTree(params) 
        else
            turtle.digUp()
        end
    end
end

local function onMove(params)
    turtle.suck()
end

local function start()
    SetTurtleStatus("cutting wood...")
    pollArea({"log", "leaves", "leaf"}, handleDetect, onMove)
    SetTurtleStatus("taking a break...")
    dropAllByName({"log"}, "down")
    dropAllByName({"sapling"}, "up")
end

start()