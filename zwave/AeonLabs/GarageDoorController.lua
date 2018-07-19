-- This script receives the Barrier Operator Reports that is sent out from the Garage Door Controller
-- When Open or Closed is received, a Dummy Device is turned OFF / ON. 

local deviceName = "Aeon"          -- Name of your Garage Door Controller
local deviceStatus = "AeonStatus"  -- Name of your Dummy Device

------ Do not change below ------

local deviceManager = require "telldus.DeviceManager"
COMMAND_CLASS_BARRIER_OPERATOR = 0x66

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if device:name() ~= deviceName then
		return
	end
	if cmdClass == COMMAND_CLASS_BARRIER_OPERATOR then
		barrierOperator(device, cmd, data)
	end
end

function barrierOperator(device, cmd, data)
	local status = deviceManager:findByName(deviceStatus)
	state = {}
	state[0x00] = "Closed"
	state[0x01] = "Stopped at exact Position"
	state[0xFC] = "Closing"
	state[0xFD] = "Stopped"
	state[0xFE] = "Opening"
	state[0xFF] = "Open"
	
	if cmd == 3 then
		value = data[0]
		if value >= 0x01 and value <= 0x63 then
			msg = state[0x01]
			print("Barrior Operator Report from %s: %s %s", device:name(), msg, value)	
		else
			msg = state[data[0]]
			print("Barrior Operator Report from %s: %s", device:name(), msg)
			if msg == "Open" then 
				status:command("turnoff", nil, deviceName .. " - " .. msg)
			elseif msg == "Closed" then
				status:command("turnon", nil, deviceName .. " - " .. msg)
			end
		end
	end
end

