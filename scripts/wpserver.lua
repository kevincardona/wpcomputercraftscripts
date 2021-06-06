local modem_side = "right"

function start()
    rednet.open(modem_side)
end


local modem = peripheral.find( "modem" ); print(modem)