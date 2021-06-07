local configName = "gringottsConfig"

local itemTypes = {"blocks", "ores", "mobs", "tools", "wood", "tech", "food", "misc"}

function checkForItems()
    for i = 0, 16, 1 do
        turtle.select(i)
        turtle.getItemDetail()
    end
end

while true do

end