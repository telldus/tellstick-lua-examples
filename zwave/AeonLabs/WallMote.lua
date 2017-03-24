-- One click toggles a device
-- Define the names on your devices here:
local remotecontrol = "WallMote"
Devices = {}
Devices[1] = "Office"
Devices[2] = "Kitchen"
Devices[3] = "Garage"
Devices[4] = "Window"
debug = true

-- DO NOT EDIT BELOW THIS LINE --

KEY_PRESS = 0
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
		if control:state() == 1 then -- Device is on
			control:command("turnoff", nil, "WallMote")
			print("Turning off device: %s", control:name())
		elseif control:state() == 2 then -- Device is off
			control:command("turnon", nil, "WallMote")
			print("Turning on device: %s", control:name())
		end
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
	control(Devices[scene], action)
end
