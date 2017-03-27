-- File: NodOn.lua
-- One click on the remote turns on a device
-- Double click on the remote turns off a device
-- Define the names on your devices here:
local remotecontrol = "NodOn"
local device1 = "Office"
local device2 = "Kitchen"
local device3 = "Garage"
local device4 = "Window"

-- DO NOT EDIT BELOW THIS LINE --

COMMAND_CLASS_CENTRAL_SCENE = 0x5B
CENTRAL_SCENE_NOTIFICATION = 0x03

local deviceManager = require "telldus.DeviceManager"

function scene1(action)
	local device = deviceManager:findByName(device1)
	if action == 0 then -- Press
		device:command("turnon", nil, "Scene")
		print("Turning ON device: %s", device1)
	elseif action == 1 then -- Release
	elseif action == 2 then -- Press and hold
	elseif action == 3 then -- Doubleclick
		device:command("turnoff", nil, "Scene")
		print("Turning OFF device: %s", device1)
	end
end

function scene2(action)
	local device = deviceManager:findByName(device2)
	if action == 0 then
		device:command("turnon", nil, "Scene")
		print("Turning ON device: %s", device2)
	elseif action == 3 then -- Doubleclick
		device:command("turnoff", nil, "Scene")
		print("Turning OFF device: %s", device2)
	end
end

function scene3(action)
	local device = deviceManager:findByName(device3)
	if action == 0 then
		device:command("turnon", nil, "Scene")
		print("Turning ON device: %s", device3)
	elseif action == 3 then -- Doubleclick
		device:command("turnoff", nil, "Scene")
		print("Turning OFF device: %s", device3)
	end
end

function scene4(action)
	local device = deviceManager:findByName(device4)
	if action == 0 then
		device:command("turnon", nil, "Scene")
		print("Turning ON device: %s", device4)
	elseif action == 3 then -- Doubleclick
		device:command("turnoff", nil, "Scene")
		print("Turning OFF device: %s", device4)
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
