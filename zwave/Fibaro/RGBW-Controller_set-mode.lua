-- Script to set mode to a Fibaro RGBW Controller (FGRGBWM-441)
-- Mode is set by changing configuration parameter 72 (0x48)
-- The RGB device will change mode according to the controlled dummy device

------ Do not change below ------
local devices = {}
local programs = {}

FIREPLACE = 0x6
STORM = 0x7
RAINBOW = 0x8
AURORA = 0x9
LAPD = 0xA

-- Define your device and settings here:
local deviceName = "RGB"    -- Name of your RGB device
devices[1] = {trigger="Fireplace", mode=FIREPLACE}; -- insert name of dummy and wanted mode
devices[2] = {trigger="Storm", mode=STORM};
devices[3] = {trigger="Rainbow", mode=RAINBOW};
devices[4] = {trigger="Aurora", mode=AURORA};
devices[5] = {trigger="LAPD", mode=LAPD};

------ Do not change below ------
local COMMAND_CLASS_CONFIGURATION = 0x70
local deviceManager = require "telldus.DeviceManager"

function onDeviceStateChanged(device, state, stateValue)
	if state == 1 then
		for k, trigger in pairs(devices) do
			if device:name() == devices[k]['trigger'] then
				print("Trigger device:%s", devices[k]['trigger'])
				modes(deviceName, devices[k]['mode'])
			end
		end
	end
end

function modes(rgbdevice, mode)
	local rgb = deviceManager:findByName(rgbdevice)
	if rgb == nil then
		print("Could not find the device %s", deviceName)
		return
	end
	-- Get the raw zwave node
	local zwaveNode = rgb:zwaveNode()
	local cmdClass = zwaveNode:cmdClass(COMMAND_CLASS_CONFIGURATION)
	if (cmdClass == nil) then
		print("Device %s does not support COMMAND_CLASS_CONFIGURATION", rgb:name())
		return
	end
	print("Set %s to mode %s", rgb:name(), mode)
	cmdClass:setConfigurationValue(0x48, 1, mode)
	cmdClass:sendConfigurationParameters()
end
