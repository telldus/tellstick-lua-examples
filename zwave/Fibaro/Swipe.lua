-- Define the names on your devices here:
local remotecontrol = "Swipe"
local device1 = "Swipe up/down"
local device2 = "Swipe left/right"

-- DO NOT EDIT BELOW THIS LINE --

COMMAND_CLASS_CENTRAL_SCENE = 0x5B
CENTRAL_SCENE_NOTIFICATION = 0x03

local deviceManager = require "telldus.DeviceManager"

function scene1(action)
	local device = deviceManager:findByName(device1)
	if action == 0 then -- UP
		device:command("turnon", nil, "Scene")
		print("Turning on device: %s", device1)
	end
end

function scene2(action)
	local device = deviceManager:findByName(device1)
	if action == 0 then -- DOWN
		device:command("turnoff", nil, "Scene")
		print("Turning off device: %s", device1)
	end
end

function scene3(action)
	local device = deviceManager:findByName(device2)
	if action == 0 then -- LEFT
		device:command("turnon", nil, "Scene")
		print("Turning on device: %s", device2)
	end
end

function scene4(action)
	local device = deviceManager:findByName(device2)
	if action == 0 then -- RIGHT
		device:command("turnoff", nil, "Scene")
		print("Turning off device: %s", device2)
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
	print("CENTRAL_SCENE_NOTIFICATION from Device: %s, Scene: %s, Action: %s", device:name(), scene, action)
	if scene == 1 then
		scene1(action)
	elseif scene == 2 then
		scene2(action)
	elseif scene == 3 then
		scene3(action)
	elseif scene == 4 then
		scene4(action)
	end
end
