----------------------------------------
plants = {"wheat", "aubergine", "hemp"}
----------------------------------------

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

start()