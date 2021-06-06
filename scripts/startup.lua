-- Run software updates
dofile("update")

-- import wp corp proprietary software
dofile("helpers")
dofile("wpturtle")
--

local password = "hey"
local oldPull = os.pullEvent
os.pullEvent = os.pullEventRaw

while true do
    term.clear()
    term.setCursorPos(1,1)
    if fs.exists("default.lua") then
        local dconfig = fs.open("default.lua", "r")
        local default = dconfig.readLine()
        if default ~= nil then
            if default == "wpserver" then
                shell.run("wpserver")
            elseif default == "lumberjack" then
                shell.run("wpclient", unpack({"lumberjack"}))
                break
            elseif default == "farmer" then
                shell.run("wpclient", unpack({"farmer"}))
                break
            elseif default == "wpclient" then
                shell.run("wpclient")
            end
        end
    end
    write("Password:")
    local input = read("*")
    if input == password then
        print("Welcome!")
        sleep(2)
        term.clear()
        term.setCursorPos(1,1)

        local computerType = selectMenu("What am I?", {"Server", "Turtle", "Phone", "It's a mystery..."})
        if computerType == 1 then
            dofile("wpserver")
            break
        elseif computerType == 2 then
            local selection = selectMenu("What kind of turtle is this?", {"Lumberjack", "Farmer"})
            if selection == 1 then
                shell.run("wpclient", unpack({"lumberjack"}))
                break
            elseif selection == 2 then
                shell.run("wpclient", unpack({"farmer"}))
                break
            end
            break
        elseif computerType == 3 then
            dofile("wpclient")
            break
        elseif computerType == 4 then
            break
        end
    else
        print("Password incorect! GG")
        sleep(2)
        term.clear()
        term.setCursorPos(1,1)
        print("Goodbye!")
        sleep(2)
        os.shutdown()
    end
end

os.pullEvent = oldPull