-- Turns off a device xx minutes after it was turned on if the time (hours) is between yy and zz
-- Please note that times is in UTC and that this might be changed in the future!

-- Define your devices and settings here:
local trigger = "Office" -- Name of the device
local delay_minutes = 0  -- Delay in minutes
local delay_seconds = 5  -- Delay in seconds
local time_start = 8     -- Timer active from 08:00
local time_stop = 10     -- Timer active until 12:00

------ Do not change below ------
local deviceManager = require "telldus.DeviceManager"
local running = false
local hour

function onDeviceStateChanged(device, state, stateValue)
	if running == true then
		return
	end
	if device:name() ~= trigger then
		return
	end
	hour = tonumber(os.date('%H'))
	if (device:state() == 1) then
		if hour >= time_start and hour < time_stop then
			print("Time is now (UTC): %s", os.date("%X"))
			print("Timer active from %s to %s", time_start, time_stop)
			running = true
			print("Timer started")
			sleep(delay_minutes*60000+delay_seconds*1000)
			print("Turning off %s", device:name())
			device:command("turnoff", nil, "TimeConditionTimer.lua")
		else
			print("Time is now (UTC): %s", os.date("%X"))
			print("Timer active from %s to %s", time_start, time_stop)
			print("Timer is not active")
		end
	end
	running = false
end

