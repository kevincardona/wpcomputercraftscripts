----------------------------------------
plants = {"wheat", "aubergine", "hemp"}
----------------------------------------

local Args = { ... }

local function handleDetect(params)
    local index = params["index"]
    local direction = params["direction"]
    if direction == "down" then
        turtle.dig()
        turtle.digUp()
    end
end

local function onMove()
    turtle.suckDown()
end

local function start()
    SetTurtleStatus("tending to crops...")
    pollArea(plants, handleDetect, onMove)
    SetTurtleStatus("taking a break...")
end

if Args[1] == "false" then
    start()
end