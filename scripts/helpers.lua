function getDeviceSide(deviceType)
    -- List of all sides
    local lstSides = {"left","right","up","down","front","back"};
    -- Now loop through all the sides
    -- "i" holds a table counter
    -- "side" will hold the actual side text
    for i, side in pairs(lstSides) do
      if (peripheral.isPresent(side)) then
        -- Yup, there is something on this side
        -- Check the type against the device
        -- string.lower() just ensures that the passed
        -- device type is in lower case.
        -- peripheral.getType() always returns lower case texts
        if (peripheral.getType(side) == string.lower(deviceType)) then
          -- Yes, this is the device type we need, so return the side
          return side;
          -- Note, that this call to "return" also terminates
          -- further running of this function
        end -- if .getType()
      end -- if .isPresent()
    end -- for-do
    -- If we reach this point, it means that we didnt find
    -- the specified device anywhere, so return nil indicating
    -- that it doesnt exist.
    return nil;
  end -- function()


function string.startswith(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

function yN()
    local n=1
    while true do
        local x, y=term.getCursorPos()
        term.clearLine()
        if n==1 then write(">YES<   NO") else write (" YES   >NO<") end
        term.setCursorPos(x, y)
        local _,key = os.pullEvent("key")
        if key == keys.left and n==2 then n=1 end
        if key == keys.right and n==1 then n=2 end
        if key == keys.enter then print("") break end
    end
    if n==1 then return true end
    if n==2 then return false end
    return false
end

function selectMenu(message, options)
    n=1
    l=#options
    while true do
        term.clear()
        term.setCursorPos(1,1)
        print(message)
        for i=1, l, 1 do
        if i==n then print(i, " ["..options[i].."]") else print(i, " ", options[i]) end
        end
        local _,key = os.pullEvent("key")
        if key == keys.up and n>1 then n=n-1 end
        if key == keys.down and n<=l then n=n+1 end
        if key == keys.enter then break end
    end
    term.clear() term.setCursorPos(1,1)
    return n
end