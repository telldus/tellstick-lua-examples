-- Script to convert the SWITCH_MULTILEVEL_REPORT that is sent from the analog 
-- input on Fibaro RGBW Controller FGRGBWM-441 to a sensor value.
-- The sensor value is shown as degrees celcius (°C), but is in fact voltage (V).
-- This script can only handle 1 analog input as it is now. 
-- Please note that configuration 14 has to be set to handle analog 0-10 V input. 
-- Use configuration 43 to set the input change threshold

local main_device = "Fibaro RGBW"  -- Set the name of the main device
local analog_input = "Fibaro RGBW IN1"  -- Set the name of the device that is IN1
local debug = true  -- Select if you like to se debug data in the console or not

-- DO NOT EDIT BELOW THIS LINE --

SWITCH_MULTILEVEL = 0x26
SWITCH_MULTILEVEL_REPORT = 3

local deviceManager = require "telldus.DeviceManager"
local sensor = deviceManager:findByName(main_device)

function onZwaveMessageReceived(device, flags, cmdClass, cmd, data)
	if device:name() ~= analog_input then
		return
	end
	if cmdClass ~= SWITCH_MULTILEVEL or cmd ~= SWITCH_MULTILEVEL_REPORT then
		return
	end
	voltage = data[0] / 10
	if debug == true then
		print("%s - %s V", device:name(), voltage)
	end
	sensor:setSensorValue(1, voltage, 0)
end
