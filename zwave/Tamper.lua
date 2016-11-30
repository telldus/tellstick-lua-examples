-- Triggers the function tamper when a tamper message is received from a Z-Wave
-- device.
SENSOR_ALARM = 0x9C

function tamper(device)
	print("Alarm from %s (%s)!", device:name(), device:id())
end

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if cmdClass ~= SENSOR_ALARM or cmd ~= 2 then
		return
	end
	local state = data[2]
	if state == 0xFF then
		tamper(device)
	end
end
