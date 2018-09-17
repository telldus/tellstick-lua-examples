-- Script to set RGB color to a device
-- The device "RGB" will be red when dummy device red is changing status

-- Define your device and settings here:
local deviceName = "RGB"    -- Name of your RGB device
local trigger = "red"       -- Name of your trigger

------ Do not change below ------
local deviceManager = require "telldus.DeviceManager"

function onDeviceStateChanged(device, state, stateValue)
	local rgb = deviceManager:findByName(deviceName)
	local trig = deviceManager:findByName(trigger)
	if trig == nil then
		print("Could not find the device %s", trigger)
		return
	end
	if rgb == nil then
		print("Could not find the device %s", deviceName)
		return
	end
	if device:id() ~= trig:id() then
		return
	end
	print("Set %s to red", rgb:name())
	rgb:command("rgb", 0xFF0000, "RGB.lua")
end
