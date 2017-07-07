-- One click turns on a device, double click turns it off. 
-- Please note that configuration:
-- 1-2 has to be set to 'Separately'
-- 11-14 has to be set to 'Central scene to gateway'
-- Define the names on your devices here:
local remotecontrol = "kfob"
devices = {}
devices[1] = "device1"
devices[2] = "device2"
devices[3] = "device3"
devices[4] = "device4"
debug = true

-- DO NOT EDIT BELOW THIS LINE --

KEY_PRESS = 0
KEY_DOUBLE = 3
KEY_HOLD = 2
KEY_RELEASE = 1

COMMAND_CLASS_CENTRAL_SCENE = 0x5B
CENTRAL_SCENE_NOTIFICATION = 0x03

local deviceManager = require "telldus.DeviceManager"

function control(device_to_control, action)
	if action == KEY_PRESS then
		local control = deviceManager:findByName(device_to_control)
		if control == nil then
			print("Could not find device: %s", device_to_control)
			return
		end
		control:command("turnon", nil, "keyfob")
		print("Turning on device: %s", control:name())
	elseif action == KEY_DOUBLE then
		local control = deviceManager:findByName(device_to_control)
		if control == nil then
			print("Could not find device: %s", device_to_control)
			return
		end
		control:command("turnoff", nil, "keyfob")
		print("Turning off device: %s", control:name())
	end
end

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if device:name() ~= remotecontrol then
		return
	end
	if cmdClass ~= COMMAND_CLASS_CENTRAL_SCENE or cmd ~= CENTRAL_SCENE_NOTIFICATION then
		return
	end
	if list.len(data) < 3 then
		return
	end
	local sequence = data[0]
	local action = data[1]
	local scene = data[2]
	if debug == true then
		print("CENTRAL_SCENE_NOTIFICATION from: %s, Scene: %s, Action: %s", device:name(), scene, action)
	end
	if scene > 4 then
		scene = scene - 4
		action = 3
	end
	control(devices[scene], action)
end
