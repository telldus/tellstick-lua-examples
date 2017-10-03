local deviceManager = require "telldus.DeviceManager"
local trigger = deviceManager:findByName('red') -- Name of the trigger
local rgb = deviceManager:findByName('rgb') -- Name of the rgb-device

function onDeviceStateChanged(device, state, stateValue)
	if trigger == nil then
		return
	end
	if rgb == nil then
		return
	end
	if device:id() ~= trigger:id() then
		return
	end
	rgb:command("rgbw", 0xFF000000, "RGB")
end
