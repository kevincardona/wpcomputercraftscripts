-- insert assert(loadfile("fgps")) at start of file to load this lib
-- north south east or west
local startDirection = "south"

-- what coordinate the turtle is at 
local startPosX = 0
local startPosY = 0 -- position when standing on turtle
local startPosZ = 0

-- what coordinate it should end at
local endPosX = 0
local endPosY = 0
local endPosZ = 0

local isReturning = false


turtleStatus = {
    code = 200,
    message = "waiting for command..."
}

function SetTurtleStatus(message, code)
    turtleStatus["message"] = message
    if code then turtleStatus["code"] = code end
end

function getTurtleStatus()
    return turtleStatus
end

local startRot = 0

local tracking_movement = false
local tracked_rot = 0
local tracked_history = {}

local function getRotVal(direction)
    if direction == "north" then
        return 0
    elseif direction == "east" then
        return 1
    elseif direction == "south" then
        return 2
    elseif direction == "west" then
        return 3
    end
end

local function setStartRot(direction)
    startRot = getRotVal(direction)
    rot = startRot
end

startRot = getRotVal(startDirection)

setStartRot(startDirection)

-- north = -z  east = x
local directionMap = {"north", "east", "south", "west"}

local posX = startPosX
local posY = startPosY
local posZ = startPosZ
local rot = startRot
accelMapX = {0, 1, 0, -1}
accelMapZ = {-1, 0, 1, 0}

function setStartDirection(x,y,z,direction)
    posX = x
    posY = y
    posZ = z
    startPosX = x
    startPosY = y
    startPosZ = z
    startDirection = direction
    setStartRot(direction)
end

function setBounds(x,y,z)
    endPosX = x
    endPosY = y
    endPosZ = z
end

local function directionFromTo(x,z,x2,z2)
    local resX = 0
    local resZ = 0
    if x2 > x then
        resX = 1
    elseif x2 < x then
        resX = -1
    end
    if z2 > z then
        resZ = 1
    elseif z2 < z then
        resZ = -1
    end
    return {resX, resZ}
end

local function directionTo(x,z)
    return directionFromTo(posX, posZ, x, z)
end

local function rotMod()
    return rot % 4 + 1
end

local function backupPosition()
    return {posX, posY, posZ, rotMod()}
 end

local function accelX()
    return accelMapX[rotMod()]
end

local function accelZ()
    return accelMapZ[rotMod()]
end

local function setAccelX(val)
    while true do
        if accelX() == val then
            return
        end
        turnLeft()
    end
end

local function setAccelZ(val)
    while true do
        if accelZ() == val then
            return
        end
        turnLeft()
    end
end

local function turnTowards(x,z)
    local tempDirection = directionFromTo(posX, posZ, x, z)
    if not (tempDirection[1] == 0) then
        setAccelX(tempDirection[1])
    else
        setAccelZ(tempDirection[2])
    end
end

local function turnTowardsZ(x,z)
    local tempDirection = directionFromTo(posX, posZ, x, z)
    setAccelZ(tempDirection[2])
end

local function faceDirectionRot(temp_rot)
    while not (rotMod() == ((temp_rot - 1)% 4 + 1) ) do
        turnLeft()
    end
end

local function faceOppositeDirectionRot(temp_rot)
    faceDirectionRot(temp_rot + 2)
end

local function getDirection()
    return directionMap[rotMod()]
end

-- will overwrite itsself if ran again
function startTracking()
    tracked_history = {}
    tracking_movement = true
    tracked_rot = rotMod()
end

function stopTracking()
    tracking_movement = false
    faceDirectionRot(tracked_rot)
end

function printLoc()
    print("X:", posX, " Y:", posY, " Z:", posZ, " rot: ", getDirection())
end

function moveForward()
    if turtle.detect() then
        return false
    end
    repeat until turtle.forward()
    posX = posX + accelX()
    posZ = posZ + accelZ()
    if tracking_movement then
        table.insert(tracked_history, rotMod())
    end
end

function moveForwardTracked(history)
    repeat until turtle.forward()
    posX = posX + accelX()
    posZ = posZ + accelZ()
    table.insert(history, rotMod())
    return history
end

local function checkForBlocks(names, cb)
    local success, data = turtle.inspect()
    for i = 1, #names, 1 do
        if success and string.find(data.name, names[i]) then
            local backup = backupPosition()
            cb({direction = "front", index = i})
            goBack(backup)
            return true
        end
    end
    if success == true then
        success, data = turtle.inspectUp()
        for i = 1, #names, 1 do
            if success and string.find(data.name, names[i]) then
                local backup = backupPosition()
                cb({direction = "top", index = i})
                goBack(backup)
                return true
            end
        end
    end
    return false
end


function moveForwardTraverse(opts, onMove)
    printLoc()
    if opts.cb ~= nil and opts.names ~= nil then
        checkForBlocks(opts.names, opts.cb)
    end
    while turtle.detect() do
        if turtle.detectUp() then
            print("TURTLE STUCK")
            SetTurtleStatus("stuck!", 500)
            return false
        end
        moveUp()
        if opts.cb ~= nil and opts.names ~= nil then
            checkForBlocks(opts.names, opts.cb)
        end
    end
    moveForward()
    if onMove ~= nil then
        onMove()
    end
    while not turtle.detectDown() do
        moveDown()
    end
    SurtleStatus = "good"
end

function moveBackward()
    repeat until turtle.back()
    posX = posX - accelX()
    posZ = posZ - accelZ()
end

function moveUp()
    if turtle.detectUp() then
        return false
    end
    repeat until turtle.up()
    posY = posY + 1
    if tracking_movement then
        table.insert(tracked_history, 5)
    end
    return true
end

local function retraceSteps(steps)
    for i = #steps, 1, -1 do
        if steps[i] == 5 then
            moveDown()
        elseif steps[i] == 6 then
            moveUp()
        else
            faceOppositeDirectionRot(steps[i])
            moveForward()
        end
    end
end

function mineVein(names)
    local backup = backupPosition()
    local veinHistory = {}
    while spinSearch(names) do
        turtle.dig()
        veinHistory = moveForwardTracked(veinHistory)
    end
    retraceSteps(veinHistory)
    goBack(backup)
end

function moveDown()
    if turtle.detectDown() then
        return false
    end
    repeat until turtle.down()
    posY = posY - 1
    if tracking_movement then
        table.insert(tracked_history, 6)
    end
    return true
end

function turnLeft()
    rot = rot - 1
    repeat until turtle.turnLeft()
end

function turnRight()
    rot = rot + 1
    repeat until turtle.turnRight()
end

function findAllInventoryByName(names)
    local res = {}
    for i = 1, 16, 1 do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data ~= nil then
            for j = 1, #names, 1 do
                if string.find(data.name, names[j]) then
                    table.insert(res, i)
                end 
            end
        end
    end
    return res
end

function dropAllByName(names, direction)
    local slots = findAllInventoryByName(names)
    if slots ~= nil then
        for i = 1, #slots, 1 do
            turtle.select(slots[i])
            if direction == "down" then
                turtle.dropDown()
            elseif direction == "up" then
                turtle.dropUp()
            else
                turtle.drop()
            end
        end
    end
end

function frontBlockIsIn(names)
    local success, data = turtle.inspect()
    for i = 1, #names, 1 do
        if success and string.find(data.name, names[i]) then
            return i
        end
    end
    return false
end

function topBlockIsIn(names)
    local success, data = turtle.inspectUp()
    for i = 1, #names, 1 do
        if success and string.find(data.name, names[i]) then
            return i
        end
    end
    return false
end


function spinSearch(names)
    for i = 1, 4, 1 do
        if frontBlockIsIn(names) then
            return true
        end
        turnLeft()
    end
    return false
end

function findItemsInInventory(names)

end

function backtrack()
    tracking_movement = false
    retraceSteps(tracked_history)
    stopTracking()
end

function goBack(position)
    while posY < position[2] do
        moveUp()
    end
    while posY > position[2] do
        moveDown()
    end
    while not (posX == position[1] and posZ == position[3]) do
        turnTowards(position[1],position[3])
        moveForward()
    end
    faceDirectionRot(position[4])
end

local boundsAreSet = false
function promptUserForBounds()
    print("What bounding system should we use?\n\n1.relative  2. coords")
    local input = tonumber(read())
    if input == 1 then
        print("How far forward should we go from here?\n (negative for back)")
        z = tonumber(read())
        print("How far to the side should we go from here?\n (negative for left)")
        x = tonumber(read())
        setBounds(x * -1,0,z)
    else
        local x, y, z = gps.locate()
        if x == nil then
            print("\nIt looks like there's no GPS signal\n Looks like we'll have to do this manually...")
            print("Enter starting x coordinate:")
            x = tonumber(read())
            print("Enter starting y coordinate:")
            y = tonumber(read())
            print("Enter starting z coordinate:")
            z = tonumber(read())
            print("\nWhich direction is it facing?\n\n1. north 2. east 3. south 4. west")
            local dir = tonumber(read())
            setStartDirection(x,y,z,directionMap[dir])
        end
        print("Enter end x coordinate:")
        x = tonumber(read())
        print("Enter end y coordinate:")
        y = tonumber(read())
        print("Enter end z coordinate:")
        z = tonumber(read())
        setBounds(x,y,z)
    end
    boundsAreSet = true
end

-- handleDetect is a callback and takes params with { status: "", direction: ""}
function pollArea(names, handleDetect)
    if not boundsAreSet then promptUserForBounds() end
    turnTowards(endPosX, endPosZ)
    while true do
        if posX == startPosX and posZ == startPosZ and isReturning then
            print("Turtle is all done!")
            SetTurtleStatus("waiting for command...", 200)
            goBack({startPosX,startPosY,startPosZ,startRot % 4 + 1})
            isReturning = false
            return "done"
        end

        checkForBlocks(names, handleDetect, onMove)

        -- TODO: Make it so it can start north south east west of corner
        if posX == endPosX and posZ == endPosZ then
            print("Turtle reached corner of bounds. Returning...")
            isReturning = true
        end

        if isReturning == true then
            turnTowards(startPosX, startPosZ)
            moveForwardTraverse({names = names, cb = handleDetect}, onMove)
        else
            directionTo(endPosX, endPosZ)
            if ((posX + accelX() == endPosX) or posX + accelX() == startPosX) and not(accelX == 0) then
                moveForwardTraverse({names = names, cb = handleDetect}, onMove)
                print("Moving to next row...")
                local tempAccelX = accelX()
                turnTowardsZ(endPosX, endPosZ)
                checkForBlocks(names, handleDetect)
                moveForwardTraverse({names = names, cb = handleDetect}, onMove)
                setAccelX(tempAccelX * -1)
            else
                moveForwardTraverse({names = names, cb = handleDetect}, onMove)
            end
        end
    end
end
