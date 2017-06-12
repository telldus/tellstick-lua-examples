-- The AeonLabs Siren can sound in a few different ways.
-- The different sounds and volume are defined using configuration 0x25 (dec 37)
-- Please note that the configurations are not resetted to what it was before.

local deviceName = "Aeon"	-- The name of the siren
local alarm1 = "alarm1"		-- Name of a dummy device 
local alarm2 = "alarm2"		-- Name of a dummy device 
debug = true				-- true = outputs more debug data, false = less debug data

----

local deviceManager = require "telldus.DeviceManager"
local COMMAND_CLASS_CONFIGURATION = 0x70
SIREN_SOUND = 0x25
SIZE = 2

function onDeviceStateChanged(device, state, stateValue)
	if state ~= 1 then
		return
	end
	local alarm1 = deviceManager:findByName(alarm1)
	local alarm2 = deviceManager:findByName(alarm2)
	if alarm1 == nil or alarm2 == nil then
		print("Could not find device")
		return
	end
	local sirenDevice = deviceManager:findByName(deviceName)
	if device:id() == alarm1:id() then
		sound = 1		-- 1-5
		volume = 1		-- 1-3
		duration = 5	-- seconds
		siren(sirenDevice, sound, volume, duration)
	elseif device:id() == alarm2:id() then
		sound = 5		-- 1-5
		volume = 1		-- 1-3
		duration = 10	-- seconds
		siren(sirenDevice, sound, volume, duration)
	end
end

function siren(devname, sound, volume, duration)
	if (devname:typeString() ~= 'zwave') then
		print("Device %s is not a Z-Wave device", devname:name())
		return
	end
	-- Get the raw zwave node
	local zwaveNode = devname:zwaveNode()
	local cmdClass = zwaveNode:cmdClass(COMMAND_CLASS_CONFIGURATION)
	if (cmdClass == nil) then
		print("Device %s does not support COMMAND_CLASS_CONFIGURATION", devname:name())
		return
	end
	config = sound * 256 + volume
	if debug == true then
		print("Config value: %s", (string.format("%x", config * 256) / 100))
	end	
	cmdClass:setConfigurationValue(SIREN_SOUND, SIZE, config)
	cmdClass:sendConfigurationParameters()
	print("Siren - Sound %s - Volume %s - Duration %s", sound, volume, duration)
	devname:command("turnon", nil, "Siren script")
	if debug == true then
		print("Turning on device: %s", devname:name())
	end
	sleep(duration*1000)
	devname:command("turnoff", nil, "Siren script")
	if debug == true then
		print("Turning off device: %s", devname:name())
	end
end
