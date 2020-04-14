-- This script can be used to make a device blink
-- It will blink for as many times configured in repeats
-- Each on/off period will be as long as configured in delay

-- Define your devices and settings here:
local blink = "Blink" -- Name of the device that should be controlled
local trigger = "Door" -- Name of the Door Bell device
local delay = 2
local repeats = 3

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
	print("Ding dong")
	sleep(1000)
    for i=1,repeats do
		bli:command("turnon", nil, "Blink.lua")
		sleep(delay*1000)
		bli:command("turnoff", nil, "Blink.lua")
		sleep(delay*1000)
    end
	bli:command("turnoff", nil, "Blink.lua")
	running = false
end
