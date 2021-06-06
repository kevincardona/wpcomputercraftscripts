-- Run software updates
dofile("update")
--

-- import wp corp proprietary software

dofile("wpturtle")
--

local password = "hey"
local oldPull = os.pullEvent
os.pullEvent = os.pullEventRaw

while true do
 term.clear()
 term.setCursorPos(1,1)
 write("Password:")
 local input = read("*")
 if input == password then
  print("Welcome!")
  sleep(2)
  term.clear()
  term.setCursorPos(1,1)
  break
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