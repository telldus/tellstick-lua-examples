-- This script is a simple example how one can iterate over all devices

function onInit()
	local deviceManager = require "telldus.DeviceManager"
	for index, device in python.enumerate(deviceManager:retrieveDevices()) do
		print(device:name())
	end
end
