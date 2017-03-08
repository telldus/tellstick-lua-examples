-- Define the names on your devices here:
local remotecontrol = "Keyfob"
local device1 = "Office"
local device2 = "Kitchen"
local device3 = "Garage"

-- DO NOT EDIT BELOW THIS LINE --

KEY_PRESS = 128
KEY_HOLD = 130
KEY_RELEASE = 129

COMMAND_CLASS_CENTRAL_SCENE = 0x5B
CENTRAL_SCENE_NOTIFICATION = 0x03

local deviceManager = require "telldus.DeviceManager"

function scene1(action)
	if action == KEY_PRESS then
		local control = deviceManager:findByName(device1)
		if control == nil then
			print("Could not find device: %s", device1)
			return
		end
		control:command("turnon", nil, "KeyFob")
		print("Turning on device: %s", control:name())
	end
end

function scene2(action)
	if action == KEY_PRESS then
		local control = deviceManager:findByName(device1)
		if control == nil then
			print("Could not find device: %s", device1)
			return
		end
		control:command("turnoff", nil, "KeyFob")
		print("Turning off device: %s", control:name())
	end
end

function scene3(action)
	if action == KEY_PRESS then
		local control = deviceManager:findByName(device2)
		if control == nil then
			print("Could not find device: %s", device2)
			return
		end
		control:command("turnon", nil, "KeyFob")
		print("Turning on device: %s", control:name())
	end
end

function scene4(action)
	if action == KEY_PRESS then
		local control = deviceManager:findByName(device2)
		if control == nil then
			print("Could not find device: %s", device2)
			return
		end
		control:command("turnoff", nil, "KeyFob")
		print("Turning off device: %s", control:name())
	end
end

function scene5(action)
	if action == KEY_PRESS then
		local control = deviceManager:findByName(device3)
		if control == nil then
			print("Could not find device: %s", device3)
			return
		end
		control:command("turnon", nil, "KeyFob")
		print("Turning on device: %s", control:name())
	end
end

function scene6(action)
	if action == KEY_PRESS then
		local control = deviceManager:findByName(device3)
		if control == nil then
			print("Could not find device: %s", device3)
			return
		end
		control:command("turnoff", nil, "KeyFob")
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
	print("CENTRAL_SCENE_NOTIFICATION from: %s, Scene: %s, Action: %s", device:name(), scene, action)
	if scene == 1 then
		scene1(action)
	elseif scene == 2 then
		scene2(action)
	elseif scene == 3 then
		scene3(action)
	elseif scene == 4 then
		scene4(action)
	elseif scene == 5 then
		scene5(action)
	elseif scene == 6 then
		scene6(action)
	end
end
