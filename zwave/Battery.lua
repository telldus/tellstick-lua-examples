-- This scripts turns on a dummy device when a Z-Wave device sends a Low Battery Warning. 
-- The name of the device that sent the warning can be seen in the device log of the dummy device.

local lowPower = "Low Battery Warning"  -- Name of the dummy device

------ Do not change below ------

local deviceManager = require "telldus.DeviceManager"
local lowPowerDevice = deviceManager:findByName(lowPower)

BATTERY = 0x80

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if cmdClass == BATTERY then 
		battery(device, cmd, data)
	end
end

function battery(device, cmd, data)
	if cmd == 3 then
		if data[0] == 0xFF then 
			msg = "LOW BATTERY WARNING"
		else
			msg = tonumber(data[0])
		end
		print("Battery Level Report from %s: %s", device:name(), msg)
		if data[0] == 0xFF then
			if lowPowerDevice == nil then
				print("Could not find the device %s", lowPower)
				return
			end
			lowPowerDevice:command("turnon", nil, "Low Battery Warning from " .. device:name())
		end
	end
end

