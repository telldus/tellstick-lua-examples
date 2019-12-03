-- This script turns on a dummy device when a tamper alarm has 
-- been received from one of the nodes in the Z-Wave-network.
-- The name of the node can be seen in the device history for the dummy device.

local tamper = "tamper"  -- Name of the dummy device


-- DO NOT EDIT BELOW THIS LINE --

local deviceManager = require "telldus.DeviceManager"
local tamperDevice = deviceManager:findByName(tamper)

SENSOR_BINARY = 0x30
NOTIFICATION = 0x71
NOTIFICATION_REPORT = 0x05
SENSOR_ALARM = 0x9C
SENSOR_ALARM_REPORT = 0x02

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if cmdClass == SENSOR_BINARY then
		sensorValue = data[0]
		sensorType = data[1]
		if sensorValue == 0xFF and sensorType == 8 then 
			tamper(device)
		end
	end
	if cmdClass == NOTIFICATION and cmd == NOTIFICATION_REPORT then
		notificationStatus = data[3]
		notificationType = data[4]
		event = data[5]
		if notificationStatus == 0xFF and notificationType == 7 and event == 3 then
			tamper(device)
		end
	end
	if cmdClass == SENSOR_ALARM and cmd == SENSOR_ALARM_REPORT then
		local state = data[2]
		if state == 0xFF then
			tamper(device)
		end
	end
end

function tamper(device)
	print("Tamper alarm from %s", device:name())
	tamperDevice:command("turnon", nil, "Tamper Warning from " .. device:name())
end
