local modem = peripheral.find( "modem" )
local port = 12523
local known_server_ports = {23523, 5000}
local server_port = 23523

local Args = { ... }
local clientID = nil
 
local function receive()
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if string.startswith(message, "request:", replyChannel, senderChannel) then
        print(string.sub(message, string.len("request:"), -1))
        modem.transmit(server_port, port, "banner:"..read())
    else
        if not(message == "done") then
            print("SERVER: "..message)  
        end
    end
end
 
local function send()
    local message = read()
    modem.transmit(server_port, port, "command:"..read())
end

if modem then
    modem.open(port)
    while true do
        print(Args)
        send()
        receive()
    end
elseif Args[1] ~= nil then
    shell.run(Args[1], unpack({"false"}))
end

