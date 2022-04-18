local modem = peripheral.wrap("left")
ID = nil
modem.open(3)

function connectToHost(hostChannel)
    local responseChannel = 2
    modem.open(responseChannel)

    modem.transmit(hostChannel,responseChannel,"Connect")
    
    --Wait for a response on the response channel
    local event, side, channel, replyChannel, message, distance
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == responseChannel
    ID = tonumber(message)
    print("ID: "..ID)
end

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function pathFindToPoint(Px,Py,Pz,x,y,z)
    local Cx,Cy,Cz = gps.locate(5)
    print("Current Cord: "..Cx.." "..Cy.." "..Cz)
    print("Going to: "..Px.." "..Py.." "..Pz)
    
    local Dx = Px-Cx
    local Dy = Py-Cy
    local Dz = Pz-Cz
    print("Displacement Cord: "..Dx.." "..Dy.." "..Dz)

    if Dx < 0 then
        turtle.turnLeft()
        turtle.turnLeft()
    end
    for i=1,Dx do
        turtle.dig()
        turtle.forward()
    end
    if Dz >= 0 then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
    for i=1,math.abs(Dz) do
        turtle.dig()
        turtle.forward()
    end
    for i=1,math.abs(Dy) do
        turtle.digDown()
        turtle.down()
    end

    digBox(x,y,z)
end

function reciveMessage(message)
    tableA = mysplit(message, ",")
    if tonumber(tableA[2]) == 1 then
        pathFindToPoint(tableA[3],tableA[4],tableA[5],tableA[6],tableA[7],tableA[8])
    end
end
--Dig Code
function digLine (TlineLength)
    lineLength = TlineLength
    for i=1,lineLength-1 do
        turtle.dig()
        turtle.digDown()
        turtle.forward()
        fake,g =turtle.inspectDown()
        if g["name"] == "minecraft:water" then
            while g["name"] ~= "minecraft:gravel" do
                fake,g =turtle.inspectDown()
                if turtle.getItemCount(turtle.getSelectedSlot()) < 2 then
                    cleanInventory()
                end
                turtle.placeDown()
            end
        end
    end
end

function digRectangle(Tx,Ty)
    local a = Tx
    local b = Ty
    left = not startState
    digLine(b)
    for i=2,a do
        if left then
            turtle.digDown()
            turtle.turnLeft()
            turtle.dig()
            turtle.forward()
            turtle.turnLeft()
            left = false
        else
            turtle.digDown()
            turtle.turnRight()
            turtle.dig()
            turtle.forward()
            turtle.turnRight()
            left = true
            
        end
        digLine(b)
    end

end


function digBox(Ax,Ay,Az)
    for i=1,Az do
        print("d")      
        digRectangle(Ax,Ay)
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.digDown()
        turtle.down()
    end
end
for t=1,32 do
    turtle.refuel()
end

function cleanInventory()
    itemCount = 0
    index = 1
    for i=2,9 do
        if compareTo(i) then
            if itemCount < getItemCount(i) then
                itemCount =  getItemCount(i)
                index = i
            end
        end
    end
    turtle.select(index)
end
connectToHost(1)
--pathFindToPoint(12,56,112,2,2,2)
while true do
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    temp = mysplit(message, ",")
    print(message)
    print(temp[1])
    if (tonumber(temp[1]) == ID) or (tonumber(temp[1]) == 0) then
        print("Recived")
        reciveMessage(message)
    end
end