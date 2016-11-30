-- Change these

-- The name of the device to turn on
local light = "Lamp"
-- The duration for the wakeup, in minutes
local minutes = 5

function onInit()
	startWakeup()
end

-- Do not change below

local deviceManager = require "telldus.DeviceManager"

function startWakeup()
	local device = deviceManager:findByName(light)
	if not device then
		print("Could not find the device")
		return
	end
	local delay = minutes*60/25*1000
	for i=5,255,10 do
		print("Setting %s to dimlevel %s%%", device:name(), math.floor(i/255*100))
		device:command("dim", i, "Wakeup")
		sleep(delay)
	end
end
