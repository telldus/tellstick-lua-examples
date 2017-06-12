-- The CoolCam Siren can act as both Siren and Doorbell.
-- The different modes, sounds and volume has to be set as configurations
-- Please note that the configurations are not resetted to what it was before.

local deviceName = "Siren"
local doorbell = "dingdong"
local alarm = "alarm"
debug = true

----

local deviceManager = require "telldus.DeviceManager"
local COMMAND_CLASS_CONFIGURATION = 0x70
ALARM_MUSIC_VOLUME	= 1
DOOR_BELL_VOLUME	= 4
ALARM_MUSIC_INDEX	= 5
DOOR_BELL_INDEX		= 6
SIZE				= 1
MODE				= 7
SIREN				= 1
DOOR_BELL			= 2

function onDeviceStateChanged(device, state, stateValue)
	if state ~= 1 then
		return
	end
	local doorbell = deviceManager:findByName(doorbell)
	local alarm = deviceManager:findByName(alarm)
	if doorbell == nil or alarm == nil then
		print("Could not find device")
		return
	end
	local sirenDevice = deviceManager:findByName(deviceName)
	if device:id() == doorbell:id() then
		mode = DOOR_BELL -- SIREN or DOOR_BELL
		sound = 1 -- 1 to 10
		volume = 1 -- 1 to 3
		duration = 5 --seconds
		siren(sirenDevice, mode, sound, volume, duration)
	elseif device:id() == alarm:id() then
		mode = SIREN -- SIREN or DOOR_BELL
		sound = 10 -- 1 to 10
		volume = 3 -- 1 to 3
		duration = 5 --seconds
		siren(sirenDevice, mode, sound, volume, duration)
	end
end

function siren(devname, mode, sound, volume, duration)
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
	if mode == SIREN then
		cmdClass:setConfigurationValue(ALARM_MUSIC_INDEX, SIZE, sound)
		cmdClass:setConfigurationValue(MODE, SIZE, mode)
		cmdClass:setConfigurationValue(ALARM_MUSIC_VOLUME, SIZE, volume)
		print("Siren - Sound %s - Volume %s - Duration %s", sound, volume, duration)
		cmdClass:sendConfigurationParameters()
		devname:command("turnon", nil, "Siren script")
		if debug == true then
			print("Turning on device: %s", devname:name())
		end
		sleep(duration*1000)
		devname:command("turnoff", nil, "Siren script")
		if debug == true then
			print("Turning off device: %s", devname:name())
		end
	elseif mode == DOOR_BELL then
		cmdClass:setConfigurationValue(DOOR_BELL_INDEX, SIZE, sound)
		cmdClass:setConfigurationValue(MODE, SIZE, mode)
		cmdClass:setConfigurationValue(DOOR_BELL_VOLUME, SIZE, volume)
		print("Door Bell - Sound %s - Volume %s - Duration %s", sound, volume, duration)
		cmdClass:sendConfigurationParameters()
		devname:command("turnon", nil, "Siren script")
		if debug == true then
			print("Turning on device: %s", devname:name())
		end
	end
end
