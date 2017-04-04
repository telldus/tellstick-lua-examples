-- Script for Philio multi-sound siren (PSE02) but it's also working for D-Link (DCH-Z510).
-- Change these --
local deviceName = "siren" -- name of your siren
local devices = {}
-- Available sounds: Fire, DoorChime, Emergency, Police, Fire, Ambulance
devices[1] = {trigger="Door", sound="DoorChime", duration=1}; -- insert name, sound and duration
devices[2] = {trigger="Fire", sound="Fire", duration=10};

------ Do not change below ------
COMMAND_CLASS_BASIC = 0x20
BASIC_SET = 0x01
COMMAND_CLASS_NOTIFICATION = 0x71
NOTIFICATION_REPORT = 0x05
SWITCH_BINARY = 0x25
SWITCH_BINARY_GET = 0x02

local sounds = {}
sounds["Fire"] =      {notification_type = 0x01, notification_event = 0x01}
sounds["DoorChime"] = {notification_type = 0x06, notification_event = 0x16}
sounds["Emergency"] = {notification_type = 0x07, notification_event = 0x01}
sounds["Police"] =    {notification_type = 0x0A, notification_event = 0x01}
sounds["Fire"] =      {notification_type = 0x0A, notification_event = 0x02}
sounds["Ambulance"] = {notification_type = 0x0A, notification_event = 0x03}

local deviceManager = require "telldus.DeviceManager"

function onDeviceStateChanged(device, state, stateValue)
	if state == 1 then
		for k, trigger in pairs(devices) do
			if device:name() == devices[k]['trigger'] then
				print("Trigger device:%s", devices[k]['trigger'])
				siren(deviceName, devices[k]['sound'], devices[k]['duration'])
			end
		end
	end
end

function siren(devname, sound, duration)
	local sirenDevice = deviceManager:findByName(devname)
	if not sirenDevice then
		print("Could not find the device")
		return
	end
	notification_type = sounds[sound]['notification_type']
	notification_event =  sounds[sound]['notification_event']
	print("Siren - %s", sound)
	sirenDevice:zwaveNode():sendMsg(COMMAND_CLASS_NOTIFICATION, NOTIFICATION_REPORT, list.new(0x00, 0x00, 0x00, 0x00, notification_type, notification_event, 0x00, 0x00))
	sleep(duration*1000)
	sirenDevice:zwaveNode():sendMsg(COMMAND_CLASS_BASIC, BASIC_SET, list.new(0x00))
	sirenDevice:zwaveNode():sendMsg(SWITCH_BINARY, SWITCH_BINARY_GET)
end
