-- This script can be used to make a device blink
-- It will keep on blinking as long as the trigger is ON

-- Define your devices and settings here:
local blink = "blink" -- Name of the device that should be controlled
local trigger = "trigger" -- Name of the trigger
local delay = 5 -- Flash speed in seconds

------ Do not change below ------
local deviceManager = require "telldus.DeviceManager"
local running = false

function onDeviceStateChanged(device, state, stateValue)
	if running == true then
		return
	end
	local trig = deviceManager:findByName(trigger)
	local bli = deviceManager:findByName(blink)
	if device:id() ~= trig:id() then
		return
	end
	if trig == nil then
		print("Could not find the device %s", trigger)
		return
	end
	if bli == nil then
		print("Could not find the device %s", blink)
		return
	end
	running = true
	while (trig:state() == 1) do -- As long as the trigger is ON
		print("Tick tack")
		bli:command("turnon", nil, "Blink.lua")
		sleep(delay*1000)
		bli:command("turnoff", nil, "Blink.lua")
		sleep(delay*1000)
	end
	running = false
end
