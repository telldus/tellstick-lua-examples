-- Script to send MULTILEVEL_SENSOR_GET to a device when trigger is controlled

local temp_device = "AC" -- Name of the device to fetch from 
local trigger = "timer" -- Name of the trigger

------ Do not change below ------
local deviceManager = require "telldus.DeviceManager"
MULTILEVEL_SENSOR = 0x31
MULTILEVEL_SENSOR_GET = 0x04

function onDeviceStateChanged(device, state, stateValue)
	local trig = deviceManager:findByName(trigger)
	local temp = deviceManager:findByName(temp_device)
	if device:id() ~= trig:id() then
		return
	end
	if trig == nil then
		print("Could not find the device %s", trigger)
		return
	end
	if temp == nil then
		print("Could not find the device %s", blink)
		return
	end
	print("MULTILEVEL_SENSOR_GET")
	temp:zwaveNode():sendMsg(MULTILEVEL_SENSOR, MULTILEVEL_SENSOR_GET)
end
