-- This script is a simple example how one can iterate over all devices

ON = 1
OFF = 2
BELL = 4
DIM = 16
LEARN = 32

function onInit()
	local deviceManager = require "telldus.DeviceManager"
	for index, device in python.enumerate(deviceManager:retrieveDevices()) do
		methodsString = ""
		methods = device:methods()
		state = device:state()
		name = device:name()
		if name == "" then
			name = "noname"
		end
		if device:methods() ~= 0 then
			if (BitAND(methods, ON) == ON) then
				methodsString = methodsString .. "ON"
			end
			if (BitAND(methods, OFF) == OFF) then
				methodsString = methodsString .. " OFF"
			end
			if (BitAND(methods, BELL) == BELL) then
				methodsString = methodsString .. " BELL"
			end
			if (BitAND(methods, DIM) == DIM) then
				methodsString = methodsString .. " DIM"
			end
			if (BitAND(methods, LEARN) == LEARN) then
				methodsString = methodsString .. " LEARN"
			end
		else
			methodsString = "None"
		end
		if device:state() == ON then
			state = "ON"
		elseif device:state() == OFF then
			state = "OFF"
		elseif device:state() == DIM then
			state = "DIM"
		end
		print("Name: %s, Methods: %s, State: %s", name, methodsString, state)
	end
end

-- The lua version shipped with TellStick does not support bitwise operators
function BitAND(a,b)--Bitwise and
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>1 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c
end
