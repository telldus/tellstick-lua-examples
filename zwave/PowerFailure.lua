-- This scripts turns off a dummy device when a Z-Wave device sends 
-- a Power Management Notification - Power Failure.
-- The device is then turned on when the message Power Restored is received. 
-- The name of the device that sent the notofication can be seen in the device log 
-- of the dummy device together with the notification message. 
-- One of the Plugs that can send this notifications is NodOn ASP-3-1-10. 
-- For this plug, please set configuration 2 to '3' and association 4 to TellStick
-- Please note that you'll need a power backup for TellStick and your Internet
-- connection in order for this to work. 

local powerFailure = "Power failure"  -- Name of the dummy device

------ Do not change below ------

local deviceManager = require "telldus.DeviceManager"
local powerFailureDevice = deviceManager:findByName(powerFailure)

NOTIFICATION = 0x71
POWER_MANAGEMENT = 0x08

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if cmdClass == NOTIFICATION and data[4] == POWER_MANAGEMENT then 
		notification(device, cmd, data)
	end
end

function notification(device, cmd, data)
	event = data[5]
	if event == 2 then
		msg = "POWER FAILURE"
	elseif event == 3 then
		msg = "POWER RESTORED"
	else
		msg = event
	end
	print("Power Management Notification from %s: %s", device:name(), msg)
	if event == 2 then
		if powerFailureDevice == nil then
			print("Could not find the device %s", powerFailure)
			return
		end
		powerFailureDevice:command("turnoff", nil, msg .. " on " .. device:name())
	elseif event == 3 then
		if powerFailureDevice == nil then
			print("Could not find the device %s", powerFailure)
			return
		end
		powerFailureDevice:command("turnon", nil, msg .. " on " .. device:name())
	end
end

