-- Script to filter out sensor values 

UNKNOWN = 0					-- Sensor type flag for an unknown type
TEMPERATURE = 1				-- Sensor type flag for temperature
HUMIDITY = 2				-- Sensor type flag for humidity
RAINRATE = 4				-- Sensor type flag for rain rate
RAINTOTAL = 8				-- Sensor type flag for rain total
WINDDIRECTION = 16			-- Sensor type flag for wind direction
WINDAVERAGE	= 32			-- Sensor type flag for wind average
WINDGUST = 64				-- Sensor type flag for wind gust
UV = 128					-- Sensor type flag for uv
WATT = 256					-- Sensor type flag for watt
LUMINANCE = 512				-- Sensor type flag for luminance
DEW_POINT = 1024			-- Sensor type flag for dew point
BAROMETRIC_PRESSURE = 2048	-- Sensor type flag for barometric pressure

SCALE_UNKNOWN = 0
SCALE_TEMPERATURE_CELCIUS = 0
SCALE_TEMPERATURE_FAHRENHEIT = 1
SCALE_HUMIDITY_PERCENT = 0
SCALE_RAINRATE_MMH = 0
SCALE_RAINTOTAL_MM = 0
SCALE_WIND_VELOCITY_MS = 0
SCALE_WIND_DIRECTION = 0
SCALE_UV_INDEX = 0
SCALE_POWER_KWH = 0
SCALE_POWER_WATT = 2
SCALE_LUMINANCE_PERCENT = 0
SCALE_LUMINANCE_LUX = 1
SCALE_BAROMETRIC_PRESSURE_KPA = 0

local my_device = "sensor"						-- Name of the sensor to filter
local debug = true								-- Print debug data to console
local verbose = false							-- Print even more debug data
local upper_limit = 100							-- Cut values above this limit
local lower_limit = -100						-- Cut values below this limit
local sensor_type = WATT						-- Sensor type to filter
local sensor_scale = SCALE_POWER_WATT			-- Sensor scale to filter
local new_sensor_type = UV						-- Filtered sensor type
local new_sensor_scale = SCALE_UV_INDEX			-- Filtered sensor scale

-- DO NOT EDIT BELOW THIS LINE --

local deviceManager = require "telldus.DeviceManager"
local sensor = deviceManager:findByName(my_device)

function onSensorValueUpdated(device, valueType, value, scale)
	if verbose == true then
		print("Verbose debug data:")
		print("Device id:, %s, %s", device:id(), sensor:id())
		print("Sensor type: %s, %s", valueType, sensor_type)
		print("Sensor scale: %s, %s", scale, sensor_scale)
		print("--")
	end
	if device:id() == sensor:id() and valueType == sensor_type and scale == sensor_scale then
		if value > upper_limit then
			if debug == true then
				print("Upper limit passed: %s - %s", device:name(), value)
				if verbose == true then
					print("%s > %s", value, limit)
				end
			end
			return
		elseif value < lower_limit then
			if debug == true then
				print("Lower limit passed: %s - %s", device:name(), value)
				if verbose == true then
					print("%s < %s", value, limit)
				end
			end
			return
		end
		if debug == true then
			print("%s - %s", device:name(), value)
		end
		if sensor == nil then
			print("Could not find device: %s", sensor)
			return
		end
		sensor:setSensorValue(new_sensor_type, value, new_sensor_scale)
	end
end
