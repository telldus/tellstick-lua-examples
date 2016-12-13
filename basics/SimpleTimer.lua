local deviceManager = require "telldus.DeviceManager"
local trigger = "Office" -- Name of the device
local delay = 5 -- Timer setting in minutes
local running = false

function onDeviceStateChanged(device, state, stateValue)
	if running == true then
		return
	end
	local device = deviceManager:findByName(trigger) 
	if device == nil then
		return
	end
	if device:name() ~= trigger then
		return
	end
	running = true
	if (device:state() == 1) then
		print("Timer started")
		sleep(delay*60000)
		print("Turning off %s", device:name())
		device:command("turnoff", nil, "Timer")
	end
	running = false
end
