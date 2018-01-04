COMMAND_CLASS_CENTRAL_SCENE = 0x5B
CENTRAL_SCENE_NOTIFICATION = 0x03

local deviceManager = require "telldus.DeviceManager"

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if shouldHandleMessage(device, cmdClass, cmd, data) == false then
		return
	end
	
	handleMessage(device, data)
end

function shouldHandleMessage(device, cmdClass, cmd, data)
	if cmdClass ~= COMMAND_CLASS_CENTRAL_SCENE or cmd ~= CENTRAL_SCENE_NOTIFICATION then
		return false
	end
	
	if list.len(data) < 3 then
		return false
	end
	
	return true
end

function handleMessage(device, data)
	--local sequence = data[0]
	--local action = data[1]
	local button = data[2]
	
	if button == 1 or button == 2 then
		device:setState(device.TURNON)
		print("[WALLC-S] Button %s pressed, turning on device: %s", button, device:name())
	elseif button == 5 or button == 6 then
		device:setState(device.TURNOFF)
		print("[WALLC-S] Button %s pressed, turning off device: %s", button, device:name())
	end	
end
