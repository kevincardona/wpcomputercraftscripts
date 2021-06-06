-- WP CONSOLE
 
local modem = peripheral.find( "modem" )
modem.open( 23523 )
local monitor = peripheral.find("monitor")
if monitor then term.redirect(monitor) end
term.setCursorBlink(false)
term.clear()
 
function string.startswith(String,Start)
    if String == nil then return end
    return string.sub(String,1,string.len(Start))==Start
end
 
local function command(command, replyChannel, senderChannel)
    if replyChannel == 12523 then
        term.setTextColor(colors.green)
        print("Kevin: "..command) 
        term.setTextColor(colors.white)
    else
        term.setTextColor(colors.red)
        print("Mr. WP: "..command)
        term.setTextColor(colors.white)
    end
    if string.startswith(command, "banner:update") then
        local text = string.sub(command, string.len("banner:update") + 1, -1)
        term.clear()
		term.setCursorPos(1,1)
        term.write(text)
        modem.transmit(replyChannel, 1, "done")
    else
        modem.transmit(replyChannel, 1, "INVALID COMMAND")
    end
end
 
while true do
    local event, modemSide, senderChannel, 
    replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if string.startswith(message, "command:") then
        command(string.sub(message, string.len("command:") + 1, -1), replyChannel, senderChannel)
        modem.transmit(replyChannel, 1, "done")
    else
        modem.transmit(replyChannel, 1, "invalid command!")
    end
end