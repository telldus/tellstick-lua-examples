-- It's not possible to know if the status from the
-- Philio multisensor PST02-1A comes from the PIR or the 
-- door/window sensor. This script checks what kind of
-- report is sent and then controls dummy devices depending
-- on the report. 
-- In order to get a Motion idle report, set 1st bit of configuration 7 to checked.

local trigger = "Philio"
local window = "Window"
local motion = "Motion"

-- DO NOT EDIT BELOW THIS LINE --

NOTIFICATION = 0x71
NOTIFICATION_REPORT = 0x05
HOME_SECURITY = 0x07
ACCESS_CONTROL = 0x06
WINDOWDOOR_IS_OPEN = 0x16
WINDOWDOOR_IS_CLOSED = 0x17
MOTIONDETECTION = 0x08
UNKNOWN_EVENT = 0xFE

local deviceManager = require "telldus.DeviceManager"

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if cmdClass == NOTIFICATION and cmd == NOTIFICATION_REPORT then
		notificationStatus = data[3]
		notificationType = data[4]
		event = data[5]
		if notificationType == ACCESS_CONTROL then
			control_window(event)
		elseif notificationType == HOME_SECURITY then
			control_motion(event)
		end
	end
end

function control_window(event)
	local control = deviceManager:findByName(window)
	if control == nil then
		print("Could not find device: %s", window)
		return
	end
	if event == WINDOWDOOR_IS_OPEN then
		control:command("turnon", nil, "Philio")
		print("Turning on device: %s", control:name())
	elseif event == WINDOWDOOR_IS_CLOSED then
		control:command("turnoff", nil, "Philio")
		print("Turning off device: %s", control:name())
	end		
end

function control_motion(value)
	local control = deviceManager:findByName(motion)
	if control == nil then
		print("Could not find device: %s", motion)
		return
	end
	if value == MOTIONDETECTION then
		control:command("turnon", nil, "Philio")
		print("Motion detected, turning on device: %s", control:name())
	elseif value == UNKNOWN_EVENT then
		print("Turning off device: %s", control:name())
		control:command("turnoff", nil, "Philio")
	end
end

