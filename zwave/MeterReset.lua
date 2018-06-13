-- Script to send a Meter Reset command to a Z-Wave device 
-- This can be handy to reset the accumulated power readings in a plug, etc.
-- The reset command will be sent to the device below when the trigger is controlled ON

local deviceName = "Plug"    -- name of your device
local trigger = "MeterReset" -- Name of the trigger

------ Do not change below ------
COMMAND_CLASS_METER = 0x32
METER_RESET = 0x05

local deviceManager = require "telldus.DeviceManager"

function onDeviceStateChanged(device, state, stateValue)
	local trig = deviceManager:findByName(trigger)
	local dev = deviceManager:findByName(deviceName)
	if device:id() ~= trig:id() then
		return
	end
	if trig == nil then
		print("Could not find the device %s", trigger)
		return
	end
	if dev == nil then
		print("Could not find the device %s", deviceName)
		return
	end
	if trig:state() == 1 then
		print("Sending METER RESET to %s", deviceName)
		dev:zwaveNode():sendMsg(COMMAND_CLASS_METER, METER_RESET)
	end
end

