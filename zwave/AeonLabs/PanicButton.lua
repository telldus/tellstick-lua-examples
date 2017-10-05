-- Long press on button turns on device, short press turns off device, 
-- Define the names on your devices here:
local remotecontrol = "Panic button"
Device = "Panic"  -- This is the name of a dummy device
debug = true

-- DO NOT EDIT BELOW THIS LINE --

KEY_PRESS = 1
KEY_HOLD = 2

SCENE_ACTIVATION = 0x2B

local deviceManager = require "telldus.DeviceManager"

function control(device_to_control, action)
	if action == KEY_HOLD then
		local control = deviceManager:findByName(device_to_control)
		if control == nil then
			print("Could not find device: %s", device_to_control)
			return
		end
		control:command("turnon", nil, "SceneMaster")
		print("Turning on device: %s", control:name())
	elseif action == KEY_PRESS then
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
	if cmdClass ~= SCENE_ACTIVATION then
		return
	end
	local action = data[0]
	if debug == true then
		print("CENTRAL_SCENE_NOTIFICATION from: %s, SceneID: %s", device:name(), action)
	end
	control(Device, action)
end
