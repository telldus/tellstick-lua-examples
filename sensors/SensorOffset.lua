-- Script to change a sensor value with a selected offset.
-- Define your sensor name and offset and the changed value will be 
-- shown as dewpoint on the same sensor.

TEMPERATURE = 1						-- Do not change
DEW_POINT = 1024					-- Do not change
SCALE_TEMPERATURE_CELCIUS = 0				-- Do not change
SCALE_TEMPERATURE_FAHRENHEIT = 1			-- Do not change

-- Define your sensor and settings here:

local my_device = "sensor"		     		-- Name of the sensor 
local debug = true					-- Print debug data to console (true/false)
local offset = -1	 				-- How much the value should be changed
local sensor_type = TEMPERATURE				-- Sensor type to change
local sensor_scale = SCALE_TEMPERATURE_CELCIUS		-- Sensor scale to change
local new_sensor_type = DEW_POINT			-- New sensor type
local new_sensor_scale = SCALE_TEMPERATURE_CELCIUS	-- New sensor scale

-- DO NOT EDIT BELOW THIS LINE --

local deviceManager = require "telldus.DeviceManager"
local sensor = deviceManager:findByName(my_device)
local new_value

function onSensorValueUpdated(device, valueType, value, scale)
	if device:id() == sensor:id() and valueType == sensor_type and scale == sensor_scale then
		new_value = value + offset
		if debug == true then
			print("Changing %s, %s", device:name(), offset)
			print("Sensor: %s - Old value: %s, New value: %s", device:name(), value, new_value)
		end
		if sensor == nil then
			print("Could not find device: %s", sensor)
			return
		end
		sleep(1000)
		sensor:setSensorValue(new_sensor_type, new_value, new_sensor_scale)
	end
end
