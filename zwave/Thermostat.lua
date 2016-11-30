-- Function to set the temperature in a Z-Wave thermostat such as a Danfoss
-- thermostat

local COMMAND_CLASS_THERMOSTAT_SETPOINT = 0x43
local SETPOINT_TYPE_HEATING = '1'
local deviceManager = require "telldus.DeviceManager"

function onInit()
	-- Example to set the device named "Danfoss" to 25 degrees
	local device = deviceManager:findByName("Danfoss")
	if device == nil then
		print("No thermostat found")
		return
	end
	setDanfossTemperature(device, 25)
end

function setDanfossTemperature(device, temperature)
	if (device:typeString() ~= 'zwave') then
		print("Device %s is not a Z-Wave device", device:name())
		return
	end
	-- Get the raw zwave node
	local zwaveNode = device:zwaveNode()
	-- Extract the thermostat setpoint command class
	local cmdClass = zwaveNode:cmdClass(COMMAND_CLASS_THERMOSTAT_SETPOINT)
	if (cmdClass == nil) then
		print("Device %s does not support THERMOSTAT_SETPOINT", device:name())
		return
	end
	-- Set new value to be sent the next time the device is awake
	cmdClass:setSetpoint(SETPOINT_TYPE_HEATING, temperature)
end
