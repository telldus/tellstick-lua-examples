-- One click turns on a device, double click turns it off. 
-- Please note that configuration 21-26 has to be set to handle double-click. 
-- Define the names on your devices here:
local remotecontrol = "KeyFob"
devices = {}
devices[1] = "Office"
devices[2] = "Kitchen"
devices[3] = "Garage"
devices[4] = "device4"
devices[5] = "device5"
devices[6] = "device6"
debug = false

-- DO NOT EDIT BELOW THIS LINE --

KEY_PRESS = 128
KEY_DOUBLE = 131
KEY_TRIPPLE = 132
KEY_HOLD = 130
KEY_RELEASE = 129

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
		control:command("turnon", nil, "SceneMaster")
		print("Turning on device: %s", control:name())
	elseif action == KEY_DOUBLE then
		local control = deviceManager:findByName(device_to_control)
		if control == nil then
			print("Could not find device: %s", device_to_control)
			return
		end
		control:command("turnoff", nil, "SceneMaster")
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
	control(devices[scene], action)
end
