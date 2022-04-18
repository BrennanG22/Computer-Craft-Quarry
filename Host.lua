local modem = peripheral.wrap("back")
--Request Connection Channel
modem.open(1)
modem.open(4)

turtleIDs = {}

function connectTurtle()
    turtleIDs[table.getn(turtleIDs)+1] = table.getn(turtleIDs)+1
    modem.transmit(2,1,turtleIDs[table.getn(turtleIDs)])
    print("ID Connected: "..turtleIDs[table.getn(turtleIDs)])
end

function sendDigOrder(Px,Py,Pz,x,y,z,numberOfT)
    Tx = math.ceil(x/numberOfT)
    Ty = y
    Tz = z
    for i=1,numberOfT do
        modem.transmit(3,4,tostring(i)..",1,"..tostring(Px+((i-1)*Tx))..","..tostring(Py)..","..tostring(Pz)..","..Tx..","..Ty..","..Tz)
    end
end


while true do
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 1 then
        connectTurtle()    
    end
    if channel == 4 then
        print("Message Sent")
        sendDigOrder(16,56,127,6,6,6,2)
    end
end