-- Turns off a device xx minutes after it was turned on

-- Define your device and settings here:
local trigger = "Office" -- Name of the device
local delay_minutes = 0 -- Delay in minutes
local delay_seconds = 5 -- Delay in seconds

------ Do not change below ------
local deviceManager = require "telldus.DeviceManager"
local running = false

function onDeviceStateChanged(device, state, stateValue)
	if running == true then
		return
	end
	if device:name() ~= trigger then
		return
	end
	running = true
	if (device:state() == 1) then
		print("Timer started")
		sleep(delay_minutes*60000+delay_seconds*1000)
		print("Turning off %s", device:name())
		device:command("turnoff", nil, "Timer")
	end
	running = false
end
