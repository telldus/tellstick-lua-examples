-- Script to check the risk of mold depending on a sensors temperature and humidity
-- The sensor needs to report both temperature and humidity
-- A dummy device will be controlled like this depending on the risk of mold: 
-- OFF - Very low risk
-- Dim 50% - Low risk
-- ON - High risk
-- Define your sensor and device names below:
	
local my_sensor = "3"		     				-- Name of the sensor 
local my_device = "mold"					-- Name of the dummy device (a dimmer!) 
local debug = true						-- Print debug data to console (true/false)

-- DO NOT EDIT BELOW THIS LINE --

function onSensorValueUpdated(device, valueType, value, scale)
	local deviceManager = require "telldus.DeviceManager"
	local sensor = deviceManager:findByName(my_sensor)
	local dimmer_device = deviceManager:findByName(my_device)
	if dimmer_device == nil then
		print("Could not find the device %s", my_device)
		return
	end
	humidityValue = sensor:sensorValue(2, 0)
	if device:id() == sensor:id() and valueType == 1 and scale == 0 then
		if debug == true then
			print("Got temperature data: %s", value)
			print("Humidity is: %s", humidityValue)
		end
		low = 23*math.exp(-value* 0.150)+75
		high = 21*math.exp(-value* 0.150)+83
		if debug == true then
			print("low: %s", math.floor(low))
			print("high: %s", math.floor(high))
		end	
		if humidityValue >= high then
			if dimmer_device:state() ~= 1 then
				dimmer_device:command("turnon", nil, "Mold script")
				print("HIGH risk!")
			end
		elseif humidityValue >= low then
			if dimmer_device:state() ~= 16 then
				dimmer_device:command("dim", 127, "Mold script")
				print("LOW risk!")
			end
		elseif humidityValue < low then
			if dimmer_device:state() ~= 2 then
				dimmer_device:command("turnoff", nil, "Mold script")
				print("Very low risk")
			end
		end
	end
end
