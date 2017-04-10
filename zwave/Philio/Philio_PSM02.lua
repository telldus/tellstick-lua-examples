-- It's not possible to know if the status from the
-- Philio multisensor PSM02 comes from the PIR or the 
-- door/window sensor. This script checks what kind of
-- report is sent and then controls dummy devices depending
-- on the report. 
-- Since the sensor does not send a Motion idle report, a simple timer 
-- turns off the motion dummy device after the set time. 

local trigger = "Philio"
local window = "Window"
local motion = "Motion"

local motion_delay_minutes = 0 -- Delay in minutes
local motion_delay_seconds = 32 -- Delay in seconds

-- DO NOT EDIT BELOW THIS LINE --

SENSOR_BINARY = 0x30
DETECTED_AN_EVENT = 0xFF
IDLE = 0
DOOR_WINDOW = 0x0A
MOTION = 0x0C

local deviceManager = require "telldus.DeviceManager"

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if cmdClass == SENSOR_BINARY then
		sensorValue = data[0]
		sensorType = data[1]
		if sensorType == DOOR_WINDOW then
			control_window(sensorValue)
		elseif sensorType == MOTION then
			control_motion(sensorValue)
		end
	end
			
end

function control_window(value)
	local control = deviceManager:findByName(window)
	if control == nil then
		print("Could not find device: %s", window)
		return
	end
	if value == DETECTED_AN_EVENT then
		control:command("turnon", nil, "Philio")
		print("Turning on device: %s", control:name())
	elseif value == IDLE then
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
	if value == DETECTED_AN_EVENT then
		control:command("turnon", nil, "Philio")
		print("Turning on device: %s", control:name())
		sleep(motion_delay_minutes*60000+motion_delay_seconds*1000)
		print("Turning off device: %s", control:name())
		control:command("turnoff", nil, "Philio")
	end
end

