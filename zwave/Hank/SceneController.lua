-- Define the names on your devices here:
local remotecontrol = "Scene Controller"
local click = "Button 1 click"
local hold = "Button hold"
local release = "Button release"
debug = true -- true = outputs more debug data, false = less debug data

-- DO NOT EDIT BELOW THIS LINE --

COMMAND_CLASS_CENTRAL_SCENE = 0x5B
CENTRAL_SCENE_NOTIFICATION = 0x03

local deviceManager = require "telldus.DeviceManager"

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
		print("CENTRAL_SCENE_NOTIFICATION from Device: %s, Scene: %s, Action: %s", device:name(), scene, action)
	end
	
	if action == 0 then -- 1 Click
		local device = deviceManager:findByName(click)
		device:command("turnon", nil, "Scene")
		print("Turning on device: %s", click)
	elseif action == 1 then -- Release
		local device = deviceManager:findByName(release)
		device:command("turnon", nil, "Scene")
		print("Turning on device: %s", release)
	elseif action == 2 then -- Press and hold
		local device = deviceManager:findByName(hold)
		device:command("turnon", nil, "Scene")
		print("Turning on device: %s", hold)
	end
end
