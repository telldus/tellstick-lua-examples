-- This script can be used to make sure that the christmas tree does not run out of water
-- You'll need a water sensor such as the Philio PAT02 and a switch for the lights in the christmas tree

local deviceManager = require "telldus.DeviceManager"
local christmas_tree = "Julgran" -- Name of the christmas tree
local water_sensor = "Vattensensor" -- Name of the water sensor
local delay = 5 -- Flash speed
local running = false

function onDeviceStateChanged(device, state, stateValue)
	if running == true then
		return
	end
	running = true
	local sensor = deviceManager:findByName(water_sensor) 
	local switch = deviceManager:findByName(christmas_tree) 
	if sensor == nil then
		return
	end
	if switch == nil then
		return
	end
	if device:id() ~= sensor:id() then
		return
	end
	while (sensor:state() == 2) do -- As long as the sensor is dry
		print("Tick tack")
		switch:command("turnoff", nil, "Christmas tree")
		sleep(delay*1000)
		switch:command("turnon", nil, "Christmas tree")
		sleep(delay*1000)
	end
	running = false
end
