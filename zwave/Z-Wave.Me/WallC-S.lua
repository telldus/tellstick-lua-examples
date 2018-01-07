-- Plugin for Z-WAVE.ME Wall Controller Secure (0115-0100-0101)
-- https://products.z-wavealliance.org/products/1086
-- 
-- # Author: Anders R
-- # Description: Turns the WALLC-S device on (top buttons) and off (bottom buttons) in Telldus Live!
-- # Usage:
-- Include device in network and add this plugin to the ZNET controller. 
-- Device might need additional button presses during inclusion to 
-- prevent it from going into sleep mode too early. Check the configuration
-- of parameters 11-14, should be set to "Central Scene to Gateway".
-- Build events around the device turning on and off.
--
-- Tip: Use the "Sniffer" plugin for troubleshooting.

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
