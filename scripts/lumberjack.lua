-- name of turtle command center
dofile("wpturtle")

-- turtle needs to start at base
function cutTree()
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
            return
        else
            turtle.digUp()
            moveUp()
            y = y + 1
        end
    end
end

local function handleDetect(params)
    local index = params["index"]
    local direction = params["direction"]
    print("DETECTED: "..index)
    if tonumber(index) > 1 then
        print("Found leaves")
        if direction == "front" then
            turtle.dig()
        else
            turtle.digUp()
        end
    elseif tonumber(index) == 1 then
        print("Found tree!")
        if direction == "front" then
            cutTree() 
        else
            turtle.digUp()
        end
    end
end

local function start()
    pollArea({"log", "leaves", "leaf"}, handleDetect)
end

setStartDirection(-635,76,-121, "south")
setCorner(-644,71,-120)
start()